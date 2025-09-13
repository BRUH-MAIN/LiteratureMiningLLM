# Demo Mode Usage Guide

## Quick Demo Options

### 1. Simple Demo (5 papers)
```bash
python main.py --demo
```

### 2. Custom Demo (specify number of papers)
```bash
python main.py --demo --demo-count 10
```

### 3. Demo with specific LLM provider
```bash
python main.py --demo --llm-provider llamacpp
```

### 4. Using the demo script
```bash
python demo.py
```

### 5. Using the interactive menu
```bash
./run_examples.sh
```

## Command Line Options

- `--demo`: Enable demo mode (default: 5 papers)
- `--demo-count N`: Process N papers in demo mode
- `--llm-provider {gemini,llamacpp}`: Override LLM provider
- `--help`: Show help message

## Examples

```bash
# Demo with 3 papers using Gemini
python main.py --demo --demo-count 3 --llm-provider gemini

# Demo with 10 papers using Llama.cpp
python main.py --demo --demo-count 10 --llm-provider llamacpp

# Full processing with Llama.cpp
python main.py --llm-provider llamacpp
```

## Output

Demo mode will:
- Process only the specified number of papers (default: 5)
- Include full validation and hallucination detection
- Generate the same reports and visualizations
- Save results to the `results/` folder
- Show validation statistics in logs

This is perfect for testing the system or when you want quick results without processing all papers.
