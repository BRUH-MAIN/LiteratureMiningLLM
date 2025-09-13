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
echo "5. ⚖️  LOAD BALANCED (5 papers, multi-model load balancing)"
echo "6. 🎛️  CUSTOM (specify papers and mode)"
echo "7. 🏭 FULL PROCESSING (all papers, full pipeline)"
echo "8. ❌ EXIT"
echo

read -p "Enter your choice (1-8): " choice

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
        echo "⚖️  Running LOAD BALANCED mode: 5 papers (automatic load balancing)..."
        python main.py --demo --load-balanced --skip-db
        ;;
    6)
        read -p "Enter number of papers to process: " count
        echo "Choose mode:"
        echo "1. Fast (Extractor→Formatter)"
        echo "2. Validate-only (check issues, no corrections)"
        echo "3. Accurate (Extractor→Checker→Formatter)"
        echo "4. Load balanced (multi-model)"
        read -p "Enter mode (1-4): " mode_choice
        if [ "$mode_choice" = "1" ]; then
            echo "🎛️  Running CUSTOM FAST: $count papers (Extractor→Formatter)..."
            python main.py --papers $count --fast --skip-db
        elif [ "$mode_choice" = "2" ]; then
            echo "🎛️  Running CUSTOM VALIDATE-ONLY: $count papers..."
            python main.py --papers $count --validate-only --skip-db
        elif [ "$mode_choice" = "3" ]; then
            echo "🎛️  Running CUSTOM ACCURATE: $count papers (Extractor→Checker→Formatter)..."
            python main.py --papers $count
        else
            echo "🎛️  Running CUSTOM LOAD BALANCED: $count papers..."
            python main.py --papers $count --load-balanced --skip-db
        fi
        ;;
    7)
        echo "🏭 Running FULL PROCESSING: all papers (Extractor→Checker→Formatter)..."
        python main.py
        ;;
    8)
        echo "❌ Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please select 1-8."
        exit 1
        ;;
esac

echo
echo "Run completed!"