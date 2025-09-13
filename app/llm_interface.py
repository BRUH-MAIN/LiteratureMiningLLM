"""
LLM Interface module for handling different LLM providers

This module provides a unified interface for:
- Google Gemini API
- Llama.cpp through OpenAI-compatible API (langchain_openai)
"""

import logging
import json
from typing import Optional, Dict, Any
from abc import ABC, abstractmethod

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
        else:
            return {'provider': 'Unknown'}
