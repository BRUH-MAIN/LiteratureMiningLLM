# API-based runs (local `.venv`, real provider keys)

Commands for everything run locally against a real provider API key (DeepSeek,
Gemini), via `benchmark/run_api_model.py`. See
`benchmark/kaggle/reference_panel_kbench/commands.md` for the newer
Kaggle-Benchmarks-based reference panel (Claude Opus 4.8 + GPT-5.6 Sol), and
`benchmark/kaggle/candidate_run/commands.md` for the open-weight GGUF
candidates.

## 0. Build the paper subset (once)

```bash
uv run python -m benchmark.sample_subset
```

Deterministic seeded sample (n=60, seed=42) from the full 296-paper dataset,
written to `data/processed/benchmark_subset.json` + a manifest/meta file under
`results/benchmark/`.

## 1. Original reference panel: DeepSeek V4 Pro + Flash

Superseded by the Claude Opus 4.8 + GPT-5.6 Sol panel (see
`benchmark/kaggle/reference_panel_kbench/`) - kept here for history. The old
DeepSeek-panel consensus gold is preserved at
`results/runs/consensus-gold-deepseek-panel/`.

```bash
uv run python -m benchmark.run_api_model --run-key deepseek-v4-pro
uv run python -m benchmark.run_api_model --run-key deepseek-v4-flash
```

Both resolve their provider/model/thinking-flag from `benchmark.config.REFERENCE_PANEL`.
Real result: 60/60 succeeded on both, real cost ~$0.0139 on an early 5-paper
smoke subset, scaled proportionally on the full run.

## 2. API candidates: Gemini 3.5 Flash

```bash
uv run python -m benchmark.run_api_model --run-key gemini-3.5-flash__low
uv run python -m benchmark.run_api_model --run-key gemini-3.5-flash__high
```

Deferred/incomplete on the free-tier key: hit a 20 req/day quota cap partway
through (in addition to the 5 req/min limit, which `--request-delay` already
paces around) - see the quarantined
`results/runs/_INVALID_gemini-3.5-flash__low_9of60/` from that partial run.
Not yet retried since the daily quota reset.

## 3. Build consensus gold from a reference panel

```bash
# Current panel (Claude Opus 4.8 + GPT-5.6 Sol):
uv run python -m benchmark.consensus --panel-a claude-opus-4.8 --panel-b gpt-5.6-sol

# Original panel (DeepSeek, for reference/reproducing history):
uv run python -m benchmark.consensus --panel-a deepseek-v4-pro --panel-b deepseek-v4-flash --out-run-key consensus-gold-deepseek-panel
```

Writes `results/runs/<out-run-key>/extractions.json`,
`results/benchmark/contested_items.json`, and
`results/benchmark/reference_agreement_report.{md,json}` (the noise-floor
statistic). `--load-db` optionally mirrors the consensus papers into Postgres
via the existing `DBLoader` (not used so far - no local Postgres server
running).

## 4. Score candidates against gold + regenerate the report/chart

```bash
uv run python -m benchmark.run_benchmark --gold consensus-gold --candidates \
  gpt-oss-20b__low gpt-oss-20b__medium gpt-oss-20b__high \
  qwen3.6-35b-a3b__thinking-on qwen3.6-35b-a3b__thinking-off \
  gemma-4-12b-it__low gemma-4-12b-it__medium gemma-4-12b-it__high

uv run python -m benchmark.chart \
  --summary-csv results/benchmark_report/summary.csv \
  --reference-agreement-json results/benchmark/reference_agreement_report.json \
  --gold-model consensus-gold \
  --out results/benchmark_report/chart.html
```

`run_benchmark.py` guards against scoring any `REFERENCE_PANEL` key as a
candidate (circularity check) - it will error out rather than silently produce
an inflated score.
