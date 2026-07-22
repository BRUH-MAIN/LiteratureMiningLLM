"""
Converts a downloaded Kaggle Benchmarks run.json (from `kaggle b t download
mxene-reference-panel-run`) into this project's results/runs/<run_key>/
extractions.json + run_stats.json format, so it's directly usable by
benchmark/consensus.py and benchmark/run_benchmark.py exactly like every other
reference-panel/candidate run.

Unlike run_api_model.py's MODEL_PRICING estimate table, cost here is computed
from kbench's own real metered per-call cost (nanodollars), since the Kaggle
Model Proxy reports exact billed cost per request rather than us guessing from
a public pricing page.
"""

import argparse
import glob
import json
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List


def load_kbench_run(task_dir: Path, model_slug: str) -> Dict[str, Any]:
    matches = glob.glob(str(task_dir / model_slug / "*" / "*.run.json"))
    if not matches:
        raise FileNotFoundError(f"No run.json found for model '{model_slug}' under {task_dir}")
    run = json.load(open(matches[0], encoding="utf-8"))
    if run.get("state") != "BENCHMARK_TASK_RUN_STATE_COMPLETED":
        raise RuntimeError(f"Run for '{model_slug}' is not COMPLETED (state={run.get('state')})")
    return run["results"][0]["dictResult"]


def convert(run_key: str, model_slug: str, provider: str, task_dir: Path,
            subset_path: Path, out_dir: Path) -> Dict[str, Any]:
    subset = json.load(open(subset_path, encoding="utf-8"))
    by_doi = {p.get("doi_url", ""): p for p in subset}

    dict_result = load_kbench_run(task_dir, model_slug)
    by_result_doi = {p["doi_url"]: p for p in dict_result.get("papers", [])}

    ordered_results: List[Dict[str, Any]] = []
    total_input_tokens = total_output_tokens = 0
    total_input_cost_nd = total_output_cost_nd = 0.0
    total_latency_ms = 0.0
    failed_count = 0

    for doi, paper in by_doi.items():
        r = by_result_doi.get(doi)
        paper_out = dict(paper)

        if r is None:
            # Errored on every manual-retry attempt inside the task itself.
            paper_out["extracted_data"] = {"materials": [], "properties": [], "applications": []}
            paper_out["extraction_failed"] = True
            failed_count += 1
        else:
            paper_out["extracted_data"] = r["extracted_data"]
            paper_out["extraction_failed"] = r["extraction_failed"]
            paper_out["_latency_s"] = round(r["latency_ms"] / 1000, 3)
            if r["extraction_failed"]:
                failed_count += 1

            total_input_tokens += int(r["input_tokens"])
            total_output_tokens += int(r["output_tokens"])
            total_input_cost_nd += r["input_cost_nanodollars"]
            total_output_cost_nd += r["output_cost_nanodollars"]
            total_latency_ms += r["latency_ms"]

        ordered_results.append(paper_out)

    est_cost_usd = (total_input_cost_nd + total_output_cost_nd) / 1e9

    stats = {
        "run_key": run_key,
        "provider": provider,
        "model": model_slug,
        "thinking_level": None,
        "thinking_enabled": None,
        "total_papers": len(subset),
        "successful_extractions": len(subset) - failed_count,
        "failed_extractions": failed_count,
        "total_time_s": round(total_latency_ms / 1000, 2),
        "avg_latency_s": round(total_latency_ms / 1000 / len(subset), 3) if subset else 0,
        "total_input_tokens": total_input_tokens,
        "total_output_tokens": total_output_tokens,
        "est_cost_usd": round(est_cost_usd, 4),
        "pricing": "real metered cost via Kaggle Model Proxy (kaggle_benchmarks Usage), not an estimate table",
        "generated_at": datetime.now().isoformat(),
        "source": "kaggle_benchmarks (kbench) reference-panel run, see commands.md in this directory",
    }

    out_dir.mkdir(parents=True, exist_ok=True)
    with open(out_dir / "extractions.json", "w", encoding="utf-8") as f:
        json.dump(ordered_results, f, indent=2, ensure_ascii=False)
    with open(out_dir / "run_stats.json", "w", encoding="utf-8") as f:
        json.dump(stats, f, indent=2)

    print(f"'{run_key}': {stats['successful_extractions']}/{stats['total_papers']} succeeded, "
          f"est. cost ${stats['est_cost_usd']}")
    return stats


def main():
    parser = argparse.ArgumentParser(description="Convert a downloaded kbench run.json into results/runs/ format")
    parser.add_argument("--task-dir", required=True, help="e.g. ./ref_results/mxene-reference-panel-run/2")
    parser.add_argument("--model-slug", required=True, help="e.g. claude-opus-4-8-default")
    parser.add_argument("--run-key", required=True, help="e.g. claude-opus-4.8")
    parser.add_argument("--provider", required=True, help="e.g. anthropic")
    parser.add_argument("--subset", default="data/processed/benchmark_subset.json")
    parser.add_argument("--runs-dir", default="results/runs")
    args = parser.parse_args()

    convert(
        run_key=args.run_key,
        model_slug=args.model_slug,
        provider=args.provider,
        task_dir=Path(args.task_dir),
        subset_path=Path(args.subset),
        out_dir=Path(args.runs_dir) / args.run_key,
    )


if __name__ == "__main__":
    main()
