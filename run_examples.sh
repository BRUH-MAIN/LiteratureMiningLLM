#!/bin/bash

# Literature Mining LLM - Example Run Scripts

echo "Literature Mining LLM - Three-Step Pipeline"
echo "============================================"
echo "Workflow: EXTRACTOR → CHECKER → FORMATTER"
echo
echo "Choose an option:"
echo "1. 🚀 FASTEST (1 paper, Extractor+Formatter only)"
echo "2. ⚡ QUICK (5 papers, Extractor+Formatter only)"  
echo "3. 🔍 VALIDATE-ONLY (5 papers, check issues but don't fix)"
echo "4. 🎯 ACCURATE (5 papers, full pipeline with corrections)"
echo "5. 🎛️  CUSTOM (specify papers and mode)"
echo "6. 🏭 FULL PROCESSING (all papers, full pipeline)"
echo "7. ❌ EXIT"
echo

read -p "Enter your choice (1-7): " choice

case $choice in
    1)
        echo "🚀 Running FASTEST mode: 1 paper (Extractor→Formatter only)..."
        python main.py --papers 1 --fast --skip-db
        ;;
    2)
        echo "⚡ Running QUICK mode: 5 papers (Extractor→Formatter only)..."
        python main.py --demo --fast --skip-db
        ;;
    3)
        echo "🔍 Running VALIDATE-ONLY mode: 5 papers (check issues, no corrections)..."
        python main.py --demo --validate-only --skip-db
        ;;
    4)
        echo "🎯 Running ACCURATE mode: 5 papers (Extractor→Checker→Formatter)..."
        python main.py --demo
        ;;
    5)
        read -p "Enter number of papers to process: " count
        echo "Choose mode:"
        echo "1. Fast (Extractor→Formatter)"
        echo "2. Validate-only (check issues, no corrections)"
        echo "3. Accurate (Extractor→Checker→Formatter)"
        read -p "Enter mode (1-3): " mode_choice
        if [ "$mode_choice" = "1" ]; then
            echo "🎛️  Running CUSTOM FAST: $count papers (Extractor→Formatter)..."
            python main.py --papers $count --fast --skip-db
        elif [ "$mode_choice" = "2" ]; then
            echo "🎛️  Running CUSTOM VALIDATE-ONLY: $count papers..."
            python main.py --papers $count --validate-only --skip-db
        else
            echo "🎛️  Running CUSTOM ACCURATE: $count papers (Extractor→Checker→Formatter)..."
            python main.py --papers $count
        fi
        ;;
    6)
        echo "🏭 Running FULL PROCESSING: all papers (Extractor→Checker→Formatter)..."
        python main.py
        ;;
    7)
        echo "❌ Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please select 1-7."
        exit 1
        ;;
esac

echo
echo "Run completed!"