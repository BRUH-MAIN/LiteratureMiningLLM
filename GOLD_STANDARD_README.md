# Gold Standard Literature Mining Extraction (Supabase Edition)

This module implements a rate-limited extraction system for creating a gold standard dataset from literature mining. It respects Gemini API rate limits and stores results in separate tables within your existing Supabase database.

## Features

- **Strict Rate Limiting**: Respects Gemini 2.5 Pro API limits (5 RPM, 250K TPM, 100 RPD)
- **Supabase Integration**: Uses your existing Supabase database with separate gold standard tables
- **Table Isolation**: Creates separate tables with `gold_` prefix (e.g., `gold_papers`, `gold_materials`)
- **Progress Tracking**: Detailed logging and progress reporting
- **Error Handling**: Robust error handling with graceful failure recovery
- **Validation**: Uses the same validation logic as the main system

## Database Setup

The system automatically creates separate tables in your existing Supabase database:

- `gold_papers`: Paper metadata (separate from your main `papers` table)
- `gold_materials`: MXene compositions and synthesis methods
- `gold_properties`: Material properties with values and units  
- `gold_applications`: Applications with performance metrics

## Quick Start

1. **Your .env file is already configured** ✅
   - Your `.env` file contains `GEMINI_API_KEY` and `POSTGRES_URL` 
   - The script will automatically use your Supabase connection

2. **Run the Extraction**:
   ```bash
   # Using the runner script (recommended)
   ./run_gold_standard.sh
   
   # Or directly with Python
   python3 gold_standard_extractor.py
   ```

3. **Inspect the Results**:
   ```bash
   # Check what data was extracted
   python3 inspect_gold_tables.py
   ```

## Rate Limits

The system enforces the following Gemini 2.5 Pro API limits:

- **5 RPM**: 5 requests per minute
- **250,000 TPM**: 250,000 tokens per minute
- **100 RPD**: 100 requests per day

## Configuration

### Processing Parameters

- **Papers to Process**: 50 (first batch)
- **LLM Provider**: Gemini 1.5 Flash
- **Temperature**: 0.1 (for consistent extraction)
- **Validation**: Uses existing validator logic

### Rate Limiting Implementation

The system implements intelligent rate limiting:

1. **Request Tracking**: Maintains a sliding window of request times
2. **Token Estimation**: Estimates token usage before requests
3. **Daily Limits**: Tracks daily usage across sessions
4. **Automatic Delays**: Waits automatically when limits are approached

## File Structure

```
gold_standard_extractor.py     # Main extraction script
gold_standard_config.py        # Configuration documentation
run_gold_standard.sh           # Runner script with checks
GOLD_STANDARD_README.md        # This documentation
```

## Output Files

### Logs
- `logs/gold_standard_extraction_YYYYMMDD_HHMMSS.log`
- Detailed extraction progress and any errors

### Reports
- `results/gold_standard_report_YYYYMMDD_HHMMSS.txt`
- Summary of extraction results and statistics

## Example Usage

```python
from gold_standard_extractor import RateLimitedExtractor

# Initialize with gold database URL
extractor = RateLimitedExtractor("postgresql://user:pass@host/gold_standard_db")

# Extract data from a paper (with automatic rate limiting)
extracted_data = extractor.extract_paper_data(paper_data)

# Store in gold standard database
if extracted_data:
    extractor.store_extracted_data(paper_data, extracted_data)
```

## Error Handling

The system handles various error conditions:

- **Rate Limit Exceeded**: Automatically waits and retries
- **API Failures**: Logs errors and continues with next paper
- **Database Errors**: Rolls back transactions and reports issues
- **Daily Limits**: Stops processing when daily limits are reached

## Monitoring

Track extraction progress through:

1. **Console Output**: Real-time progress updates
2. **Log Files**: Detailed operation logs
3. **Database Queries**: Check extracted data directly
4. **Summary Reports**: Final statistics and metrics

## Quality Assurance

The gold standard dataset includes:

- **Validation**: All extracted data passes validation checks
- **Completeness**: Only complete extractions are stored
- **Consistency**: Standardized property types and units
- **Traceability**: Full audit trail in logs

## Scaling Considerations

For processing larger batches:

1. **Daily Limits**: Plan for 100 requests per day maximum
2. **Time Estimates**: ~12 seconds minimum per request (rate limiting)
3. **Session Management**: Can resume on different days
4. **Token Management**: Monitor token usage to avoid daily limits

## Troubleshooting

### Common Issues

1. **Rate Limit Errors**: Check if daily limits are exceeded
2. **Database Connection**: Verify PostgreSQL URL and permissions
3. **API Key Issues**: Ensure valid Gemini API key
4. **Memory Usage**: Monitor for large paper datasets

### Debug Mode

Enable debug logging by modifying the logging level in the script:

```python
logging.basicConfig(level=logging.DEBUG, ...)
```

## Next Steps

After running the first batch of 50 papers:

1. **Analyze Results**: Review the generated reports
2. **Validate Quality**: Manually check a sample of extractions
3. **Scale Up**: Process additional batches if quality is acceptable
4. **Export Data**: Use the analytics module for further analysis

## Integration

The gold standard dataset can be used for:

- **Quality Benchmarking**: Compare with regular extraction results
- **Model Training**: Fine-tuning extraction models
- **Research Analysis**: High-quality dataset for scientific analysis
- **Validation**: Reference dataset for testing improvements