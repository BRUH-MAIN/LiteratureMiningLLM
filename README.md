# Literature Mining LLM - MXene Research Data Extraction

This project implements a modular Python application with an agentic flow for extracting structured research data about MXenes from JSON metadata files and storing it in PostgreSQL.

## Features

- **Preprocessing Agent**: Cleans and normalizes paper data, removes duplicates
- **Extraction Agent**: Uses Gemini Flash LLM to extract structured materials, properties, and applications data
- **Validation Agent**: Validates and standardizes extracted data (units, property types, etc.)
- **Database Loader Agent**: Stores processed data in PostgreSQL with normalized schema
- **Analytics Agent**: Provides queries, visualizations, and export functionality

## Requirements

- Python 3.11+
- PostgreSQL database
- Gemini API key
- UV package manager (recommended)

## Setup

1. **Clone and navigate to the project:**
   ```bash
   cd /path/to/LiteratureMiningLLM
   ```

2. **Install dependencies using UV:**
   ```bash
   uv sync
   ```

3. **Set up environment variables:**
   Create a `.env` file with:
   ```
   GEMINI_API_KEY=your_gemini_api_key_here
   POSTGRES_URL=postgresql://user:password@localhost:5432/database
   ```

4. **Prepare your data:**
   Place your JSON data file in `data/processed/combined_papers_merged.json`

## Usage

### Run System Test
```bash
uv run python test_system.py
```

### Run Main Pipeline
```bash
uv run python main.py
```

### Test Gemini API Integration
```bash
uv run python test_gemini.py
```

## Input Data Format

The system expects a JSON file with papers in this format:
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

## Database Schema

The system automatically creates four main tables if they don't exist and **truncates all data on each run** to ensure fresh results:

- **papers**: Paper metadata (title, authors, journal, DOI, etc.)
- **materials**: Material information (MXene composition, synthesis methods)
- **properties**: Material properties (conductivity, modulus, etc.)
- **applications**: Application data (sensors, energy storage, etc.)

### Database Behavior
- **Schema Creation**: Tables are automatically created if they don't exist
- **Data Truncation**: All existing data is cleared on each run to prevent duplicates
- **Fresh Start**: Each execution starts with a clean database state

## Output

Results are saved to the `results/` directory:

- **CSV files**: Extracted data exports
- **Visualizations**: Histograms and distribution plots
- **Summary reports**: Database statistics and insights
- **Logs**: Detailed processing logs

## Configuration

Edit `app/config.py` to modify:
- Processing settings (demo mode, batch sizes)
- Database behavior (`TRUNCATE_ON_RUN = True` by default)
- File paths
- API settings

## Demo Mode

By default, the system runs in demo mode processing only 5 papers to avoid API rate limits. To process all papers, set `DEMO_MODE = False` in `app/config.py`.

## Modules

- `app/preprocessor.py`: Data cleaning and normalization
- `app/extractor.py`: LLM-based data extraction
- `app/validator.py`: Data validation and standardization
- `app/db_loader.py`: Database operations
- `app/analytics.py`: Analytics and visualization
- `app/models.py`: Database schema definitions

## Analytics Features

- Conductivity value distributions
- MXene composition analysis
- Sensor application statistics
- Property type distributions
- Publication trend analysis

## Error Handling

The system includes comprehensive error handling and logging. Check the `logs/` directory for detailed execution logs.

## Contributing

1. Follow the modular architecture
2. Add comprehensive docstrings
3. Include error handling
4. Update tests as needed

## License

This project is for research purposes.