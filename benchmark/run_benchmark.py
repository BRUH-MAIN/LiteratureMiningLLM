"""
CLI: score every candidate model's results/runs/<run_key>/extractions.json
against the consensus gold standard (see benchmark/consensus.py), and write
the final benchmark report.

    uv run python -m benchmark.run_benchmark
    uv run python -m benchmark.run_benchmark --candidates gpt-oss-20b__low gpt-oss-20b__high
"""

import argparse
import json
import logging
from pathlib import Path
from typing import Any, Dict, List

from benchmark.config import REFERENCE_PANEL, all_candidate_run_keys, parse_run_key
from benchmark.scoring.metrics import aggregate_macro, aggregate_micro, score_paper
from benchmark.scoring.report import build_per_paper_df, build_report

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


def load_run(runs_dir: Path, model: str) -> Dict[str, Dict[str, Any]]:
    """Load results/runs/<model>/extractions.json, keyed by doi_url"""
    path = runs_dir / model / 'extractions.json'
    if not path.exists():
        raise FileNotFoundError(f"No extraction run found for '{model}' at {path}")

    papers: List[Dict[str, Any]] = json.load(open(path, encoding='utf-8'))
    by_doi = {}
    for paper in papers:
        doi = paper.get('doi_url', '')
        if not doi:
            logger.warning(f"Paper without doi_url in {model} run, skipping: {paper.get('title', 'Unknown')[:60]}")
            continue
        by_doi[doi] = paper.get('extracted_data', {"materials": [], "properties": [], "applications": []})
    return by_doi


def load_stats(runs_dir: Path, model: str) -> Dict[str, Any]:
    path = runs_dir / model / 'run_stats.json'
    if path.exists():
        return json.load(open(path, encoding='utf-8'))
    return {}


def check_no_panel_candidates(candidates: List[str]) -> None:
    """Refuse to score reference-panel models as candidates - they define the gold standard,
    so their own scores would be circularly inflated (see benchmark/consensus.py)."""
    panel_keys_requested = [c for c in candidates if c in REFERENCE_PANEL]
    if panel_keys_requested:
        raise ValueError(
            f"Refusing to score reference-panel model(s) {panel_keys_requested} as candidates - they "
            f"define the gold standard, so their own scores would be circularly inflated. Remove them "
            f"from --candidates (they are not meant to appear on the leaderboard)."
        )


def run_benchmark(gold_model: str, candidates: List[str], runs_dir: Path, out_dir: Path):
    check_no_panel_candidates(candidates)

    gold_run = load_run(runs_dir, gold_model)
    logger.info(f"Loaded gold-standard run '{gold_model}': {len(gold_run)} papers")

    all_models = [gold_model] + list(candidates)
    model_scores = {}
    run_stats = {}
    per_paper_scores: Dict[str, Dict[str, Dict[str, Any]]] = {}

    for model in all_models:
        cand_run = load_run(runs_dir, model)
        run_stats[model] = load_stats(runs_dir, model)

        missing = [doi for doi in gold_run if doi not in cand_run]
        if missing:
            raise ValueError(
                f"Candidate run '{model}' is missing {len(missing)} paper(s) present in the gold-standard "
                f"run (e.g. {missing[0]}). All runs must cover the exact same paper subset."
            )

        paper_results = {}
        for doi, gold_extracted in gold_run.items():
            paper_results[doi] = score_paper(gold_extracted, cand_run[doi])
        per_paper_scores[model] = paper_results

        micro = aggregate_micro(list(paper_results.values()))
        macro = aggregate_macro(list(paper_results.values()))
        model_scores[model] = micro
        logger.info(f"'{model}' micro F1 - materials: {micro['materials'].f1:.3f}, "
                    f"properties: {micro['properties'].f1:.3f}, applications: {micro['applications'].f1:.3f} "
                    f"(macro: {macro})")

    report_md, summary_df = build_report(model_scores, run_stats, gold_model)
    per_paper_df = build_per_paper_df(per_paper_scores)

    # family/thinking_level columns let benchmark/chart.py group and facet the visualization
    # without re-parsing run keys itself. Reference/gold runs have no '__' suffix -> level is None.
    parsed = summary_df['model'].apply(parse_run_key)
    summary_df['family'] = parsed.apply(lambda t: t[0])
    summary_df['thinking_level'] = parsed.apply(lambda t: t[1])

    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / 'report.md').write_text(report_md, encoding='utf-8')
    summary_df.to_csv(out_dir / 'summary.csv', index=False)
    per_paper_df.to_csv(out_dir / 'per_paper_scores.csv', index=False)

    logger.info(f"Wrote report to {out_dir / 'report.md'}")
    return report_md, summary_df, per_paper_df


def main():
    parser = argparse.ArgumentParser(description="Score benchmark candidate runs against the consensus gold standard")
    parser.add_argument('--gold-model', default='consensus-gold')
    parser.add_argument('--candidates', nargs='+', default=None,
                         help="Run keys matching results/runs/<run_key>/ directories. Defaults to every "
                              "registered API + Kaggle candidate in benchmark.config.all_candidate_run_keys().")
    parser.add_argument('--runs-dir', default='results/runs')
    parser.add_argument('--out-dir', default='results/benchmark_report')
    args = parser.parse_args()

    candidates = args.candidates or all_candidate_run_keys()
    report_md, _, _ = run_benchmark(args.gold_model, candidates, Path(args.runs_dir), Path(args.out_dir))
    print(report_md)


if __name__ == '__main__':
    main()
