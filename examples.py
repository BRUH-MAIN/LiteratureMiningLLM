"""
Example script demonstrating individual component usage
"""

import sys
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

from app.preprocessor import Preprocessor
from app.extractor import Extractor
from app.validator import Validator
from app.analytics import Analytics

def example_preprocessing():
    """Example: Using the preprocessing agent"""
    print("=== Preprocessing Example ===")
    
    preprocessor = Preprocessor()
    
    # Load and preprocess sample data
    input_file = "data/processed/combined_papers_merged.json"
    papers = preprocessor.load_json_data(input_file)
    
    print(f"Loaded {len(papers)} papers")
    
    # Process first paper only for demo
    sample_papers = preprocessor.preprocess_papers([papers[0]])
    
    print("Sample processed paper:")
    print(f"Title: {sample_papers[0]['title'][:60]}...")
    print(f"Abstract length: {len(sample_papers[0]['abstract'])} chars")
    print(f"Keywords: {sample_papers[0]['keywords']}")

def example_extraction():
    """Example: Using the extraction agent"""
    print("\n=== Extraction Example ===")
    
    extractor = Extractor()
    
    # Sample paper data
    sample_paper = {
        'title': 'MXene-based conductivity study',
        'abstract': 'Ti3C2Tx MXene shows excellent electrical conductivity of 500 S/m.',
        'conclusion': 'The MXene demonstrated high conductivity for sensor applications.'
    }
    
    # Extract data
    result = extractor.extract_data_from_text(
        sample_paper['title'],
        sample_paper['abstract'], 
        sample_paper['conclusion']
    )
    
    if result:
        print("Extracted data:")
        print(f"Materials: {result.get('materials', [])}")
        print(f"Properties: {result.get('properties', [])}")
        print(f"Applications: {result.get('applications', [])}")
    else:
        print("No data extracted")

def example_validation():
    """Example: Using the validation agent"""
    print("\n=== Validation Example ===")
    
    validator = Validator()
    
    # Sample extracted data
    sample_data = {
        'materials': [{'mxene_composition': 'Ti3C2Tx', 'composite_material': 'polymer'}],
        'properties': [{'property_type': 'conductivity', 'value': '500.5', 'unit': 's/m'}],
        'applications': [{'application_type': 'sensors', 'metric': 'sensitivity', 'value': 10}]
    }
    
    # Validate data
    validated = validator.validate_extracted_data(sample_data)
    
    print("Validated data:")
    print(f"Properties: {validated['properties']}")
    print(f"Materials: {validated['materials']}")

def example_analytics():
    """Example: Using the analytics agent"""
    print("\n=== Analytics Example ===")
    
    analytics = Analytics()
    
    # Get database statistics
    try:
        conductivity_data = analytics.get_conductivity_data()
        print(f"Found {len(conductivity_data)} conductivity records")
        
        if not conductivity_data.empty:
            print("Sample conductivity data:")
            print(conductivity_data.head())
        
        # Generate summary
        summary = analytics.generate_summary_report()
        print("\nDatabase Summary (first 300 chars):")
        print(summary[:300] + "...")
        
    except Exception as e:
        print(f"Analytics error (database may be empty): {e}")

def main():
    """Run all examples"""
    print("Literature Mining LLM - Component Examples")
    print("=" * 50)
    
    try:
        example_preprocessing()
        example_extraction()
        example_validation()
        example_analytics()
        
        print("\n" + "=" * 50)
        print("All examples completed successfully!")
        
    except Exception as e:
        print(f"Error running examples: {e}")

if __name__ == "__main__":
    main()
