# Engineering Log — what actually broke, and what it taught

Every entry below is a bug that was **hit live**, diagnosed, and fixed during this project. Nothing
here is hypothetical. Several of them silently produced *plausible-looking wrong numbers*, which is
the failure mode that matters most in an evaluation harness — a crash tells you something is wrong;
a quietly-wrong metric does not.

Ordered roughly by how much they changed the design.

---

## Methodology

### 1. A single model's output is not a gold standard
**What happened:** The first design used one strong model's extractions as ground truth.

**Why it's wrong:** That isn't ground truth, it's one model's opinion with extra steps. Every
candidate score becomes "similarity to Model X," and a candidate that is *genuinely better* than
Model X gets penalized for it.

**Fix:** Two independent frontier models from different labs (Claude Opus 4.8 + GPT-5.6 Sol) extract
independently; only items **both** find become gold. Their mutual agreement rate is published as the
noise floor. See [`DEFENSE.md`](DEFENSE.md).

**Takeaway:** In an eval harness, the *evaluator* needs a defensibility argument before the results
mean anything.

---

### 2. Two tiers of the same vendor is a weak panel
**What happened:** Gemini 3.1 Pro was the intended second panel member. It returned a hard
`429 RESOURCE_EXHAUSTED` with `limit: 0` on every Pro-tier quota metric — free-tier keys have *zero*
Pro quota, not a small one. The panel fell back to DeepSeek V4 Pro + DeepSeek V4 Flash.

**Why it's wrong:** Same vendor → shared architecture and training data → **correlated blind spots**.
Two models that fail the same way agree with each other, which inflates the apparent gold quality.

**Observable proof this mattered:** after switching to a genuinely cross-vendor panel, agreement
*dropped* (materials F1 0.735 → 0.606). A lower number here is the **more honest** one — same-vendor
agreement was partly measuring shared bias, not shared correctness.

**Fix:** Kaggle Benchmarks' model proxy gave free-quota access to real cross-vendor frontier models.

---

### 3. Agreement metrics and faithfulness metrics measure different things
**What happened:** Added groundedness checking (does each extracted item trace back to the source
text?) expecting it to correlate with F1.

**Result:** It didn't. GLM-5 ranks 8th of 13 on F1 but **1st on groundedness (0.970)**. Claude Sonnet
4.6 ranks 3rd on F1 with the *lowest* groundedness (0.822). Hand-verified: on one review paper,
Claude emitted `Ti3C2Tx` for 7 composite variants when that string appears nowhere in the provided
text — correct domain knowledge, but not extraction.

**Takeaway:** Consensus-based scoring is structurally blind to hallucinations that *multiple* models
share. A source-grounded check is the only thing that catches them, and it needs no gold standard at
all.

---

## Silent wrong-number bugs (the dangerous class)

### 4. `gpt-oss-20b` returned 100% schema-valid, **completely empty** extractions
**What happened:** Grammar-constrained JSON generation (`response_format` with a schema) was added
to fix parse failures. `run_stats.json` then reported `successful_extractions: 60` — a perfect score.
Every single one of the 180 extractions was `{"materials": [], "properties": [], "applications": []}`.

**Root cause:** gpt-oss is trained on the Harmony format — it reasons in an `analysis` channel
*before* answering. Forcing valid JSON from token 1 removes that room, so the model satisfies the
grammar the cheapest way possible: empty arrays.

**Why it was nearly missed:** the success counter only measured *parseability*, and empty JSON parses
perfectly. Caught only by inspecting the actual `extracted_data` payloads.

**Fix:** per-model `use_json_schema` flag — `False` for gpt-oss (rely on the tolerant parser),
`True` for Qwen/Gemma which showed real content under the constraint.

**Takeaway:** **Never trust a success counter that measures the wrong property.** Validate content,
not just form.

---

### 5. Retries fired with zero delay
**What happened:** `LLMInterface.generate_response` slept between attempts inside an `except` block.

**Root cause:** the provider classes catch their own exceptions internally and return `None`. The
`except` branch therefore **never executed** — so all retries fired back-to-back in microseconds,
which is exactly the wrong behavior against a rate limit.

**Fix:** sleep after *any* failed attempt (exception **or** falsy return).

**Takeaway:** Retry logic that assumes exceptions will silently no-op against layers that swallow
them.

---

### 6. Kaggle silently disabled retries, and a parallel run mass-failed
**What happened:** The first full 60-paper reference run used `n_jobs=4, max_attempts=3`. Result:
GPT-5.6 Sol **2/60**, Claude Opus **0/60**.

