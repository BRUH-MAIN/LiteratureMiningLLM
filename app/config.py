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
    GROQ_API_KEY = os.getenv('GROQ_API_KEY')
    
    # Database
    POSTGRES_URL = os.getenv('POSTGRES_URL')
    
    # File paths
    DATA_DIR = "data/processed"
    INPUT_FILE = "combined_papers_merged.json"
    OUTPUT_DIR = "results"
    LOGS_DIR = "logs"
    
    # Processing settings
    PAPER_COUNT = int(os.getenv('PAPER_COUNT', '0'))  # 0 means process all papers
    DEMO_MODE = False  # Deprecated - use PAPER_COUNT instead
    DEMO_PAPER_COUNT = 5  # Deprecated - use PAPER_COUNT instead
    
    # LLM Provider settings - choose 'gemini', 'llamacpp', or 'groq'
    LLM_PROVIDER = os.getenv('LLM_PROVIDER', 'gemini')
    
    # Gemini settings
    GEMINI_MODEL = "gemini-2.5-flash"
    
    # Groq settings
    GROQ_MODEL = os.getenv('GROQ_MODEL', 'llama-3.1-70b-versatile')
    GROQ_TEMPERATURE = float(os.getenv('GROQ_TEMPERATURE', '0.1'))
    GROQ_MAX_TOKENS = int(os.getenv('GROQ_MAX_TOKENS', '2048'))
    
    # Llama.cpp settings (through OpenAI-compatible API)
    LLAMACPP_BASE_URL = os.getenv('LLAMACPP_BASE_URL', 'http://localhost:8080/v1')
    LLAMACPP_MODEL = os.getenv('LLAMACPP_MODEL', 'llama-model')
    LLAMACPP_TEMPERATURE = float(os.getenv('LLAMACPP_TEMPERATURE', '0.1'))
    LLAMACPP_MAX_TOKENS = int(os.getenv('LLAMACPP_MAX_TOKENS', '2048'))
    
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
        elif cls.LLM_PROVIDER == 'groq':
            if not cls.GROQ_API_KEY:
                raise ValueError("GROQ_API_KEY environment variable not set")
        elif cls.LLM_PROVIDER == 'llamacpp':
            if not cls.LLAMACPP_BASE_URL:
                raise ValueError("LLAMACPP_BASE_URL environment variable not set")
        else:
            raise ValueError(f"Invalid LLM_PROVIDER: {cls.LLM_PROVIDER}. Must be 'gemini', 'groq', or 'llamacpp'")
        
        if not cls.POSTGRES_URL:
            raise ValueError("POSTGRES_URL environment variable not set")
        
        return True
