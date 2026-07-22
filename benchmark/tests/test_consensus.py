import json
from pathlib import Path

import pytest

from benchmark.consensus import build_agreement_report, build_consensus

FIXTURES_DIR = Path(__file__).parent / "fixtures"


def _load_by_doi(name):
    papers = json.load(open(FIXTURES_DIR / name, encoding='utf-8'))
    return {p['doi_url']: p for p in papers}


@pytest.fixture
def panel_a():
    return _load_by_doi('gold_fixture.json')


@pytest.fixture
def panel_b():
    return _load_by_doi('candidate_fixture.json')


def test_build_consensus_confirmed_and_contested_counts(panel_a, panel_b):
    consensus_papers, contested, per_paper_agreement = build_consensus(panel_a, panel_b, 'panel-a', 'panel-b')

    assert len(consensus_papers) == 2

    by_doi = {p['doi_url']: p for p in consensus_papers}

    # Paper 1 is an exact match on both sides -> everything confirmed
    p1 = by_doi['10.1000/fake1']['extracted_data']
    assert len(p1['materials']) == 1
    assert len(p1['properties']) == 1
    assert len(p1['applications']) == 1

    # Paper 2: materials fuzzy-match (confirmed), Conductivity in-tolerance (confirmed),
    # Young_Modulus only in panel_a (contested), capacitance value mismatch (contested),
    # shielding only in panel_b (contested)
    p2 = by_doi['10.1000/fake2']['extracted_data']
    assert len(p2['materials']) == 1
    assert len(p2['properties']) == 1
    assert p2['properties'][0]['property_type'] == 'Conductivity'
    assert len(p2['applications']) == 0

    assert len(contested) == 3
    categories = sorted(item['category'] for item in contested)
    assert categories == ['applications', 'applications', 'properties']


def test_agreement_report_structure(panel_a, panel_b):
    _, contested, per_paper_agreement = build_consensus(panel_a, panel_b, 'panel-a', 'panel-b')
    report_md, report_json = build_agreement_report(per_paper_agreement, 'panel-a', 'panel-b', contested)

    assert report_json['reference_panel'] == ['panel-a', 'panel-b']
    for cat in ('materials', 'properties', 'applications'):
        assert 0.0 <= report_json['agreement_micro'][cat]['f1'] <= 1.0
    assert 'panel-a' in report_md and 'panel-b' in report_md
