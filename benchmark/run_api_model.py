"""
Run a single API-based model variant (Gemini or DeepSeek, at a specific model+thinking
setting) over the fixed paper subset. Used for both:
  - the two reference-panel runs that build the consensus gold standard
    (see benchmark/consensus.py), and
  - the API-based candidates on the benchmark leaderboard (Gemini 3.5 Flash, DeepSeek V4 Flash).

Generalizes what used to be a DeepSeek-only script: prompt-building and LLM-calling stay
entirely in app/extractor.py and app/llm_interface.py, this is just an instrumented loop
(latency/token/cost tracking, validation, writing extractions.json + run_stats.json) reused
across every provider/model/thinking-level combination via benchmark.config's registries.
"""

import argparse
import json
import logging
import time
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional

from app.extractor import Extractor
from app.llm_interface import DeepSeekProvider, GeminiProvider, LLMInterface
from app.validator import Validator
from benchmark.config import MODEL_PRICING, resolve_run_config

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

DEFAULT_REQUEST_DELAY_S = 0.5


def _usage_tokens(usage: Optional[Dict[str, Any]]) -> tuple:
    """Normalize the different provider usage-metadata shapes into (input, output) token counts"""
    if not usage:
        return 0, 0
    input_tokens = usage.get('input_tokens', usage.get('prompt_tokens', 0)) or 0
    output_tokens = usage.get('output_tokens', usage.get('completion_tokens', 0)) or 0
    return input_tokens, output_tokens


def build_extractor(resolved: Dict[str, Any]) -> Extractor:
    provider_type = resolved['provider']
    if provider_type == 'gemini':
        provider = GeminiProvider(model=resolved['model'], thinking_level=resolved.get('thinking_level'))
    elif provider_type == 'deepseek':
        provider = DeepSeekProvider(model=resolved['model'], thinking_enabled=resolved.get('thinking_enabled'))
    else:
        raise ValueError(f"run_api_model.py only supports 'gemini'/'deepseek' providers, got '{provider_type}'")

    llm_interface = LLMInterface.from_provider(provider, provider_type)
    return Extractor(llm_interface=llm_interface)


def run_api_model(run_key: str, subset_path: Path, out_dir: Path,
                   request_delay: float = DEFAULT_REQUEST_DELAY_S) -> Dict[str, Any]:
    resolved = resolve_run_config(run_key)
    papers = json.load(open(subset_path, encoding='utf-8'))
    extractor = build_extractor(resolved)
    validator = Validator()

    logger.info(f"Running '{run_key}' ({resolved}) over {len(papers)} papers")

    results: List[Dict[str, Any]] = []
    total_input_tokens = 0
    total_output_tokens = 0
    total_latency = 0.0
    failed_count = 0

    for i, paper in enumerate(papers):
        logger.info(f"[{i + 1}/{len(papers)}] {paper.get('title', 'Unknown')[:60]}...")

        t0 = time.time()
        extracted = extractor.extract_data_from_text(
            paper.get('title', ''), paper.get('abstract', ''), paper.get('conclusion', '')
        )
        latency = time.time() - t0
        total_latency += latency

        input_tokens, output_tokens = _usage_tokens(extractor.llm.get_last_usage())
        total_input_tokens += input_tokens
        total_output_tokens += output_tokens

        paper_out = dict(paper)
        validated = validator.validate_extracted_data(
            extracted or {"materials": [], "properties": [], "applications": []}
        )
        paper_out['extracted_data'] = validated
        paper_out['extraction_failed'] = extracted is None
        paper_out['_latency_s'] = round(latency, 3)
        results.append(paper_out)

        if extracted is None:
            failed_count += 1

        if i < len(papers) - 1:
            time.sleep(request_delay)

    pricing = MODEL_PRICING.get(resolved['model'], {})
    est_cost = (
        total_input_tokens / 1_000_000 * pricing.get('input_per_1m', 0)
        + total_output_tokens / 1_000_000 * pricing.get('output_per_1m', 0)
    )
    if not pricing:
        logger.warning(f"No pricing entry for model '{resolved['model']}' - est_cost_usd will read 0")

    stats = {
        'run_key': run_key,
        'provider': resolved['provider'],
        'model': resolved['model'],
        'thinking_level': resolved.get('thinking_level'),
        'thinking_enabled': resolved.get('thinking_enabled'),
        'total_papers': len(papers),
        'successful_extractions': len(papers) - failed_count,
        'failed_extractions': failed_count,
        'total_time_s': round(total_latency, 2),
        'avg_latency_s': round(total_latency / len(papers), 3) if papers else 0,
        'total_input_tokens': total_input_tokens,
        'total_output_tokens': total_output_tokens,
        'est_cost_usd': round(est_cost, 4),
        'pricing': pricing,
        'generated_at': datetime.now().isoformat(),
    }

    out_dir.mkdir(parents=True, exist_ok=True)
    with open(out_dir / 'extractions.json', 'w', encoding='utf-8') as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    with open(out_dir / 'run_stats.json', 'w', encoding='utf-8') as f:
        json.dump(stats, f, indent=2)

    logger.info(f"'{run_key}' complete: {stats['successful_extractions']}/{stats['total_papers']} succeeded, "
                f"est. cost ${stats['est_cost_usd']}")
    return {'results': results, 'stats': stats}


def main():
    parser = argparse.ArgumentParser(
        description="Run one API-based model variant (reference-panel or candidate) over the paper subset"
    )
    parser.add_argument('--run-key', required=True,
                         help="A benchmark.config REFERENCE_PANEL key (e.g. gemini-3.1-pro) or "
                              "'<API_CANDIDATES family>__<level>' (e.g. gemini-3.5-flash__low)")
    parser.add_argument('--subset', default='data/processed/benchmark_subset.json')
    parser.add_argument('--out-dir', default=None, help="Defaults to results/runs/<run-key>/")
    parser.add_argument('--request-delay', type=float, default=DEFAULT_REQUEST_DELAY_S)
    args = parser.parse_args()

    out_dir = Path(args.out_dir) if args.out_dir else Path('results/runs') / args.run_key
    run_api_model(args.run_key, Path(args.subset), out_dir, args.request_delay)


if __name__ == '__main__':
    main()
