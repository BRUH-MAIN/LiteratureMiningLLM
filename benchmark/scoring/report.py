"""Builds the final markdown + CSV benchmark report from per-model aggregate scores"""

from typing import Any, Dict, Tuple

import pandas as pd

from benchmark.scoring.metrics import CATEGORIES, CategoryScore


def _mean_f1(scores: Dict[str, CategoryScore]) -> float:
    return sum(scores[cat].f1 for cat in CATEGORIES) / len(CATEGORIES)


def build_summary_df(model_scores: Dict[str, Dict[str, CategoryScore]], run_stats: Dict[str, dict]) -> pd.DataFrame:
    rows = []
    for model, scores in model_scores.items():
        stats = run_stats.get(model, {})
        row = {
            'model': model,
            'mean_f1': _mean_f1(scores),
        }
        for cat in CATEGORIES:
            row[f'{cat}_precision'] = scores[cat].precision
            row[f'{cat}_recall'] = scores[cat].recall
            row[f'{cat}_f1'] = scores[cat].f1
            row[f'{cat}_value_mismatches'] = scores[cat].value_mismatches
        row['total_papers'] = stats.get('total_papers')
        # Kaggle candidate_run stats write 'avg_time_per_paper_s' instead of 'avg_latency_s'
        # (same quantity, different key - the notebook computes it independently of run_api_model.py).
        row['avg_latency_s'] = stats.get('avg_latency_s', stats.get('avg_time_per_paper_s'))
        row['est_cost_usd'] = stats.get('est_cost_usd')
        rows.append(row)

    df = pd.DataFrame(rows).sort_values('mean_f1', ascending=False).reset_index(drop=True)
    return df


def build_report(model_scores: Dict[str, Dict[str, CategoryScore]], run_stats: Dict[str, dict],
                  gold_model: str) -> Tuple[str, pd.DataFrame]:
    summary_df = build_summary_df(model_scores, run_stats)

    lines = ["# Benchmark Report", "", f"Gold standard: `{gold_model}`", "",
             "| Model | Mean F1 | Materials F1 | Properties F1 | Applications F1 | Avg latency (s) | Est. cost (USD) |",
             "|---|---|---|---|---|---|---|"]

    for _, row in summary_df.iterrows():
        mean_f1_display = "1.000 (reference)" if row['model'] == gold_model else f"{row['mean_f1']:.3f}"
        latency = f"{row['avg_latency_s']:.2f}" if pd.notna(row['avg_latency_s']) else "-"
        cost = f"${row['est_cost_usd']:.4f}" if pd.notna(row['est_cost_usd']) else "-"
        lines.append(
            f"| {row['model']} | {mean_f1_display} | {row['materials_f1']:.3f} | "
            f"{row['properties_f1']:.3f} | {row['applications_f1']:.3f} | {latency} | {cost} |"
        )

    lines += ["", "Precision/recall/F1 are computed via schema-aware item matching (see "
              "`benchmark/scoring/matching.py`) with a 10% relative-value tolerance on numeric "
              "properties/applications, not naive JSON string comparison.", ""]

    return "\n".join(lines), summary_df


def build_per_paper_df(all_paper_scores: Dict[str, Dict[str, Dict[str, CategoryScore]]]) -> pd.DataFrame:
    """all_paper_scores: {model: {doi_url: {category: CategoryScore}}} -> long-format DataFrame"""
    rows = []
    for model, per_paper in all_paper_scores.items():
        for doi_url, cat_scores in per_paper.items():
            for cat in CATEGORIES:
                s = cat_scores[cat]
                rows.append({
                    'doi_url': doi_url, 'model': model, 'category': cat,
                    'precision': s.precision, 'recall': s.recall, 'f1': s.f1,
                    'tp': s.tp, 'fp': s.fp, 'fn': s.fn, 'value_mismatches': s.value_mismatches,
                })
    return pd.DataFrame(rows)
