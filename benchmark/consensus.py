"""
Builds the consensus gold standard from the two-model reference panel
(DeepSeek V4 Pro + DeepSeek V4 Flash, both thinking-enabled - see
benchmark/config.py's REFERENCE_PANEL for why Gemini 3.1 Pro isn't in the
panel currently), instead of trusting either model's raw output alone.

Reuses benchmark/scoring/matching.py's match_materials/match_properties/
match_applications as a symmetric item-aligner between the two reference
runs (it doesn't know or care which side is "truth"). An item both
reference models extracted (matched within the existing fuzzy/tolerance
thresholds) becomes a confirmed consensus item; an item only one model
found, or that both models found but disagree on the numeric value beyond
tolerance, becomes a "contested" item - excluded from the strict gold set
but logged for transparency, not silently dropped.

The two reference models' mutual agreement rate is itself reported (via the
same score_paper/aggregate_micro machinery used everywhere else) as a
defensible "noise floor" statistic: no candidate model benchmarked against
this gold standard should be expected to exceed it, since it's the
agreement level of the extraction task's two most capable models.
"""

import argparse
import json
import logging
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Tuple

from benchmark.scoring.matching import match_applications, match_materials, match_properties
from benchmark.scoring.metrics import CATEGORIES, aggregate_macro, aggregate_micro, score_paper

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


def load_run(runs_dir: Path, run_key: str) -> Dict[str, Dict[str, Any]]:
    """Load results/runs/<run_key>/extractions.json, keyed by doi_url -> full paper dict"""
    path = runs_dir / run_key / 'extractions.json'
    if not path.exists():
        raise FileNotFoundError(f"No run found for '{run_key}' at {path}")

    papers: List[Dict[str, Any]] = json.load(open(path, encoding='utf-8'))
    by_doi = {}
    for paper in papers:
        doi = paper.get('doi_url', '')
        if not doi:
            logger.warning(f"Paper without doi_url in '{run_key}' run, skipping: {paper.get('title', 'Unknown')[:60]}")
            continue
        by_doi[doi] = paper
    return by_doi


def _merge_material(a: Dict[str, Any], b: Dict[str, Any]) -> Dict[str, Any]:
    fields = ['mxene_composition', 'composite_material', 'synthesis_method', 'fabrication_method']
    return {f: (str(a.get(f, '') or '').strip() or str(b.get(f, '') or '').strip()) for f in fields}


def _merge_property(a: Dict[str, Any], b: Dict[str, Any]) -> Dict[str, Any]:
    return {
        'property_type': a.get('property_type') or b.get('property_type'),
        'value': a.get('value') if a.get('value') is not None else b.get('value'),
        'unit': a.get('unit') or b.get('unit'),
        'test_conditions': str(a.get('test_conditions', '') or '').strip() or str(b.get('test_conditions', '') or '').strip(),
    }


def _merge_application(a: Dict[str, Any], b: Dict[str, Any]) -> Dict[str, Any]:
    return {
        'application_type': a.get('application_type') or b.get('application_type'),
        'metric': a.get('metric') or b.get('metric'),
        'value': a.get('value') if a.get('value') is not None else b.get('value'),
        'unit': a.get('unit') or b.get('unit'),
        'notes': str(a.get('notes', '') or '').strip() or str(b.get('notes', '') or '').strip(),
    }


