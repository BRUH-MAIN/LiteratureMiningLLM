from dotenv import load_dotenv
import yaml
import os

def load_env():
    """Load environment variables from .env file"""
    load_dotenv()

def load_config():
    """Load configuration from config.yaml"""
    config_path = os.path.join(os.path.dirname(__file__), 'config.yaml')
    with open(config_path, 'r') as file:
        return yaml.safe_load(file)

def load_prompt(prompt_file_path):
    """Load prompt from markdown file"""
    full_path = os.path.join(os.path.dirname(__file__), prompt_file_path)
    with open(full_path, 'r') as file:
        return file.read()
