"""
Prompt loading utilities for the Literature Mining LLM application
"""

import logging
from typing import Dict, List, Optional
from pathlib import Path


class PromptLoader:
    """Utility class for loading prompts from .txt files"""

    def __init__(self, prompts_dir: str = "prompts"):
        self.logger = logging.getLogger(__name__)
        self.prompts_dir = Path(prompts_dir)
        self._prompt_cache: Dict[str, str] = {}

        if not self.prompts_dir.exists():
            raise FileNotFoundError(f"Prompts directory not found: {self.prompts_dir}")

    def load_prompt(self, prompt_name: str) -> Optional[str]:
        """Load a prompt from a .txt file (cached after first read)"""
        if prompt_name in self._prompt_cache:
            return self._prompt_cache[prompt_name]

        prompt_file = self.prompts_dir / f"{prompt_name}.txt"

        try:
            if not prompt_file.exists():
                self.logger.error(f"Prompt file not found: {prompt_file}")
                return None

            with open(prompt_file, 'r', encoding='utf-8') as f:
                prompt_content = f.read().strip()

            self._prompt_cache[prompt_name] = prompt_content
            self.logger.debug(f"Loaded prompt: {prompt_name}")

            return prompt_content

        except Exception as e:
            self.logger.error(f"Error loading prompt {prompt_name}: {e}")
            return None

    def format_prompt(self, prompt_name: str, **kwargs) -> Optional[str]:
        """Load and format a prompt with provided variables"""
        prompt_content = self.load_prompt(prompt_name)

        if not prompt_content:
            return None

        try:
            return prompt_content.format(**kwargs)
        except KeyError as e:
            self.logger.error(f"Missing variable for prompt {prompt_name}: {e}")
            return None
        except Exception as e:
            self.logger.error(f"Error formatting prompt {prompt_name}: {e}")
            return None

    def list_available_prompts(self) -> List[str]:
        """List all available prompt files"""
        try:
            return sorted(f.stem for f in self.prompts_dir.glob("*.txt"))
        except Exception as e:
            self.logger.error(f"Error listing prompts: {e}")
            return []
