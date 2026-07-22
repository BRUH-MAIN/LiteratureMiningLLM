# Open-weight candidates via llama.cpp/GGUF on Kaggle (P100)

Commands for the sequential-multi-model Kaggle notebook that runs gpt-oss-20b,
Qwen3.6-35B-A3B, and gemma-4-12b-it via `llama-cpp-python` + unsloth GGUF
quants. See `benchmark/kaggle/reference_panel_kbench/commands.md` for the
newer, unrelated Kaggle-Benchmarks-based reference panel (different mechanism
entirely - managed model proxy, not a self-hosted GGUF notebook).

## Prerequisites

```bash
export KAGGLE_USERNAME=<your kaggle username>
export KAGGLE_KEY=$(python -c "import json; print(json.load(open('kaggle.json'))['key'])")
export PYTHONUTF8=1   # Windows encoding workaround for the `kaggle` package's
                       # own output-file writing
```

## 1. Bundle the paper subset + shared code into a Kaggle Dataset

```bash
# First time only:
uv run python -m benchmark.kaggle.prepare_kaggle_dataset --first-time

# Any later update (subset regenerated, json_utils.py/validator.py edited):
uv run python -m benchmark.kaggle.prepare_kaggle_dataset
```

Serializes `benchmark.config.KAGGLE_CANDIDATES` to `kaggle_candidates.json` and
copies `benchmark_subset.json`, `extraction_prompt.txt`, `json_utils.py`,
`validator.py` into `benchmark/kaggle/dataset_bundle/`, then pushes that as the
`chiefkeef999/mxene-benchmark-subset` Kaggle Dataset (same dataset the kbench
reference panel also attaches).

## 2. Push the notebook and wait for it to run

```bash
uv run python -m benchmark.kaggle.push_and_wait \
  --run-dir benchmark/kaggle/candidate_run \
  --kernel-slug chiefkeef999/mxene-candidate-run
```

Pushes `candidate_extraction.ipynb` (per `kernel-metadata.json`: GPU-enabled,
internet-enabled, `chiefkeef999/mxene-benchmark-subset` attached), then polls
`kaggle kernels status` until it's no longer `RUNNING` (12h timeout, matching
Kaggle's own session cap). Each of the 3 models loads once, sweeps its
thinking-level variants, then is explicitly freed (`del`/`gc.collect()` +
delete the downloaded GGUF file) before the next model loads - Kaggle's disk
quota can't hold multiple large checkpoints at once.

**Do not re-run `push_and_wait.py` just to poll an already-running kernel** -
it unconditionally re-pushes first, which restarts the run as a new version
and throws away in-progress work. Poll directly instead:

```bash
kaggle kernels status chiefkeef999/mxene-candidate-run
kaggle kernels output chiefkeef999/mxene-candidate-run -p <local-dir>  # only returns data once terminal
```

## 3. Pull results into results/runs/

```bash
uv run python -m benchmark.kaggle.pull_results --kernel-slug chiefkeef999/mxene-candidate-run
```

Downloads the kernel's `<run_key>/extractions.json` + `<run_key>/run_stats.json`
output subfolders into `benchmark/kaggle/_pulled/`, then fans each out into
`results/runs/<run_key>/`. Real confirmed outcomes: gpt-oss-20b 57/60, 54/60,
56/60 (low/medium/high, after fixing the `use_json_schema=False` empty-extraction
regression - see git history / benchmark/config.py's KAGGLE_CANDIDATES comments);
qwen3.6-35b-a3b 59/60 on both thinking variants (needs the `gpu_layers_to_try`
CPU-offload fallback ladder - its GGUF alone exceeds the P100's 16GB VRAM);
gemma-4-12b-it 60/60 on every level.

## 4. Score + regenerate report/chart

Same as the API-run candidates - see `benchmark/COMMANDS_api_runs.md` step 4,
just include the GGUF run keys in `--candidates`.
