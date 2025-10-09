# Literature Mining LLM - Workflow Summary

## Overview

This document provides a comprehensive overview of the information extraction workflow used in the Literature Mining LLM project. The system implements an agentic flow using five specialized agents to extract structured research data about MXenes from scientific literature JSON metadata and store it in a PostgreSQL database.

## System Architecture

The workflow follows a sequential pipeline architecture with the following components:

```
JSON Input → Preprocessor → Extractor → Validator → Database Loader → Analytics
```

### Core Technologies
- **Language Models**: Multiple LLM providers supported (Gemini, Groq, Llama.cpp)
- **Database**: PostgreSQL with SQLAlchemy ORM
- **Data Processing**: Python with pandas for analytics
- **Visualization**: matplotlib and seaborn for data visualization

## Detailed Workflow

### 1. Input Data Format

The system processes JSON files containing paper metadata with the following structure:
- **Paper metadata**: title, authors, journal, year, DOI, ISSN
- **Content**: abstract, conclusion, keywords
- **URLs**: DOI links, ScienceDirect URLs

### 2. Agent Pipeline

#### 2.1 Preprocessor Agent (`app/preprocessor.py`)

**Purpose**: Clean and normalize raw paper data

**Key Functions**:
- **Data Loading**: Loads JSON files containing multiple papers
- **Key Normalization**: Standardizes field names across different data sources
- **Text Cleaning**: 
  - Removes LaTeX equations (`$$...$$` and `$...$`)
  - Eliminates LaTeX commands (`\command{content}`)
  - Cleans special characters while preserving punctuation
  - Normalizes whitespace
- **Keyword Processing**: Converts comma-separated strings to arrays
- **Deduplication**: Removes duplicate papers based on DOI

**Input**: Raw JSON paper data
**Output**: Cleaned and normalized paper records

#### 2.2 Extractor Agent (`app/extractor.py`)

**Purpose**: Extract structured data using Large Language Models

**Key Functions**:
- **Multi-LLM Support**: Configurable providers (Gemini, Groq, Llama.cpp)
- **Schema-Guided Extraction**: Uses structured prompts to ensure consistent JSON output
- **Data Extraction Categories**:
  - **Materials**: MXene compositions, composite materials, synthesis/fabrication methods
  - **Properties**: Property types, values, units, test conditions
  - **Applications**: Application types, performance metrics, values, units

**Extraction Schema**:
```json
{
  "materials": [
    {
      "mxene_composition": "Ti3C2Tx",
      "composite_material": "polymer composite",
      "synthesis_method": "etching process",
      "fabrication_method": "solution casting"
    }
  ],
  "properties": [
    {
      "property_type": "Conductivity",
      "value": 353.77,
      "unit": "S/m",
      "test_conditions": "room temperature"
    }
  ],
  "applications": [
    {
      "application_type": "sensors",
      "metric": "sensitivity",
      "value": 0.5,
      "unit": "kPa⁻¹",
      "notes": "pressure sensing"
    }
  ]
}
```

**LLM Configuration**:
- **Gemini**: Uses gemini-2.5-flash model with low temperature (0.1) for consistency
- **Groq**: Supports llama-3.1-70b-versatile with configurable parameters
- **Llama.cpp**: Local models via OpenAI-compatible API

**Input**: Preprocessed paper data (title, abstract, conclusion)
**Output**: Structured JSON with materials, properties, and applications

#### 2.3 Validator Agent (`app/validator.py`)

**Purpose**: Validate and standardize extracted data

**Key Functions**:
- **Property Type Standardization**: Maps various property names to standardized vocabulary
  - `conductivity` → `Conductivity`
  - `young modulus` → `Young_Modulus`
  - `seebeck coefficient` → `Seebeck_Coefficient`
- **Unit Standardization**: Normalizes units to consistent format
  - `s m−1` → `S/m`
  - `gpa` → `GPa`
  - `mv/k` → `mV/K`
- **Value Parsing**: Extracts numeric values from strings with units
- **Data Validation**: Ensures required fields are present and valid
- **Duplicate Removal**: Eliminates duplicate entries within papers

**Input**: Raw extracted JSON data
**Output**: Validated and standardized data records

#### 2.4 Database Loader Agent (`app/db_loader.py`)

**Purpose**: Store processed data in PostgreSQL database

**Database Schema**:
- **Papers Table**: Core paper metadata with unique DOI constraint
- **Materials Table**: MXene compositions and synthesis methods (1:N with papers)
- **Properties Table**: Material properties with standardized types (1:N with materials)
- **Applications Table**: Application metrics and performance data (1:N with materials)

