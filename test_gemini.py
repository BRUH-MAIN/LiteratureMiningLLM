"""
Simple test for Gemini API integration
"""

import sys
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

import google.generativeai as genai
import os
from dotenv import load_dotenv

load_dotenv()

def test_gemini_api():
    """Test basic Gemini API functionality"""
    try:
        api_key = os.getenv('GEMINI_API_KEY')
        print(f"API Key present: {bool(api_key)}")
        print(f"API Key length: {len(api_key) if api_key else 0}")
        
        genai.configure(api_key=api_key)
        model = genai.GenerativeModel('gemini-1.5-flash')
        
        # Simple test prompt
        test_prompt = "Extract the number 42 from this text: 'The answer is 42.' Return only a JSON object with format: {\"number\": 42}"
        
        print("Sending test prompt to Gemini...")
        response = model.generate_content(test_prompt)
        
        print(f"Response received: {bool(response)}")
        print(f"Response text: {response.text if response.text else 'None'}")
        
        if response.text:
            print("✓ Gemini API is working")
        else:
            print("✗ Gemini API returned empty response")
            
    except Exception as e:
        print(f"✗ Error testing Gemini API: {e}")

if __name__ == "__main__":
    test_gemini_api()
