"""Tunables for the benchmark subset, matching thresholds, and candidate-model registry"""

# Paper subset defaults (see benchmark/sample_subset.py)
DEFAULT_SUBSET_SIZE = 60
DEFAULT_SUBSET_SEED = 42

# Matching thresholds (see benchmark/scoring/matching.py) - rapidfuzz scores are 0-100
MATERIAL_FIELD_WEIGHTS = {
    "mxene_composition": 0.4,
    "composite_material": 0.2,
    "synthesis_method": 0.2,
    "fabrication_method": 0.2,
}
MATERIAL_MATCH_THRESHOLD = 70.0
PROPERTY_TYPE_MATCH_THRESHOLD = 85.0
APPLICATION_TYPE_MATCH_THRESHOLD = 80.0
VALUE_RELATIVE_TOLERANCE = 0.10  # 10% relative error allowed on numeric property/application values

# Known unit synonyms not already collapsed by Validator.standardize_unit
UNIT_EQUIVALENCE_GROUPS = [
    {"s/m", "s·m-1", "s m-1"},
    {"ω·m", "ohm·m", "ohm.m", "ω.m"},
]

# ---------------------------------------------------------------------------
# Run matrix: reference panel (builds consensus gold, never scored itself),
# API candidates (run locally via benchmark/run_api_model.py), and Kaggle
# candidates (open-weight, run via benchmark/kaggle/candidate_run/).
#
# Run key convention used everywhere (results/runs/<run_key>/): "<family>__<level>"
# for anything with a thinking-level sweep; the two reference-panel runs and
# "consensus-gold" itself have no "__" suffix since they're single runs.
# ---------------------------------------------------------------------------

GOLD_MODEL = "consensus-gold"

# Reference panel: two independent frontier models, used ONLY to build the consensus gold
# standard (see benchmark/consensus.py). Never pass these run keys to run_benchmark.py
# --candidates - see the guard there.
#
# Claude Opus 4.8 + GPT-5.6 Sol, run via Kaggle Benchmarks (kbench) - see
# benchmark/kaggle/reference_panel_kbench/. This replaces the original DeepSeek V4 Pro +
# Flash panel (same-vendor tiers, correlated blind spots - a compromise made after Gemini
# 3.1 Pro hit a hard quota=0 wall on a free-tier personal API key). kbench's Model Proxy
# gives free-quota access ($10/day, $100/month) to genuinely independent vendors instead,
# confirmed live: Claude Opus 4.8 60/60 API calls succeeded (59/60 clean JSON parses),
# GPT-5.6 Sol 58/60 succeeded after retries. Real metered cost for the full panel run:
# $1.72 (Opus) + $2.04 (Sol) = ~$3.76 total. The old DeepSeek panel's gold is preserved at
# results/runs/consensus-gold-deepseek-panel/ for comparison - see
# benchmark/COMMANDS_api_runs.md for its commands.
REFERENCE_PANEL = {
    "claude-opus-4.8": {
        "provider": "kbench",
        "model": "claude-opus-4-8-default",
    },
    "gpt-5.6-sol": {
        "provider": "kbench",
        "model": "gpt-5.6-sol",
    },
    "deepseek-v4-pro": {
        "provider": "deepseek",
        "model": "deepseek-v4-pro",
        "thinking_enabled": True,
    },
    "deepseek-v4-flash": {
        "provider": "deepseek",
        "model": "deepseek-v4-flash",
        "thinking_enabled": True,
    },
}

# API-based candidates (closed weights - run locally via benchmark/run_api_model.py).
# Gemini 3.1 Pro supports a 3-level thinking_level; there is no plain "gemini-3.1-flash" model
# (confirmed via client.models.list()) - Google's current flash-tier flagship is gemini-3.5-flash,
# confirmed working on a free-tier API key.
#
# DeepSeek V4 Flash is NOT listed here: it's in REFERENCE_PANEL above, and scoring it as a
# candidate too would be circular (its own output partly defines the gold it'd be judged
# against) - the same reason Gemini 3.1 Pro and DeepSeek V4 Pro are reference-only.
API_CANDIDATES = {
    "gemini-3.5-flash": {
        "provider": "gemini",
        "model": "gemini-3.5-flash",
        "thinking_variants": {
            "low": {"thinking_level": "low"},
            "high": {"thinking_level": "high"},
        },
    },
}

