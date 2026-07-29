# Project Defense — methodology, limitations, and the hard questions

This document exists because the interesting part of this project is not "we ran 13 LLMs on 60
papers." It is: **how do you evaluate an extraction pipeline when you cannot produce a human-annotated
gold standard?** Everything below is the argument for why these numbers mean something, and an honest
accounting of where they stop meaning something.

---

## 1. The core problem

Extracting MXene compositions, properties, and applications from papers is a domain task. Judging
whether an extraction is *correct* requires materials-science expertise. Neither author has it.

Three bad options were rejected:

| Option | Why rejected |
|---|---|
| Trust one strong model as ground truth | Not ground truth — one model's opinion. Penalizes candidates that are genuinely *better* than the reference. |
| Non-expert manual review | A non-expert's yes/no adds **false confidence**, not validation. Worse than no review, because it looks rigorous. |
| Skip evaluation, report extractions | The entire point was measurement. |

The chosen approach: **cross-model consensus, with the trustworthiness of that consensus measured and
published rather than assumed.**

---

## 2. How the gold standard is built

Two independent frontier models from **different labs** — Claude Opus 4.8 (Anthropic) and GPT-5.6 Sol
(OpenAI) — independently extract from all 60 papers using the identical prompt, parser, and validator.

Their outputs are reconciled **item by item** using the same schema-aware matcher used for scoring
(it is symmetric — it has no notion of which side is "truth"):

- Item found by **both**, within matching thresholds and ±10% numeric tolerance → **confirmed gold**
- Item found by **only one**, or found by both but with values outside tolerance → **contested**,
  written to `results/benchmark/contested_items.json`, excluded from gold

**Real numbers: 280 confirmed, 379 contested.** More than half of everything either model proposed
did not survive reconciliation. That number is published, not hidden.

---

## 3. The noise floor — the single most important number

The two panel models' agreement **with each other** is scored using the exact same machinery and
reported as the ceiling:

| Category | Panel agreement F1 |
|---|---|
| Materials | 0.606 |
| Properties | 0.586 |
| Applications | 0.548 |
| **Mean** | **0.580** |

**This is the measured ambiguity of the task itself.** Two frontier models, same prompt, same papers,
agree at 0.58.

Three consequences that shape every claim in this project:

1. **A candidate scoring ~0.6 is not "60% correct."** It is *at the agreement ceiling of the task*.
   GPT-5.6 Terra's 0.623 sits **above** the panel's own mutual agreement.
2. **Differences smaller than the noise floor's own spread are not real.** Qwen thinking-on (0.4947)
   vs thinking-off (0.4939) is noise. Claiming otherwise would be overreading.
3. **The honest headline is a tier list, not a ranking.** Top tier (Terra / Gemini 3.6 Flash /
   Sonnet 4.6, 0.57–0.62), middle (gemma / DeepSeek V3.1 / GLM-5 / Qwen, 0.49–0.53), bottom
   (gpt-oss-20b, 0.36–0.41). Positions *within* a tier are not defensible; the gaps *between* tiers
   are.

---

## 4. Anti-circularity, enforced in code

A model that helps define the gold standard cannot be scored against it — its score would be
inflated by construction. This is enforced, not just documented:

```python
# benchmark/run_benchmark.py
check_no_panel_candidates(candidates)   # raises if any REFERENCE_PANEL key is passed
```

This is why Claude Opus 4.8 and GPT-5.6 Sol appear **nowhere** on the leaderboard despite being the
strongest models in the study. It's also why the earlier DeepSeek panel members were removed from
candidacy when they were promoted to the panel.

---

## 5. Groundedness — the independent second axis

Consensus scoring has a structural blind spot: **if both panel models hallucinate the same thing, it
becomes gold.** Nothing in the agreement framework can detect that.

Groundedness (`benchmark/scoring/groundedness.py`) checks each extracted item against the **source
paper text** — no gold standard involved at all:

- **Numeric fields:** is a matching value present in the text, within tolerance, with a compatible
  unit in the window immediately following it?
- **Free-text material fields:** does a fuzzy substring match exist (`partial_ratio ≥ 70`)?
- **Categorical labels** (`property_type`, `application_type`) are deliberately **excluded** — these
  are the model's own classification choice, not a quotation, so text-matching doesn't apply.

