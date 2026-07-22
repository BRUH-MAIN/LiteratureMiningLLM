from app.json_utils import extract_json_from_response

NESTED_JSON = '{"materials": [{"mxene_composition": "Ti3C2Tx"}], "properties": [], "applications": []}'


def test_extracts_clean_json_directly():
    assert extract_json_from_response(NESTED_JSON) == {
        "materials": [{"mxene_composition": "Ti3C2Tx"}], "properties": [], "applications": []
    }


def test_strips_deepseek_think_tags():
    response = f"<think>reasoning about the paper...</think>{NESTED_JSON}"
    assert extract_json_from_response(response) is not None


def test_strips_gpt_oss_harmony_channel_tags():
    """gpt-oss wraps reasoning in an 'analysis' channel before the real answer in 'final'"""
    response = (
        "<|channel|>analysis<|message|>We need to parse the abstract and extract materials...<|end|>"
        f"<|start|>assistant<|channel|>final<|message|>{NESTED_JSON}<|return|>"
    )
    result = extract_json_from_response(response)
    assert result == {"materials": [{"mxene_composition": "Ti3C2Tx"}], "properties": [], "applications": []}


def test_regex_fallback_captures_full_nested_object_not_just_first_inner_brace():
    """Regression test: a naive non-greedy match would truncate at the first inner object's
    closing brace (the first material), losing properties/applications entirely."""
    response = f"Here is the extracted data:\n{NESTED_JSON}\nLet me know if you need anything else."
    result = extract_json_from_response(response)
    assert result is not None
    assert "properties" in result and "applications" in result


def test_strips_markdown_code_fences():
    response = f"```json\n{NESTED_JSON}\n```"
    assert extract_json_from_response(response) is not None


def test_returns_none_on_unparseable_response():
    assert extract_json_from_response("not json at all") is None
