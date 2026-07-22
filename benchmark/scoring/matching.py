"""
Gold <-> candidate item alignment for a single paper's extracted_data.

Materials/properties/applications are unordered lists with no stable ID, so
before we can compute precision/recall we need to decide which candidate
item "is" which gold item. This module does that via a generic greedy
bipartite matcher: score every (gold, candidate) pair, then greedily accept
the highest-scoring pairs above a threshold, without reusing an index on
either side. At the <10 items/paper scale this problem operates at, greedy
matching is equivalent to optimal (Hungarian) matching in practice and much
simpler to reason about.
"""

from dataclasses import dataclass, field
from typing import Any, Callable, Dict, List, Optional, Tuple

from rapidfuzz import fuzz

from app.validator import Validator
from benchmark.config import (
    APPLICATION_TYPE_MATCH_THRESHOLD,
    MATERIAL_FIELD_WEIGHTS,
    MATERIAL_MATCH_THRESHOLD,
    PROPERTY_TYPE_MATCH_THRESHOLD,
    UNIT_EQUIVALENCE_GROUPS,
    VALUE_RELATIVE_TOLERANCE,
)

_validator = Validator()


@dataclass
class MatchResult:
    matched: List[Tuple[int, int, float]] = field(default_factory=list)
    unmatched_gold: List[int] = field(default_factory=list)
    unmatched_cand: List[int] = field(default_factory=list)


def match_items(
    gold_items: List[Dict[str, Any]],
    cand_items: List[Dict[str, Any]],
    *,
    score_fn: Callable[[Dict[str, Any], Dict[str, Any]], float],
    threshold: float,
) -> MatchResult:
    """Greedy one-to-one bipartite matcher: highest-scoring pairs >= threshold win first"""
    candidate_pairs = []
    for gi, gold_item in enumerate(gold_items):
        for ci, cand_item in enumerate(cand_items):
            score = score_fn(gold_item, cand_item)
            if score >= threshold:
                candidate_pairs.append((score, gi, ci))

    candidate_pairs.sort(key=lambda t: t[0], reverse=True)

    matched_gold, matched_cand = set(), set()
    matched: List[Tuple[int, int, float]] = []
    for score, gi, ci in candidate_pairs:
        if gi in matched_gold or ci in matched_cand:
            continue
        matched.append((gi, ci, score))
        matched_gold.add(gi)
        matched_cand.add(ci)

    unmatched_gold = [gi for gi in range(len(gold_items)) if gi not in matched_gold]
    unmatched_cand = [ci for ci in range(len(cand_items)) if ci not in matched_cand]
    return MatchResult(matched=matched, unmatched_gold=unmatched_gold, unmatched_cand=unmatched_cand)


def score_material_pair(gold: Dict[str, Any], cand: Dict[str, Any]) -> float:
    """Weighted average of token_sort_ratio across the material fields; fields blank on both sides are excluded"""
    total_weight = 0.0
    weighted_sum = 0.0

    for field_name, weight in MATERIAL_FIELD_WEIGHTS.items():
        gold_val = str(gold.get(field_name, '') or '').strip()
        cand_val = str(cand.get(field_name, '') or '').strip()

        if not gold_val and not cand_val:
            continue

        total_weight += weight
        if not gold_val or not cand_val:
            continue  # one-sided empty contributes 0 to weighted_sum, but still counts toward total_weight

        # token_set_ratio (not token_sort_ratio) - these fields are often a terse phrase from
        # one model vs a full paragraph from another describing the same synthesis/fabrication;
        # set-based comparison recognizes the shorter text as a subset/paraphrase instead of
        # penalizing the length difference (empirically: 47->100 and 55->96 on real mismatched
        # verbosity pairs from a live DeepSeek Pro vs Flash smoke test).
        weighted_sum += weight * fuzz.token_set_ratio(gold_val, cand_val)

    if total_weight == 0:
        return 0.0
    return weighted_sum / total_weight


def units_equivalent(unit_a: Optional[str], unit_b: Optional[str]) -> bool:
    a = _validator.standardize_unit(unit_a or '').strip().lower()
    b = _validator.standardize_unit(unit_b or '').strip().lower()

    if not a and not b:
        return True
    if a == b:
        return True

    for group in UNIT_EQUIVALENCE_GROUPS:
        if a in group and b in group:
            return True
    return False


def value_within_tolerance(gold_value: Optional[float], cand_value: Optional[float],
                            tolerance: float = VALUE_RELATIVE_TOLERANCE) -> bool:
    if gold_value is None or cand_value is None:
        return False
    if gold_value == 0:
        return abs(cand_value) < 1e-9
    return abs(cand_value - gold_value) / abs(gold_value) <= tolerance


def _property_type_unit_score(gold: Dict[str, Any], cand: Dict[str, Any]) -> float:
    if not units_equivalent(gold.get('unit'), cand.get('unit')):
        return 0.0
    gold_type = str(gold.get('property_type', '') or '')
    cand_type = str(cand.get('property_type', '') or '')
    if not gold_type or not cand_type:
        return 0.0
    return fuzz.ratio(gold_type.lower(), cand_type.lower())


def _application_type_metric_score(gold: Dict[str, Any], cand: Dict[str, Any]) -> float:
    gold_type = str(gold.get('application_type', '') or '')
    cand_type = str(cand.get('application_type', '') or '')
    if not gold_type or not cand_type:
        return 0.0
    type_score = fuzz.ratio(gold_type.lower(), cand_type.lower())

    gold_metric = str(gold.get('metric', '') or '')
    cand_metric = str(cand.get('metric', '') or '')
    if not gold_metric and not cand_metric:
        return type_score
    if not gold_metric or not cand_metric:
        return type_score * 0.5
    metric_score = fuzz.ratio(gold_metric.lower(), cand_metric.lower())
    return (type_score + metric_score) / 2


def match_materials(gold: List[Dict[str, Any]], cand: List[Dict[str, Any]]) -> MatchResult:
    return match_items(gold, cand, score_fn=score_material_pair, threshold=MATERIAL_MATCH_THRESHOLD)


def match_properties(gold: List[Dict[str, Any]], cand: List[Dict[str, Any]]) -> Tuple[MatchResult, List[Tuple[int, int]]]:
    """Matches on property_type + unit equivalence. Type/unit-matched pairs whose numeric value
    falls outside VALUE_RELATIVE_TOLERANCE are still returned as 'matched' structurally, but also
    listed separately in value_mismatches - callers (metrics.py) decide how to score those."""
    result = match_items(gold, cand, score_fn=_property_type_unit_score, threshold=PROPERTY_TYPE_MATCH_THRESHOLD)
    value_mismatches = [
        (gi, ci) for gi, ci, _ in result.matched
        if not value_within_tolerance(gold[gi].get('value'), cand[ci].get('value'))
    ]
    return result, value_mismatches


def match_applications(gold: List[Dict[str, Any]], cand: List[Dict[str, Any]]) -> Tuple[MatchResult, List[Tuple[int, int]]]:
    """Matches on application_type + metric. Same value_mismatches convention as match_properties."""
    result = match_items(gold, cand, score_fn=_application_type_metric_score, threshold=APPLICATION_TYPE_MATCH_THRESHOLD)
    value_mismatches = [
        (gi, ci) for gi, ci, _ in result.matched
        if not value_within_tolerance(gold[gi].get('value'), cand[ci].get('value'))
    ]
    return result, value_mismatches
