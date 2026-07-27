from benchmark.scoring.groundedness import (
    score_paper_groundedness,
    text_is_grounded,
    value_is_grounded,
)

SOURCE_TEXT = (
    "The pMT electrode achieves a specific capacitance of 530 F g-1 at 1 A g-1 and "
    "retains 300 F g-1 at 50 A g-1. Ti3C2Tx nanosheets were prepared via HF etching. "
    "The asymmetric supercapacitor reaches 23.8 Wh kg-1 energy density at 300.2 W kg-1."
)


def test_value_is_grounded_exact_match():
    assert value_is_grounded(530, "F/g", SOURCE_TEXT)


def test_value_is_grounded_within_tolerance():
    assert value_is_grounded(528.5, "F/g", SOURCE_TEXT, tolerance=0.10)


def test_value_is_grounded_rejects_hallucinated_value():
    assert not value_is_grounded(9999, "F/g", SOURCE_TEXT)


def test_value_is_grounded_rejects_wrong_unit_for_a_real_number():
    # 530 is genuinely in the text, but not paired with GPa anywhere nearby
    assert not value_is_grounded(530, "GPa", SOURCE_TEXT)


def test_value_is_grounded_does_not_cross_match_nearby_numbers():
    # 1 (A/g) is in the text but never paired with F/g in its own window
    assert not value_is_grounded(1, "F/g", SOURCE_TEXT)


def test_value_is_grounded_none_value_is_false():
    assert not value_is_grounded(None, "F/g", SOURCE_TEXT)


def test_text_is_grounded_matches_substring():
    assert text_is_grounded("Ti3C2Tx", SOURCE_TEXT)


def test_text_is_grounded_rejects_unrelated_text():
    assert not text_is_grounded("Nb2CTx MAX phase exfoliation", SOURCE_TEXT)


def test_text_is_grounded_empty_field_counts_as_grounded():
    # nothing claimed, nothing to hallucinate
    assert text_is_grounded("", SOURCE_TEXT)
    assert text_is_grounded(None, SOURCE_TEXT)


def test_score_paper_groundedness_excludes_null_values_from_total():
    # A None value means the model claimed nothing for that item - it shouldn't count as
    # "ungrounded" (that would conflate omission with hallucination, inflating flagged counts
    # with non-issues; confirmed against real data where these were drowning out genuine finds).
    extracted = {
        "materials": [],
        "properties": [{"property_type": "Conductivity", "value": None, "unit": ""}],
        "applications": [],
    }
    result = score_paper_groundedness(extracted, SOURCE_TEXT)
    assert result["properties"] == (0, 0)
    assert result["flagged"] == []


def test_score_paper_groundedness_counts():
    extracted = {
        "materials": [{"mxene_composition": "Ti3C2Tx", "composite_material": "", "synthesis_method": "HF etching", "fabrication_method": ""}],
        "properties": [
            {"property_type": "Specific_Capacitance", "value": 530, "unit": "F/g"},
            {"property_type": "Fake_Property", "value": 9999, "unit": "F/g"},
        ],
        "applications": [{"application_type": "energy_storage", "metric": "energy_density", "value": 23.8, "unit": "Wh/kg"}],
    }
    result = score_paper_groundedness(extracted, SOURCE_TEXT)
    assert result["materials"] == (2, 2)  # mxene_composition + synthesis_method both grounded
    assert result["properties"] == (1, 2)  # 530 grounded, 9999 not
    assert result["applications"] == (1, 1)
    assert len(result["flagged"]) == 1
    assert result["flagged"][0]["value"] == 9999