**This is the one axis a non-expert can meaningfully audit.** "Does this number appear in this
paragraph?" is a reading-comprehension question, not a chemistry question. The report emits flagged
items with source excerpts for exactly this purpose.

**It found something real.** Claude Sonnet 4.6 ranks 3rd on F1 but last on groundedness (0.822). A
hand-traced case: on a review paper, it emitted `Ti3C2Tx` as the composition for 7 different
composite variants — that string appears **nowhere** in the abstract or conclusion it was given. That
is domain-knowledge inference, not extraction. Meanwhile GLM-5 ranks 8th on F1 but **1st on
groundedness (0.970)**.

**Conclusion: "agrees with the consensus panel" and "faithful to the source" are different
properties, and a benchmark that only measures the first is incomplete.**

---

## 6. Scoring is schema-aware, not string comparison

A naive whole-JSON diff would be meaningless here: these are unordered lists with no stable IDs,
where the same fact can be phrased many ways. So items are aligned first via greedy bipartite
matching (equivalent to optimal Hungarian matching at <10 items/paper), then scored.

| Category | Match signal | Threshold |
|---|---|---|
| Materials | Weighted `token_set_ratio` — composition 0.4, composite 0.2, synthesis 0.2, fabrication 0.2 | 70 |
| Properties | `property_type` similarity **+** unit equivalence | 85, values ±10% |
| Applications | `application_type` **+** metric similarity | 80, values ±10% |

A type-matched pair whose numeric value falls outside tolerance counts as **1 FP + 1 FN** (strict) and
is separately tracked as a `value_mismatch` for diagnostics.

Reported both ways: **micro** (sum TP/FP/FN across papers — weights every *item* equally, the primary
metric) and **macro** (mean of per-paper F1 — weights every *paper* equally).

---

## 7. Hard questions, answered honestly

> **"Your gold standard is just two LLMs agreeing. How do you know it's correct?"**

I don't, and I don't claim to. What I claim is narrower and actually supported: gold is the subset of
extractions that two independent frontier models **independently converged on**, and I publish exactly
how often they *fail* to converge (0.580 mean F1). The claim is *relative ranking under a measured
noise floor*, not absolute correctness. That's why the noise floor is on the chart itself.

> **"Excluding contested items — doesn't that bias the gold standard?"**

Yes, and this is the limitation I'd raise first if I were reviewing this. Gold is deliberately
**high-precision, low-recall**: it contains only easy/unambiguous items. Two concrete consequences:
(a) candidate recall is measured against an incomplete target, so real recall is likely *understated*;
(b) a candidate that correctly extracts a genuinely-present item that only *one* panel model found is
penalized with a false positive. The alternative — including contested items — would inject known
disagreements into the ground truth, which I judged worse. It's a defensible trade, not a solved
problem, and the contested set is logged so this is auditable.

> **"Why are the F1 scores only ~0.6? That seems bad."**

Because the ceiling is 0.58. See §3. Presenting these as "60% accuracy" would be the actual error.

> **"Isn't Claude scoring itself, given Claude Opus is on the panel?"**

Different models, and the guard is enforced in code (§4). Claude Opus 4.8 (panel) is a different
model from Claude Sonnet 4.6 (candidate). That said — a shared vendor means shared training lineage,
so Sonnet 4.6's 3rd-place F1 deserves an asterisk that GLM-5's or DeepSeek's does not. Worth noting
that Sonnet 4.6 has the *lowest* groundedness of all 13, which is the opposite of what
family-favoritism would predict.

> **"Why not just use LLM-as-a-judge?"**

It's a reasonable addition and it's on the roadmap (§9). It wasn't the first thing built because a
judge model has the same fundamental problem as a single-model gold standard — you're trusting one
model's opinion — whereas groundedness verifies against the *source document*, which is
checkable by a human without domain expertise.

> **"n=60 on one random seed. Is the ranking stable?"**

