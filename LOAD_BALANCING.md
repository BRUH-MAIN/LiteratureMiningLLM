# ⚖️ Load Balanced Multi-Model Processing

## Overview

The load balancing system automatically distributes work across multiple LLM models to optimize performance and reliability. It intelligently routes requests to available models and balances the load.

## Supported Models

### 1. **Llama.cpp** (Local)
- **URL**: From `LLAMACPP_BASE_URL` (default: http://localhost:8080/v1)
- **Model**: From `LLAMACPP_MODEL` 
- **Type**: Local server via OpenAI-compatible API

### 2. **LM Studio** (Remote) ✨ NEW
- **URL**: From `LM_STUDIO_PORT` (configured for your remote device)
- **Model**: From `model_name` in .env
- **Type**: Remote LM Studio server via OpenAI-compatible API

### 3. **Gemini** (Cloud)
- **API**: Google Gemini API
- **Model**: `gemini-1.5-flash`
- **Type**: Cloud-based API

## Configuration

Your `.env` file contains:
```bash
# Local Llama.cpp
LLAMACPP_BASE_URL=http://0.0.0.0:8080/v1
LLAMACPP_MODEL=llama-model

# Remote LM Studio  
LM_STUDIO_PORT=http://10.12.234.53:1234/v1
model_name=openai-gpt-oss-20b-abliterated-uncensored-neo-imatrix

# Cloud Gemini
GEMINI_API_KEY=AIzaSyC1vfGc5Mtgvmd5gs91cvr1xTtNI5NFjKo
```

## How Load Balancing Works

### 1. **Provider Pool**
- Initializes all available providers (Llama.cpp, LM Studio, Gemini)
- Tracks status and request counts for each provider

### 2. **Health Checking**
- Monitors provider availability
- Automatically retries failed providers
- Marks unavailable providers temporarily offline

### 3. **Load Distribution**
- Routes requests to provider with lowest request count
- Balances load across available models
- Fails over to other providers if one becomes unavailable

### 4. **Automatic Failover**
- If a provider fails, automatically tries the next available provider
- Maintains service continuity even if models go offline
- Logs provider status and performance

## Usage

### Command Line
```bash
# Enable load balancing
python main.py --load-balanced

# Load balanced demo
python main.py --demo --load-balanced --skip-db

# Load balanced with custom count
python main.py --papers 10 --load-balanced
```

### Interactive Script
```bash
./run_examples.sh
# Choose option 5: ⚖️ LOAD BALANCED
```

## Benefits

### 1. **Performance**
- Distributes workload across multiple models
- Reduces bottlenecks on single models
- Faster overall processing

### 2. **Reliability**
- Automatic failover if models become unavailable
- No single point of failure
- Graceful degradation

### 3. **Resource Optimization**
- Utilizes available compute resources efficiently
- Balances local and remote processing
- Optimizes costs by mixing cloud and local models

### 4. **Scalability**
- Easy to add new models to the pool
- Automatically adapts to available resources
- Handles varying workloads

## Example Output

```
2025-09-13 20:30:15 - INFO - Load balancer initialized with 3 providers
2025-09-13 20:30:15 - INFO - Initialized provider: llamacpp
2025-09-13 20:30:15 - INFO - Initialized provider: lmstudio  
2025-09-13 20:30:15 - INFO - Initialized provider: gemini
2025-09-13 20:30:16 - DEBUG - Attempting request with provider: llamacpp
2025-09-13 20:30:18 - DEBUG - Successful response from provider: llamacpp
2025-09-13 20:30:19 - DEBUG - Attempting request with provider: lmstudio
2025-09-13 20:30:21 - DEBUG - Successful response from provider: lmstudio
```

## Monitoring & Statistics

The load balancer provides detailed statistics:
- **Provider status**: Which models are available
- **Request counts**: How requests are distributed
- **Performance metrics**: Response times and success rates
- **Failover events**: When and why providers failed

## Troubleshooting

### Provider Not Available
If a provider fails to initialize:
1. Check network connectivity (for remote models)
2. Verify API keys and configurations
3. Ensure model servers are running
4. Check firewall settings for remote connections

### Load Balancing Not Working
- Verify multiple providers are configured in .env
- Check logs for provider initialization errors
- Ensure at least one provider is available
- Monitor provider health check results

## Architecture

```
Request → Load Balancer → Available Provider Selection → LLM Model
                      ↓
              Provider Pool Management
                      ↓
              Health Monitoring & Failover
```

## Configuration Examples

### For Maximum Performance
```bash
# Use all available models
python main.py --load-balanced --fast --skip-db
```

### For High Reliability  
```bash
# Use load balancing with validation
python main.py --load-balanced --demo
```

### For Cost Optimization
```bash
# Prefer local models, fallback to cloud
python main.py --load-balanced --papers 50
```

This load balancing system gives you the best of all worlds: **performance, reliability, and resource optimization**! 🚀
