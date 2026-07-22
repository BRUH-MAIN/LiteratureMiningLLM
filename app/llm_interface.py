"""
LLM Interface module for handling different LLM providers

This module provides a unified interface for:
- Google Gemini API (via the current google-genai SDK - google-generativeai is fully
  deprecated/EOL and doesn't support Gemini 3.1's thinking_config)
- Llama.cpp through OpenAI-compatible API (langchain_openai)
"""

import logging
from typing import Optional, Dict, Any
from abc import ABC, abstractmethod

from google import genai
from langchain_openai import ChatOpenAI
from app.config import Config
from app.json_utils import extract_json_from_response as _extract_json_from_response


class LLMProvider(ABC):
    """Abstract base class for LLM providers"""
    
    @abstractmethod
    def generate_response(self, prompt: str) -> Optional[str]:
        """Generate a response from the LLM"""
        pass


class GeminiProvider(LLMProvider):
    """Gemini LLM provider using Google's current google-genai SDK

    `model`/`thinking_level` let callers (e.g. benchmark/run_api_model.py) instantiate
    multiple Gemini variants (different model id, different reasoning depth) directly,
    independent of the single process-wide Config.GEMINI_MODEL used by the main pipeline.
    `thinking_level` should be one of 'low'/'medium'/'high' where the target model supports
    it (Gemini 3.1 Pro supports all three, Flash-tier models a subset) - None omits
    thinking_config from the request entirely (the model's own default applies).
    """

    def __init__(self, model: str = None, thinking_level: Optional[str] = None):
        self.logger = logging.getLogger(__name__)
        self.model_name = model or Config.GEMINI_MODEL
        self.thinking_level = thinking_level
        self.last_usage: Optional[Dict[str, Any]] = None
        self.setup_gemini()

    def setup_gemini(self):
        """Setup Gemini API client"""
        if not Config.GEMINI_API_KEY:
            raise ValueError("GEMINI_API_KEY environment variable not set")

        self.client = genai.Client(api_key=Config.GEMINI_API_KEY)
        self.logger.info(f"Gemini {self.model_name} client initialized (thinking_level={self.thinking_level})")

    def generate_response(self, prompt: str) -> Optional[str]:
        """Generate response using Gemini"""
        try:
            config = {}
            if self.thinking_level:
                config['thinking_config'] = {'thinking_level': self.thinking_level.lower()}

            response = self.client.models.generate_content(
                model=self.model_name, contents=prompt, config=config or None,
            )

            usage = getattr(response, 'usage_metadata', None)
            if usage is not None:
                self.last_usage = {
                    'input_tokens': getattr(usage, 'prompt_token_count', None),
                    'output_tokens': getattr(usage, 'candidates_token_count', None),
                }

            if not response.text:
                self.logger.error("Empty response from Gemini")
                return None

            return response.text

        except Exception as e:
            self.logger.error(f"Error generating Gemini response: {e}")
            return None


class LlamaCppProvider(LLMProvider):
    """Llama.cpp LLM provider using OpenAI-compatible API through langchain_openai"""
    
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.setup_llamacpp()
    
    def setup_llamacpp(self):
        """Setup Llama.cpp client through OpenAI-compatible API"""
        if not Config.LLAMACPP_BASE_URL:
            raise ValueError("LLAMACPP_BASE_URL environment variable not set")
        
        # Initialize ChatOpenAI client with custom base URL for llama.cpp server
        self.client = ChatOpenAI(
            base_url=Config.LLAMACPP_BASE_URL,
            api_key="sk-no-key-required",  # llama.cpp server typically doesn't require a real API key
            model=Config.LLAMACPP_MODEL,
            temperature=Config.LLAMACPP_TEMPERATURE,
            max_tokens=Config.LLAMACPP_MAX_TOKENS,
        )
        
        self.logger.info(f"Llama.cpp model initialized - URL: {Config.LLAMACPP_BASE_URL}, Model: {Config.LLAMACPP_MODEL}")
    
    def generate_response(self, prompt: str) -> Optional[str]:
        """Generate response using Llama.cpp through OpenAI-compatible API"""
        try:
            # ChatOpenAI expects messages format
            from langchain_core.messages import HumanMessage
            
            messages = [HumanMessage(content=prompt)]
            response = self.client.invoke(messages)
            
            if not response or not response.content:
                self.logger.error("Empty response from Llama.cpp")
                return None
                
            return response.content
            
        except Exception as e:
            self.logger.error(f"Error generating Llama.cpp response: {e}")
            return None


