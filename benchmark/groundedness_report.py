"""
Computes groundedness/faithfulness rates for one or more results/runs/<run_key>/
directories - independent of any gold standard (see benchmark/scoring/groundedness.py).
Each extracted item is checked against the paper's own title+abstract+conclusion
(already embedded in every extractions.json record), not compared to another model's
output, so this can run over every stored run, including ones never scored against
consensus-gold.
"""

import argparse
import json
import logging
from pathlib import Path
from typing import Any, Dict, List

from benchmark.scoring.groundedness import score_paper_groundedness

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

CATEGORIES = ("materials", "properties", "applications")


def score_run(run_key: str, runs_dir: Path) -> Dict[str, Any]:
    path = runs_dir / run_key / 'extractions.json'
    papers = json.load(open(path, encoding='utf-8'))

    totals = {cat: [0, 0] for cat in CATEGORIES}  # [grounded, total]
    flagged: List[Dict[str, Any]] = []

    for paper in papers:
        source_text = f"{paper.get('title', '')}\n\n{paper.get('abstract', '')}\n\n{paper.get('conclusion', '')}"
        result = score_paper_groundedness(paper.get('extracted_data', {}), source_text)

        for cat in CATEGORIES:
            grounded, total = result[cat]
            totals[cat][0] += grounded
            totals[cat][1] += total

        for item in result['flagged']:
            item['doi_url'] = paper.get('doi_url', '')
            item['title'] = paper.get('title', '')[:80]
            flagged.append(item)

    rates = {cat: (totals[cat][0] / totals[cat][1] if totals[cat][1] else None) for cat in CATEGORIES}
    return {
        'run_key': run_key,
        'rates': rates,
        'counts': {cat: {'grounded': totals[cat][0], 'total': totals[cat][1]} for cat in CATEGORIES},
        'flagged': flagged,
    }


def build_report(run_scores: List[Dict[str, Any]]) -> str:
    lines = [
        "# Groundedness / Faithfulness Report",
        "",
        "Measures whether extracted items trace back to the source text given to the model "
        "(title+abstract+conclusion) - independent of the consensus gold standard entirely. "
        "Numeric fields: is a matching value+unit found in the text? Free-text material fields: "
        "does a fuzzy substring match exist? Not a correctness check - a grounded item can still "
        "be scientifically wrong, and an ungrounded item might be a legitimate paraphrase our "
        "matcher missed (see the flagged items below for spot-checking).",
        "",
        "| Run | Materials | Properties | Applications | Flagged items |",
        "|---|---|---|---|---|",
    ]
    for rs in run_scores:
        r = rs['rates']
        fmt = lambda v: f"{v:.3f}" if v is not None else "-"
        lines.append(f"| {rs['run_key']} | {fmt(r['materials'])} | {fmt(r['properties'])} | "
                      f"{fmt(r['applications'])} | {len(rs['flagged'])} |")
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Score groundedness/faithfulness for one or more runs")
    parser.add_argument('--runs', nargs='+', required=True, help="run_key(s) under --runs-dir to score")
    parser.add_argument('--runs-dir', default='results/runs')
    parser.add_argument('--out-dir', default='results/benchmark_report')
    parser.add_argument('--max-flagged-in-report', type=int, default=20,
                         help="How many lowest-confidence flagged items to write per run for spot-checking")
    args = parser.parse_args()

    runs_dir = Path(args.runs_dir)
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    run_scores = []
    for run_key in args.runs:
        logger.info(f"Scoring groundedness for '{run_key}'...")
        rs = score_run(run_key, runs_dir)
        r = rs['rates']
        logger.info(f"'{run_key}' groundedness - materials: {r['materials']}, "
                     f"properties: {r['properties']}, applications: {r['applications']} "
                     f"({len(rs['flagged'])} flagged)")
        run_scores.append(rs)

    report_md = build_report(run_scores)
    (out_dir / 'groundedness_report.md').write_text(report_md, encoding='utf-8')
    with open(out_dir / 'groundedness_report.json', 'w', encoding='utf-8') as f:
        json.dump({
            rs['run_key']: {
                'rates': rs['rates'],
                'counts': rs['counts'],
                'flagged_sample': rs['flagged'][:args.max_flagged_in_report],
            }
            for rs in run_scores
        }, f, indent=2, ensure_ascii=False)

    print(report_md)
    logger.info(f"Wrote report to {out_dir / 'groundedness_report.md'}")


if __name__ == '__main__':
    main()
