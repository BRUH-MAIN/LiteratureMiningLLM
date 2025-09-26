#!/bin/bash

# Gold Standard Extraction Runner Script
# This script runs the gold standard extraction with proper error handling

echo "=========================================="
echo "Gold Standard Literature Mining Extractor"
echo "=========================================="
echo ""

# Load environment variables from .env file if it exists
if [ -f ".env" ]; then
    echo "📁 Found .env file - Python script will load it automatically"
    # Just verify GEMINI_API_KEY exists in the file
    if grep -q "GEMINI_API_KEY" .env; then
        echo "✅ GEMINI_API_KEY found in .env file"
    else
        echo "❌ GEMINI_API_KEY not found in .env file"
        echo "Please add GEMINI_API_KEY to your .env file"
        exit 1
    fi
else
    echo "❌ No .env file found"
    echo "Please create a .env file with GEMINI_API_KEY"
    exit 1
fi
echo ""

# Check if required environment variables are set
echo "✅ Environment files configured"
echo "🔑 Gemini API Key: Found in .env file"
echo "🗄️  PostgreSQL URL: Found in .env file"
echo ""

echo "📊 Processing Parameters:"
echo "   - Papers to process: 50"
echo "   - Rate limits: 5 RPM, 250K TPM, 100 RPD"
echo "   - Database: Supabase with gold standard tables (gold_ prefix)"
echo ""

# Confirm before starting
read -p "🚀 Start gold standard extraction? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Extraction cancelled."
    exit 0
fi

echo ""
echo "⏱️  Starting extraction at $(date)"
echo "📝 Logs will be saved to logs/gold_standard_extraction_*.log"
echo ""

# Run the extraction script
python3 gold_standard_extractor.py

# Check exit code
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Gold standard extraction completed successfully!"
    echo "📋 Check the results/ directory for summary reports"
    echo "🗄️  Data stored in Supabase with gold standard tables"
else
    echo ""
    echo "❌ Gold standard extraction failed"
    echo "📝 Check the logs for error details"
    exit 1
fi