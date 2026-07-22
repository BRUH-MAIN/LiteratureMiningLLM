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