def _reconcile_paper(extracted_a: Dict[str, Any], extracted_b: Dict[str, Any], doi: str,
                      panel_a_name: str, panel_b_name: str) -> Tuple[Dict[str, Any], List[Dict[str, Any]]]:
    """Returns (confirmed_extracted_data, contested_items) for one paper"""
    confirmed = {'materials': [], 'properties': [], 'applications': []}
    contested: List[Dict[str, Any]] = []

    gold_m = extracted_a.get('materials', []) or []
    cand_m = extracted_b.get('materials', []) or []
    m_match = match_materials(gold_m, cand_m)
    for gi, ci, _ in m_match.matched:
        confirmed['materials'].append(_merge_material(gold_m[gi], cand_m[ci]))
    for gi in m_match.unmatched_gold:
        contested.append({'doi_url': doi, 'category': 'materials', 'item': gold_m[gi], 'only_in': panel_a_name})
    for ci in m_match.unmatched_cand:
        contested.append({'doi_url': doi, 'category': 'materials', 'item': cand_m[ci], 'only_in': panel_b_name})

    gold_p = extracted_a.get('properties', []) or []
    cand_p = extracted_b.get('properties', []) or []
    p_match, p_mismatches = match_properties(gold_p, cand_p)
    mismatch_set = set(p_mismatches)
    for gi, ci, _ in p_match.matched:
        if (gi, ci) in mismatch_set:
            contested.append({
                'doi_url': doi, 'category': 'properties', 'item': gold_p[gi], 'other_item': cand_p[ci],
                'only_in': 'value_mismatch', 'source_a': panel_a_name, 'source_b': panel_b_name,
            })
            continue
        confirmed['properties'].append(_merge_property(gold_p[gi], cand_p[ci]))
    for gi in p_match.unmatched_gold:
        contested.append({'doi_url': doi, 'category': 'properties', 'item': gold_p[gi], 'only_in': panel_a_name})
    for ci in p_match.unmatched_cand:
        contested.append({'doi_url': doi, 'category': 'properties', 'item': cand_p[ci], 'only_in': panel_b_name})

    gold_app = extracted_a.get('applications', []) or []
    cand_app = extracted_b.get('applications', []) or []
    app_match, app_mismatches = match_applications(gold_app, cand_app)
    mismatch_set = set(app_mismatches)
    for gi, ci, _ in app_match.matched:
        if (gi, ci) in mismatch_set:
            contested.append({
                'doi_url': doi, 'category': 'applications', 'item': gold_app[gi], 'other_item': cand_app[ci],
                'only_in': 'value_mismatch', 'source_a': panel_a_name, 'source_b': panel_b_name,
            })
            continue
        confirmed['applications'].append(_merge_application(gold_app[gi], cand_app[ci]))
    for gi in app_match.unmatched_gold:
        contested.append({'doi_url': doi, 'category': 'applications', 'item': gold_app[gi], 'only_in': panel_a_name})
    for ci in app_match.unmatched_cand:
        contested.append({'doi_url': doi, 'category': 'applications', 'item': cand_app[ci], 'only_in': panel_b_name})

    return confirmed, contested


def build_consensus(panel_a: Dict[str, Dict[str, Any]], panel_b: Dict[str, Any],
                     panel_a_name: str, panel_b_name: str):
    missing = [doi for doi in panel_a if doi not in panel_b]
    if missing:
        raise ValueError(
            f"'{panel_b_name}' reference run is missing {len(missing)} paper(s) present in "
            f"'{panel_a_name}' (e.g. {missing[0]}). Both reference-panel runs must cover the same subset."
        )

    consensus_papers = []
    all_contested = []
    per_paper_agreement = []

    for doi, paper_a in panel_a.items():
        paper_b = panel_b[doi]
        extracted_a = paper_a.get('extracted_data', {"materials": [], "properties": [], "applications": []})
        extracted_b = paper_b.get('extracted_data', {"materials": [], "properties": [], "applications": []})

        confirmed, contested = _reconcile_paper(extracted_a, extracted_b, doi, panel_a_name, panel_b_name)
        all_contested.extend(contested)

        consensus_paper = dict(paper_a)
        consensus_paper['extracted_data'] = confirmed
        consensus_paper.pop('extraction_failed', None)
        consensus_paper.pop('_latency_s', None)
        consensus_papers.append(consensus_paper)

        per_paper_agreement.append(score_paper(extracted_a, extracted_b))

    return consensus_papers, all_contested, per_paper_agreement


