"""
LLM Interface module for handling different LLM providers

This module provides a unified interface for:
- Google Gemini API
- Llama.cpp through OpenAI-compatible API (langchain_openai)
"""

import logging
import json
import time
import threading
from typing import Optional, Dict, Any, List
from abc import ABC, abstractmethod
from concurrent.futures import ThreadPoolExecutor, as_completed
import requests

import google.generativeai as genai
from langchain_openai import ChatOpenAI
from app.config import Config


class LLMProvider(ABC):
    """Abstract base class for LLM providers"""
    
    @abstractmethod
    def generate_response(self, prompt: str) -> Optional[str]:
        """Generate a response from the LLM"""
        pass


class GeminiProvider(LLMProvider):
    """Gemini LLM provider using Google's Generative AI"""
    
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.setup_gemini()
    
    def setup_gemini(self):
        """Setup Gemini API client"""
        if not Config.GEMINI_API_KEY:
            raise ValueError("GEMINI_API_KEY environment variable not set")
        
        genai.configure(api_key=Config.GEMINI_API_KEY)
        self.model = genai.GenerativeModel(Config.GEMINI_MODEL)
        self.logger.info(f"Gemini {Config.GEMINI_MODEL} model initialized")
    
    def generate_response(self, prompt: str) -> Optional[str]:
        """Generate response using Gemini"""
        try:
            response = self.model.generate_content(prompt)
            
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


class LMStudioProvider(LLMProvider):
    """LM Studio LLM provider using OpenAI-compatible API through langchain_openai"""
    
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.setup_lmstudio()
    
    def setup_lmstudio(self):
        """Setup LM Studio client through OpenAI-compatible API"""
        if not Config.LM_STUDIO_BASE_URL:
            raise ValueError("LM_STUDIO_BASE_URL environment variable not set")
        
        # Initialize ChatOpenAI client with custom base URL for LM Studio server
        self.client = ChatOpenAI(
            base_url=Config.LM_STUDIO_BASE_URL,
            api_key="lm-studio",  # LM Studio typically doesn't require a real API key
            model=Config.LM_STUDIO_MODEL,
            temperature=Config.LM_STUDIO_TEMPERATURE,
            max_tokens=Config.LM_STUDIO_MAX_TOKENS,
        )
        
        self.logger.info(f"LM Studio model initialized - URL: {Config.LM_STUDIO_BASE_URL}, Model: {Config.LM_STUDIO_MODEL}")
    
    def generate_response(self, prompt: str) -> Optional[str]:
        """Generate response using LM Studio through OpenAI-compatible API"""
        try:
            # ChatOpenAI expects messages format
            from langchain_core.messages import HumanMessage
            
            messages = [HumanMessage(content=prompt)]
            response = self.client.invoke(messages)
            
            if not response or not response.content:
                self.logger.error("Empty response from LM Studio")
                return None
                
            return response.content
            
        except Exception as e:
            self.logger.error(f"Error generating LM Studio response: {e}")
            return None


class LoadBalancedProvider(LLMProvider):
    """Load balancing provider that distributes requests across multiple models"""
    
    def __init__(self, providers: List[str]):
        self.logger = logging.getLogger(__name__)
        self.providers = {}
        self.provider_status = {}
        self.request_counts = {}
        self.lock = threading.Lock()
        
        # Initialize individual providers
        for provider_name in providers:
            try:
                if provider_name.lower() == 'llamacpp':
                    self.providers['llamacpp'] = LlamaCppProvider()
                elif provider_name.lower() == 'lmstudio':
                    self.providers['lmstudio'] = LMStudioProvider()
                elif provider_name.lower() == 'gemini':
                    self.providers['gemini'] = GeminiProvider()
                
                self.provider_status[provider_name.lower()] = True  # Assume available initially
                self.request_counts[provider_name.lower()] = 0
                self.logger.info(f"Initialized provider: {provider_name}")
                
            except Exception as e:
                self.logger.warning(f"Failed to initialize provider {provider_name}: {e}")
                self.provider_status[provider_name.lower()] = False
        
        if not self.providers:
            raise ValueError("No providers could be initialized for load balancing")
        
        self.logger.info(f"Load balancer initialized with {len(self.providers)} providers")
    
    def check_provider_availability(self, provider_name: str) -> bool:
        """Check if a provider is available by making a simple health check"""
        try:
            provider = self.providers.get(provider_name)
            if not provider:
                return False
            
            # Try a simple test prompt
            test_response = provider.generate_response("Test")
            return test_response is not None
            
        except Exception as e:
            self.logger.debug(f"Provider {provider_name} availability check failed: {e}")
            return False
    
    def get_available_provider(self) -> Optional[str]:
        """Get the name of an available provider with lowest load"""
        with self.lock:
            available_providers = []
            
            # Check which providers are available
            for provider_name in self.providers.keys():
                if self.provider_status[provider_name]:
                    available_providers.append(provider_name)
            
            if not available_providers:
                # All providers marked as unavailable, try to recheck them
                self.logger.warning("All providers marked unavailable, rechecking...")
                for provider_name in self.providers.keys():
                    if self.check_provider_availability(provider_name):
                        self.provider_status[provider_name] = True
                        available_providers.append(provider_name)
            
            if not available_providers:
                self.logger.error("No providers available")
                return None
            
            # Return provider with lowest request count (simple load balancing)
            selected_provider = min(available_providers, 
                                  key=lambda p: self.request_counts[p])
            
            self.request_counts[selected_provider] += 1
            return selected_provider
    
    def mark_provider_unavailable(self, provider_name: str):
        """Mark a provider as temporarily unavailable"""
        with self.lock:
            self.provider_status[provider_name] = False
            self.logger.warning(f"Marked provider {provider_name} as unavailable")
    
    def generate_response(self, prompt: str) -> Optional[str]:
        """Generate response using load balancing across available providers"""
        max_retries = len(self.providers)
        
        for attempt in range(max_retries):
            provider_name = self.get_available_provider()
            
            if not provider_name:
                self.logger.error("No available providers for request")
                return None
            
            try:
                self.logger.debug(f"Attempting request with provider: {provider_name}")
                provider = self.providers[provider_name]
                response = provider.generate_response(prompt)
                
                if response:
                    self.logger.debug(f"Successful response from provider: {provider_name}")
                    return response
                else:
                    self.logger.warning(f"Empty response from provider: {provider_name}")
                    
            except Exception as e:
                self.logger.warning(f"Error with provider {provider_name}: {e}")
                self.mark_provider_unavailable(provider_name)
                continue
        
        self.logger.error("All providers failed to generate response")
        return None
    
    def get_stats(self) -> Dict[str, Any]:
        """Get load balancing statistics"""
        with self.lock:
            return {
                "providers": list(self.providers.keys()),
                "provider_status": self.provider_status.copy(),
                "request_counts": self.request_counts.copy(),
                "total_requests": sum(self.request_counts.values())
            }


