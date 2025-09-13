# Literature Mining LLM - New Workflow

## Redesigned Three-Step Pipeline: Extractor → Checker → Formatter

### Overview
The workflow has been restructured into three clear, sequential steps:

```
Input Papers → EXTRACTOR → CHECKER → FORMATTER → Output
```

### Detailed Workflow

#### 1. **EXTRACTOR** (`app/extractor.py`)
- **Purpose**: Extract structured data from research papers using LLM
- **Input**: Preprocessed paper text (title, abstract, conclusion)
- **Process**: 
  - Load extraction prompt from `prompts/extraction_prompt.txt`
  - Send formatted prompt to LLM (Gemini/Llama.cpp)
  - Parse JSON response into structured data
- **Output**: Raw extracted data (may contain hallucinations/errors)

#### 2. **CHECKER** (`app/validator_agent.py`)
- **Purpose**: Detect and fix hallucinations, errors, and inconsistencies
- **Input**: Original paper text + raw extracted data
- **Process**:
  - Load validation prompt from `prompts/validation_prompt.txt`
  - Check extracted data against original paper content
  - Identify issues (hallucinations, missing data, errors)
  - **Full mode**: Apply corrections using `prompts/correction_prompt.txt`
  - **Validate-only mode**: Report issues but keep original data
- **Output**: Verified and corrected data (full mode) or original data with validation report (validate-only mode)
- **Note**: Can be skipped with `--fast` flag, or run in validate-only mode with `--validate-only` flag

#### 3. **FORMATTER** (`app/validator.py`)
- **Purpose**: Clean, standardize, and format the final data
- **Input**: Checked/corrected data
- **Process**:
  - Standardize property types and units
  - Remove duplicates
  - Validate numeric values
  - Apply consistent formatting
- **Output**: Clean, standardized data ready for database

### Command Line Options

#### Fast Mode (Skip Checker)
```bash
# Only Extractor + Formatter (fastest)
python main.py --fast --papers 1 --skip-db
```

#### Full Pipeline
```bash
# Extractor + Checker + Formatter (most accurate)
python main.py --papers 5
```

#### Demo Options
```bash
# Fastest test (skip validation)
python main.py --papers 1 --fast --skip-db

# Quality check only (no corrections)
python main.py --papers 5 --validate-only --skip-db

# Full accuracy (with corrections)
python main.py --demo

# Custom count with validation only
python main.py --papers 3 --validate-only
```

### Validation Modes

The CHECKER step has three modes:

1. **Skipped** (`--fast`): No validation, fastest processing
2. **Validate-only** (`--validate-only`): Identifies issues but doesn't correct them
   - Useful for quality assessment
   - Faster than full correction
   - Provides detailed issue reports
3. **Full validation** (default): Identifies and corrects issues
   - Most accurate results
   - Slower processing
   - Automatically fixes detected problems

### Key Benefits

1. **Clear Separation**: Each step has a single responsibility
2. **Modular**: Can skip steps for speed vs accuracy trade-offs
3. **Configurable**: Different modes for different use cases
4. **Maintainable**: Easy to modify or replace individual components
5. **Transparent**: Clear logging of what each step accomplishes

### Performance Modes

| Mode | Speed | Accuracy | Use Case | Command |
|------|-------|----------|----------|---------|
| `--fast --skip-db` | ⚡⚡⚡ Fastest | ✅ Good | Quick testing | `python main.py --papers 1 --fast --skip-db` |
| `--validate-only --skip-db` | ⚡⚡ Fast | 🔍 Analysis | Quality assessment | `python main.py --papers 5 --validate-only --skip-db` |
| `--fast` | ⚡⚡ Fast | ✅ Good | Bulk processing | `python main.py --papers 10 --fast` |
| Default | ⚡ Slower | ✅✅ Best | Research/Production | `python main.py --papers 5` |

### File Structure
```
LiteratureMiningLLM/
├── prompts/
│   ├── extraction_prompt.txt    # EXTRACTOR prompts
│   ├── validation_prompt.txt    # CHECKER prompts  
│   └── correction_prompt.txt    # CHECKER prompts
├── app/
│   ├── extractor.py            # EXTRACTOR implementation
│   ├── validator_agent.py      # CHECKER implementation
│   ├── validator.py            # FORMATTER implementation
│   └── ...
└── main.py                     # Orchestrates the 3-step pipeline
```

This new workflow makes it easy to understand what each step does and allows for flexible configuration based on your speed vs accuracy requirements.
