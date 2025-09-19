---
applyTo: '**'
---

# Literature Mining LLM - MXene Research Data Extraction

## Project Overview

This is a sophisticated Python application implementing an **agentic workflow** for extracting structured research data about MXenes (2D materials) from JSON metadata files using Large Language Models. The system employs a multi-agent architecture with specialized agents for different tasks.

### Core Architecture

The system follows a **three-step pipeline**: `Extractor → Checker → Formatter`

```
Input Papers → EXTRACTOR → CHECKER → FORMATTER → Database → Analytics
```

## Key Modules & Agents

### 1. Core Agents (`app/`)
- **`extractor.py`**: LLM-based data extraction agent using configurable providers
- **`validator_agent.py`**: Hallucination detection and correction agent  
- **`validator.py`**: Data cleaning and standardization formatter
- **`preprocessor.py`**: Data cleaning and normalization agent
- **`db_loader.py`**: Database operations agent with PostgreSQL
- **`analytics.py`**: Analytics and visualization agent

### 2. Support Modules
- **`llm_interface.py`**: Unified interface for multiple LLM providers (Gemini, Llama.cpp, LM Studio)
- **`prompt_loader.py`**: Loads prompts from external `.txt` files
- **`models.py`**: SQLAlchemy database schema definitions
- **`config.py`**: Centralized configuration management

### 3. LLM Provider Support
- **Gemini API**: Google's Generative AI with API key
- **Llama.cpp**: Local models via OpenAI-compatible API
- **LM Studio**: Local models with OpenAI-compatible interface
- **Load Balanced**: Automatic failover across multiple providers

## Data Schema

The system extracts three main data types:

### Materials
```python
{
    "mxene_composition": "Ti3C2Tx",
    "composite_material": "Ti3C2Tx/PDMS",
    "synthesis_method": "HF etching",
    "fabrication_method": "spin coating"
}
```

### Properties
```python
{
    "property_type": "Conductivity",  # Standardized types
    "value": 353.77,                 # Numeric only
    "unit": "S/m",                   # Standardized units
    "test_conditions": "room temperature"
}
```

### Applications
```python
{
    "application_type": "sensors",
    "metric": "sensitivity",
    "value": 0.85,
    "unit": "pF/Pa",
    "notes": "pressure sensing"
}
```

## Workflow Modes

### 1. 🚀 **FAST MODE** (extraction only)
- **Steps**: Extractor → Formatter  
- **Speed**: ⚡ Fastest (~10s for 1 paper)
- **Use**: Quick testing, development
- **Command**: `python main.py --fast --papers 1 --skip-db`

### 2. ✅ **VALIDATE-ONLY MODE** (check without correction)
- **Steps**: Extractor → Checker (validation only) → Formatter
- **Speed**: ⚡ Fast 
- **Use**: Quality assessment without correction
- **Command**: `python main.py --validate-only --papers 5`

### 3. 🎯 **ACCURATE MODE** (default)
- **Steps**: Extractor → Checker (full correction) → Formatter  
- **Speed**: ⚡ Slower
- **Use**: Production, research with highest accuracy
- **Command**: `python main.py --papers 5`

### 4. 🏭 **FULL PROCESSING** 
- **Steps**: Extractor → Checker → Formatter → Database → Analytics
- **Speed**: ⚡ Slowest
- **Use**: Complete pipeline with database and visualizations
- **Command**: `python main.py`

## Configuration

### Environment Variables (`.env`)
```bash
# LLM Provider ('gemini', 'llamacpp', 'lmstudio', 'loadbalanced')
LLM_PROVIDER=gemini

# Gemini Configuration
GEMINI_API_KEY=your_gemini_api_key_here

# Llama.cpp Configuration  
LLAMACPP_BASE_URL=http://localhost:8080/v1
LLAMACPP_MODEL=llama-model
LLAMACPP_TEMPERATURE=0.1
LLAMACPP_MAX_TOKENS=2048

# LM Studio Configuration
LM_STUDIO_PORT=http://localhost:1234/v1
model_name=local-model

# Database
POSTGRES_URL=postgresql://user:password@localhost:5432/database
```

### Configuration Settings (`app/config.py`)
- **DEMO_MODE**: Process only 5 papers (default for testing)
- **DEMO_PAPER_COUNT**: Number of demo papers
- **DB_BATCH_SIZE**: Database commit batch size
- **TRUNCATE_ON_RUN**: Reset database on each run

## Command Line Interface

