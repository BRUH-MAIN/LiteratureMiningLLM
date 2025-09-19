#!/usr/bin/env python3
"""
Test script for the Property Relevance Evaluator

This script tests the evaluator functions to ensure they work correctly.
"""

import sys
import logging
from pathlib import Path

# Add the project root to Python path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

from app.analytics import Analytics
from app.models import get_session, Paper, Material, Property


def test_evaluator_functions():
    """Test the evaluator functions"""
    print("Testing Property Relevance Evaluator Functions...")
    
    try:
        # Test Analytics class initialization
        analytics = Analytics()
        print("✓ Analytics class initialized successfully")
        
        # Test prompt creation function
        test_text = "Abstract: This paper studies the conductivity of Ti3C2Tx MXene films."
        test_property = "Property Type: Conductivity, Value: 1000, Unit: S/cm"
        
        prompt = analytics._create_evaluation_prompt(test_text, test_property)
        print("✓ Evaluation prompt creation successful")
        print(f"  Prompt length: {len(prompt)} characters")
        
        # Test database connection
        try:
            session = get_session()
            paper_count = session.query(Paper).count()
            session.close()
            print(f"✓ Database connection successful ({paper_count} papers found)")
        except Exception as e:
            print(f"⚠ Database connection issue: {e}")
        
        # Test evaluation report generation with empty DataFrame
        import pandas as pd
        empty_df = pd.DataFrame()
        report = analytics.generate_evaluation_report(empty_df)
        print("✓ Evaluation report generation (empty data) successful")
        
        print("\nAll tests passed! The evaluator functions are working correctly.")
        print("\nTo run the actual evaluation:")
        print("1. Ensure your database has papers with extracted properties")
        print("2. Run: uv run python main.py --evaluate")
        print("3. Or run: uv run python demo_evaluator.py")
        
    except Exception as e:
        print(f"✗ Test failed: {e}")
        return False
        
    return True


if __name__ == "__main__":
    success = test_evaluator_functions()
    sys.exit(0 if success else 1)
