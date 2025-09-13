# Speed Optimization Guide

## Problem: Slow Processing
The original pipeline with validation takes a long time because it makes 2 LLM calls per paper:
1. Extraction call (~10-30 seconds)
2. Validation call (~10-30 seconds) 
3. Plus database operations

## Fast Demo Options

### 🚀 Ultra Fast (1 paper, 5-15 seconds)
```bash
python main.py --papers 1 --fast --skip-db
```

### ⚡ Quick Demo (5 papers, ~30-60 seconds)
```bash
python main.py --demo --fast --skip-db
```

### 🔍 Demo with Validation (5 papers, ~5-10 minutes)
```bash
python main.py --demo
```

## Command Line Options

| Option | Description | Speed Impact |
|--------|-------------|--------------|
| `--papers N` | Process only N papers | ⭐⭐⭐ |
| `--fast` | Skip LLM validation | ⭐⭐⭐ |
| `--skip-db` | Skip database operations | ⭐⭐ |
| `--demo` | Process only 5 papers | ⭐⭐⭐ |

## Examples

```bash
# Test with 1 paper quickly
./fast_demo.sh

# Interactive menu
./run_examples.sh

# Manual commands
python main.py --papers 1 --fast --skip-db              # 1 paper, fastest
python main.py --papers 3 --fast --skip-db              # 3 papers, fast  
python main.py --demo --fast --skip-db                  # 5 papers, fast
python main.py --demo                                   # 5 papers, with validation
python main.py --papers 10                              # 10 papers, full pipeline
```

## What Each Mode Does

### Fast Mode (`--fast`)
- ❌ Skips LLM-based hallucination detection
- ❌ Skips validation and correction
- ✅ Only does extraction
- ✅ Still does data cleaning and standardization
- **Speed: ~50% faster**

### Skip DB Mode (`--skip-db`)  
- ❌ Skips PostgreSQL database insertion
- ❌ Skips analytics generation
- ✅ Shows extraction results in logs
- **Speed: ~20% faster**

### Papers Limit (`--papers N`)
- Processes only first N papers from dataset
- **Speed: Linear with number of papers**

## Performance Comparison

| Mode | Papers | Time | LLM Calls | Features |
|------|---------|------|-----------|----------|
| Ultra Fast | 1 | ~10s | 1 | Extraction only |
| Quick Demo | 5 | ~30s | 5 | Extraction only |
| Demo + Validation | 5 | ~5min | 10 | Full pipeline |
| Full Processing | 500+ | Hours | 1000+ | Production |

## Tips for Development

1. **Use `--papers 1 --fast --skip-db` for quick testing**
2. **Use `--demo --fast --skip-db` for feature development**  
3. **Use `--demo` when testing validation features**
4. **Use full mode only for production runs**
