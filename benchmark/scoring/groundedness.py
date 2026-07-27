"""
Groundedness/faithfulness checking: does each extracted item trace back to the
source text we actually gave the model? Unlike everything else in benchmark/scoring/,
this needs NO gold standard - each item is checked against the paper's own
title+abstract+conclusion, not compared to another model's output. That means it can
run over every stored run, including ones never scored against consensus-gold.

This is the RAG "faithfulness"/"groundedness" technique (RAGAS, TruLens, DeepEval)
applied to an extractive task instead of open-ended generation: since our models are
asked to pull facts out of provided text rather than answer from world knowledge, a
real answer should be near-verbatim traceable to that text. An item that can't be
found there is a strong hallucination signal - and critically, checking "does this
number appear in this paragraph" is a reading-comprehension check anyone can
spot-check by hand, unlike judging whether the underlying science is correct.

Two field types get different treatment:
- Numeric value+unit (properties/applications): search source text for a number
  within VALUE_RELATIVE_TOLERANCE, with a compatible unit in the local window around
  it (not just anywhere in the whole paper - two nearby-but-different numbers in the
  same sentence, e.g. "530 F g-1 at 1 A g-1", make a whole-text unit search too loose).
- Free text (materials' composition/synthesis/fabrication fields): fuzzy substring
  match via rapidfuzz - extractive tasks shouldn't paraphrase, so a low partial-ratio
  score is a real signal, not just style variance.

Categorical labels (property_type, application_type) are deliberately NOT checked
here - they're the model's own classification choice, not a literal quote, so strict
text-matching doesn't meaningfully apply to them.
"""

import re
from typing import Any, Dict, List, Optional, Tuple

from rapidfuzz import fuzz

from app.validator import Validator
from benchmark.config import VALUE_RELATIVE_TOLERANCE

_validator = Validator()

# Matches ints/decimals, optionally in "a x 10^b" / "aEb" scientific notation, with a
# unicode minus (papers extracted from PDFs often carry '−' instead of ASCII '-').
NUMBER_RE = re.compile(
    r'[-−]?\d+\.?\d*(?:\s*[x×]\s*10\s*\^?\s*[-−]?\d+|[eE][-−]?\d+)?'
)

TEXT_MATCH_THRESHOLD = 70.0  # rapidfuzz partial_ratio, 0-100
WINDOW_CHARS = 60  # chars of context searched around each numeric hit for a matching unit

MATERIAL_TEXT_FIELDS = ["mxene_composition", "composite_material", "synthesis_method", "fabrication_method"]


def _normalize_number(token: str) -> Optional[float]:
    token = token.replace('−', '-').replace(' ', '')
    try:
        if 'x10' in token.lower():
            base, exp = re.split(r'x10\^?', token, flags=re.IGNORECASE)
            return float(base) * (10 ** float(exp))
        return float(token)
    except (ValueError, ZeroDivisionError):
        return None


def _letters_only(s: str) -> str:
    """Strips everything but letters, so 'F/g', 'F g-1', 'F g−1' all normalize to 'fg' -
    unit notation varies too much (slashes, superscript exponents, unicode minus, spacing)
    for exact substring matching to be workable against raw paper text."""
    return re.sub(r'[^a-z]', '', s.lower())


def _find_numbers_with_context(text: str) -> List[Tuple[float, str]]:
    """(value, forward_unit_window) for every number-like token in text. The window is
    forward-only (text right after the number) and stops at the next digit, so a unit
    belonging to a DIFFERENT nearby number (e.g. "530 F g-1 at 1 A g-1" - checking the "1"
    must not pick up "F g-1" from the preceding number) isn't picked up."""
    hits = []
    for m in NUMBER_RE.finditer(text):
        val = _normalize_number(m.group())
        if val is None:
            continue
        tail = text[m.end():m.end() + WINDOW_CHARS]
        next_digit = re.search(r'\d', tail)
        window = tail[:next_digit.start()] if next_digit else tail
        hits.append((val, window.lower()))
    return hits


def value_is_grounded(value: Optional[float], unit: Optional[str], source_text: str,
                       tolerance: float = VALUE_RELATIVE_TOLERANCE) -> bool:
    """A numeric value is grounded if some number in source_text is within `tolerance` of it,
    with a compatible unit appearing in the text immediately following that number."""
    if value is None:
        return False
    target_unit = _letters_only(_validator.standardize_unit(unit or '') or unit or '')

    for found_val, window in _find_numbers_with_context(source_text):
        close = abs(found_val) < 1e-9 if value == 0 else abs(found_val - value) / abs(value) <= tolerance
        if not close:
            continue
        if not target_unit:
            return True  # nothing to check the unit against - numeric proximity alone counts
        if target_unit in _letters_only(window):
            return True
    return False


def text_is_grounded(extracted_text: Optional[str], source_text: str,
                      threshold: float = TEXT_MATCH_THRESHOLD) -> bool:
    """A free-text field is grounded if it fuzzy-matches some substring of source_text"""
    extracted_text = (extracted_text or '').strip()
    if not extracted_text:
        return True  # nothing claimed, nothing to hallucinate
    return fuzz.partial_ratio(extracted_text.lower(), source_text.lower()) >= threshold


def score_paper_groundedness(extracted_data: Dict[str, Any], source_text: str) -> Dict[str, Any]:
    """Per-paper groundedness: (grounded, total) counts per category, plus the individual
    ungrounded items for human spot-checking."""
    flagged: List[Dict[str, Any]] = []

    mat_grounded = mat_total = 0
    for item in extracted_data.get('materials', []) or []:
        for field in MATERIAL_TEXT_FIELDS:
            val = (item.get(field) or '').strip()
            if not val:
                continue
            mat_total += 1
            if text_is_grounded(val, source_text):
                mat_grounded += 1
            else:
                flagged.append({'category': 'materials', 'field': field, 'value': val})

    prop_grounded = prop_total = 0
    for item in extracted_data.get('properties', []) or []:
        if item.get('value') is None:
            continue  # nothing claimed, nothing to hallucinate - same convention as text fields
        prop_total += 1
        if value_is_grounded(item.get('value'), item.get('unit'), source_text):
            prop_grounded += 1
        else:
            flagged.append({
                'category': 'properties', 'field': 'value',
                'value': item.get('value'), 'unit': item.get('unit'),
            })

    app_grounded = app_total = 0
    for item in extracted_data.get('applications', []) or []:
        if item.get('value') is None:
            continue
        app_total += 1
        if value_is_grounded(item.get('value'), item.get('unit'), source_text):
            app_grounded += 1
        else:
            flagged.append({
                'category': 'applications', 'field': 'value',
                'value': item.get('value'), 'unit': item.get('unit'),
            })

    return {
        'materials': (mat_grounded, mat_total),
        'properties': (prop_grounded, prop_total),
        'applications': (app_grounded, app_total),
        'flagged': flagged,
    }
