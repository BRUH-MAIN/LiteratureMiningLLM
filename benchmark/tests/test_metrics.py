import json
from pathlib import Path

import pytest

from benchmark.scoring.metrics import aggregate_micro, score_paper

FIXTURES_DIR = Path(__file__).parent / "fixtures"


def _load(name):
    return json.load(open(FIXTURES_DIR / name, encoding='utf-8'))


@pytest.fixture
def gold_papers():
    return {p['doi_url']: p['extracted_data'] for p in _load('gold_fixture.json')}


@pytest.fixture
def candidate_papers():
    return {p['doi_url']: p['extracted_data'] for p in _load('candidate_fixture.json')}


def test_paper1_exact_match_is_perfect(gold_papers, candidate_papers):
    scores = score_paper(gold_papers['10.1000/fake1'], candidate_papers['10.1000/fake1'])
    for cat in ('materials', 'properties', 'applications'):
        assert scores[cat].precision == 1.0
        assert scores[cat].recall == 1.0
        assert scores[cat].f1 == 1.0


def test_paper2_mixed_case_counts(gold_papers, candidate_papers):
    scores = score_paper(gold_papers['10.1000/fake2'], candidate_papers['10.1000/fake2'])

    # materials: fuzzy near-duplicate still matches -> perfect
    assert (scores['materials'].tp, scores['materials'].fp, scores['materials'].fn) == (1, 0, 0)

    # properties: Conductivity matched within tolerance (TP), Young_Modulus missing from candidate (FN)
    assert (scores['properties'].tp, scores['properties'].fp, scores['properties'].fn) == (1, 0, 1)

    # applications: capacitance matched but value out of tolerance (FP+FN), shielding is hallucinated (FP)
    assert (scores['applications'].tp, scores['applications'].fp, scores['applications'].fn) == (0, 2, 1)
    assert scores['applications'].value_mismatches == 1


def test_gold_vs_gold_is_always_perfect(gold_papers):
    """Regression guard: scoring the gold run against itself must always yield P=R=F1=1.0.
    Any matcher/metrics bug will show up here as a score below 1.0."""
    per_paper = [score_paper(extracted, extracted) for extracted in gold_papers.values()]
    micro = aggregate_micro(per_paper)
    for cat in ('materials', 'properties', 'applications'):
        assert micro[cat].precision == 1.0
        assert micro[cat].recall == 1.0
        assert micro[cat].f1 == 1.0
        assert micro[cat].value_mismatches == 0
