#!/usr/bin/env python3
"""
Test other LLM providers while LM Studio is down
"""

import os
import requests
from dotenv import load_dotenv

load_dotenv()

def test_llamacpp():
    """Test Llama.cpp local server"""
    print("🦙 Testing Llama.cpp...")
    
    base_url = os.getenv('LLAMACPP_BASE_URL', 'http://localhost:8080/v1')
    
    try:
        response = requests.get(f"{base_url}/models", timeout=5)
        if response.status_code == 200:
            print(f"   ✅ Llama.cpp is available at {base_url}")
            return True
        else:
            print(f"   ❌ Llama.cpp returned status {response.status_code}")
            return False
    except Exception as e:
        print(f"   ❌ Llama.cpp not reachable: {e}")
        return False

def test_gemini():
    """Test Gemini API"""
    print("🤖 Testing Gemini API...")
    
    api_key = os.getenv('GEMINI_API_KEY')
    if not api_key or api_key == "YOUR_GEMINI_API_KEY_HERE":
        print("   ❌ Gemini API key not configured")
        return False
    
    # Simple test - just check if we have a valid key format
    if api_key.startswith('AIza') and len(api_key) > 30:
        print("   ✅ Gemini API key looks valid")
        return True
    else:
        print("   ❌ Gemini API key format invalid")
        return False

def main():
    print("🔍 Testing available LLM providers...")
    print("-" * 40)
    
    providers_available = []
    
    if test_llamacpp():
        providers_available.append("Llama.cpp")
    
    if test_gemini():
        providers_available.append("Gemini")
    
    print("-" * 40)
    print(f"📊 Available providers: {len(providers_available)}")
    for provider in providers_available:
        print(f"   ✅ {provider}")
    
    if not providers_available:
        print("   ❌ No providers available!")
    
    print("\n💡 Recommendation:")
    if providers_available:
        print("   Run the system with available providers only")
        print("   Load balancing will automatically exclude LM Studio")
    else:
        print("   Fix provider configurations before proceeding")

if __name__ == "__main__":
    main()
