#!/usr/bin/env python3
"""
Test script to check LM Studio connectivity
"""

import os
import requests
import json
from dotenv import load_dotenv

load_dotenv()

def test_lm_studio_connection():
    """Test LM Studio connection and model availability"""
    
    # Get configuration from .env
    lm_studio_url = os.getenv('LM_STUDIO_PORT', 'http://localhost:1234')
    model_name = os.getenv('model_name', 'local-model')
    
    # Ensure URL ends with /v1
    if not lm_studio_url.endswith('/v1'):
        lm_studio_url = lm_studio_url.rstrip('/') + '/v1'
    
    print(f"🔍 Testing LM Studio connection...")
    print(f"URL: {lm_studio_url}")
    print(f"Model: {model_name}")
    print("-" * 50)
    
    # Test 1: Check if server is reachable
    try:
        health_url = f"{lm_studio_url.rstrip('/v1')}/health"
        print(f"1. Testing server health at: {health_url}")
        response = requests.get(health_url, timeout=10)
        print(f"   ✅ Server reachable! Status: {response.status_code}")
    except Exception as e:
        print(f"   ❌ Server health check failed: {e}")
        # Continue with other tests
    
    # Test 2: List available models
    try:
        models_url = f"{lm_studio_url}/models"
        print(f"2. Listing models at: {models_url}")
        response = requests.get(models_url, timeout=10)
        
        if response.status_code == 200:
            models_data = response.json()
            print(f"   ✅ Models endpoint reachable!")
            
            if 'data' in models_data:
                available_models = [model['id'] for model in models_data['data']]
                print(f"   Available models: {available_models}")
                
                if model_name in available_models:
                    print(f"   ✅ Target model '{model_name}' is available!")
                else:
                    print(f"   ⚠️  Target model '{model_name}' not found in available models")
            else:
                print(f"   Response: {models_data}")
        else:
            print(f"   ❌ Models endpoint failed: {response.status_code}")
            print(f"   Response: {response.text}")
            
    except Exception as e:
        print(f"   ❌ Models listing failed: {e}")
    
    # Test 3: Test chat completions endpoint
    try:
        chat_url = f"{lm_studio_url}/chat/completions"
        print(f"3. Testing chat completions at: {chat_url}")
        
        test_payload = {
            "model": model_name,
            "messages": [
                {"role": "user", "content": "Hello! Please respond with just 'Hello back!' to confirm you're working."}
            ],
            "max_tokens": 50,
            "temperature": 0.1
        }
        
        headers = {
            "Content-Type": "application/json"
        }
        
        response = requests.post(
            chat_url, 
            headers=headers,
            json=test_payload,
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            if 'choices' in result and len(result['choices']) > 0:
                message = result['choices'][0]['message']['content']
                print(f"   ✅ Chat completion successful!")
                print(f"   Response: {message.strip()}")
            else:
                print(f"   ⚠️  Unexpected response format: {result}")
        else:
            print(f"   ❌ Chat completion failed: {response.status_code}")
            print(f"   Response: {response.text}")
            
    except Exception as e:
        print(f"   ❌ Chat completion test failed: {e}")
    
    print("-" * 50)
    print("🏁 Test completed!")

if __name__ == "__main__":
    test_lm_studio_connection()
