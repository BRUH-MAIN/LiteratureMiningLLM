"""
Per-paper and aggregate precision/recall/F1 for the materials/properties/applications
categories, built on top of benchmark.scoring.matching's item alignment.
"""

from dataclasses import dataclass
from typing import Any, Dict, List

from benchmark.scoring.matching import match_applications, match_materials, match_properties

CATEGORIES = ("materials", "properties", "applications")


@dataclass
class CategoryScore:
    tp: int = 0
    fp: int = 0
    fn: int = 0
    value_mismatches: int = 0

    @property
    def precision(self) -> float:
        denom = self.tp + self.fp
        return self.tp / denom if denom else (1.0 if self.tp == 0 and self.fn == 0 else 0.0)

    @property
    def recall(self) -> float:
        denom = self.tp + self.fn
        return self.tp / denom if denom else (1.0 if self.tp == 0 and self.fp == 0 else 0.0)

    @property
    def f1(self) -> float:
        p, r = self.precision, self.recall
        return 2 * p * r / (p + r) if (p + r) else 0.0

    def __add__(self, other: "CategoryScore") -> "CategoryScore":
        return CategoryScore(
            tp=self.tp + other.tp,
            fp=self.fp + other.fp,
            fn=self.fn + other.fn,
            value_mismatches=self.value_mismatches + other.value_mismatches,
        )


def score_paper(gold_extracted: Dict[str, Any], cand_extracted: Dict[str, Any]) -> Dict[str, CategoryScore]:
    """Score one paper's candidate extraction against gold. A type/unit-matched pair whose numeric
    value falls outside tolerance counts as 1 FP + 1 FN (strict mode) and is also tracked separately
    as a value_mismatch for diagnostics."""
    gold_materials = gold_extracted.get('materials', []) or []
    cand_materials = cand_extracted.get('materials', []) or []
    material_match = match_materials(gold_materials, cand_materials)
    materials_score = CategoryScore(
        tp=len(material_match.matched),
        fp=len(material_match.unmatched_cand),
        fn=len(material_match.unmatched_gold),
    )

    gold_properties = gold_extracted.get('properties', []) or []
    cand_properties = cand_extracted.get('properties', []) or []
    prop_match, prop_value_mismatches = match_properties(gold_properties, cand_properties)
    n_mismatch = len(prop_value_mismatches)
    properties_score = CategoryScore(
        tp=len(prop_match.matched) - n_mismatch,
        fp=len(prop_match.unmatched_cand) + n_mismatch,
        fn=len(prop_match.unmatched_gold) + n_mismatch,
        value_mismatches=n_mismatch,
    )

    gold_applications = gold_extracted.get('applications', []) or []
    cand_applications = cand_extracted.get('applications', []) or []
    app_match, app_value_mismatches = match_applications(gold_applications, cand_applications)
    n_mismatch = len(app_value_mismatches)
    applications_score = CategoryScore(
        tp=len(app_match.matched) - n_mismatch,
        fp=len(app_match.unmatched_cand) + n_mismatch,
        fn=len(app_match.unmatched_gold) + n_mismatch,
        value_mismatches=n_mismatch,
    )

    return {
        'materials': materials_score,
        'properties': properties_score,
        'applications': applications_score,
    }


def aggregate_micro(per_paper: List[Dict[str, CategoryScore]]) -> Dict[str, CategoryScore]:
    """Primary metric: sum tp/fp/fn across all papers per category, then derive one P/R/F1 per category"""
    totals = {cat: CategoryScore() for cat in CATEGORIES}
    for paper_scores in per_paper:
        for cat in CATEGORIES:
            totals[cat] = totals[cat] + paper_scores[cat]
    return totals


def aggregate_macro(per_paper: List[Dict[str, CategoryScore]]) -> Dict[str, float]:
    """Secondary metric: mean of per-paper F1, excluding papers with zero gold items in that category"""
    macro = {}
    for cat in CATEGORIES:
        f1s = [
            paper_scores[cat].f1
            for paper_scores in per_paper
            if (paper_scores[cat].tp + paper_scores[cat].fn) > 0
        ]
        macro[cat] = sum(f1s) / len(f1s) if f1s else 0.0
    return macro
