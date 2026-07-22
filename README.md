# Literature Mining LLM - MXene Research Data Extraction

This project implements a modular Python application with an agentic flow for extracting structured research data about MXenes from JSON metadata files and storing it in PostgreSQL.

## Features

- **Preprocessing Agent**: Cleans and normalizes paper data, removes duplicates
- **Extraction Agent**: Uses Gemini Flash LLM to extract structured materials, properties, and applications data
- **Validation Agent**: Validates and standardizes extracted data (units, property types, etc.)
- **Database Loader Agent**: Stores processed data in PostgreSQL with normalized schema
- **Analytics Agent**: Provides queries, visualizations, and export functionality

## Requirements

- Python 3.11+
- PostgreSQL database
- Gemini API key
- UV package manager (recommended)

## Setup

1. **Clone and navigate to the project:**
   ```bash
   cd /path/to/LiteratureMiningLLM
   ```

2. **Install dependencies using UV:**
   ```bash
   uv sync
   ```

3. **Set up environment variables:**
   Create a `.env` file with:
   ```
   GEMINI_API_KEY=your_gemini_api_key_here
   POSTGRES_URL=postgresql://user:password@localhost:5432/database
   ```

4. **Prepare your data:**
   Place your JSON data file in `data/processed/combined_papers_merged.json`

## Usage

### Run System Test
```bash
uv run python test_system.py
```

### Run Main Pipeline
```bash
uv run python main.py
```

### Test Gemini API Integration
```bash
uv run python test_gemini.py
```

## Dataset Provenance

`data/processed/combined_papers_merged.json` (296 papers) is **not** downloaded from any external dataset — it was self-collected:

1. Three manual "Export citation" batches from ScienceDirect.com search results (`ScienceDirect_citations_<timestamp>.txt`, ~99 papers each, 296 total, years 2017–2026), dominated by *Journal of Energy Storage*, *Chemical Engineering Journal*, *Journal of Alloys and Compounds*, *Journal of Power Sources*, and *Electrochimica Acta* — i.e. an MXene + energy-storage/sensor search.
2. Enrichment with full-text `conclusion` sections via `preprocessing/institutional_scraper.py` (Selenium, scraping ScienceDirect full text through institutional/university library access) and `preprocessing/enrich_papers.py` (Unpaywall API, for open-access papers).
3. Merge and de-duplication by DOI into `combined_papers_merged.json`.

This all happened in git commit `1594d86` ("dataset", 2025-09-10). The raw exports and most scraper scripts were later deleted from the working tree (commit `522b6ed`, "cleaned from dataset") but were recovered from git history and restored under `preprocessing/` (`institutional_scraper.py`, `enrich_papers.py`, `process_citations.py`, `extract_conclusions.py`, `analyze_data.py`, `generate_summary.py`, `requirements_scraper.txt`). These scripts are **archived/historical** — they depend on Selenium plus an institutional library login and the Unpaywall API, and are not part of the maintained `.venv` dependency set (see `preprocessing/requirements_scraper.txt` if you need to re-run them). To pull more papers, re-run a ScienceDirect "MXene" search under similar filters and repeat the same export → enrich → merge steps.

