"""
Push a candidate-model kernel (notebook) to Kaggle and poll until it finishes.

Kaggle kernel execution is asynchronous - there is no push-and-block API.
This script pushes, then polls `kaggle kernels status` on an interval up to
a generous timeout (Kaggle's own session cap is 12h). It cannot force a run
to complete or auto-diagnose a failure: on error/timeout it prints the
kernel's web URL so you can inspect logs/settings (e.g. confirm the GPU
accelerator that got assigned) in the browser.

    uv run python -m benchmark.kaggle.push_and_wait --run-dir benchmark/kaggle/candidate_run --kernel-slug <user>/mxene-candidate-run
"""

import argparse
import logging
import subprocess
import time
from pathlib import Path

from app.config import Config  # noqa: F401  (import triggers load_dotenv())

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

TERMINAL_STATUSES = {"complete", "error", "cancelled"}


def push_kernel(run_dir: Path) -> None:
    cmd = ["kaggle", "kernels", "push", "-p", str(run_dir)]
    logger.info(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    logger.info(result.stdout)
    if result.returncode != 0:
        logger.error(result.stderr)
        raise RuntimeError(f"kaggle kernels push failed (exit {result.returncode}): {result.stderr}")


def get_status(kernel_slug: str) -> str:
    cmd = ["kaggle", "kernels", "status", kernel_slug]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        raise RuntimeError(f"kaggle kernels status failed: {result.stderr}")
    return result.stdout.strip()


def wait_for_completion(kernel_slug: str, poll_interval_s: int, timeout_s: int) -> str:
    elapsed = 0
    while elapsed < timeout_s:
        status_text = get_status(kernel_slug)
        logger.info(f"[{elapsed}s] {status_text}")

        lowered = status_text.lower()
        for terminal in TERMINAL_STATUSES:
            if terminal in lowered:
                if terminal != "complete":
                    logger.warning(
                        f"Kernel finished with status '{terminal}'. Inspect logs/settings at "
                        f"https://www.kaggle.com/code/{kernel_slug}"
                    )
                return terminal

        time.sleep(poll_interval_s)
        elapsed += poll_interval_s

    logger.warning(
        f"Timed out after {timeout_s}s waiting for kernel to finish. Check "
        f"https://www.kaggle.com/code/{kernel_slug} manually."
    )
    return "timeout"


def main():
    parser = argparse.ArgumentParser(description="Push a Kaggle kernel and poll until it completes")
    parser.add_argument('--run-dir', required=True, help="Directory containing kernel-metadata.json + notebook")
    parser.add_argument('--kernel-slug', required=True, help="e.g. <kaggle_username>/mxene-qwen-run")
    parser.add_argument('--poll-interval', type=int, default=60)
    parser.add_argument('--timeout', type=int, default=12 * 3600, help="Seconds; Kaggle's own session cap is 12h")
    args = parser.parse_args()

    push_kernel(Path(args.run_dir))
    status = wait_for_completion(args.kernel_slug, args.poll_interval, args.timeout)
    logger.info(f"Final status: {status}")


if __name__ == '__main__':
    main()
