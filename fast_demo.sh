#!/bin/bash

echo "🚀 FAST Demo Testing"
echo "==================="
echo
echo "This will run the fastest possible demo with just 1 paper:"
echo "- Fast mode (no validation)"
echo "- Skip database"
echo "- Reduced delays"
echo

read -p "Press Enter to start fast demo..."

# Run with timing
echo "Starting..."
start_time=$(date +%s)

python main.py --papers 1 --fast --skip-db

end_time=$(date +%s)
duration=$((end_time - start_time))

echo
echo "✅ Fast demo completed in $duration seconds"
echo
echo "For comparison, the same paper with full validation would take ~30-60 seconds"
echo
echo "Available options:"
echo "  python main.py --papers 1 --fast --skip-db     # Fastest (1 paper)"
echo "  python main.py --demo --fast --skip-db         # Quick (5 papers)"
echo "  python main.py --demo                          # Full validation (5 papers)"
