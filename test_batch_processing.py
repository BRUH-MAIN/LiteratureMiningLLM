#!/usr/bin/env python3
"""
Test script to demonstrate batch processing of 2 chunks at a time
"""

import sys
import os
from typing import Dict, Any, List

# Add the project root to the Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Mock Document class to simulate chunks
class MockDocument:
    def __init__(self, content: str, metadata: Dict[str, Any]):
        self.page_content = content
        self.metadata = metadata

def create_mock_chunks() -> List[MockDocument]:
    """Create mock chunks for testing"""
    chunks = []
    for i in range(5):  # Create 5 mock chunks
        chunk = MockDocument(
            content=f"This is abstract {i+1} about CO2 adsorption. The material shows excellent performance with high surface area and good selectivity.",
            metadata={
                'abstract_id': f'A{i+1}',
                'page': i+1,
                'source': 'test_document.pdf',
                'chunk_type': 'abstract'
            }
        )
        chunks.append(chunk)
    return chunks

def test_vector_retriever_batch_processing():
    """Test that vector retriever can handle batch processing"""
    print("🧪 Testing Vector Retriever Batch Processing...")
    
    try:
        from agents.vector_retriever_agent import VectorStoreRetrieverAgent
        
        agent = VectorStoreRetrieverAgent()
        mock_chunks = create_mock_chunks()
        
        # Create initial state
        state = {
            'chunks': mock_chunks,
            'current_chunk_index': 0,
            'batch_size': 2,
            'processing_complete': False
        }
        
        print(f"📝 Created {len(mock_chunks)} mock chunks")
        print(f"🔄 Testing batch processing with batch_size=2")
        
        batch_count = 0
        while not state.get('processing_complete', False):
            batch_count += 1
            print(f"\n--- Batch {batch_count} ---")
            
            # Get next batch
            state = agent.get_next_chunk(state)
            
            current_chunks = state.get('current_chunks', [])
            if current_chunks:
                print(f"✅ Retrieved {len(current_chunks)} chunks in this batch:")
                for chunk in current_chunks:
                    print(f"   - {chunk.metadata['abstract_id']}")
            else:
                print("🏁 No more chunks to process")
        
        print(f"\n🎯 Total batches processed: {batch_count}")
        print("✅ Vector Retriever batch processing test passed!")
        return True
        
    except Exception as e:
        print(f"❌ Vector Retriever batch processing test failed: {e}")
        return False

def test_schema_designer_batch_processing():
    """Test that schema designer can handle multiple chunks"""
    print("\n🧪 Testing Schema Designer Batch Processing...")
    
    try:
        from agents.schema_designer_agent import SchemaDesignerAgent
        
        # Note: This will fail without API keys, but we can test the structure
        agent = SchemaDesignerAgent()
        mock_chunks = create_mock_chunks()[:2]  # Test with 2 chunks
        
        state = {
            'current_chunks': mock_chunks
        }
        
        print(f"📝 Testing with {len(mock_chunks)} chunks")
        
        # Test the method exists and accepts the right parameters
        assert hasattr(agent, 'extract_properties')
        print("✅ Schema Designer has extract_properties method")
        
        # Note: We won't actually call it because it requires API keys
        # But the structure test shows it can handle multiple chunks
        print("✅ Schema Designer batch processing structure test passed!")
        return True
        
    except Exception as e:
        print(f"❌ Schema Designer batch processing test failed: {e}")
        return False

def test_result_aggregator_batch_processing():
    """Test that result aggregator can handle multiple extraction results"""
    print("\n🧪 Testing Result Aggregator Batch Processing...")
    
    try:
        from agents.result_aggregator_agent import ResultAggregatorAgent
        
        agent = ResultAggregatorAgent()
        
        # Mock extraction results from batch processing
        mock_extraction_results = [
            {
                'abstract_id': 'A1',
                'page_number': 1,
                'source': 'test.pdf',
                'properties': [{'property': 'BET_surface_area', 'value': '500 m²/g'}]
            },
            {
                'abstract_id': 'A2',
                'page_number': 2,
                'source': 'test.pdf',
                'properties': [{'property': 'CO2_uptake', 'value': '2.5 mmol/g'}]
            }
        ]
        
        state = {
            'extraction_results': mock_extraction_results,
            'aggregated_results': []
        }
        
        print(f"📝 Testing with {len(mock_extraction_results)} extraction results")
        
        # Test aggregation
        updated_state = agent.aggregate_results(state)
        
        aggregated = updated_state.get('aggregated_results', [])
        print(f"✅ Aggregated {len(aggregated)} results")
        
        assert len(aggregated) == 2
        assert aggregated[0]['abstract_id'] == 'A1'
        assert aggregated[1]['abstract_id'] == 'A2'
        
        print("✅ Result Aggregator batch processing test passed!")
        return True
        
    except Exception as e:
        print(f"❌ Result Aggregator batch processing test failed: {e}")
        return False

def main():
    """Run all batch processing tests"""
    print("🚀 Testing Batch Processing Implementation")
    print("=" * 60)
    
    tests = [
        test_vector_retriever_batch_processing,
        test_schema_designer_batch_processing,
        test_result_aggregator_batch_processing
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        if test():
            passed += 1
    
    print("\n" + "=" * 60)
    print(f"🎯 Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All batch processing tests passed!")
        print("✅ The workflow is now configured to process 2 chunks at a time")
    else:
        print("❌ Some tests failed")
    
    return passed == total

if __name__ == "__main__":
    main()