Unverified, and stated as a limitation in the README. Tier separations (0.36 vs 0.62) are large
relative to plausible sampling error; within-tier ordering is not defensible. The correct fixes are
bootstrap confidence intervals and a second independent subset — both cheap (no new API spend for the
former) and both listed in §9.

> **"You changed the gold standard mid-project. Doesn't that invalidate earlier results?"**

The earlier DeepSeek-panel gold is preserved at `results/runs/consensus-gold-deepseek-panel/` and its
agreement report is kept alongside the current one, so the comparison is auditable rather than
overwritten. The switch is *why* we know same-vendor agreement was inflated (0.735 → 0.606,
LEARNINGS.md §4.7). Every candidate was re-scored against the new gold; no numbers are mixed across
gold-standard versions.

> **"What would you do differently with a real budget?"**

Domain-expert annotation of ~100 items — not to build the gold standard, but to **validate** it:
measure how often consensus-gold agrees with an expert, which converts the whole methodology from
"internally consistent" to "externally calibrated." That single measurement would be worth more than
any additional model I could benchmark.

---

## 8. Known limitations (complete list)

1. **No external validation of scientific correctness.** The gold standard is internally consistent,
   not verified against reality. Groundedness verifies *traceability*, not *truth*.
2. **Contested-item exclusion biases gold toward easy items** (§7).
3. **n = 60, single seed (42).** No cross-subset stability check; no confidence intervals.
4. **Matching thresholds (70 / 85 / 80, ±10%) are engineering defaults**, not tuned or ablated.
5. **Reasoning effort was uncontrolled** for the 7 Kaggle-Benchmarks models in the current results —
   including both panel members. Fix committed, re-run pending (LEARNINGS.md §4.8, §4.11).
6. **`/no_think` prompt contamination** reached non-Qwen models in the published runs. Fixed in the
   Kaggle path; the same re-run clears it.
7. **Latency is not comparable across execution modes** — shared Kaggle P100 wall-clock vs. hosted
   API round-trip. Shown in a separate panel for this reason.
8. **Open-weight models ran quantized** (Q4_K_M / IQ4_XS GGUF), so their scores reflect the quantized
   variants, not full-precision weights.
9. **gpt-oss-20b uses a different extraction path** (no grammar constraint) than Qwen/Gemma — a
   protocol asymmetry that partly explains its low properties F1 (LEARNINGS.md §4.1).
10. **Single prompt, no prompt-sensitivity analysis.** Results measure model × *this* prompt.

---

## 9. Roadmap (highest value first)

1. **Bootstrap confidence intervals** on every reported F1 — zero API cost, pure resampling of
   existing per-paper scores. Converts point estimates into "is this gap real?"
2. **Second independent subset** (different seed) — confirms ranking stability.
3. **Complete the reasoning-controlled re-run** (§8.5) so the panel and candidates share one
   documented setting.
4. **Expert spot-validation** of ~100 gold items — external calibration (§7).
5. **LLM-as-a-judge** as a third scoring axis, independent of both consensus and groundedness.
6. **Self-consistency**: same model, multiple samples, measure its agreement with *itself* to
   separate model unreliability from genuine passage ambiguity.
7. **Cohen's κ instead of raw agreement F1** for the noise floor — corrects for chance agreement and
   is the more standard framing.

---

## 10. What this project actually demonstrates

Setting aside the leaderboard, the transferable content is:

- **Designing an evaluation harness under a hard constraint** (no annotation budget, no domain
  expertise) and being explicit about what that buys and costs.
- **Knowing that a metric can be structurally blind** — and building a second, independent axis
  (groundedness) specifically to cover consensus scoring's blind spot.
- **Catching silent wrong-number bugs**: 100%-success-but-empty extractions, retries with no delay,
  a blank latency column, `NaN` breaking JSON. See [`LEARNINGS.md`](LEARNINGS.md).
- **Engineering around infrastructure you don't control**: GPU capability limits, silently CPU-only
  CUDA wheels, VRAM ceilings, quota reservations, framework-downgraded retry settings.
- **Reporting negative and inconvenient results**: reasoning effort didn't help; the more honest
  panel produced *lower* agreement numbers; the 3rd-place model is the least faithful one.

The leaderboard is the artifact. The methodology and the failure analysis are the work.