**Root cause:** buried in the logs — `` `max_attempts` must be 1 for nested task evaluations;
coercing from 3 to 1``. The platform silently disables retries for `.evaluate()` inside a running
task. So 4-way concurrency hit rate limits with **no retry safety net at all**.

**Fix:** `n_jobs=1` (sequential) plus a hand-rolled retry loop with backoff `[5, 15, 30, 60]s` inside
the per-paper task. Result: Opus 60/60, Sol 58/60.

**Takeaway:** Read the warnings. A framework silently downgrading your reliability settings is
indistinguishable from your settings working — until everything fails at once.

---

### 7. Latency column was silently blank for half the models
**Root cause:** the Kaggle notebook writes `avg_time_per_paper_s`; the API runner writes
`avg_latency_s`. `report.py` only read the latter, so every open-weight model showed `-`.

**Fix:** fall back across both key names.

**Takeaway:** Two code paths producing "the same" stats file will drift. A schema — or at least a
shared writer — prevents it.

---

### 8. `NaN` produced structurally invalid JSON
**Root cause:** pandas reads a blank CSV cell as `float('nan')`, not `None`. Two consequences:
`not nan` is `False` in Python (so falsy-guards don't catch it), and `json.dumps(nan)` emits the bare
token `NaN`, which **is not valid JSON** and breaks `JSON.parse()` in the browser.

**Fix:** `isinstance(x, str)` guards instead of truthiness checks.

**Takeaway:** `NaN` is falsy-adjacent, not falsy. It defeats both `if not x` and JSON serialization.

---

## Prompt & format bugs

### 9. `/no_think` leaked into every non-Qwen model's prompt
**What happened:** The shared prompt template ends with `/no_think` — a Qwen-specific chat-template
directive. `app/prompt_loader.py` never strips it, so it was sent as literal trailing text to Claude,
GPT, Gemini, GLM, and DeepSeek.

**Impact:** almost certainly inert noise, but it is prompt contamination that shouldn't be in a
controlled comparison.

**Fix:** stripped in the Kaggle Benchmarks path.

**Takeaway:** A "shared prompt" carrying one model's private conventions isn't actually shared.

---

### 10. Reasoning effort was never controlled for 7 of 13 models
**What happened:** Every Kaggle Benchmarks call used a bare `llm.prompt(prompt)` — no `reasoning=`
argument. All 7 models (including **both gold-standard panel members**) silently used whatever their
provider defaults to, while the GGUF and direct-API candidates had thinking levels explicitly swept.

**Why it matters:** an uncontrolled variable sitting underneath the gold standard itself.

**Fix status:** committed (`reasoning="low"`, explicit and uniform) but **the re-run is still
pending** — the first attempt surfaced bug #11 below. Current published numbers predate the fix,
which is stated in the README rather than quietly ignored.

**Takeaway:** "Default settings" is not a controlled condition — it's an unrecorded one.

---

### 11. `reasoning="medium"` failed on cost *reservation*, not capability
**What happened:** Setting `reasoning="medium"` produced
`403 PermissionDeniedError: max estimated cost of operation ($0.49) exceeds your available quota`
for Gemini 3.6 Flash and DeepSeek V3.1.

**Root cause:** the proxy reserves budget up-front from worst-case `max_output_tokens` for the
requested reasoning depth. This is a *quota reservation* failure, not "model doesn't support
reasoning" — an easy misdiagnosis.

**Fix:** `reasoning="low"`, validated across all 7 models with a 1-paper smoke test *before*
committing to a 420-call re-run.

**Takeaway:** Smoke-test a parameter change on one item before spending the full run's budget.

---

### 12. `gpt-oss-20b` had a ~90% JSON parse failure rate
**Two independent root causes, both real:**
1. Harmony-format control tokens (`<|channel|>analysis<|message|>…`) leaking into the response and
   defeating the parser.
2. The regex fallback was `r'\{[^}]*\}'` — non-greedy, so it **truncated at the first inner `}`**,
   which mangles every nested object in our schema.

**Fix:** strip Harmony tags (take content after the final `<|message|>`), and switch to
`r'\{.*\}'` with `re.DOTALL` to capture through the last closing brace.

**Takeaway:** A regex that works on flat JSON will silently corrupt nested JSON.

---

### 13. Fuzzy matcher penalized verbosity instead of measuring meaning
**What happened:** `token_sort_ratio` scored a terse phrase and a full paragraph describing the *same*
synthesis method as a non-match.

**Fix:** `token_set_ratio`, which treats the shorter text as a subset rather than a mismatch.
Measured effect on real mismatched-verbosity pairs: 47 → 100 and 55 → 96.

---

## Infrastructure & environment

### 14. Every vLLM quantization format was incompatible with the assigned GPU
**What happened:** Kaggle assigns a **P100** (compute capability 6.0). MXFP4 (gpt-oss native) and FP8
need Ampere+ (8.0); W4A16-marlin needs Volta+ (7.0). Every planned config was unrunnable.

**Fix:** replaced the entire inference engine with **llama.cpp + GGUF** — its k-quant CUDA kernels
are broadly portable and sidestep the capability gate.

**Takeaway:** Verify the actual hardware before designing around a quantization format.

---

### 15. A CUDA wheel installed successfully as CPU-only
**What happened:** `pip install llama-cpp-python` with the CUDA index succeeded, but inference ran on
CPU. The environment reported **cu128**, for which no wheel is published — pip silently fell back to
the CPU build.

**Fix:** try `cu124 → cu122 → cu121` in order and **verify** each with
`llama_cpp.llama_supports_gpu_offload()`, falling back to a source build only as a last resort.

**Takeaway:** "Install succeeded" ≠ "GPU support present." Assert the capability, don't infer it.

---

### 16. Qwen3.6-35B OOM misdiagnosed as a known llama.cpp bug
**What happened:** Model load failed. A web search surfaced a documented
`rope.dimension_sections` validation bug that matched the symptom, and it was nearly accepted as the
cause.

**Actual cause (found via `verbose=True`):** plain OOM —
`cudaMalloc failed: out of memory`, trying to allocate ~16.4 GB on a GPU with 16269 MiB total. Every
available quant of this model exceeds P100 VRAM.

**Fix:** a `gpu_layers_to_try = [40, 30, 20, 12, 6, 0]` retry ladder that progressively offloads
layers to CPU. MoE models tolerate this relatively well (only ~3B of 35B params active per token).
Result: 59/60 on both variants.

**Takeaway:** A plausible external explanation is not evidence. Turn on verbose logging and read the
actual error before believing a matching GitHub issue.

---

### 17. Windows `charmap` codec crashed on real scientific text
**What happened:** `UnicodeEncodeError: 'charmap' codec can't encode character '−'` — the
unicode **minus sign** in paper abstracts (PDFs use `−`, not ASCII `-`), crashing both the `kaggle`
CLI and the benchmarks SDK console logger.

**Fix:** `PYTHONUTF8=1`. `PYTHONIOENCODING` alone was insufficient — the failure was in *file
writing*, not stdio.

**Related:** the same `−` vs `-` distinction had to be handled explicitly in the groundedness number
parser.

---

### 18. Groundedness checker: two bugs found by validating against real data
Both surfaced only because the checker was run against actual extractions rather than trusting the
unit tests:

1. **Unit notation mismatch** — extracted `"F/g"` vs. paper text `"F g-1"`. Exact substring matching
   failed on every real property. Fixed by comparing letters-only normalizations (`fg` ≡ `fg`).
2. **Numeric window cross-matching** — in `"530 F g-1 at 1 A g-1"`, checking the value `1` picked up
   `F g-1` from the *preceding* clause and wrongly marked it grounded. Fixed with a forward-only
   window that stops at the next digit.
3. **Null values counted as ungrounded** — items where the model correctly claimed nothing were
   inflating the flagged count. Omission ≠ hallucination; nulls are now excluded.

**Takeaway:** Unit tests with clean synthetic strings will pass while the checker is wrong about
every real input. Validate new metrics against production data before trusting their output.

---

## Visualization

### 19. The first chart was unreadable at the data's actual shape
**What happened:** A grouped bar chart (thinking levels nested under families) collided its own
labels once family names got long. The accompanying accuracy-vs-latency scatter had 8 points forming
two tight clusters — Qwen alone near 130 s, everything else at 41–50 s — with overlapping markers and
colliding direct labels.

**Fix:** a **sorted horizontal leaderboard** (HuggingFace-style). Row order carries the ranking that
the scatter's y-position was doing, and bars cannot overlap regardless of how close two values are.
Latency became a second panel in the *same row order*, so the trade-off is still readable by scanning
across.

**Takeaway:** Chart type should be chosen for the data's real distribution, not its schema.

---

## Meta-lessons

1. **The worst bugs produce numbers, not errors.** Empty-but-valid extractions, blank latency
   columns, and zero-delay retries all looked like success.
2. **Validate metrics against production data, not just unit tests.** Bugs #18 and #4 were invisible
   to synthetic tests.
3. **Read the warnings.** #6 announced itself in the logs and was ignored for a full failed run.
4. **A plausible explanation is not a diagnosis** (#16).
5. **Smoke-test before spending** (#11) — one paper, seven models, then commit to 420 calls.
6. **Cheap fallback ladders beat guessed-correct configuration** (#15, #16): try-and-verify beats
   predict-and-hope in an environment you don't control.