class LLMInterface:
    """Unified interface for different LLM providers"""
    
    def __init__(self, provider: str = None):
        self.logger = logging.getLogger(__name__)
        self.provider_name = provider or Config.LLM_PROVIDER
        self.provider = self._initialize_provider()
    
    def _initialize_provider(self) -> LLMProvider:
        """Initialize the appropriate LLM provider"""
        if self.provider_name.lower() == 'gemini':
            return GeminiProvider()
        elif self.provider_name.lower() == 'llamacpp':
            return LlamaCppProvider()
        elif self.provider_name.lower() == 'lmstudio':
            return LMStudioProvider()
        elif self.provider_name.lower() == 'loadbalanced':
            # Load balanced mode with all available providers
            providers = ['llamacpp', 'lmstudio', 'gemini']
            return LoadBalancedProvider(providers)
        else:
            raise ValueError(f"Unsupported LLM provider: {self.provider_name}")
    
    def generate_response(self, prompt: str, retries: int = None) -> Optional[str]:
        """Generate response with retry logic"""
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
                
                # Add delay between retries
                import time
                time.sleep(Config.RETRY_DELAY * (attempt + 1))
        
        return None
    
    def extract_json_from_response(self, response: str) -> Optional[Dict[str, Any]]:
        """Extract and parse JSON from LLM response"""
        try:
            # Clean up the response text
            clean_text = response.strip()
            
            # Remove thinking tags if present (common in some models)
            if "<think>" in clean_text:
                # Extract content after </think> tag
                think_end = clean_text.find("</think>")
                if think_end != -1:
                    clean_text = clean_text[think_end + 8:].strip()
                else:
                    # If no closing tag, remove everything up to and including <think>
                    think_start = clean_text.find("<think>")
                    if think_start != -1:
                        clean_text = clean_text[think_start + 7:].strip()
            
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
                # Look for JSON object in the text
                import re
                json_match = re.search(r'\{[^}]*\}', clean_text, re.DOTALL)
                if json_match:
                    clean_text = json_match.group(0)
                else:
                    self.logger.error(f"No JSON object found in response: {clean_text[:100]}...")
                    return None
            
            # Parse JSON
            result = json.loads(clean_text)
            self.logger.debug(f"Successfully extracted JSON: {result}")
            return result
            
        except json.JSONDecodeError as e:
            self.logger.error(f"JSON parsing error: {e}")
            self.logger.debug(f"Clean text: '{clean_text[:200]}...'")
            self.logger.debug(f"Raw response: '{response[:200]}...'")
            return None
        except Exception as e:
            self.logger.error(f"Error processing response: {e}")
            return None
    
    def get_provider_info(self) -> Dict[str, str]:
        """Get information about the current provider"""
        if self.provider_name.lower() == 'gemini':
            return {
                'provider': 'Gemini',
                'model': Config.GEMINI_MODEL,
                'type': 'Google Generative AI'
            }
        elif self.provider_name.lower() == 'llamacpp':
            return {
                'provider': 'Llama.cpp',
                'model': Config.LLAMACPP_MODEL,
                'base_url': Config.LLAMACPP_BASE_URL,
                'type': 'OpenAI-compatible API'
            }
        elif self.provider_name.lower() == 'lmstudio':
            return {
                'provider': 'LM Studio',
                'model': Config.LM_STUDIO_MODEL,
                'base_url': Config.LM_STUDIO_BASE_URL,
                'type': 'OpenAI-compatible API'
            }
        elif self.provider_name.lower() == 'loadbalanced':
            if hasattr(self.provider, 'get_stats'):
                stats = self.provider.get_stats()
                return {
                    'provider': 'Load Balanced',
                    'models': ', '.join(stats.get('providers', [])),
                    'type': 'Multi-provider load balancer',
                    'stats': stats
                }
            else:
                return {
                    'provider': 'Load Balanced',
                    'type': 'Multi-provider load balancer'
                }
        else:
            return {'provider': 'Unknown'}
