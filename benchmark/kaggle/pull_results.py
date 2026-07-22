"""
Download a finished Kaggle kernel's output into results/runs/. Since
benchmark/kaggle/candidate_run/ runs multiple models x thinking-levels
sequentially in ONE kernel, its /kaggle/working output contains multiple
<run_key>/{extractions.json,run_stats.json} subfolders (one per model x
level combination) rather than a single flat extractions.json - this fans
those out into results/runs/<run_key>/ for each one, with a light
shape-check before treating any of them as usable input to the scorer.

    uv run python -m benchmark.kaggle.pull_results --kernel-slug <kaggle_username>/mxene-candidate-run
"""

import argparse
import json
import logging
import shutil
import subprocess
from pathlib import Path

from app.config import Config  # noqa: F401  (import triggers load_dotenv())

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


def pull(kernel_slug: str, staging_dir: Path) -> None:
    staging_dir.mkdir(parents=True, exist_ok=True)
    cmd = ["kaggle", "kernels", "output", kernel_slug, "-p", str(staging_dir)]
    logger.info(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    logger.info(result.stdout)
    if result.returncode != 0:
        logger.error(result.stderr)
        raise RuntimeError(f"kaggle kernels output failed (exit {result.returncode}): {result.stderr}")


def validate_shape(extractions_path: Path) -> int:
    if not extractions_path.exists():
        raise FileNotFoundError(f"Expected {extractions_path} - was the run successful?")

    data = json.load(open(extractions_path, encoding='utf-8'))
    if not isinstance(data, list) or not data:
        raise ValueError(f"{extractions_path} did not contain a non-empty JSON list")

    for item in data:
        if 'doi_url' not in item or 'extracted_data' not in item:
            raise ValueError(f"{extractions_path} contains an item missing 'doi_url' or 'extracted_data': {item}")

    return len(data)


def fan_out(staging_dir: Path, runs_dir: Path) -> list:
    """Find every <run_key>/extractions.json under the pulled output and copy it into
    results/runs/<run_key>/, using the subfolder name the notebook itself already assigned."""
    fanned_out = []
    for extractions_path in staging_dir.rglob('extractions.json'):
        run_key = extractions_path.parent.name
        dest_dir = runs_dir / run_key
        dest_dir.mkdir(parents=True, exist_ok=True)

        shutil.copy(extractions_path, dest_dir / 'extractions.json')
        stats_path = extractions_path.parent / 'run_stats.json'
        if stats_path.exists():
            shutil.copy(stats_path, dest_dir / 'run_stats.json')

        n_papers = validate_shape(dest_dir / 'extractions.json')
        logger.info(f"'{run_key}': {n_papers} papers -> {dest_dir}")
        fanned_out.append(run_key)

    return fanned_out


def main():
    parser = argparse.ArgumentParser(
        description="Pull a candidate_run kernel's output and fan its multiple run subfolders into results/runs/"
    )
    parser.add_argument('--kernel-slug', required=True)
    parser.add_argument('--staging-dir', default='benchmark/kaggle/_pulled')
    parser.add_argument('--runs-dir', default='results/runs')
    args = parser.parse_args()

    staging_dir = Path(args.staging_dir)
    pull(args.kernel_slug, staging_dir)

    fanned_out = fan_out(staging_dir, Path(args.runs_dir))
    if not fanned_out:
        raise RuntimeError(f"No <run_key>/extractions.json found under {staging_dir} - check the kernel actually completed")

    logger.info(f"Fanned out {len(fanned_out)} run(s): {fanned_out}")


if __name__ == '__main__':
    main()
