# Learning Guide

A guide to understanding, running, and extending this project — and to the transferable ideas
behind it.

**Who this is for:** anyone who wants to (a) understand how LLM-based structured extraction is
built and *evaluated*, (b) navigate or extend this codebase, or (c) borrow the methodology for a
domain where labelled ground truth doesn't exist.

**What you'll be able to do afterwards:** explain why the benchmark scores look "low" and why
that's correct; add a new model or a new scoring axis; and recognize the class of bug that produces
*plausible wrong numbers* instead of errors.

**Prerequisites:** Python, basic precision/recall/F1. No materials-science knowledge needed — that
constraint is the whole reason this project is designed the way it is.

| Part | Contents |
|---|---|
| [0. Orientation](#part-0--orientation) | The 5-minute mental model |
| [1. Concepts](#part-1--the-concepts) | The transferable ideas, one at a time |
| [2. Code tour](#part-2--code-tour) | What to read, in what order |
| [3. Recipes](#part-3--recipes) | How to extend it |
| [4. Failure case studies](#part-4--failure-case-studies) | 19 real bugs, and the rule each one teaches |
| [5. Exercises](#part-5--exercises) | Work you can actually do on this repo |

---

## Part 0 — Orientation

The project is two halves that share one prompt, one parser, and one validator:

1. **An extraction pipeline** — reads 296 MXene papers, pulls structured facts out of the prose,
   normalizes them, loads them into PostgreSQL. (`app/`, `main.py`)
2. **A benchmark harness** — measures how well 13 different LLMs do that extraction.
   (`benchmark/`)

Half 2 is the larger and more interesting half, because of a constraint: **there is no
human-annotated ground truth, and we can't produce one.** Judging whether an MXene extraction is
correct needs domain expertise nobody on the project has.

Everything distinctive about this codebase follows from that single constraint. If you understand
that, the rest follows.

> **The one-sentence version:** when you can't get ground truth, build it from the agreement of
> independent models, *measure how much they disagree*, publish that as the ceiling, and add a
> second check that doesn't depend on the gold standard at all.

---

## Part 1 — The concepts

### 1.1 Structured extraction, and why it's not just prompting

The task: paper prose in, schema-conforming JSON out (see the worked example in the
[README](README.md#2-what-it-produces)).

Getting an LLM to emit *some* JSON is easy. The hard parts are the ones that only show up at scale:

- **Models don't reliably emit valid JSON.** Reasoning models leak control tokens; markdown fences
  appear and disappear; nested objects get truncated. → `app/json_utils.py`
- **The same fact has many surface forms.** `S m⁻¹` / `S/m` / `S·m-1`; `Young modulus` / `elastic
  modulus`. Without normalization, your database can't be queried. → `app/validator.py`
- **Constraining output can change behavior.** Forcing strict JSON from token 1 broke one model
  completely (case study #4). Format control is not free.

### 1.2 Why evaluation is the hard part

Suppose your pipeline extracts `530 F/g` from a paper. Is that right?

You can't diff against a reference — you don't have one. You can't eyeball it at scale. And the
model will produce equally confident output whether it read the number or invented it.

Three approaches were considered and rejected:

| Approach | Why rejected |
|---|---|
| Trust one strong model as truth | It's one model's opinion. Penalizes candidates that are *better* than the reference. |
| Non-expert manual review | Adds **false confidence**, not validation — worse than nothing because it looks rigorous. |
| Skip evaluation | The measurement *was* the project. |

### 1.3 Consensus gold standards

**The idea:** one model's output is an opinion; two independent models *independently arriving at
the same answer* is evidence.

Two frontier models **from different labs** (Claude Opus 4.8, GPT-5.6 Sol) extract the same 60
papers. Reconciliation is item-by-item using the same matcher used for scoring — symmetric, with no
notion of which side is "truth":

- both models found it → **confirmed gold** (280 items)
- only one found it, or values disagree → **contested** (379 items), logged, excluded

Read: `benchmark/consensus.py`.

**Why different labs matters.** The panel was originally two tiers of the *same* vendor. After
switching to genuinely cross-vendor, agreement *dropped* — materials F1 0.735 → 0.606. The lower
number is the more honest one: same-vendor models share training lineage, so part of their
agreement was shared bias, not shared correctness. Case study #2.

**The cost, stated honestly:** excluding contested items makes gold high-precision but
*incomplete*. A candidate that correctly extracts something only one panel model found is charged a
false positive. Real recall is likely understated. This is the limitation to raise first.

### 1.4 The noise floor — the most important number here

Score the two panel models *against each other* with the same machinery:

| Category | Panel agreement F1 |
|---|---|
| Materials | 0.606 |
| Properties | 0.586 |
| Applications | 0.548 |
| **Mean** | **0.580** |

**That is the measured ambiguity of the task itself.** Two frontier models, same prompt, same
papers, agree 58% of the time.

Three consequences that govern every claim in the project:

1. A candidate at ~0.6 is **not "60% correct"** — it's at the task's agreement ceiling. The top
   model (0.623) scores *above* the panel's own agreement.
2. **Differences smaller than the floor's spread aren't real.** Qwen thinking-on (0.4947) vs
   thinking-off (0.4939) is noise. Saying otherwise would be overreading.
3. The defensible output is a **tier list, not a ranking**. Gaps between tiers are real; ordering
   within a tier is not.

> **Transferable rule:** whenever you build a reference from model agreement, publish the agreement
> rate. Without it, readers will interpret your scores on an absolute scale that doesn't exist.

### 1.5 Groundedness — covering the blind spot

Consensus has a structural hole: **if both panel models hallucinate the same thing, it becomes
gold.** No agreement metric can detect that, ever.

So every extraction is *also* checked against the source paper directly — no gold standard involved:

- **Numeric fields:** does a matching value appear in the text, within tolerance, with a compatible
  unit immediately after it?
- **Free-text fields:** does a fuzzy substring match exist?
- **Categorical labels** (`property_type`) are deliberately **excluded** — those are the model's own
  classification, not a quotation.

Read: `benchmark/scoring/groundedness.py`.

**Two reasons this matters more than it looks:**

1. **It's the one axis a non-expert can audit.** *"Does this number appear in this paragraph?"* is a
   reading question, not a chemistry question. The report emits flagged items with source excerpts
   precisely so a human can spot-check them.
2. **It found something real.** GLM-5 ranks 8th of 13 on F1 but **1st on groundedness (0.970)**.
   Claude Sonnet 4.6 ranks 3rd on F1 with the *lowest* groundedness (0.822) — hand-traced to a
   review paper where it emitted `Ti3C2Tx` for 7 composite variants, a string appearing **nowhere**
   in the provided text. Correct domain knowledge; not extraction.

> **Transferable rule:** every metric has a blind spot. Ask what failure mode your metric *cannot
> see by construction*, then add a metric that measures a different thing — not a better version of
> the same thing.

### 1.6 Schema-aware matching

A naive whole-JSON diff would be meaningless: these are unordered lists with no stable IDs, where
the same fact has many phrasings. So items are **aligned first**, then scored.

Alignment is greedy bipartite matching — score every (gold, candidate) pair, accept the best above
threshold, never reusing an index. At <10 items/paper this equals optimal (Hungarian) matching and
is far simpler to reason about.

| Category | Match signal | Threshold |
|---|---|---|
| Materials | Weighted `token_set_ratio` (composition 0.4, composite/synthesis/fabrication 0.2 each) | 70 |
| Properties | `property_type` similarity **+** unit equivalence | 85, values ±10% |
| Applications | `application_type` **+** metric similarity | 80, values ±10% |

A type-matched pair whose *number* is out of tolerance counts as 1 FP + 1 FN and is tracked
separately as a `value_mismatch` — so "found the right property, got the number wrong" is
distinguishable from "missed it entirely."

Read: `benchmark/scoring/matching.py`, then `benchmark/scoring/metrics.py`.

---

## Part 2 — Code tour

**Read in this order.** Each step builds on the last; the whole tour is ~1200 lines.

### Step 1 — the contract (10 min)

| File | Why |
|---|---|
| `prompts/extraction_prompt.txt` | The schema everything else assumes. Start here. |
| `benchmark/config.py` | Single source of truth: reference panel, candidate registries, thresholds. Every design decision is documented in comments here. |

### Step 2 — scoring, bottom-up (30 min)

| File | Lines | Why |
|---|---|---|
| `benchmark/scoring/matching.py` | 172 | How two items are decided to be "the same item". The core of the whole harness. |
| `benchmark/scoring/metrics.py` | 106 | TP/FP/FN → P/R/F1; micro vs macro aggregation. |
| `benchmark/scoring/groundedness.py` | 163 | The gold-free axis. Note the unit normalization and the forward-only numeric window — both exist because of real bugs (#18). |

> **Tip:** read each module's tests alongside it. `benchmark/tests/test_matching.py` (7 tests) and
> `test_groundedness.py` (11) are the fastest way to see intended behavior, including the edge cases
> that bit us.

### Step 3 — the pipelines that use it (30 min)

| File | Lines | Why |
|---|---|---|
| `benchmark/consensus.py` | 249 | Builds gold + the agreement report. |
| `benchmark/run_benchmark.py` | 141 | Scores candidates. Note `check_no_panel_candidates` — circularity blocked in code. |
| `benchmark/groundedness_report.py` | 116 | Runs the gold-free check over any run. |

**The data flow, end to end:**

```
results/runs/<model>/extractions.json
        │
        ├─ load_run()                     run_benchmark.py:24
        ├─ score_paper(gold, cand)        metrics.py  ← calls matching.py
        ├─ aggregate_micro() / _macro()   metrics.py
        └─ build_report()                 scoring/report.py
                 └─→ report.md · summary.csv · per_paper_scores.csv
                          └─→ chart.py (HTML) · chart_static.py (SVG)
```

### Step 4 — extraction & execution (as needed)

`app/extractor.py` · `app/validator.py` · `app/json_utils.py` for the pipeline;
`benchmark/kaggle/` for how models were actually executed (Kaggle Benchmarks proxy for frontier
models, llama.cpp/GGUF notebook for open-weight ones).

### The one file to skim, not read

`benchmark/chart.py` (590 lines) is mostly an HTML/JS template string. Read
`build_chart_data()` at the bottom; skip the rest unless you're changing the visualization.

---

## Part 3 — Recipes

### Add a new candidate model (frontier, via Kaggle Benchmarks)

1. Register it in `benchmark/config.py` → `KBENCH_CANDIDATES` (use the exact slug from
   `kaggle b t models`).
2. Run it: `kaggle b t run mxene-reference-panel-run -m <slug> --wait`
3. Convert: `uv run python -m benchmark.kaggle.reference_panel_kbench.convert_results
   --task-dir <dir> --model-slug <slug> --run-key <key> --provider <vendor>`
4. Score + chart: `uv run python -m benchmark.run_benchmark` then `benchmark.chart` /
   `benchmark.chart_static`.
5. Assign it a colour slot in `chart_static.py`/`chart.py` → `FAMILY_COLOR_SLOTS`. **Append, never
   reorder** — colour follows the entity, so existing models must keep theirs.

Full commands: `benchmark/kaggle/reference_panel_kbench/commands.md`.

> ⚠️ The palette is at its validated 8-hue ceiling. A 9th family needs facets or an "Other" group,
> not a generated 9th colour — generated hues are indistinguishable under colour-vision deficiency.

### Add a new scoring axis

Model it on `groundedness.py`, which is the cleanest example:

1. Write `benchmark/scoring/<axis>.py` with a pure `score_paper_<axis>(extracted, ...)` function.
2. Write `benchmark/<axis>_report.py` as a thin CLI over `results/runs/`.
3. Add tests **and validate against real run data before trusting it** — case study #18 exists
   because clean synthetic tests passed while the checker was wrong about every real input.

### Change a matching threshold

Edit `benchmark/config.py`, then re-run `benchmark.consensus` **and** `benchmark.run_benchmark` —
thresholds affect gold construction *and* scoring, so changing one without the other makes the two
inconsistent.

### Run the whole benchmark from scratch

See [README §6](README.md#6-quickstart). Note `run_benchmark` skips registered candidates with no
run directory (warning, not crash), so a partially-populated `results/runs/` is fine.

---

## Part 4 — Failure case studies

Every entry below was hit live, diagnosed, and fixed. They're grouped by the *kind* of mistake,
because that's what transfers.

### The dangerous class: bugs that produce numbers, not errors

A crash tells you something is wrong. A quietly-wrong metric does not — and in an evaluation
harness, a quietly-wrong metric is the entire product.

#### 4.1 · 100% "successful" extractions that were completely empty

Grammar-constrained JSON generation was added to fix parse failures. `run_stats.json` then reported
`successful_extractions: 60` — a perfect score. All 180 extractions were
`{"materials": [], "properties": [], "applications": []}`.

**Root cause:** gpt-oss is trained on the Harmony format — it reasons in an `analysis` channel
*before* answering. Forcing valid JSON from token 1 removes that room, so it satisfied the grammar
the cheapest way available: empty arrays.

**Why it nearly shipped:** the success counter measured *parseability*. Empty JSON parses perfectly.

**Fix:** per-model `use_json_schema` flag — `False` for gpt-oss (use the tolerant parser instead),
`True` for models that showed real content under constraint.

> **Rule:** never trust a success counter that measures the wrong property. Validate *content*, not
> just *form*.

#### 4.2 · Retries that fired with zero delay

`generate_response` slept between attempts inside an `except` block. But the provider classes catch
their own exceptions and return `None` — so the `except` branch **never ran**, and all retries fired
back-to-back in microseconds, against a rate limit.

**Fix:** sleep after *any* failed attempt — exception **or** falsy return.

> **Rule:** retry logic that assumes exceptions silently no-ops against layers that swallow them.

#### 4.3 · A framework silently disabled retries, then a run mass-failed

First full reference run used `n_jobs=4, max_attempts=3`. Result: GPT-5.6 Sol **2/60**, Claude Opus
**0/60**.

Buried in the logs: `` `max_attempts` must be 1 for nested task evaluations; coercing from 3 to 1``.
The platform disables retries for `.evaluate()` inside a running task. So 4-way concurrency hit rate
limits with **no retry safety net at all**.

**Fix:** `n_jobs=1` plus a hand-rolled retry loop with `[5,15,30,60]s` backoff. Opus 60/60, Sol 58/60.

> **Rule:** read the warnings. A framework downgrading your reliability settings looks exactly like
> your settings working — until everything fails at once.

#### 4.4 · A blank column nobody noticed

The Kaggle notebook writes `avg_time_per_paper_s`; the API runner writes `avg_latency_s`. The report
read only the latter, so every open-weight model silently showed `-` for latency.

> **Rule:** two code paths writing "the same" stats file will drift. Share a writer, or a schema.

#### 4.5 · `NaN` broke JSON, twice

Pandas reads a blank CSV cell as `float('nan')`, not `None`. Two consequences: `not nan` is `False`
(so falsy-guards miss it), and `json.dumps(nan)` emits the bare token `NaN`, which **is not valid
JSON** and breaks `JSON.parse()` in the browser.

**Fix:** `isinstance(x, str)` guards instead of truthiness.

> **Rule:** `NaN` is falsy-adjacent, not falsy. It defeats both `if not x` and JSON serialization.

### Methodology mistakes

#### 4.6 · A single model is not a gold standard
→ Concept [1.3](#13-consensus-gold-standards). One model's extractions are one model's opinion;
every candidate score becomes "similarity to Model X," and a *better* candidate is penalized.

#### 4.7 · Same-vendor panels inflate agreement
→ Concept [1.3](#13-consensus-gold-standards). Cross-vendor switch dropped agreement 0.735 → 0.606.
**A lower number was the more honest one.**

#### 4.8 · Uncontrolled variables hide in "defaults"
Every Kaggle Benchmarks call used a bare `llm.prompt(prompt)` — no `reasoning=` argument. All 7
models (including **both gold-standard panel members**) used whatever their provider defaults to,
while other candidates had thinking levels explicitly swept.

**Status:** fix committed (`reasoning="low"`, uniform); re-run pending. Current published numbers
predate it, stated in the README rather than quietly ignored.

> **Rule:** "default settings" is not a controlled condition — it's an *unrecorded* one.

#### 4.9 · A shared prompt carrying one model's private conventions
`prompts/extraction_prompt.txt` ends with `/no_think` — a Qwen chat-template directive — which was
sent as literal text to Claude, GPT, Gemini, GLM, and DeepSeek. Almost certainly inert, but it's
contamination in a controlled comparison.

### Diagnosis discipline

#### 4.10 · A plausible explanation is not a diagnosis
Qwen3.6-35B failed to load. A web search surfaced a documented `rope.dimension_sections` validation
bug matching the symptom exactly — nearly accepted as the cause.

With `verbose=True`, the actual error: `cudaMalloc failed: out of memory`, allocating ~16.4 GB on a
16269 MiB GPU. Every available quant exceeds P100 VRAM.

**Fix:** a `gpu_layers_to_try = [40,30,20,12,6,0]` ladder progressively offloading to CPU. MoE
models tolerate this well (~3B of 35B params active per token). Result: 59/60.

> **Rule:** turn on verbose logging and read the actual error before believing a matching GitHub
> issue.

#### 4.11 · Smoke-test before spending
`reasoning="medium"` returned `403 PermissionDeniedError: max estimated cost ($0.49) exceeds your
available quota` for two models. This is a *quota reservation* failure (the proxy reserves budget
from worst-case `max_output_tokens`), **not** "model doesn't support reasoning" — an easy
misdiagnosis.

`reasoning="low"` was then validated on **one paper across all 7 models** before committing to a
420-call re-run.

### Format & parsing

#### 4.12 · ~90% JSON parse failure, two independent causes
1. Harmony control tokens (`<|channel|>analysis<|message|>…`) leaking into responses.
2. The regex fallback was `r'\{[^}]*\}'` — non-greedy, so it **truncated at the first inner `}`**,
   mangling every nested object in the schema.

**Fix:** strip Harmony tags (take content after the final `<|message|>`); switch to `r'\{.*\}'` with
`re.DOTALL`.

> **Rule:** a regex that works on flat JSON will silently corrupt nested JSON.

#### 4.13 · The matcher penalized verbosity instead of measuring meaning
`token_sort_ratio` scored a terse phrase and a paragraph describing the *same* synthesis method as a
non-match. `token_set_ratio` treats the shorter as a subset. Measured on real pairs: 47 → 100 and
55 → 96.

#### 4.14 · Windows `charmap` crashed on real scientific text
`UnicodeEncodeError: 'charmap' codec can't encode character '−'` — the unicode **minus sign**, which
PDFs use instead of ASCII hyphen. Fix: `PYTHONUTF8=1` (`PYTHONIOENCODING` alone was insufficient —
the failure was in file *writing*, not stdio). The same `−` vs `-` distinction had to be handled in
the groundedness number parser.

### Infrastructure you don't control

#### 4.15 · Every quantization format was incompatible with the assigned GPU
Kaggle assigns a **P100** (compute capability 6.0). MXFP4 and FP8 need Ampere+ (8.0); W4A16-marlin
needs Volta+ (7.0). Every planned vLLM config was unrunnable → switched the entire inference engine
to **llama.cpp + GGUF**, whose k-quant CUDA kernels are broadly portable.

> **Rule:** verify actual hardware before designing around a quantization format.

#### 4.16 · A CUDA wheel installed successfully as CPU-only
`pip install` succeeded; inference ran on CPU. The environment reported **cu128**, for which no
wheel is published — pip silently fell back to the CPU build.

**Fix:** try `cu124 → cu122 → cu121` and **verify** each with
`llama_cpp.llama_supports_gpu_offload()`.

> **Rule:** "install succeeded" ≠ "capability present." Assert it; don't infer it.

### Metrics and visualization

#### 4.17 · A new metric was wrong about every real input while its tests passed
Three bugs in the groundedness checker, all found only by running it on **real extractions**:

1. **Unit notation** — extracted `"F/g"` vs paper text `"F g-1"`. Exact substring matching failed on
   every real property. Fixed by comparing letters-only normalizations (`fg` ≡ `fg`).
2. **Numeric window cross-matching** — in `"530 F g-1 at 1 A g-1"`, checking the value `1` picked up
   `F g-1` from the *preceding* clause. Fixed with a forward-only window stopping at the next digit.
3. **Nulls counted as ungrounded** — omission ≠ hallucination; nulls are now excluded.

> **Rule:** unit tests with clean synthetic strings will pass while your metric is wrong about
> production data. Validate new metrics against real data before trusting a single number they emit.

#### 4.18 · The chart was unreadable at the data's actual shape
Grouped bars collided their own labels; the accuracy-vs-latency scatter had 8 points in two tight
clusters with overlapping markers and labels.

**Fix:** a sorted horizontal leaderboard. Row order carries the ranking the scatter's y-position was
doing, and bars can't overlap however close two values are.

> **Rule:** choose chart type for the data's real distribution, not its schema.

#### 4.19 · A "safe" SVG feature silently erased the text
Value labels collided with the noise-floor line, so a halo was added via SVG `paint-order="stroke"`.
The renderer doesn't support it — it painted stroke *over* fill, **erasing every label**. Caught only
by rasterizing the output and looking at it.

**Fix:** an explicit background rect, which renders identically everywhere.

> **Rule:** render it and look at it. Layout math that says "it fits" is not the same as it fitting.

---

## Part 5 — Exercises

Roughly increasing difficulty. Each is real work the project would benefit from.

**1. Read a hallucination with your own eyes.** Run
`uv run python -m benchmark.groundedness_report --runs claude-sonnet-4.6`, open
`results/benchmark_report/groundedness_report.json`, pick a flagged item, and find its paper in
`results/runs/claude-sonnet-4.6/extractions.json`. Decide for yourself: hallucination, or a
paraphrase the matcher missed? *This is the human-audit loop the project is designed around.*

**2. Move a threshold.** Change `MATERIAL_MATCH_THRESHOLD` in `benchmark/config.py` from 70 to 85,
re-run consensus + scoring, and explain which direction gold size moved and why.

**3. Add bootstrap confidence intervals.** Resample the 60 papers with replacement, recompute F1
many times, report a 95% CI per candidate. **Zero API cost** — `per_paper_scores.csv` already has
everything. This is the highest-value open item: it converts point estimates into "is this gap
real?"

**4. Implement Cohen's κ for the noise floor.** Raw agreement F1 doesn't correct for chance
agreement. κ is the more standard framing and would strengthen the methodology section.

**5. Test ranking stability.** Generate a second 60-paper subset with a different seed
(`benchmark.sample_subset --seed 7`), re-run a few candidates, and check whether the tier ordering
holds. Addresses the "n=60, one seed" limitation directly.

**6. Add an LLM-as-a-judge axis.** A third scoring dimension independent of both consensus and
groundedness. Follow the recipe in [Part 3](#add-a-new-scoring-axis).

---

## Meta-lessons

1. **The worst bugs produce numbers, not errors.** Empty-but-valid extractions, blank latency
   columns, zero-delay retries — all looked like success.
2. **Validate metrics against production data, not just unit tests** (#4.1, #4.17).
3. **Read the warnings** (#4.3) — one announced itself in the logs and was ignored through a full
   failed run.
4. **A plausible explanation is not a diagnosis** (#4.10).
5. **Smoke-test before spending** (#4.11) — one paper, seven models, then commit to 420 calls.
6. **Try-and-verify beats predict-and-hope** in environments you don't control (#4.15, #4.16).
7. **Every metric has a blind spot** — ask what yours cannot see, and add a *different* metric
   (#1.5).

---

**Next:** [`DEFENSE.md`](DEFENSE.md) covers the methodology argument, all 10 known limitations, and
the hard questions with honest answers. [`README.md`](README.md) has the results and setup.
