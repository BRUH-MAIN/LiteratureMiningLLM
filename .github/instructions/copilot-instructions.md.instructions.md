---
applyTo: '**'
---

# Literature Mining LLM - Copilot Instructions

## Project Overview

This is a modular Python application implementing an agentic flow for extracting structured research data about MXenes from JSON metadata files and storing it in PostgreSQL. The system uses a pipeline of specialized agents for processing scientific literature.

## Architecture & Core Components

### 1. Agent-Based Pipeline Architecture
The application follows an agentic flow with five specialized agents:

- **Preprocessor Agent** (`app/preprocessor.py`): Cleans and normalizes paper data, removes duplicates
- **Extractor Agent** (`app/extractor.py`): Uses LLM to extract structured materials, properties, and applications data
- **Validator Agent** (`app/validator.py`): Validates and standardizes extracted data (units, property types, etc.)
- **Database Loader Agent** (`app/db_loader.py`): Stores processed data in PostgreSQL with normalized schema
- **Analytics Agent** (`app/analytics.py`): Provides queries, visualizations, and export functionality

### 2. Key Modules

#### Configuration (`app/config.py`)
- Centralized configuration using environment variables
- Supports multiple LLM providers (Gemini, Llama.cpp)
- Database settings, file paths, and processing parameters
- Demo mode for testing with limited data

#### LLM Interface (`app/llm_interface.py`) 
- Unified interface for multiple LLM providers
- Abstract base class `LLMProvider` with concrete implementations
- `GeminiProvider` for Google Gemini API
- `LlamaCppProvider` for local Llama.cpp models via OpenAI-compatible API
- Proper error handling and retry logic

#### Database Models (`app/models.py`)
- SQLAlchemy ORM models for normalized schema
- `Paper`: Paper metadata (title, authors, journal, year, DOI, abstract, keywords)
- `Material`: MXene compositions, synthesis/fabrication methods  
- `Property`: Material properties with values, units, and types
- `Application`: Applications like sensors, energy storage, etc.
- Proper foreign key relationships and cascade deletes

## Coding Standards & Guidelines

### 1. Code Structure
- Follow modular, single-responsibility principle
- Each agent should be self-contained with clear interfaces
- Use type hints consistently throughout the codebase
- Implement proper error handling with try/catch blocks
- Use logging extensively for debugging and monitoring

### 2. Data Processing Patterns
- **Input**: JSON files containing paper metadata
- **Processing**: Sequential agent pipeline with validation at each step
- **Output**: Structured data in PostgreSQL + analytics/visualizations
- Use pandas DataFrames for data manipulation in analytics
- Implement batch processing for database operations

### 3. LLM Integration Best Practices
- Use schema-guided prompts for consistent JSON extraction
- Implement retry logic for API failures
- Support multiple providers through unified interface
- Validate LLM outputs before database insertion
- Use appropriate temperature settings (0.1 for structured extraction)

### 4. Database Guidelines
- Use SQLAlchemy ORM for all database operations
- Implement proper session management with context managers
- Use batch inserts for performance
- Implement cascade deletes for data integrity
- Create indexes on frequently queried columns

### 5. Error Handling & Logging
- Use Python's logging module with appropriate levels
- Log all major operations with timestamps
- Handle API rate limits and connection failures gracefully
- Implement graceful degradation for non-critical failures
- Store logs in timestamped files under `logs/` directory

## Development Patterns

### 1. Agent Development Pattern
When creating or modifying agents:
```python
class NewAgent:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
    
    def process(self, data: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Main processing method with proper typing"""
        try:
            # Process data
            self.logger.info(f"Processed {len(data)} items")
            return processed_data
        except Exception as e:
            self.logger.error(f"Processing failed: {e}")
            raise
```

### 2. Database Operations Pattern
Always use session management:
```python
def database_operation():
    session = get_session()
    try:
        # Database operations
        session.commit()
    except Exception as e:
        session.rollback()
        logger.error(f"Database operation failed: {e}")
        raise
    finally:
        session.close()
```

### 3. LLM Integration Pattern
Use the unified interface:
```python
llm = LLMInterface(provider='gemini')  # or 'llamacpp'
response = llm.generate_response(prompt)
if response:
    parsed_data = llm.parse_json_response(response)
```

## Environment & Dependencies

### Required Environment Variables
- `GEMINI_API_KEY`: Google Gemini API key
- `POSTGRES_URL`: PostgreSQL connection string
- `LLM_PROVIDER`: 'gemini' or 'llamacpp'
- `LLAMACPP_BASE_URL`: For local Llama.cpp models

### Key Dependencies
- `google-generativeai`: Gemini API integration
- `langchain-openai`: OpenAI-compatible API support
- `sqlalchemy`: Database ORM
- `psycopg2-binary`: PostgreSQL driver
- `pandas`, `matplotlib`, `seaborn`: Data analysis and visualization
- `pydantic`: Data validation
- `python-dotenv`: Environment variable management

## Testing & Quality Assurance

### Testing Guidelines
- Test each agent independently with mock data
- Validate JSON schema compliance for LLM outputs
- Test database operations with rollback scenarios
- Verify data integrity across the full pipeline
- Test with both demo and full datasets

### Code Quality
- Use descriptive variable and function names
- Document complex algorithms and business logic
- Follow PEP 8 style guidelines
- Use docstrings for all public methods
- Implement input validation for all public interfaces

## Data Flow & Schema

### Input Data Format
JSON files with paper metadata including:
- Title, authors, journal, year, DOI
- Abstract and conclusion text
- Keywords array
- URLs and identifiers

### Extracted Data Schema
- **Materials**: MXene compositions, synthesis methods
- **Properties**: Conductivity, mechanical properties with values/units
- **Applications**: Sensor types, energy storage applications

### Database Schema
Normalized relational schema with proper foreign keys:
- Papers (1) → Materials (N) → Properties/Applications (N)

## Analytics & Visualization

### Supported Analytics
- Conductivity distribution analysis
- MXene composition frequency analysis
- Application category statistics
- Publication trend analysis
- Cross-correlation between properties and applications

### Visualization Standards
- Use seaborn/matplotlib for consistent styling
- Save plots to `results/` directory with descriptive names
- Include proper labels, titles, and legends
- Use appropriate color schemes for scientific data

## Performance Considerations

### Optimization Guidelines
- Use batch processing for database operations (default batch size: 10)
- Implement connection pooling for database access
- Cache frequently accessed data
- Use appropriate LLM models (Gemini Flash for speed vs accuracy balance)
- Monitor memory usage during large dataset processing

### Scalability Patterns
- Design for horizontal scaling with queue-based processing
- Implement checkpointing for long-running extractions
- Support parallel processing where appropriate
- Design database schema for efficient queries

This codebase represents a production-ready literature mining system with proper separation of concerns, robust error handling, and extensible architecture for processing scientific literature at scale.