"""
Deterministic paper subset sampler for the gold-standard/benchmark workflow.

Draws a fixed, seeded subset of papers from the full 296-paper dataset so
the DeepSeek gold-standard run and every Kaggle candidate model run see
exactly the same papers.
"""

import argparse
import csv
import json
import logging
import random
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List

from app.preprocessor import Preprocessor

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

MIN_TEXT_LENGTH = 100  # matches Extractor.extract_data_from_text's own skip threshold


def is_eligible(paper: Dict[str, Any]) -> bool:
    """A paper is eligible if it has enough abstract+conclusion text for extraction to run at all"""
    combined_text = f"{paper.get('abstract', '')}\n\n{paper.get('conclusion', '')}"
    return len(combined_text.strip()) >= MIN_TEXT_LENGTH


def select_subset(papers: List[Dict[str, Any]], n: int, seed: int) -> List[Dict[str, Any]]:
    eligible = [p for p in papers if is_eligible(p)]

    if n > len(eligible):
        raise ValueError(f"Requested subset size {n} exceeds eligible paper count {len(eligible)}")

    indices = sorted(random.Random(seed).sample(range(len(eligible)), n))
    return [eligible[i] for i in indices]


def write_manifest(subset: List[Dict[str, Any]], manifest_path: Path) -> None:
    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    with open(manifest_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['doi_url', 'title', 'year', 'journal'])
        for paper in subset:
            writer.writerow([paper.get('doi_url', ''), paper.get('title', ''), paper.get('year', ''), paper.get('journal', '')])


def write_meta(meta_path: Path, *, n: int, seed: int, eligible_count: int, source: str) -> None:
    meta_path.parent.mkdir(parents=True, exist_ok=True)
    with open(meta_path, 'w', encoding='utf-8') as f:
        json.dump({
            'n': n,
            'seed': seed,
            'eligible_count': eligible_count,
            'source_file': source,
            'generated_at': datetime.now().isoformat(),
        }, f, indent=2)


def main():
    parser = argparse.ArgumentParser(description="Sample a deterministic benchmark subset from the full paper dataset")
    parser.add_argument('--input', default='data/processed/combined_papers_merged.json')
    parser.add_argument('--n', type=int, default=60)
    parser.add_argument('--seed', type=int, default=42)
    parser.add_argument('--out', default='data/processed/benchmark_subset.json')
    parser.add_argument('--manifest', default='results/benchmark/subset_manifest.csv')
    parser.add_argument('--meta', default='results/benchmark/subset_meta.json')
    args = parser.parse_args()

    preprocessor = Preprocessor()
    papers = preprocessor.preprocess_papers(preprocessor.load_json_data(args.input))

    eligible = [p for p in papers if is_eligible(p)]
    logger.info(f"{len(eligible)}/{len(papers)} papers eligible (>= {MIN_TEXT_LENGTH} chars of abstract+conclusion)")

    subset = select_subset(papers, args.n, args.seed)
    logger.info(f"Selected {len(subset)} papers (seed={args.seed})")

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with open(out_path, 'w', encoding='utf-8') as f:
        json.dump(subset, f, indent=2, ensure_ascii=False)
    logger.info(f"Wrote subset to {out_path}")

    write_manifest(subset, Path(args.manifest))
    write_meta(Path(args.meta), n=args.n, seed=args.seed, eligible_count=len(eligible), source=args.input)
    logger.info(f"Wrote manifest to {args.manifest} and meta to {args.meta}")


if __name__ == '__main__':
    main()
