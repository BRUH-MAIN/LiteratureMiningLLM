"""
Prompt loading utilities for the Literature Mining LLM application
"""

import os
import logging
from typing import Dict, Optional
from pathlib import Path


class PromptLoader:
    """Utility class for loading prompts from .txt files"""
    
    def __init__(self, prompts_dir: str = "prompts"):
        self.logger = logging.getLogger(__name__)
        self.prompts_dir = Path(prompts_dir)
        self._prompt_cache: Dict[str, str] = {}
        
        # Ensure prompts directory exists
        if not self.prompts_dir.exists():
            raise FileNotFoundError(f"Prompts directory not found: {self.prompts_dir}")
    
    def load_prompt(self, prompt_name: str) -> Optional[str]:
        """
        Load a prompt from a .txt file
        
        Args:
            prompt_name: Name of the prompt file (without .txt extension)
            
        Returns:
            Prompt content as string, or None if file not found
        """
        # Check cache first
        if prompt_name in self._prompt_cache:
            return self._prompt_cache[prompt_name]
        
        prompt_file = self.prompts_dir / f"{prompt_name}.txt"
        
        try:
            if not prompt_file.exists():
                self.logger.error(f"Prompt file not found: {prompt_file}")
                return None
            
            with open(prompt_file, 'r', encoding='utf-8') as f:
                prompt_content = f.read().strip()
            
            # Cache the prompt
            self._prompt_cache[prompt_name] = prompt_content
            self.logger.debug(f"Loaded prompt: {prompt_name}")
            
            return prompt_content
            
        except Exception as e:
            self.logger.error(f"Error loading prompt {prompt_name}: {e}")
            return None
    
    def format_prompt(self, prompt_name: str, **kwargs) -> Optional[str]:
        """
        Load and format a prompt with provided variables
        
        Args:
            prompt_name: Name of the prompt file (without .txt extension)
            **kwargs: Variables to format into the prompt
            
        Returns:
            Formatted prompt content as string, or None if error
        """
        prompt_content = self.load_prompt(prompt_name)
        
        if not prompt_content:
            return None
        
        try:
            formatted_prompt = prompt_content.format(**kwargs)
            return formatted_prompt
            
        except KeyError as e:
            self.logger.error(f"Missing variable for prompt {prompt_name}: {e}")
            return None
        except Exception as e:
            self.logger.error(f"Error formatting prompt {prompt_name}: {e}")
            return None
    
    def list_available_prompts(self) -> list:
        """
        List all available prompt files
        
        Returns:
            List of prompt names (without .txt extension)
        """
        try:
            prompt_files = [f.stem for f in self.prompts_dir.glob("*.txt")]
            return sorted(prompt_files)
        except Exception as e:
            self.logger.error(f"Error listing prompts: {e}")
            return []
    
    def reload_prompt(self, prompt_name: str) -> Optional[str]:
        """
        Force reload a prompt from file (bypassing cache)
        
        Args:
            prompt_name: Name of the prompt file (without .txt extension)
            
        Returns:
            Prompt content as string, or None if file not found
        """
        # Remove from cache
        if prompt_name in self._prompt_cache:
            del self._prompt_cache[prompt_name]
        
        # Load fresh from file
        return self.load_prompt(prompt_name)
    
    def clear_cache(self):
        """Clear the prompt cache"""
        self._prompt_cache.clear()
        self.logger.debug("Prompt cache cleared")


# Global prompt loader instance
prompt_loader = PromptLoader()
