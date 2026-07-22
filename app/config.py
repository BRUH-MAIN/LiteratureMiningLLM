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

    # DeepSeek settings (through OpenAI-compatible API) - used as the gold-standard extractor
    DEEPSEEK_API_KEY = os.getenv('DEEPSEEK_API_KEY')
    DEEPSEEK_BASE_URL = os.getenv('DEEPSEEK_BASE_URL', 'https://api.deepseek.com')
    DEEPSEEK_MODEL = os.getenv('DEEPSEEK_MODEL', 'deepseek-v4-flash')
    DEEPSEEK_TEMPERATURE = float(os.getenv('DEEPSEEK_TEMPERATURE', '0.1'))
    DEEPSEEK_MAX_TOKENS = int(os.getenv('DEEPSEEK_MAX_TOKENS', '4096'))

    # DeepSeek V4 Flash pricing (USD per 1M tokens), for benchmark cost tracking
    DEEPSEEK_PRICE_PER_1M_INPUT = float(os.getenv('DEEPSEEK_PRICE_PER_1M_INPUT', '0.14'))
    DEEPSEEK_PRICE_PER_1M_OUTPUT = float(os.getenv('DEEPSEEK_PRICE_PER_1M_OUTPUT', '0.28'))

    # Kaggle settings - used by benchmark/kaggle/*.py to push/pull candidate model runs
    KAGGLE_USERNAME = os.getenv('KAGGLE_USERNAME')
    KAGGLE_KEY = os.getenv('KAGGLE_KEY')

    # Common LLM settings
    MAX_RETRIES = 3
    RETRY_DELAY = 1  # seconds
    
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
        elif cls.LLM_PROVIDER == 'deepseek':
            if not cls.DEEPSEEK_API_KEY:
                raise ValueError("DEEPSEEK_API_KEY environment variable not set")
        else:
            raise ValueError(f"Invalid LLM_PROVIDER: {cls.LLM_PROVIDER}. Must be 'gemini', 'llamacpp', or 'deepseek'")
        
        if not cls.POSTGRES_URL:
            raise ValueError("POSTGRES_URL environment variable not set")
        
        return True