### Basic Usage
```bash
# Demo mode (5 papers, full pipeline)
python main.py --demo

# Fast demo (5 papers, extraction only)
python main.py --demo --fast --skip-db

# Custom paper count
python main.py --papers 10

# Specific LLM provider
python main.py --llm-provider llamacpp

# Load balanced mode
python main.py --load-balanced

# Validate-only mode
python main.py --validate-only --papers 3
```

### Development Commands
```bash
# Fastest testing (1 paper)
python main.py --papers 1 --fast --skip-db

# Quick validation test
python main.py --papers 1 --validate-only --skip-db

# Test LLM providers
python test_lm_studio.py
python test_other_providers.py

# Network diagnostics
python network_test.py
```

## File Structure

```
/
├── app/                     # Core application modules
│   ├── analytics.py         # Analytics and visualization
│   ├── config.py           # Configuration management
│   ├── db_loader.py        # Database operations
│   ├── extractor.py        # LLM extraction agent
│   ├── llm_interface.py    # Multi-provider LLM interface
│   ├── models.py           # Database schema
│   ├── preprocessor.py     # Data preprocessing
│   ├── prompt_loader.py    # External prompt loading
│   ├── validator_agent.py  # Hallucination detection
│   └── validator.py        # Data standardization
├── agents/                 # Additional agent modules (mostly empty)
├── data/processed/         # Input data location
├── prompts/               # External LLM prompts (.txt files)
│   ├── extraction_prompt.txt
│   ├── validation_prompt.txt
│   └── correction_prompt.txt
├── results/               # Output files and visualizations
├── logs/                  # Application logs
├── main.py               # Main pipeline runner
└── demo.py               # Demo script
```

## Development Guidelines

### Code Quality
1. **Follow existing patterns**: Use the established agent-based architecture
2. **Error handling**: Comprehensive try-catch blocks with logging
3. **Type hints**: Use typing annotations for function parameters
4. **Logging**: Use module-level loggers for debugging
5. **Configuration**: Store settings in `app/config.py` and `.env`

### LLM Integration
1. **Use LLMInterface**: Don't call LLM providers directly
2. **Prompt files**: Store prompts in `prompts/` directory as `.txt` files
3. **Provider agnostic**: Code should work with any configured provider
4. **Rate limiting**: Respect API limits with delays and retries

### Database Operations
1. **Use SQLAlchemy**: Follow existing model patterns in `models.py`
2. **Batch processing**: Use configured batch sizes for efficiency
3. **Transactions**: Proper session management and rollback on errors
4. **Schema consistency**: Maintain referential integrity

### Testing & Demo
1. **Start with demo mode**: Use `--demo` for initial testing
2. **Fast mode for development**: Use `--fast --skip-db` for quick iteration
3. **Validate-only for quality**: Use `--validate-only` to check extraction quality
4. **Progressive testing**: 1 paper → 5 papers → full dataset

### Performance Optimization
1. **Request delays**: Use configured delays between LLM calls
2. **Provider selection**: Choose appropriate provider for use case
3. **Load balancing**: Use `--load-balanced` for reliability
4. **Caching**: Leverage prompt caching in PromptLoader

## Common Tasks

### Adding New LLM Provider
1. Extend `LLMInterface` in `llm_interface.py`
2. Add provider class implementing `LLMProvider` interface
3. Update configuration in `config.py`
4. Add validation in `Config.validate()`

### Adding New Data Fields
1. Update extraction prompt in `prompts/extraction_prompt.txt`
2. Modify database schema in `models.py`
3. Update validation logic in `validator.py`
4. Extend analytics queries in `analytics.py`

### Creating New Agents
1. Follow existing agent patterns
2. Use centralized logging
3. Implement proper error handling
4. Add to main pipeline in `main.py`

## Troubleshooting

### LLM Provider Issues
- Check network connectivity with test scripts
- Verify API keys and endpoints in `.env`
- Use load balanced mode for fallback
- Check logs for specific error messages

### Database Problems
- Verify PostgreSQL connection string
- Check if database exists and is accessible
- Review database logs for connection issues
- Use `--skip-db` to bypass database operations

### Performance Issues
- Use `--fast` mode to skip validation
- Reduce batch sizes in configuration
- Check network latency to LLM providers
- Monitor memory usage with large datasets

## Supabase Integration

The project includes Supabase configuration for potential cloud database deployment:
- Configuration in `supabase/config.toml`
- Local development support
- Database migrations and schema management
- Authentication and API endpoints

When contributing to this project, ensure your code maintains the established patterns, includes proper error handling, and works across all supported LLM providers. Always test with demo mode first before processing large datasets.