# Literature Mining LLM - AI Assistant Instructions

## Project Overview

This is a **Literature Mining LLM** project that implements an agentic workflow for extracting structured research data about MXenes (2D carbides and nitrides) from JSON metadata files and storing it in PostgreSQL. The system processes academic papers to extract materials data, properties, and applications using Large Language Models.

## Architecture & Components

### Core Agents
1. **Preprocessor Agent** (`app/preprocessor.py`): Data cleaning, normalization, deduplication
2. **Extractor Agent** (`app/extractor.py`): LLM-based structured data extraction
3. **Validator Agent** (`app/validator_agent.py`): LLM-powered hallucination detection and correction
4. **Formatter Agent** (`app/validator.py`): Data standardization and final cleaning
5. **Database Loader Agent** (`app/db_loader.py`): PostgreSQL storage with normalized schema
6. **Analytics Agent** (`app/analytics.py`): Querying, visualization, and reporting

### Database Schema (PostgreSQL)
- **papers**: Metadata (title, authors, journal, DOI, abstract, keywords)
- **materials**: MXene composition, synthesis methods, fabrication details
- **properties**: Material properties (conductivity, modulus, etc.) with units
- **applications**: Application data (sensors, energy storage) with performance metrics

### LLM Integration
- **Configurable Providers**: Supports Google Gemini and Llama.cpp via OpenAI-compatible API
- **Prompt Management**: External `.txt` files in `prompts/` directory
- **Three-Step Pipeline**: Extract → Validate → Format for maximum accuracy

## Processing Workflow

```
JSON Papers → Preprocessor → Extractor → Validator Agent → Formatter → Database → Analytics
```

### Three Validation Modes
1. **Fast Mode** (`--fast`): Skip LLM validation, fastest processing
2. **Validate-Only** (`--validate-only`): Detect issues but don't correct them
3. **Full Validation** (default): Detect and automatically correct issues

## Configuration & Environment

### Required Environment Variables
```bash
GEMINI_API_KEY=your_gemini_api_key_here                    # For Gemini provider
POSTGRES_URL=postgresql://user:password@localhost:5432/db  # Database connection
LLM_PROVIDER=gemini|llamacpp                              # Optional: Choose provider
LLAMACPP_BASE_URL=http://localhost:8080/v1                # For Llama.cpp provider
```

### Key Configuration (`app/config.py`)
- **DEMO_MODE**: Process limited papers (default: 5)
- **TRUNCATE_ON_RUN**: Clear database on each run (default: True)
- **LLM_PROVIDER**: Choose between 'gemini' or 'llamacpp'
- **REQUEST_DELAY**: Control API rate limiting

## Development Guidelines

### Code Style & Structure
1. **Follow existing patterns**: Each agent is a class with clear responsibilities
2. **Logging**: Use `self.logger = logging.getLogger(__name__)` for all modules
3. **Error Handling**: Comprehensive try-catch blocks with proper logging
4. **Type Hints**: Use typing annotations for function parameters and returns
5. **Docstrings**: Document all classes and public methods with purpose and parameters

### Database Operations
- **Always use SQLAlchemy ORM**: No raw SQL queries
- **Transaction Management**: Use sessions properly with try-finally blocks
- **Schema Management**: Tables auto-created, data truncated on each run
- **Foreign Key Relationships**: Maintain referential integrity

### LLM Integration Best Practices
1. **Use LLMInterface**: Don't directly call provider APIs
2. **Prompt Files**: Store all prompts in `prompts/*.txt` files
3. **Error Recovery**: Implement retries and fallback mechanisms
4. **Rate Limiting**: Respect API limits with configurable delays
5. **Response Validation**: Always validate JSON responses from LLMs

### File Organization
```
app/
├── __init__.py              # Package initialization
├── config.py               # Configuration settings
├── models.py               # Database schema definitions
├── llm_interface.py        # LLM provider abstraction
├── prompt_loader.py        # Prompt management utilities
├── preprocessor.py         # Data cleaning agent
├── extractor.py           # LLM extraction agent
├── validator_agent.py     # LLM validation agent
├── validator.py           # Data formatting agent
├── db_loader.py           # Database operations agent
└── analytics.py           # Analytics and reporting agent

prompts/
├── extraction_prompt.txt   # Main data extraction prompt
├── validation_prompt.txt   # Hallucination detection prompt
└── correction_prompt.txt   # Data correction prompt
```

## Common Commands & Usage

### Development & Testing
```bash
# Quick test (1 paper, fast mode)
python main.py --papers 1 --fast --skip-db

# Demo mode (5 papers with validation)
python main.py --demo

# Validate-only mode (check quality without corrections)
python main.py --papers 3 --validate-only

# Full processing with specific provider
python main.py --llm-provider llamacpp --papers 10
```

### Package Management
- **Use UV**: `uv sync` for dependency installation
- **Python 3.11+**: Required for all development
- **Dependencies**: Defined in `pyproject.toml`

## Data Flow & Processing

### Input Format (JSON)
```json
[
  {
    "title": "Paper title",
    "authors": "Author names",
    "journal": "Journal name", 
    "year": 2025,
    "doi_url": "https://doi.org/...",
    "abstract": "Paper abstract text",
    "conclusion": "Paper conclusion text",
    "keywords": ["keyword1", "keyword2"]
  }
]
```

### Extracted Data Schema
```json
{
  "materials": [
    {
      "mxene_composition": "Ti3C2Tx",
      "composite_material": "Ti3C2Tx/polymer",
      "synthesis_method": "HF etching",
      "fabrication_method": "drop casting"
    }
  ],
  "properties": [
    {
      "property_type": "electrical_conductivity",
      "value": 1500.0,
      "unit": "S/m",
      "test_conditions": "room temperature"
    }
  ],
  "applications": [
    {
      "application_type": "gas_sensor",
      "metric": "sensitivity",
      "value": 95.5,
      "unit": "%",
      "notes": "NH3 detection"
    }
  ]
}
```

## Troubleshooting & Common Issues

### Database Issues
- **Connection errors**: Check POSTGRES_URL environment variable
- **Schema conflicts**: Tables are auto-created and truncated on each run
- **Foreign key errors**: Ensure proper relationship handling in db_loader

### LLM Issues
- **API rate limits**: Adjust REQUEST_DELAY in config
- **Invalid JSON**: Validator agent handles malformed responses
- **Hallucinations**: Use full validation mode, not fast mode

### Performance Optimization
- **Use fast mode** for development: `--fast --skip-db`
- **Limit papers** for testing: `--papers N`
- **Skip database operations** for LLM testing: `--skip-db`

## Contributing Guidelines

### Before Making Changes
1. **Understand the workflow**: Extract → Validate → Format → Store
2. **Check existing patterns**: Follow established code structure
3. **Test with demo mode**: Use `--demo` for quick validation
4. **Validate database schema**: Ensure model relationships are correct

### When Adding Features
1. **Create new agent classes**: Follow existing agent patterns
2. **Add configuration options**: Update `app/config.py`
3. **Include error handling**: Comprehensive logging and recovery
4. **Update documentation**: Modify relevant .md files
5. **Test with different providers**: Both Gemini and Llama.cpp

### Code Review Focus Areas
- **Database transactions**: Proper session management
- **LLM error handling**: Retries and fallbacks
- **Data validation**: Both LLM and programmatic validation
- **Configuration management**: Environment variables and defaults
- **Logging quality**: Informative messages for debugging

---

This codebase represents a production-ready research tool for materials science literature mining. Focus on maintainability, accuracy, and proper error handling when making modifications.