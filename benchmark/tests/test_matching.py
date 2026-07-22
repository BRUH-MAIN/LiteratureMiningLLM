from benchmark.scoring.matching import (
    match_applications,
    match_materials,
    match_properties,
    score_material_pair,
    units_equivalent,
    value_within_tolerance,
)


def test_score_material_pair_exact_match():
    m = {"mxene_composition": "Ti3C2Tx", "composite_material": "BC", "synthesis_method": "etch", "fabrication_method": "filter"}
    assert score_material_pair(m, dict(m)) == 100.0


def test_score_material_pair_near_duplicate_scores_high():
    gold = {"mxene_composition": "Ti2CTx", "composite_material": "", "synthesis_method": "HF etching", "fabrication_method": "spray coating"}
    cand = {"mxene_composition": "Ti2CTx", "composite_material": "", "synthesis_method": "HF etching ", "fabrication_method": "spray-coating"}
    assert score_material_pair(gold, cand) >= 85.0


def test_units_equivalent_after_standardization():
    assert units_equivalent("S/m", "s m−1")
    assert not units_equivalent("S/m", "GPa")


def test_value_within_tolerance():
    assert value_within_tolerance(1000.0, 1050.0, tolerance=0.10)
    assert not value_within_tolerance(200.0, 600.0, tolerance=0.10)
    assert value_within_tolerance(0.0, 0.0)
    assert not value_within_tolerance(None, 1.0)


def test_match_materials_hallucinated_item_is_unmatched_candidate():
    gold = [{"mxene_composition": "Ti3C2Tx", "composite_material": "", "synthesis_method": "", "fabrication_method": ""}]
    cand = [
        {"mxene_composition": "Ti3C2Tx", "composite_material": "", "synthesis_method": "", "fabrication_method": ""},
        {"mxene_composition": "Nb2CTx", "composite_material": "", "synthesis_method": "", "fabrication_method": ""},
    ]
    result = match_materials(gold, cand)
    assert len(result.matched) == 1
    assert result.unmatched_gold == []
    assert result.unmatched_cand == [1]


def test_match_properties_flags_out_of_tolerance_values():
    gold = [{"property_type": "Conductivity", "value": 200.0, "unit": "S/m"}]
    cand = [{"property_type": "Conductivity", "value": 600.0, "unit": "S/m"}]
    result, mismatches = match_properties(gold, cand)
    assert len(result.matched) == 1
    assert mismatches == [(0, 0)]


def test_match_applications_missing_gold_item_is_fn():
    gold = [
        {"application_type": "sensors", "metric": "sensitivity", "value": 5.0, "unit": "kPa-1"},
        {"application_type": "energy_storage", "metric": "capacitance", "value": 200.0, "unit": "F/g"},
    ]
    cand = [{"application_type": "sensors", "metric": "sensitivity", "value": 5.1, "unit": "kPa-1"}]
    result, mismatches = match_applications(gold, cand)
    assert len(result.matched) == 1
    assert result.unmatched_gold == [1]
    assert mismatches == []
