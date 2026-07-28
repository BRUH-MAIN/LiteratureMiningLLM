import json
import shutil
from pathlib import Path

import pytest

from benchmark.config import REFERENCE_PANEL
from benchmark.run_benchmark import check_no_panel_candidates, run_benchmark

FIXTURES_DIR = Path(__file__).parent / "fixtures"


def test_check_no_panel_candidates_rejects_reference_models():
    a_panel_key = next(iter(REFERENCE_PANEL))

    with pytest.raises(ValueError, match="reference-panel"):
        check_no_panel_candidates([a_panel_key, 'gpt-oss-20b__low'])

    check_no_panel_candidates(['gpt-oss-20b__low'])  # should not raise


def test_run_benchmark_end_to_end(tmp_path):
    runs_dir = tmp_path / 'runs'
    (runs_dir / 'consensus-gold').mkdir(parents=True)
    (runs_dir / 'some-candidate').mkdir(parents=True)

    shutil.copy(FIXTURES_DIR / 'gold_fixture.json', runs_dir / 'consensus-gold' / 'extractions.json')
    shutil.copy(FIXTURES_DIR / 'candidate_fixture.json', runs_dir / 'some-candidate' / 'extractions.json')

    out_dir = tmp_path / 'report'
    report_md, summary_df, per_paper_df = run_benchmark(
        'consensus-gold', ['some-candidate'], runs_dir, out_dir
    )

    assert (out_dir / 'report.md').exists()
    assert (out_dir / 'summary.csv').exists()
    assert (out_dir / 'per_paper_scores.csv').exists()

    assert 'family' in summary_df.columns and 'thinking_level' in summary_df.columns
    gold_row = summary_df[summary_df['model'] == 'consensus-gold'].iloc[0]
    assert gold_row['family'] == 'consensus-gold' and gold_row['thinking_level'] is None
    assert 'consensus-gold' in report_md


def test_run_benchmark_skips_candidates_with_no_run(tmp_path):
    """A registered-but-not-yet-run candidate must not abort scoring of the ones that do have
    data - benchmark.config lists models whose runs may not exist locally."""
    runs_dir = tmp_path / 'runs'
    (runs_dir / 'consensus-gold').mkdir(parents=True)
    (runs_dir / 'some-candidate').mkdir(parents=True)
    shutil.copy(FIXTURES_DIR / 'gold_fixture.json', runs_dir / 'consensus-gold' / 'extractions.json')
    shutil.copy(FIXTURES_DIR / 'candidate_fixture.json', runs_dir / 'some-candidate' / 'extractions.json')

    _, summary_df, _ = run_benchmark(
        'consensus-gold', ['some-candidate', 'never-run-model'], runs_dir, tmp_path / 'report'
    )

    assert set(summary_df['model']) == {'consensus-gold', 'some-candidate'}


def test_all_candidate_run_keys_includes_kbench_candidates():
    """The default `run_benchmark` invocation uses this - omitting a registry silently drops
    those models from the published leaderboard."""
    from benchmark.config import KBENCH_CANDIDATES, all_candidate_run_keys

    keys = all_candidate_run_keys()
    assert set(KBENCH_CANDIDATES).issubset(keys)