**Key Functions**:
- **Schema Management**: Creates tables if not exists, handles truncation
- **Batch Processing**: Inserts data in configurable batches (default: 10)
- **Transaction Management**: Proper session handling with rollback on errors
- **Foreign Key Relationships**: Maintains referential integrity across tables
- **Statistics Tracking**: Provides insertion counts and database statistics

**Input**: Validated data records
**Output**: Structured data in PostgreSQL with foreign key relationships

#### 2.5 Analytics Agent (`app/analytics.py`)

**Purpose**: Query database and generate insights and visualizations

**Key Functions**:
- **Data Queries**:
  - Conductivity analysis with MXene compositions
  - Sensor application statistics
  - Property distribution analysis
  - Publication trend analysis
- **Data Export**: CSV exports for external analysis
- **Visualizations**:
  - Conductivity value histograms
  - MXene composition frequency distributions
  - Property correlation analyses
- **Summary Reports**: Comprehensive statistics and insights

**Output Formats**:
- CSV files for each data category
- PNG plots for visualizations
- Text reports with statistical summaries

## Configuration Management

### Environment Variables
- `GEMINI_API_KEY`: Google Gemini API access
- `GROQ_API_KEY`: Groq API access
- `POSTGRES_URL`: PostgreSQL connection string
- `LLM_PROVIDER`: Active LLM provider selection
- `PAPER_COUNT`: Limit processing to specific number of papers

### Processing Settings
- **Demo Mode**: Configurable paper count limits for testing
- **Batch Processing**: Adjustable batch sizes for database operations
- **Retry Logic**: Automatic retry for API failures with exponential backoff
- **Logging**: Comprehensive logging with timestamped files

## Data Flow

### Input → Processing → Output

1. **Input**: JSON files in `data/processed/` directory
2. **Processing**: Sequential agent pipeline with validation
3. **Intermediate**: Cleaned, extracted, and validated JSON structures
4. **Storage**: Normalized relational data in PostgreSQL
5. **Output**: 
   - CSV exports in `results/` directory
   - Visualizations (PNG plots)
   - Summary reports (TXT files)
   - Database ready for queries

### Quality Assurance

- **Schema Validation**: JSON schema compliance at each stage
- **Data Integrity**: Foreign key constraints and cascade deletes
- **Error Handling**: Graceful degradation with detailed logging
- **Standardization**: Consistent vocabulary and units across all data

## Performance Characteristics

### Scalability Features
- **Batch Processing**: Configurable batch sizes prevent memory issues
- **Session Management**: Proper database connection handling
- **Error Recovery**: Continue processing despite individual paper failures
- **Parallel Processing**: Support for concurrent LLM requests

### Processing Metrics
- **Throughput**: Processes ~100-1000 papers depending on LLM provider
- **Accuracy**: Schema-guided extraction ensures high structure compliance
- **Reliability**: Retry logic and error handling for robust operation

## Usage Patterns

### Standard Workflow
```bash
# Full pipeline execution
python main.py

# Evaluation mode
python main.py --evaluate
```

### Configuration Examples
```bash
# Use Gemini with 30 paper limit
export LLM_PROVIDER=gemini
export PAPER_COUNT=30

# Use local Llama.cpp model
export LLM_PROVIDER=llamacpp
export LLAMACPP_BASE_URL=http://localhost:8080/v1
```

## Output Analytics

The system generates comprehensive analytics including:

- **Conductivity Analysis**: Distribution of electrical conductivity values across different MXene compositions
- **Materials Overview**: Frequency analysis of MXene types and synthesis methods
- **Applications Mapping**: Sensor applications with performance metrics
- **Publication Trends**: Temporal analysis of research publications
- **Property Correlations**: Relationships between materials and their properties

## Quality Control

### Validation Mechanisms
- **LLM Output Validation**: JSON schema compliance checking
- **Unit Standardization**: Automatic conversion to standard units
- **Value Range Checking**: Realistic bounds for physical properties
- **Duplicate Detection**: Removal of redundant data entries

### Error Handling
- **API Failures**: Automatic retry with exponential backoff
- **Database Errors**: Transaction rollback and session cleanup
- **Data Parsing**: Graceful handling of malformed JSON responses
- **Missing Data**: Appropriate defaults and null handling

This workflow provides a robust, scalable solution for extracting structured research data from scientific literature, with comprehensive quality control and analytics capabilities.