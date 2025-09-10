#!/usr/bin/env python3
"""
Merge paper metadata from two JSON files by DOI URL.

Inputs (default paths can be overridden with CLI flags):
  - citations JSON (contains abstract and citation metadata)
  - conclusions JSON (contains conclusion and some metadata)

Output:
  - combined JSON array with merged entries for DOIs present in both files.

Usage:
  python merge_papers_by_doi.py \
    --citations dataset/processed/combined_citations.json \
    --conclusions paper_conclusions.json \
    --output dataset/processed/combined_papers_merged.json
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple


def normalize_doi_key(doi_url: Optional[str]) -> Optional[str]:
    """Normalize DOI URL or DOI string to a comparable key.

    Examples:
      https://doi.org/10.1016/j.cej.2024.158423 -> 10.1016/j.cej.2024.158423
      DOI:10.1016/j.cej.2024.158423 -> 10.1016/j.cej.2024.158423
      10.1016/j.cej.2024.158423 -> 10.1016/j.cej.2024.158423
    """
    if not doi_url:
        return None
    s = doi_url.strip().lower()
    # Strip common prefixes
    for prefix in (
        "https://doi.org/",
        "http://doi.org/",
        "https://dx.doi.org/",
        "http://dx.doi.org/",
        "doi:",
        "doi/",
    ):
        if s.startswith(prefix):
            s = s[len(prefix) :]
            break
    # Remove any trailing punctuation or whitespace
    s = s.strip().strip(" .;")
    return s


def load_json_array(path: Path) -> List[Dict[str, Any]]:
    with path.open("r", encoding="utf-8") as f:
        data = json.load(f)
    if not isinstance(data, list):
        raise ValueError(f"Expected a JSON array in {path}, got {type(data)}")
    return data  # type: ignore[return-value]


def merge_records(
    citation: Dict[str, Any], conclusion: Dict[str, Any]
) -> Dict[str, Any]:
    """Merge two records into one.

    Strategy:
      - Start from conclusion record, then overlay citation record so citation
        fields (like 'abstract') are preserved and standard metadata from
        citations takes precedence when overlapping.
      - Ensure 'conclusion' field from conclusion record is present.
    """
    merged = {**conclusion, **citation}
    # Ensure we keep the conclusion text if present
    if "conclusion" in conclusion and conclusion["conclusion"]:
        merged["conclusion"] = conclusion["conclusion"]
    return merged


def build_index(records: List[Dict[str, Any]]) -> Dict[str, Dict[str, Any]]:
    idx: Dict[str, Dict[str, Any]] = {}
    for r in records:
        key = normalize_doi_key(r.get("doi_url"))
        if not key:
            continue
        # If duplicates, keep the first occurrence
        idx.setdefault(key, r)
    return idx


def run(citations_path: Path, conclusions_path: Path, output_path: Path) -> Tuple[int, int, int]:
    citations = load_json_array(citations_path)
    conclusions = load_json_array(conclusions_path)

    conc_idx = build_index(conclusions)

    merged_list: List[Dict[str, Any]] = []
    matched = 0
    missing_in_conclusions = 0

    for c in citations:
        key = normalize_doi_key(c.get("doi_url"))
        if not key:
            missing_in_conclusions += 1
            continue
        conc = conc_idx.get(key)
        if conc is None:
            missing_in_conclusions += 1
            continue
        merged_list.append(merge_records(c, conc))
        matched += 1

    # Write output
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8") as f:
        json.dump(merged_list, f, ensure_ascii=False, indent=2)

    extras_in_conclusions = max(0, len(conclusions) - matched)
    return matched, missing_in_conclusions, extras_in_conclusions


def main() -> None:
    parser = argparse.ArgumentParser(description="Merge papers by DOI URL from two JSON arrays.")
    parser.add_argument(
        "--citations",
        type=Path,
        default=Path("dataset/processed/combined_citations.json"),
        help="Path to citations JSON file (with abstracts).",
    )
    parser.add_argument(
        "--conclusions",
        type=Path,
        default=Path("paper_conclusions.json"),
        help="Path to conclusions JSON file (with conclusions).",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("dataset/processed/combined_papers_merged.json"),
        help="Path to write merged JSON array.",
    )

    args = parser.parse_args()

    matched, missing_in_conc, extras_in_conc = run(args.citations, args.conclusions, args.output)
    print(
        json.dumps(
            {
                "matched": matched,
                "missing_in_conclusions": missing_in_conc,
                "extras_in_conclusions": extras_in_conc,
                "output": str(args.output),
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
