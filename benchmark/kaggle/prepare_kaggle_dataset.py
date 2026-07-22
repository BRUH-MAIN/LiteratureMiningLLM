"""
Bundles the benchmark subset + shared prompt template + dependency-free
app/json_utils.py and app/validator.py + the Kaggle candidate-model registry
into a Kaggle Dataset, so the candidate_run notebook parses/validates
extractions identically to the local pipeline and reads model configs from
the same source of truth as benchmark/config.py rather than a hardcoded copy.

Requires the `kaggle` CLI to be authenticated (KAGGLE_USERNAME/KAGGLE_KEY
in .env, picked up via app.config's load_dotenv() call before this module
shells out to `kaggle`).

    uv run python -m benchmark.kaggle.prepare_kaggle_dataset
"""

import argparse
import json
import logging
import shutil
import subprocess
from pathlib import Path

from app.config import Config  # noqa: F401  (import triggers load_dotenv())
from benchmark.config import KAGGLE_CANDIDATES

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

BUNDLE_FILES = {
    'data/processed/benchmark_subset.json': 'benchmark_subset.json',
    'prompts/extraction_prompt.txt': 'extraction_prompt.txt',
    'app/json_utils.py': 'json_utils.py',
    'app/validator.py': 'validator.py',
}


def build_bundle(bundle_dir: Path) -> None:
    if bundle_dir.exists():
        shutil.rmtree(bundle_dir)
    bundle_dir.mkdir(parents=True)

    for src, dest_name in BUNDLE_FILES.items():
        src_path = Path(src)
        if not src_path.exists():
            raise FileNotFoundError(f"Missing bundle input: {src_path} (run benchmark.sample_subset first?)")
        shutil.copy(src_path, bundle_dir / dest_name)
        logger.info(f"Bundled {src_path} -> {dest_name}")

    with open(bundle_dir / 'kaggle_candidates.json', 'w', encoding='utf-8') as f:
        json.dump(KAGGLE_CANDIDATES, f, indent=2)
    logger.info("Bundled benchmark.config.KAGGLE_CANDIDATES -> kaggle_candidates.json")


def write_dataset_metadata(bundle_dir: Path, dataset_slug: str) -> None:
    if not Config.KAGGLE_USERNAME:
        raise ValueError("KAGGLE_USERNAME environment variable not set")

    metadata = {
        "title": "MXene Benchmark Subset",
        "id": f"{Config.KAGGLE_USERNAME}/{dataset_slug}",
        "licenses": [{"name": "CC0-1.0"}],
    }
    with open(bundle_dir / 'dataset-metadata.json', 'w', encoding='utf-8') as f:
        json.dump(metadata, f, indent=2)


def push_dataset(bundle_dir: Path, version_message: str, first_time: bool) -> None:
    if first_time:
        cmd = ["kaggle", "datasets", "create", "-p", str(bundle_dir), "--dir-mode", "zip"]
    else:
        cmd = ["kaggle", "datasets", "version", "-p", str(bundle_dir), "-m", version_message, "--dir-mode", "zip"]

    logger.info(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    logger.info(result.stdout)
    if result.returncode != 0:
        logger.error(result.stderr)
        raise RuntimeError(f"kaggle CLI failed (exit {result.returncode}): {result.stderr}")


def main():
    parser = argparse.ArgumentParser(description="Bundle and push the benchmark subset + shared code to Kaggle as a Dataset")
    parser.add_argument('--bundle-dir', default='benchmark/kaggle/dataset_bundle')
    parser.add_argument('--dataset-slug', default='mxene-benchmark-subset')
    parser.add_argument('--message', default='Update benchmark subset')
    parser.add_argument('--first-time', action='store_true', help="Use `kaggle datasets create` instead of `version` (only needed once)")
    args = parser.parse_args()

    bundle_dir = Path(args.bundle_dir)
    build_bundle(bundle_dir)
    write_dataset_metadata(bundle_dir, args.dataset_slug)
    push_dataset(bundle_dir, args.message, args.first_time)


if __name__ == '__main__':
    main()