If any of these scripts are ever deleted again, they remain recoverable with:
```bash
git show 1594d86:preprocessing/institutional_scraper.py > preprocessing/institutional_scraper.py
```
(swap the path for any other file under that commit's `preprocessing/` tree).

## Input Data Format

The system expects a JSON file with papers in this format:
```json
[
  {
    "title": "Paper title",
    "authors": "Author names",
    "journal": "Journal name",
    "year": 2025,
    "doi_url": "https://doi.org/...",
    "abstract": "Paper abstract text",
    "conclusion": "Paper conclusion text",
    "keywords": ["keyword1", "keyword2"]
  }
]
```

## Database Schema

The system automatically creates four main tables if they don't exist and **truncates all data on each run** to ensure fresh results:

- **papers**: Paper metadata (title, authors, journal, DOI, etc.)
- **materials**: Material information (MXene composition, synthesis methods)
- **properties**: Material properties (conductivity, modulus, etc.)
- **applications**: Application data (sensors, energy storage, etc.)

### Database Behavior
- **Schema Creation**: Tables are automatically created if they don't exist
- **Data Truncation**: All existing data is cleared on each run to prevent duplicates
- **Fresh Start**: Each execution starts with a clean database state

## Output

Results are saved to the `results/` directory:

- **CSV files**: Extracted data exports
- **Visualizations**: Histograms and distribution plots
- **Summary reports**: Database statistics and insights
- **Logs**: Detailed processing logs

## Configuration

Edit `app/config.py` to modify:
- Processing settings (demo mode, batch sizes)
- Database behavior (`TRUNCATE_ON_RUN = True` by default)
- File paths
- API settings

## Demo Mode

By default, the system runs in demo mode processing only 5 papers to avoid API rate limits. To process all papers, set `DEMO_MODE = False` in `app/config.py`.

## Modules

- `app/preprocessor.py`: Data cleaning and normalization
- `app/extractor.py`: LLM-based data extraction
- `app/validator.py`: Data validation and standardization
- `app/db_loader.py`: Database operations
- `app/analytics.py`: Analytics and visualization
- `app/models.py`: Database schema definitions

## Benchmark / Gold-Standard Workflow

Benchmarks Gemini 3.5 Flash, gpt-oss-20b, Qwen3.6-35B-A3B, and gemma-4-12B-it (each at multiple thinking/reasoning-effort levels) against a **consensus gold standard**, on a fixed, seeded paper subset. Shares `app/extractor.py`, `app/validator.py`, and `prompts/extraction_prompt.txt` across every model so the comparison is fair.

### Why not just trust one model's output as "gold"?

A single model's extractions aren't a defensible ground truth — they're just another model's opinion. Instead:

1. **Reference panel**: two independent frontier models, **Claude Opus 4.8** and **GPT-5.6 Sol**, each extract the full subset independently via [Kaggle Benchmarks](https://www.kaggle.com/benchmarks) (`kaggle_benchmarks`/`kbench`) — see `benchmark/kaggle/reference_panel_kbench/`. This replaced an earlier DeepSeek V4 Pro + Flash panel (same-vendor tiers, correlated blind spots — a compromise made after Gemini 3.1 Pro hit a hard quota=0 wall on a free-tier personal API key). kbench's Model Proxy gives free-quota access ($10/day, $100/month) to real independent-vendor models instead; the old DeepSeek-panel gold is preserved at `results/runs/consensus-gold-deepseek-panel/` for comparison, and its commands are in `benchmark/COMMANDS_api_runs.md`.
2. **Consensus construction** (`benchmark/consensus.py`): the two reference runs are aligned item-by-item using the same schema-aware matcher used for scoring (`benchmark/scoring/matching.py`) — an item both models agree on becomes **confirmed gold**; an item only one model found, or that both found but disagree on the numeric value beyond tolerance, becomes **contested** (excluded from gold, logged to `results/benchmark/contested_items.json` for transparency).
3. **Reference-panel agreement is itself reported** (`results/benchmark/reference_agreement_report.md`) as a "noise floor" — no candidate model should be expected to exceed how much the two reference models agree with *each other*. This agreement rate is the sole defensibility argument for the gold standard (there's deliberately no manual human-review step: judging MXene extraction correctness requires materials-science domain expertise neither of us has, and a non-expert's yes/no would add false confidence rather than real validation). Notably, the Claude+GPT panel's raw agreement numbers are *lower* than the old DeepSeek panel's (materials F1 0.606 vs 0.735) — expected and more honest, not worse: two same-vendor models share correlated blind spots and so agree with each other more, while two genuinely independent architectures' agreement reflects real independent consensus rather than shared training artifacts.

Reference-panel models are **never** scored as candidates (`run_benchmark.py` refuses to score any `REFERENCE_PANEL` key, since their own scores would be circularly inflated by definition).

### Running it end to end

1. **Environment**: `uv venv && uv sync`. Fill in `KAGGLE_USERNAME`/`KAGGLE_KEY` in `.env` for both the reference panel and the open-weight candidates; `DEEPSEEK_API_KEY`/`GEMINI_API_KEY` are only needed if reproducing the older DeepSeek-panel/Gemini-candidate runs (see `benchmark/COMMANDS_api_runs.md`).
2. **Sample the fixed subset** (default: 60 papers, seed 42):
   ```bash
   uv run python -m benchmark.sample_subset
   ```
3. **Run the reference panel** via Kaggle Benchmarks (writes `results/runs/claude-opus-4.8/` and `results/runs/gpt-5.6-sol/`) — see `benchmark/kaggle/reference_panel_kbench/commands.md` for the full push/run/download/convert sequence:
   ```bash
   kaggle b t push mxene-reference-panel-run -f benchmark/kaggle/reference_panel_kbench/task.py -d <user>/mxene-benchmark-subset --wait
   kaggle b t run mxene-reference-panel-run -m claude-opus-4-8-default -m gpt-5.6-sol --wait
   kaggle b t download mxene-reference-panel-run -o <download-dir> -f
   uv run python -m benchmark.kaggle.reference_panel_kbench.convert_results --task-dir <download-dir>/mxene-reference-panel-run/<version> --model-slug claude-opus-4-8-default --run-key claude-opus-4.8 --provider anthropic
   uv run python -m benchmark.kaggle.reference_panel_kbench.convert_results --task-dir <download-dir>/mxene-reference-panel-run/<version> --model-slug gpt-5.6-sol --run-key gpt-5.6-sol --provider openai
   ```
4. **Build the consensus gold standard** (writes `results/runs/consensus-gold/`, the agreement report, and contested items; `--load-db` loads it into Postgres — this truncates the DB, same as `main.py` today):
   ```bash
   uv run python -m benchmark.consensus --load-db
   ```
5. **Run the API-based candidates** (Gemini 3.5 Flash, at 2 thinking levels):
   ```bash
   uv run python -m benchmark.run_api_model --run-key gemini-3.5-flash__low
   uv run python -m benchmark.run_api_model --run-key gemini-3.5-flash__high
   ```
6. **Run the open-weight candidates on Kaggle** — gpt-oss-20b, Qwen3.6-35B-A3B, and gemma-4-12B-it run **sequentially in one notebook** (`benchmark/kaggle/candidate_run/`), each swept across its thinking-level variants while loaded, then explicitly freed (GPU memory + downloaded weights) before the next model loads — Kaggle's disk quota can't hold multiple large checkpoints at once. One-time: replace `<KAGGLE_USERNAME>` in `benchmark/kaggle/candidate_run/kernel-metadata.json`.
   ```bash
   uv run python -m benchmark.kaggle.prepare_kaggle_dataset --first-time
   uv run python -m benchmark.kaggle.push_and_wait --run-dir benchmark/kaggle/candidate_run --kernel-slug <user>/mxene-candidate-run
   uv run python -m benchmark.kaggle.pull_results --kernel-slug <user>/mxene-candidate-run
   ```
   This fans the kernel's multiple `<run_key>/` output subfolders out into `results/runs/<run_key>/` automatically. Uses **llama.cpp** (`llama-cpp-python`) with unsloth GGUF quantizations rather than vLLM — confirmed live that Kaggle's assigned GPU (a P100, compute capability 6.0) is incompatible with every native quantization format vLLM would otherwise need (MXFP4/FP8 need Ampere+, W4A16-marlin needs Volta+); GGUF's k-quants sidestep that hardware gate. Notes: (a) Kaggle kernel execution is asynchronous with no push-and-block API, so `push_and_wait` polls up to the 12h session cap; (b) diagnosing a failed/timed-out run may need a manual check in the Kaggle web UI; (c) each model's "thinking level" is a prompt/message-level convention, not an API parameter (documented in the notebook's intro cell) — verify against your installed `llama-cpp-python`/model versions before trusting the thinking-level sweep.
7. **Score every candidate against the consensus gold standard**:
   ```bash
   uv run python -m benchmark.run_benchmark
   ```
   Defaults to every registered candidate. Produces `results/benchmark_report/report.md` (ranked precision/recall/F1 per category), `summary.csv`, and `per_paper_scores.csv`. Scoring is schema-aware (fuzzy field matching + 10% numeric value tolerance via `benchmark/scoring/`), not a naive whole-JSON text comparison.
8. **Generate the comparison chart**:
   ```bash
   uv run python -m benchmark.chart
   ```
   Writes an interactive, theme-aware HTML chart to `results/benchmark_report/chart.html` — a sorted mean-F1 leaderboard (HuggingFace-leaderboard style, colored by model family) with a matching latency leaderboard in the same row order, plus a full data table.

Before trusting real results, run `uv run pytest benchmark/tests/` — it includes a gold-vs-gold regression check that the scorer always reports a perfect 1.0 when a run is compared against itself.

The full model/thinking-level registry lives in `benchmark/config.py` (`REFERENCE_PANEL`, `API_CANDIDATES`, `KAGGLE_CANDIDATES`) — that file is the single source of truth `run_api_model.py`, `run_benchmark.py`, and the Kaggle notebook (via a bundled `kaggle_candidates.json`) all read from.

## Analytics Features

- Conductivity value distributions
- MXene composition analysis
- Sensor application statistics
- Property type distributions
- Publication trend analysis

## Error Handling

The system includes comprehensive error handling and logging. Check the `logs/` directory for detailed execution logs.

## Contributing

1. Follow the modular architecture
2. Add comprehensive docstrings
3. Include error handling
4. Update tests as needed

## License

This project is for research purposes.