import json

from benchmark.kaggle.pull_results import fan_out

SAMPLE_EXTRACTIONS = [
    {"doi_url": "10.1000/fake1", "title": "t", "extracted_data": {"materials": [], "properties": [], "applications": []}},
]


def test_fan_out_discovers_multiple_run_key_subfolders(tmp_path):
    staging_dir = tmp_path / 'staging'
    runs_dir = tmp_path / 'runs'

    for run_key in ('gpt-oss-20b__low', 'gpt-oss-20b__medium'):
        sub = staging_dir / run_key
        sub.mkdir(parents=True)
        with open(sub / 'extractions.json', 'w', encoding='utf-8') as f:
            json.dump(SAMPLE_EXTRACTIONS, f)
        with open(sub / 'run_stats.json', 'w', encoding='utf-8') as f:
            json.dump({'run_key': run_key}, f)

    fanned_out = fan_out(staging_dir, runs_dir)

    assert sorted(fanned_out) == ['gpt-oss-20b__low', 'gpt-oss-20b__medium']
    for run_key in fanned_out:
        assert (runs_dir / run_key / 'extractions.json').exists()
        assert (runs_dir / run_key / 'run_stats.json').exists()