# Open-weight candidates - run sequentially in one Kaggle notebook (benchmark/kaggle/candidate_run/),
# each model loaded once via llama.cpp (llama-cpp-python), its thinking-level variants swept
# while loaded, then the model and its downloaded GGUF file are deleted before the next one
# loads (Kaggle disk is constrained).
#
# Uses llama.cpp + GGUF rather than vLLM: confirmed live that Kaggle assigns a P100 (compute
# capability 6.0), which is incompatible with every native quantization format the original
# vLLM-based configs used (MXFP4/FP8 need Ampere+ 8.0, W4A16-marlin needs Volta+ 7.0). GGUF's
# k-quants run via llama.cpp's own broadly-portable CUDA kernels instead, sidestepping the
# hardware-capability gate entirely.
#
# "gpu_layers_to_try" lets the notebook retry with progressively fewer GPU-resident layers on
# OOM (falling back toward CPU) rather than needing a guessed-correct number up front - MoE
# models like Qwen only activate a few billion of their total params per token, so CPU-spilled
# expert layers should be tolerably slow rather than catastrophic. Defaults to a single -1
# attempt (all-GPU) for models that don't need this fallback.
#
# "use_json_schema" controls whether create_chat_completion's response_format grammar
# constraint is applied. Confirmed live on a single Kaggle P100: gpt-oss-20b and
# gemma-4-12b-it both 60/60 on every thinking level at n_gpu_layers=-1; qwen3.6-35b-a3b 59/60
# on both variants once CPU-offloaded via gpu_layers_to_try (its GGUF alone exceeds the P100's
# VRAM). BUT gpt-oss-20b regressed to 100% *empty* (schema-valid but content-free) extractions
# under the grammar constraint - it's trained to reason in a Harmony "analysis" channel before
# answering, and forcing strict JSON from token 1 removes that room, so it just satisfies the
# schema trivially. Qwen/Gemma showed real content under the same constraint, so this is
# gpt-oss-specific: it gets use_json_schema=False, relying on the Harmony-tag-stripping +
# greedy-regex parser in app/json_utils.py to pull the real JSON out of its natural output.
#
# All three confirmed live on Kaggle's P100 with this config: gpt-oss-20b 57/60, 54/60, 56/60
# (low/medium/high, after the use_json_schema=False fix); qwen3.6-35b-a3b 59/60 on both
# thinking variants (needs gpu_layers_to_try's CPU-offload fallback - its GGUF alone exceeds
# the P100's 16GB VRAM); gemma-4-12b-it 60/60 on every level at n_gpu_layers=-1.
KAGGLE_CANDIDATES = {
    "gpt-oss-20b": {
        "gguf_repo": "unsloth/gpt-oss-20b-GGUF",
        "gguf_filename": "gpt-oss-20b-Q4_K_M.gguf",  # 11.6GB
        "gpu_layers_to_try": [-1],
        "use_json_schema": False,
        "thinking_variants": ["low", "medium", "high"],  # native reasoning_effort via system message
    },
    "qwen3.6-35b-a3b": {
        "gguf_repo": "unsloth/Qwen3.6-35B-A3B-GGUF",
        "gguf_filename": "Qwen3.6-35B-A3B-UD-IQ4_XS.gguf",
        "gpu_layers_to_try": [40, 30, 20, 12, 6, 0],
        "use_json_schema": True,
        "thinking_variants": ["thinking-on", "thinking-off"],  # /think and /no_think prompt directives
    },
    "gemma-4-12b-it": {
        "gguf_repo": "unsloth/gemma-4-12b-it-GGUF",
        "gguf_filename": "gemma-4-12b-it-Q4_K_M.gguf",
        "gpu_layers_to_try": [-1],
        "use_json_schema": True,
        "thinking_variants": ["low", "medium", "high"],  # thinking_budget buckets, prompt-appended
    },
}


def all_candidate_run_keys():
    """Every '<family>__<level>' run key across API and Kaggle candidates"""
    keys = []
    for family, cfg in {**API_CANDIDATES, **KAGGLE_CANDIDATES}.items():
        levels = cfg["thinking_variants"]
        for level in (levels if isinstance(levels, list) else levels.keys()):
            keys.append(f"{family}__{level}")
    return keys


def parse_run_key(run_key: str):
    """'<family>__<level>' -> (family, level). Falls back to (run_key, None) for run keys with
    no thinking-level suffix (e.g. 'consensus-gold' or the reference-panel runs)."""
    if "__" in run_key:
        family, level = run_key.split("__", 1)
        return family, level
    return run_key, None


def resolve_run_config(run_key: str) -> dict:
    """Resolve a run key against REFERENCE_PANEL / API_CANDIDATES so benchmark/run_api_model.py
    doesn't need every provider/model/thinking flag passed manually on the command line."""
    if run_key in REFERENCE_PANEL:
        return dict(REFERENCE_PANEL[run_key])

    family, level = parse_run_key(run_key)
    if family in API_CANDIDATES:
        cfg = API_CANDIDATES[family]
        variant = cfg["thinking_variants"].get(level)
        if variant is None:
            raise ValueError(
                f"Unknown thinking-level '{level}' for '{family}'. Options: {list(cfg['thinking_variants'])}"
            )
        return {"provider": cfg["provider"], "model": cfg["model"], **variant}

    raise ValueError(
        f"Unknown run key '{run_key}'. Must be a REFERENCE_PANEL key ({list(REFERENCE_PANEL)}) "
        f"or '<API_CANDIDATES family>__<level>' ({list(API_CANDIDATES)})."
    )


# Best-effort per-1M-token USD pricing for run_stats.json cost tracking. VERIFY against each
# provider's current pricing page before trusting est_cost_usd.
MODEL_PRICING = {
    "gemini-3.5-flash": {"input_per_1m": 1.50, "output_per_1m": 9.00},   # confirmed (launched 2026-05-19)
    "deepseek-v4-pro": {"input_per_1m": 0.435, "output_per_1m": 0.87},   # confirmed
    "deepseek-v4-flash": {"input_per_1m": 0.14, "output_per_1m": 0.28},  # confirmed
}
