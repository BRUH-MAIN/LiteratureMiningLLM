"""
Test script for the Literature Mining LLM application
"""

import sys
import logging
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

from app.config import Config
from app.models import create_all_tables
from app.preprocessor import Preprocessor
from app.db_loader import DBLoader

def test_configuration():
    """Test configuration and environment setup"""
    print("Testing configuration...")
    try:
        Config.validate()
        print("✓ Configuration valid")
        return True
    except Exception as e:
        print(f"✗ Configuration error: {e}")
        return False

def test_database_connection():
    """Test database connection and table creation"""
    print("Testing database connection...")
    try:
        engine = create_all_tables()
        print("✓ Database connection successful")
        print("✓ Tables created/verified")
        return True
    except Exception as e:
        print(f"✗ Database error: {e}")
        return False

def test_data_loading():
    """Test data loading from JSON file"""
    print("Testing data loading...")
    try:
        preprocessor = Preprocessor()
        input_file = project_root / "data" / "processed" / "combined_papers_merged.json"
        
        print(f"Looking for file at: {input_file}")
        if not input_file.exists():
            print(f"✗ Input file not found: {input_file}")
            return False
        
        papers = preprocessor.load_json_data(str(input_file))
        print(f"✓ Loaded {len(papers)} papers from JSON")
        
        # Test preprocessing on first paper
        if papers:
            sample_paper = preprocessor.preprocess_papers([papers[0]])
            print(f"✓ Preprocessing test successful")
        
        return True
    except Exception as e:
        print(f"✗ Data loading error: {e}")
        return False

def test_database_operations():
    """Test basic database operations"""
    print("Testing database operations...")
    try:
        db_loader = DBLoader()
        stats = db_loader.get_database_stats()
        print(f"✓ Database stats retrieved: {stats}")
        return True
    except Exception as e:
        print(f"✗ Database operations error: {e}")
        return False

def main():
    """Run all tests"""
    print("Literature Mining LLM - System Test")
    print("=" * 40)
    
    tests = [
        test_configuration,
        test_database_connection,
        test_data_loading,
        test_database_operations
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        try:
            if test():
                passed += 1
        except Exception as e:
            print(f"✗ Test failed with exception: {e}")
        print()
    
    print("=" * 40)
    print(f"Tests passed: {passed}/{total}")
    
    if passed == total:
        print("✓ All tests passed! System is ready.")
        return True
    else:
        print("✗ Some tests failed. Please check the errors above.")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
