"""
Configuration settings for the Literature Mining LLM application
"""

import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Application configuration"""
    
    # API Keys
    GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')
    
    # Database
    POSTGRES_URL = os.getenv('POSTGRES_URL')
    
    # File paths
    DATA_DIR = "data/processed"
    INPUT_FILE = "combined_papers_merged.json"
    OUTPUT_DIR = "results"
    LOGS_DIR = "logs"
    
    # Processing settings
    DEMO_MODE = False  # Set to False for full processing
    DEMO_PAPER_COUNT = 5  # Number of papers to process in demo mode
    
    # LLM Provider settings - choose 'gemini' or 'llamacpp'
    LLM_PROVIDER = os.getenv('LLM_PROVIDER', 'gemini')
    
    # Gemini settings
    GEMINI_MODEL = "gemini-1.5-flash"
    
    # Llama.cpp settings (through OpenAI-compatible API)
    LLAMACPP_BASE_URL = os.getenv('LLAMACPP_BASE_URL', 'http://localhost:8080/v1')
    LLAMACPP_MODEL = os.getenv('LLAMACPP_MODEL', 'llama-model')
    LLAMACPP_TEMPERATURE = float(os.getenv('LLAMACPP_TEMPERATURE', '0.1'))
    LLAMACPP_MAX_TOKENS = int(os.getenv('LLAMACPP_MAX_TOKENS', '2048'))
    
    # LM Studio settings (through OpenAI-compatible API)
    LM_STUDIO_BASE_URL = os.getenv('LM_STUDIO_PORT', 'http://localhost:1234/v1')
    LM_STUDIO_MODEL = os.getenv('model_name', 'local-model')
    LM_STUDIO_TEMPERATURE = float(os.getenv('LM_STUDIO_TEMPERATURE', '0.1'))
    LM_STUDIO_MAX_TOKENS = int(os.getenv('LM_STUDIO_MAX_TOKENS', '2048'))
    
    # Common LLM settings
    MAX_RETRIES = 3
    RETRY_DELAY = 1  # seconds
    REQUEST_DELAY = 0.5  # seconds between LLM requests (can be reduced for fast mode)
    
    # Database settings
    DB_BATCH_SIZE = 10  # Number of papers to process before committing
    TRUNCATE_ON_RUN = True  # Whether to truncate tables on each run
    
    @classmethod
    def validate(cls):
        """Validate configuration"""
        if cls.LLM_PROVIDER == 'gemini':
            if not cls.GEMINI_API_KEY:
                raise ValueError("GEMINI_API_KEY environment variable not set")
        elif cls.LLM_PROVIDER == 'llamacpp':
            if not cls.LLAMACPP_BASE_URL:
                raise ValueError("LLAMACPP_BASE_URL environment variable not set")
        elif cls.LLM_PROVIDER == 'lmstudio':
            if not cls.LM_STUDIO_BASE_URL:
                raise ValueError("LM_STUDIO_BASE_URL environment variable not set")
        elif cls.LLM_PROVIDER == 'loadbalanced':
            # Load balanced mode doesn't require specific validation
            # Individual providers will be validated when initialized
            pass
        else:
            raise ValueError(f"Invalid LLM_PROVIDER: {cls.LLM_PROVIDER}. Must be 'gemini', 'llamacpp', 'lmstudio', or 'loadbalanced'")
        
        if not cls.POSTGRES_URL:
            raise ValueError("POSTGRES_URL environment variable not set")
        
        return True
