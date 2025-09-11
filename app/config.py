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
    
    # Gemini settings
    GEMINI_MODEL = "gemini-1.5-flash"
    MAX_RETRIES = 3
    RETRY_DELAY = 1  # seconds
    
    # Database settings
    DB_BATCH_SIZE = 10  # Number of papers to process before committing
    TRUNCATE_ON_RUN = True  # Whether to truncate tables on each run
    
    @classmethod
    def validate(cls):
        """Validate configuration"""
        if not cls.GEMINI_API_KEY:
            raise ValueError("GEMINI_API_KEY environment variable not set")
        
        if not cls.POSTGRES_URL:
            raise ValueError("POSTGRES_URL environment variable not set")
        
        return True
