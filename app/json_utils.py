"""
Pure-stdlib JSON extraction helper.

Deliberately dependency-free (json/re/logging only) so this module can be
copied as-is into a Kaggle notebook and used by the benchmark candidate
models without pulling in the rest of this package.
"""

import json
import logging
import re
from typing import Any, Dict, Optional


def extract_json_from_response(response: str, logger: Optional[logging.Logger] = None) -> Optional[Dict[str, Any]]:
    """Extract and parse JSON from an LLM response, stripping think-tags and markdown fences"""
    log = logger or logging.getLogger(__name__)
    clean_text = ""
    try:
        clean_text = response.strip()

        # Remove thinking tags if present (common in some models)
        if "<think>" in clean_text:
            think_end = clean_text.find("</think>")
            if think_end != -1:
                clean_text = clean_text[think_end + 8:].strip()
            else:
                think_start = clean_text.find("<think>")
                if think_start != -1:
                    clean_text = clean_text[think_start + 7:].strip()

        # Handle OpenAI Harmony-format responses (gpt-oss): reasoning is emitted in an
        # "analysis" channel before the real answer in a "final" channel, e.g.
        # "<|channel|>analysis<|message|>...<|channel|>final<|message|>{...}". Taking
        # everything after the LAST <|message|> marker reliably isolates the final
        # channel's content regardless of how many reasoning channels preceded it.
        if "<|message|>" in clean_text:
            clean_text = clean_text.rsplit("<|message|>", 1)[1].strip()
            for marker in ("<|return|>", "<|end|>", "<|call|>"):
                if clean_text.endswith(marker):
                    clean_text = clean_text[:-len(marker)].strip()

        # Remove markdown code blocks if present
        if clean_text.startswith("```json"):
            clean_text = clean_text[7:]
        elif clean_text.startswith("```"):
            clean_text = clean_text[3:]

        if clean_text.endswith("```"):
            clean_text = clean_text[:-3]

        clean_text = clean_text.strip()

        # Try to find JSON-like content if the response doesn't start with {
        if not clean_text.startswith('{'):
            # Greedy match to the LAST closing brace, not the first - our schema is nested
            # (materials/properties/applications are arrays of objects), so a non-greedy
            # match would truncate at the first inner object's closing brace instead of
            # capturing the whole outer JSON object.
            json_match = re.search(r'\{.*\}', clean_text, re.DOTALL)
            if json_match:
                clean_text = json_match.group(0)
            else:
                log.error(f"No JSON object found in response: {clean_text[:100]}...")
                return None

        result = json.loads(clean_text)
        log.debug(f"Successfully extracted JSON: {result}")
        return result

    except json.JSONDecodeError as e:
        log.error(f"JSON parsing error: {e}")
        log.debug(f"Clean text: '{clean_text[:200]}...'")
        log.debug(f"Raw response: '{response[:200]}...'")
        return None
    except Exception as e:
        log.error(f"Error processing response: {e}")
        return None