def build_agreement_report(per_paper_agreement, panel_a_name: str, panel_b_name: str,
                            contested: List[Dict[str, Any]]) -> Tuple[str, Dict[str, Any]]:
    micro = aggregate_micro(per_paper_agreement)
    macro = aggregate_macro(per_paper_agreement)
    contested_by_category = Counter(item['category'] for item in contested)

    report = {
        'reference_panel': [panel_a_name, panel_b_name],
        'agreement_micro': {cat: {'precision': micro[cat].precision, 'recall': micro[cat].recall,
                                   'f1': micro[cat].f1, 'value_mismatches': micro[cat].value_mismatches}
                             for cat in CATEGORIES},
        'agreement_macro_f1': macro,
        'contested_item_counts': dict(contested_by_category),
        'generated_at': datetime.now().isoformat(),
    }

    lines = [
        "# Reference Panel Agreement Report",
        "",
        f"Panel: `{panel_a_name}` vs `{panel_b_name}` (symmetric agreement, not candidate-vs-gold)",
        "",
        "This is the noise floor of the extraction task itself: no candidate model scored against "
        "the consensus gold standard should be expected to exceed these agreement figures, since "
        "even the two strongest reference models don't agree perfectly with each other.",
        "",
        "| Category | Precision | Recall | F1 | Value mismatches | Contested items |",
        "|---|---|---|---|---|---|",
    ]
    for cat in CATEGORIES:
        s = micro[cat]
        lines.append(f"| {cat} | {s.precision:.3f} | {s.recall:.3f} | {s.f1:.3f} | {s.value_mismatches} | "
                      f"{contested_by_category.get(cat, 0)} |")

    return "\n".join(lines), report


def main():
    parser = argparse.ArgumentParser(description="Build the consensus gold standard from the reference panel")
    parser.add_argument('--panel-a', default='claude-opus-4.8')
    parser.add_argument('--panel-b', default='gpt-5.6-sol')
    parser.add_argument('--runs-dir', default='results/runs')
    parser.add_argument('--out-run-key', default='consensus-gold')
    parser.add_argument('--benchmark-dir', default='results/benchmark')
    parser.add_argument('--load-db', dest='load_db', action='store_true',
                         help="Load consensus-gold into Postgres via the existing DBLoader (TRUNCATES the DB)")
    parser.add_argument('--no-load-db', dest='load_db', action='store_false')
    parser.set_defaults(load_db=False)
    args = parser.parse_args()

    runs_dir = Path(args.runs_dir)
    panel_a = load_run(runs_dir, args.panel_a)
    panel_b = load_run(runs_dir, args.panel_b)
    logger.info(f"Loaded reference panel: '{args.panel_a}' ({len(panel_a)} papers), "
                f"'{args.panel_b}' ({len(panel_b)} papers)")

    consensus_papers, contested, per_paper_agreement = build_consensus(panel_a, panel_b, args.panel_a, args.panel_b)

    out_dir = runs_dir / args.out_run_key
    out_dir.mkdir(parents=True, exist_ok=True)
    with open(out_dir / 'extractions.json', 'w', encoding='utf-8') as f:
        json.dump(consensus_papers, f, indent=2, ensure_ascii=False)

    benchmark_dir = Path(args.benchmark_dir)
    benchmark_dir.mkdir(parents=True, exist_ok=True)
    with open(benchmark_dir / 'contested_items.json', 'w', encoding='utf-8') as f:
        json.dump(contested, f, indent=2, ensure_ascii=False)

    report_md, report_json = build_agreement_report(per_paper_agreement, args.panel_a, args.panel_b, contested)
    (benchmark_dir / 'reference_agreement_report.md').write_text(report_md, encoding='utf-8')
    with open(benchmark_dir / 'reference_agreement_report.json', 'w', encoding='utf-8') as f:
        json.dump(report_json, f, indent=2)

    n_confirmed = sum(len(p['extracted_data'][cat]) for p in consensus_papers for cat in CATEGORIES)
    logger.info(f"Consensus gold written to {out_dir}: {n_confirmed} confirmed items, "
                f"{len(contested)} contested items logged to {benchmark_dir / 'contested_items.json'}")
    print(report_md)

    if args.load_db:
        from app.db_loader import DBLoader
        logger.info("Loading consensus-gold into Postgres (this truncates existing papers/materials/properties/applications)...")
        load_stats = DBLoader().load_papers_to_database(consensus_papers)
        logger.info(f"DB load stats: {load_stats}")


if __name__ == '__main__':
    main()