class DeepSeekProvider(LLMProvider):
    """DeepSeek LLM provider using DeepSeek's OpenAI-compatible API (via langchain_openai)

    `model`/`thinking_enabled` let callers (e.g. benchmark/run_api_model.py) instantiate
    multiple DeepSeek variants (Pro/Flash, thinking on/off) directly, independent of the
    single process-wide Config.DEEPSEEK_MODEL used by the main pipeline. DeepSeek V4 exposes
    thinking as a binary request-body flag (not graduated levels) - thinking_enabled=None
    leaves the provider's own default (thinking on) untouched.
    """

    def __init__(self, model: str = None, thinking_enabled: Optional[bool] = None):
        self.logger = logging.getLogger(__name__)
        self.model_name = model or Config.DEEPSEEK_MODEL
        self.thinking_enabled = thinking_enabled
        self.last_usage: Optional[Dict[str, Any]] = None
        self.setup_deepseek()

    def setup_deepseek(self):
        """Setup DeepSeek client through its OpenAI-compatible API"""
        if not Config.DEEPSEEK_API_KEY:
            raise ValueError("DEEPSEEK_API_KEY environment variable not set")

        extra_body = {}
        if self.thinking_enabled is not None:
            extra_body['thinking'] = {'type': 'enabled' if self.thinking_enabled else 'disabled'}

        self.client = ChatOpenAI(
            base_url=Config.DEEPSEEK_BASE_URL,
            api_key=Config.DEEPSEEK_API_KEY,
            model=self.model_name,
            temperature=Config.DEEPSEEK_TEMPERATURE,
            max_tokens=Config.DEEPSEEK_MAX_TOKENS,
            extra_body=extra_body or None,
        )

        self.logger.info(f"DeepSeek model initialized - Model: {self.model_name} (thinking_enabled={self.thinking_enabled})")

    def generate_response(self, prompt: str) -> Optional[str]:
        """Generate response using DeepSeek, recording token usage for cost tracking"""
        try:
            from langchain_core.messages import HumanMessage

            messages = [HumanMessage(content=prompt)]
            response = self.client.invoke(messages)

            self.last_usage = (
                getattr(response, "usage_metadata", None)
                or (getattr(response, "response_metadata", None) or {}).get("token_usage")
            )

            if not response or not response.content:
                self.logger.error("Empty response from DeepSeek")
                return None

            return response.content

        except Exception as e:
            self.logger.error(f"Error generating DeepSeek response: {e}")
            return None


class LLMInterface:
    """Unified interface for different LLM providers"""
    
    def __init__(self, provider: str = None):
        self.logger = logging.getLogger(__name__)
        self.provider_name = provider or Config.LLM_PROVIDER
        self.provider = self._initialize_provider()

    @classmethod
    def from_provider(cls, provider_instance: LLMProvider, provider_name: str) -> 'LLMInterface':
        """Wrap an already-constructed provider instance (e.g. GeminiProvider(model='gemini-3.1-pro',
        thinking_level='high')) instead of building one from Config via a bare provider-name string.
        Used by benchmark scripts that need multiple variants of the same provider type."""
        instance = cls.__new__(cls)
        instance.logger = logging.getLogger(__name__)
        instance.provider_name = provider_name
        instance.provider = provider_instance
        return instance

    def _initialize_provider(self) -> LLMProvider:
        """Initialize the appropriate LLM provider"""
        if self.provider_name.lower() == 'gemini':
            return GeminiProvider()
        elif self.provider_name.lower() == 'llamacpp':
            return LlamaCppProvider()
        elif self.provider_name.lower() == 'deepseek':
            return DeepSeekProvider()
        else:
            raise ValueError(f"Unsupported LLM provider: {self.provider_name}")
    
    def generate_response(self, prompt: str, retries: int = None) -> Optional[str]:
        """Generate response with retry logic.

        Note: GeminiProvider/DeepSeekProvider catch their own exceptions internally and
        return None rather than raising, so the sleep must happen for a falsy return too -
        not just in the except branch, which those providers never actually trigger. Without
        this, retries fire back-to-back with zero delay, which is useless against a
        requests-per-minute rate limit (confirmed live: 3 back-to-back retries all 429'd
        against Gemini's free-tier 5-req/min cap).
        """
        import time
        max_retries = retries or Config.MAX_RETRIES

        for attempt in range(max_retries):
            try:
                response = self.provider.generate_response(prompt)
                if response:
                    return response

                self.logger.warning(f"Attempt {attempt + 1}/{max_retries} failed - empty response")

            except Exception as e:
                self.logger.warning(f"Attempt {attempt + 1}/{max_retries} failed: {e}")

            if attempt == max_retries - 1:
                self.logger.error(f"All {max_retries} attempts failed for LLM response")
                return None

            time.sleep(Config.RETRY_DELAY * (attempt + 1))

        return None
    
    def extract_json_from_response(self, response: str) -> Optional[Dict[str, Any]]:
        """Extract and parse JSON from LLM response"""
        return _extract_json_from_response(response, self.logger)

    def get_last_usage(self) -> Optional[Dict[str, Any]]:
        """Get token usage metadata from the most recent generate_response call, if the provider tracks it"""
        return getattr(self.provider, 'last_usage', None)

    def get_provider_info(self) -> Dict[str, str]:
        """Get information about the current provider (reads the instance's actual model/thinking
        settings where the provider tracks them, rather than assuming the process-wide Config default)"""
        if self.provider_name.lower() == 'gemini':
            return {
                'provider': 'Gemini',
                'model': getattr(self.provider, 'model_name', Config.GEMINI_MODEL),
                'thinking_level': getattr(self.provider, 'thinking_level', None),
                'type': 'Google Generative AI'
            }
        elif self.provider_name.lower() == 'llamacpp':
            return {
                'provider': 'Llama.cpp',
                'model': Config.LLAMACPP_MODEL,
                'base_url': Config.LLAMACPP_BASE_URL,
                'type': 'OpenAI-compatible API'
            }
        elif self.provider_name.lower() == 'deepseek':
            return {
                'provider': 'DeepSeek',
                'model': getattr(self.provider, 'model_name', Config.DEEPSEEK_MODEL),
                'thinking_enabled': getattr(self.provider, 'thinking_enabled', None),
                'base_url': Config.DEEPSEEK_BASE_URL,
                'type': 'OpenAI-compatible API'
            }
        else:
            return {'provider': 'Unknown'}
