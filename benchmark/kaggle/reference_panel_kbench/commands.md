# Reference panel via Kaggle Benchmarks (kbench)

> ⚠️ **Task version vs. published results.** `task.py` in this directory is **v3** (strips the stray
> `/no_think` tag, sets an explicit uniform `reasoning="low"`). The results currently in
> `results/runs/` were produced by **v2**, which had neither fix — so re-running the commands below
> will NOT reproduce the committed numbers byte-for-byte. The v3 re-run was attempted and partially
> failed (claude-opus 49/60, gpt-5.6-terra 53/60 — reasoning-enabled calls appear to need a longer
> per-paper `timeout` than the current 180s, given the manual retry loop also consumes up to 110s of
> backoff). Nothing was overwritten; v2 data stands until a clean v3 run completes. See
> `LEARNINGS.md` §10-11 and `DEFENSE.md` §8.5.

Real commands used to build the consensus gold standard from **Claude Opus 4.8**
+ **GPT-5.6 Sol** via Kaggle's `kaggle_benchmarks` SDK / `kaggle benchmarks` CLI,
replacing the original DeepSeek V4 Pro + Flash panel (see
`benchmark/COMMANDS_api_runs.md` for that earlier panel's commands).

**Cost note:** each full run below is ~60 real model calls. Re-running these
spends real Kaggle AI credit ($10/day, $100/month quota) - don't re-run blindly.
`task.py` in this directory is the exact script that was pushed.

## Prerequisites

```bash
export KAGGLE_USERNAME=<your kaggle username>
export KAGGLE_KEY=$(python -c "import json; print(json.load(open('kaggle.json'))['key'])")
export PYTHONUTF8=1   # Windows console encoding workaround - kbench's ConsoleUI
                       # crashes on real minus signs (U+2212) / other non-cp1252
                       # chars in paper abstracts without this
```

## One-time: fetch Model Proxy credentials

```bash
kaggle b init -y
```

Writes `.env` (`MODEL_PROXY_URL`, `MODEL_PROXY_API_KEY` - expires in ~1 hour,
re-run this if a later command 401s) plus scaffold files. Also prints the
model roster authorized for the **local dev proxy token** specifically - this
list is much narrower than the full platform catalog (see below), so don't
use it to decide what's reachable.

## Discover the real model catalog

```bash
kaggle b t models
```

This is the authoritative list - it matches what the Kaggle web UI's "Evaluate
More Models" picker shows for a *pushed* task, which is a superset of the local
dev proxy token's whitelist. Confirmed real slugs at time of writing include
`claude-opus-4-8-default`, `claude-sonnet-4-5-20250929`, `gemini-3.1-pro-preview`,
`gpt-5.6-sol`, `gpt-5.6-terra`, `deepseek-v3.1`, `gemma-4-31b-it`,
`qwen3-235b-a22b-instruct-2507`, and more.

## Smoke test (single paper, reachability + quality check)

Done before committing to the full run - confirms a model is actually up and
returns sane structured output before spending the full 60-paper budget on it.

```bash
# Write a minimal task with the prompt/paper inlined (see push_task.py pattern),
# validate locally first:
python push_task.py

# Push once:
kaggle b t push mxene-extraction-push-smoke -f push_task.py --wait

# Run against any candidate models (repeat -m per model, not space-separated):
kaggle b t run mxene-extraction-push-smoke -m claude-opus-4-8-default -m gpt-5.6-sol -m gpt-5.6-terra --wait

kaggle b t status mxene-extraction-push-smoke
kaggle b t download mxene-extraction-push-smoke -o ./results -f
```

Real measured per-paper cost/latency from this smoke test (see conversation
for full numbers): Claude Opus 4.8 $0.024/paper @ 5.3s, GPT-5.6 Sol $0.032/paper
@ 12.8s, GPT-5.6 Terra $0.011/paper @ 2.9s, Claude Sonnet 4.5 $0.012/paper @ 5.5s,
Gemini 3.1 Pro Preview $0.028/paper @ 14.8s.

## Full reference-panel run (60 papers x 2 models)

`task.py` (this directory) wraps a per-paper `extract_one_paper` task
(`store_task=False` - internal helper, not its own leaderboard entry) inside an
outer `full_reference_run` task that calls `.evaluate()` over all 60 papers with
retry/failure isolation (`on_failure="continue"`, `max_attempts=3`), then
returns every paper's extracted JSON + real per-call cost/latency as one dict.

Reuses the exact prompt/JSON-parser/validator from the main pipeline, bundled
via the already-published `chiefkeef999/mxene-benchmark-subset` Kaggle Dataset
(attached with `-d`) - same dataset the GGUF candidate notebook uses (see
`benchmark/kaggle/candidate_run/commands.md`), so results are directly
comparable to every other run in `results/runs/`.

```bash
kaggle b t push mxene-reference-panel-run -f task.py -d chiefkeef999/mxene-benchmark-subset --wait

kaggle b t run mxene-reference-panel-run -m claude-opus-4-8-default -m gpt-5.6-sol --wait

kaggle b t status mxene-reference-panel-run
kaggle b t download mxene-reference-panel-run -o ./results -f
```

## Converting to the project's results/runs/ format

The downloaded `*.run.json` files are kbench's own schema
(`results[0].dictResult` holds our task's returned dict). A one-off conversion
script pulled `dictResult.papers` (list of per-paper `{doi_url, title,
extracted_data, extraction_failed, input_tokens, output_tokens,
input_cost_nanodollars, output_cost_nanodollars, latency_ms}` dicts) into
`results/runs/claude-opus-4.8/extractions.json` +
`results/runs/gpt-5.6-sol/extractions.json`, and aggregated `run_stats.json`
(total_papers, successful_extractions, failed_extractions, total_time_s,
avg_latency_s, est_cost_usd - the last one computed from real
`*_cost_nanodollars` sums, not the `MODEL_PRICING` estimate table other
providers use, since kbench reports real metered cost per call).

## Building consensus gold from the new panel

```bash
uv run python -m benchmark.consensus --panel-a claude-opus-4.8 --panel-b gpt-5.6-sol
```

This overwrites `results/runs/consensus-gold/`. The prior DeepSeek-panel gold
was preserved under `results/runs/consensus-gold-deepseek-panel/` before this
ran (renamed, not deleted - see git history for the DeepSeek panel's original
commands in `benchmark/COMMANDS_api_runs.md`).
