# Gold Standard Extraction Configuration
# This file documents the configuration for the gold standard extraction script

# Rate Limiting Configuration for Gemini 2.5 Pro API
RATE_LIMITS = {
    'requests_per_minute': 5,        # 5 RPM
    'tokens_per_minute': 250000,     # 250K TPM  
    'requests_per_day': 100          # 100 RPD
}

# Processing Configuration
PROCESSING = {
    'paper_limit': 50,               # Process only 50 papers initially
    'llm_provider': 'gemini',        # Use Gemini for extraction
    'model': 'gemini-1.5-flash',    # Gemini model to use
    'temperature': 0.1,              # Low temperature for consistent extraction
    'max_retries': 3,                # Max retries for failed requests
    'retry_delay': 1                 # Delay between retries (seconds)
}

# Database Configuration
DATABASE = {
    'gold_db_name': 'gold_standard_literature_mining',  # Separate database name
    'schema': 'same_as_main',        # Use same schema as main database
    'tables': [
        'papers',           # Paper metadata
        'materials',        # MXene compositions and methods
        'properties',       # Material properties with values/units
        'applications'      # Applications with metrics
    ]
}

# Data Sources
DATA_SOURCES = {
    'input_file': 'data/processed/combined_papers_merged.json',
    'total_papers': 292,             # Total papers available
    'processing_batch': 50           # First batch size
}

# Output Configuration
OUTPUT = {
    'logs_dir': 'logs/',
    'results_dir': 'results/',
    'log_format': 'gold_standard_extraction_%Y%m%d_%H%M%S.log',
    'report_format': 'gold_standard_report_%Y%m%d_%H%M%S.txt'
}

# Extraction Schema
EXTRACTION_SCHEMA = {
    'materials': [
        'mxene_composition',    # e.g., Ti3C2Tx, Ti2CTx
        'composite_material',   # Any composite materials
        'synthesis_method',     # MXene synthesis method
        'fabrication_method'    # Device/material fabrication
    ],
    'properties': [
        'property_type',        # Conductivity, Modulus, etc.
        'value',               # Numeric value
        'unit',                # Standardized unit
        'test_conditions'      # Testing conditions
    ],
    'applications': [
        'application_type',     # sensors, energy_storage, etc.
        'metric',              # sensitivity, response_time, etc.
        'value',               # Numeric value
        'unit',                # Unit of metric
        'notes'                # Additional context
    ]
}

# Quality Metrics to Track
QUALITY_METRICS = {
    'extraction_success_rate': 'Percentage of successful extractions',
    'api_requests_used': 'Total API requests consumed',
    'tokens_consumed': 'Total tokens used',
    'processing_time': 'Average time per paper',
    'validation_pass_rate': 'Percentage passing validation',
    'data_completeness': 'Percentage of complete extractions'
}