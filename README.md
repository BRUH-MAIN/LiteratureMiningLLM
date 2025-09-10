# ScienceDirect Citation Processing Project

This project provides tools to convert ScienceDirect citation text files into structured JSON format and perform comprehensive analysis.

## 📁 Project Structure

```
LiteratureMiningLLM/
├── dataset/
│   ├── raw/                    # Original text files
│   │   ├── ScienceDirect_citations_1756226791775.txt
│   │   ├── ScienceDirect_citations_1756226833643.txt
│   │   └── ScienceDirect_citations_1756226850223.txt
│   └── processed/              # Processed JSON files and reports
│       ├── individual JSON files (one per input file)
│       ├── combined_citations.json
│       ├── analysis_results.json
│       └── processing_report.txt
├── preprocessing/              # Processing scripts
│   ├── process_citations.py   # Main preprocessing pipeline
│   ├── analyze_data.py        # Data analysis tools
│   └── generate_summary.py    # Project summary generator
└── README.md
```

## 🚀 Quick Start

### Basic Usage

To process all citation files and generate cleaned JSON data:

```bash
python preprocessing/process_citations.py
```

This single command will:
- Process all `.txt` files in `dataset/raw/`
- Extract and structure citation data
- Clean and validate the data
- Generate comprehensive analysis
- Save results to `dataset/processed/`

## 📊 What the Cleaning Process Does

The cleaning script performs the following operations:

1. **Text Normalization**:
   - Removes trailing commas from author names
   - Trims whitespace from all text fields
   - Standardizes field formats

2. **Data Enhancement**:
   - Extracts publication years from volume information when missing
   - Cleans and normalizes keyword lists
   - Removes empty keyword entries

3. **Quality Improvement**:
   - Identifies and flags potential duplicate papers
   - Validates ISSN formats
   - Ensures data consistency across fields

4. **Field Standardization**:
   - Consistent author name formatting
   - Standardized journal names
   - Cleaned abstract text

## 📋 Output Files

After processing, you'll find these files in `dataset/processed/`:

- **`combined_citations.json`**: All citations in a single structured file
- **`analysis_results.json`**: Comprehensive statistics and insights
- **`processing_report.txt`**: Human-readable processing summary
- **Individual files**: `ScienceDirect_citations_*.json` (one per input file)

## 📈 Analysis Features

The processing pipeline automatically generates:

- **Citation Statistics**: Total papers, unique journals, authors, keywords
- **Temporal Analysis**: Publication year distribution
- **Journal Analysis**: Top publishing venues
- **Author Analysis**: Most prolific researchers
- **Keyword Analysis**: Research trends and topics
- **Quality Metrics**: Data completion rates and validation results
- **Duplicate Detection**: Identification of potential duplicate papers

## 🔧 Advanced Usage

### Processing Specific Files

```bash
# Modify the raw_data_dir parameter in the script
processor = CitationProcessor(raw_data_dir="path/to/your/files")
```

### Custom Output Location

```bash
# Modify the output_dir parameter
processor = CitationProcessor(output_dir="path/to/output")
```

## 📊 Data Structure

Each citation in the JSON files contains:

```json
{
  "authors": "Author1, Author2, Author3",
  "title": "Paper Title",
  "journal": "Journal Name",
  "volume_info": ["Volume X", "2024", "Article ID"],
  "year": 2024,
  "article_id": "123456",
  "issn": "1234-5678",
  "doi_url": "https://doi.org/10.1016/...",
  "sciencedirect_url": "https://www.sciencedirect.com/...",
  "abstract": "Paper abstract text...",
  "keywords": ["keyword1", "keyword2", "keyword3"]
}
```

## 🎯 Current Dataset Overview

**Latest Processing Results** (296 total citations):
- **Journals**: 68 unique venues
- **Authors**: 1,598 unique researchers  
- **Keywords**: 768 unique terms
- **Top Research Areas**: MXene materials, Supercapacitors, Energy storage
- **Data Quality**: 100% completion for core fields (title, authors, journal)

## 💡 Usage Tips

1. **For Analysis**: Use `combined_citations.json` as your primary dataset
2. **For Quality Insights**: Check `processing_report.txt` for data quality metrics
3. **For Research Trends**: Analyze the keyword and temporal distributions
4. **For Collaboration Networks**: Use the author data for network analysis

## 🛠️ Available Tools

The preprocessing folder contains three focused scripts:

- **`process_citations.py`**: Main conversion pipeline (text → JSON + analysis)
- **`analyze_data.py`**: Interactive data exploration and analysis
- **`generate_summary.py`**: Project overview and documentation

## 📝 Notes

- The main script automatically handles encoding issues (UTF-8/Latin-1)
- Duplicate detection is based on title similarity
- ISSN validation uses standard format checking
- All output files use UTF-8 encoding for international character support
