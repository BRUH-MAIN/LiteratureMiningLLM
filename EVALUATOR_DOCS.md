# Property Relevance Evaluator Documentation

## Overview

The Property Relevance Evaluator is a quality assessment tool that compares extracted material properties against the original paper abstracts and conclusions to determine if the extraction is relevant and accurate.

## How It Works

### 1. Data Collection
- Iterates through all papers in the database
- Collects paper abstracts and conclusions
- Retrieves all extracted properties for each paper
- Forms paper-property combinations for evaluation

### 2. LLM-Based Evaluation
- Uses the configured LLM (Gemini, Groq, or Llama.cpp) to evaluate relevance
- Sends a structured prompt containing:
  - Paper abstract and conclusion text
  - Extracted property information (type, value, unit, test conditions)
  - MXene composition information
- Requests a binary relevance score (0 or 1) with reasoning

### 3. Scoring Criteria

**Score 1 (Relevant)** if:
- The property type is explicitly mentioned in the text
- The property is directly related to the main research focus
- The text discusses measurements, characterization, or applications related to this property
- The property values or test conditions align with what's described in the text

**Score 0 (Not Relevant)** if:
- The property type is not mentioned or discussed in the text
- The property seems unrelated to the research described
- The extracted property appears to be an error or misinterpretation
- There's no clear connection between the text content and the property

## Usage

### Command Line Options

```bash
# Run evaluation as part of main script
uv run python main.py --evaluate

# Run standalone evaluator
uv run python run_evaluator.py

# Run demo version (recommended for first-time users)
uv run python demo_evaluator.py

# Test evaluator functions
uv run python test_evaluator.py
```

### Programmatic Usage

```python
from app.analytics import Analytics

# Initialize analytics
analytics = Analytics()

# Run evaluation (processes in batches)
evaluation_df = analytics.evaluate_property_relevance(batch_size=5)

# Generate report
report = analytics.generate_evaluation_report(evaluation_df, "report.txt")

# Print summary
print(f"Relevance rate: {evaluation_df['relevance_score'].mean()*100:.1f}%")
```

## Configuration

### Environment Variables Required

```bash
# LLM Provider (choose one)
LLM_PROVIDER=gemini  # or 'groq' or 'llamacpp'

# API Keys (depending on provider)
GEMINI_API_KEY=your_gemini_key
GROQ_API_KEY=your_groq_key

# Database
POSTGRES_URL=postgresql://user:password@localhost:5432/database
```

### Batch Processing

The evaluator processes papers in batches to avoid overwhelming the LLM:
- Default batch size: 5 papers
- Configurable via `batch_size` parameter
- Smaller batches for more stable processing
- Larger batches for faster processing (if LLM allows)

## Output Files

### 1. Evaluation Results CSV
- `results/property_relevance_evaluation_YYYYMMDD_HHMMSS.csv`
- Contains: paper_id, material_id, property_id, property_type, relevance_score, reasoning

### 2. Evaluation Report
- `results/evaluation_report_YYYYMMDD_HHMMSS.txt`
- Contains: overall statistics, breakdown by property type, low-relevance papers, recommendations

### 3. Log Files
- `logs/evaluator_YYYYMMDD_HHMMSS.log`
- Detailed execution logs with progress and error information

## Interpretation

### Overall Relevance Rate
- **>90%**: Excellent extraction quality
- **70-90%**: Good extraction quality
- **50-70%**: Moderate quality, consider improvements
- **<50%**: Poor extraction quality, review prompts and validation

### Property Type Analysis
- Compare relevance rates across different property types
- Identify which properties are consistently well/poorly extracted
- Focus improvement efforts on low-performing property types

### Paper-Level Analysis
- Identify papers with consistently low relevance scores
- May indicate issues with specific paper formats or content
- Could suggest need for specialized extraction prompts

## Troubleshooting

### Common Issues

1. **No evaluation results**
   - Ensure database has papers with both abstracts/conclusions and extracted properties
   - Check LLM API key configuration
   - Verify database connection

2. **Low relevance rates**
   - Review extraction prompts in `app/extractor.py`
   - Check if property types are being extracted correctly
   - Consider adjusting evaluation criteria

3. **LLM API errors**
   - Check API key validity
   - Verify rate limits
   - Consider reducing batch size

### Error Handling

- Failed evaluations default to score 0
- Batch processing continues even if individual evaluations fail
- Comprehensive logging for debugging
- Graceful degradation for API issues

## Integration with Main Pipeline

The evaluator integrates seamlessly with the main pipeline:

1. **Data Flow**: Paper → Extraction → Validation → Database → Evaluation
2. **Quality Feedback**: Evaluation results inform extraction improvements
3. **Continuous Monitoring**: Regular evaluation ensures consistent quality
4. **Validation Loop**: Low scores trigger review of extraction logic

## Best Practices

1. **Regular Evaluation**: Run evaluation after each major data processing batch
2. **Baseline Establishment**: Document initial relevance rates for comparison
3. **Improvement Tracking**: Monitor relevance rate changes over time
4. **Property-Specific Analysis**: Focus on property types with low relevance
5. **Human Validation**: Spot-check low-scoring evaluations manually

## Future Enhancements

- **Confidence Scoring**: Multi-level relevance scoring (0-5 scale)
- **Aspect-Specific Evaluation**: Separate scores for value accuracy, unit correctness, etc.
- **Automated Feedback**: Direct integration with extraction prompt optimization
- **Comparative Analysis**: Compare different LLM providers for evaluation consistency
