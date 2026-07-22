# %%
# Full 60-paper reference-panel extraction run, used to build the consensus gold
# standard (see benchmark/consensus.py). Pushed once, then run twice via
# `kaggle b t run -m claude-opus-4-8-default -m gpt-5.6-sol` so each model
# independently extracts from all 60 papers under the same task/prompt.
#
# v2: the platform forces max_attempts=1 for .evaluate() calls nested inside an
# already-running task ("max_attempts must be 1 for nested task evaluations"),
# so there is no automatic retry here - v1 ran at n_jobs=4 with the (silently
# ignored) max_attempts=3 and both models mostly failed (gpt-5.6-sol: 2/60,
# claude-opus-4-8-default: 0/60), almost certainly concurrent-request rate
# limiting with zero retry safety net. Fixed by going fully sequential
# (n_jobs=1) and adding a manual retry loop inside the per-paper task itself.
import glob
import sys
import time
import traceback
from pathlib import Path

import kaggle_benchmarks as kbench
import pandas as pd

BUNDLE_DIR = None
for _ in range(10):
    matches = glob.glob("/kaggle/input/**/benchmark_subset.json", recursive=True)
    if matches:
        BUNDLE_DIR = Path(matches[0]).parent
        break
    time.sleep(5)
if BUNDLE_DIR is None:
    raise RuntimeError("Could not find benchmark_subset.json under /kaggle/input")

sys.path.insert(0, str(BUNDLE_DIR))
from json_utils import extract_json_from_response  # noqa: E402
from validator import Validator  # noqa: E402

import json  # noqa: E402

with open(BUNDLE_DIR / "benchmark_subset.json", encoding="utf-8") as f:
    papers = json.load(f)
with open(BUNDLE_DIR / "extraction_prompt.txt", encoding="utf-8") as f:
    PROMPT_TEMPLATE = f.read()

validator = Validator()

df = pd.DataFrame([
    {
        "doi_url": p.get("doi_url", ""),
        "title": p.get("title", ""),
        "abstract": p.get("abstract", ""),
        "conclusion": p.get("conclusion", ""),
    }
    for p in papers
])

MAX_MANUAL_RETRIES = 4
RETRY_BACKOFF_S = [5, 15, 30, 60]


# %%
@kbench.task(name="extract_one_paper", store_task=False)
def extract_one_paper(llm, doi_url: str, title: str, abstract: str, conclusion: str) -> dict:
    prompt = PROMPT_TEMPLATE.format(title=title, abstract=abstract, conclusion=conclusion)

    last_error = None
    for attempt in range(MAX_MANUAL_RETRIES):
        try:
            with kbench.chats.new(f"extract:{doi_url}:{attempt}") as chat:
                response_text = llm.prompt(prompt)
                usage = chat.usage
            break
        except Exception as e:  # noqa: BLE001 - genuinely want to retry any transient failure here
            last_error = e
            if attempt < MAX_MANUAL_RETRIES - 1:
                time.sleep(RETRY_BACKOFF_S[attempt])
    else:
        raise RuntimeError(
            f"All {MAX_MANUAL_RETRIES} attempts failed for {doi_url}: {last_error}"
        ) from last_error

    extracted = extract_json_from_response(response_text) if response_text else None
    validated = validator.validate_extracted_data(
        extracted or {"materials": [], "properties": [], "applications": []}
    )
    return {
        "doi_url": doi_url,
        "title": title,
        "extracted_data": validated,
        "extraction_failed": extracted is None,
        "input_tokens": usage.input_tokens,
        "output_tokens": usage.output_tokens,
        "input_cost_nanodollars": usage.input_tokens_cost_nanodollars,
        "output_cost_nanodollars": usage.output_tokens_cost_nanodollars,
        "latency_ms": usage.total_backend_latency_ms,
    }


# %%
@kbench.task(name="mxene-reference-panel-run", description="Full 60-paper MXene extraction for gold-standard reference panel")
def full_reference_run(llm) -> dict:
    with kbench.client.enable_cache():
        runs = extract_one_paper.evaluate(
            llm=[llm],
            evaluation_data=df,
            on_failure="continue",
            max_attempts=1,  # platform forces this to 1 for nested evaluations anyway
            n_jobs=1,        # sequential - avoids concurrent-request rate limiting
            timeout=180,
            remove_run_files=True,
        )
    completed = runs.completed_runs.as_dataframe()
    errored = runs.errored_runs

    result = {
        "total_papers": len(df),
        "successful": len(completed),
        "errored": len(errored),
        "error_messages": [str(r.error_message)[:1000] for r in errored],
        "papers": completed["result"].tolist() if len(completed) > 0 else [],
    }
    return result


try:
    full_reference_run.run(llm=kbench.llm)
except Exception:
    traceback.print_exc()
    raise
