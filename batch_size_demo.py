#!/usr/bin/env python3
"""
Demonstration script showing how to configure different batch sizes
"""

import sys
import os

# Add the project root to the Python path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

def test_different_batch_sizes():
    """Test the workflow with different batch sizes"""
    print("🧪 Testing Different Batch Sizes")
    print("=" * 60)
    
    # Mock Document class
    class MockDocument:
        def __init__(self, content: str, metadata: dict):
            self.page_content = content
            self.metadata = metadata
    
    # Create mock chunks
    mock_chunks = []
    for i in range(7):  # 7 chunks to test different batch scenarios
        chunk = MockDocument(
            content=f"Abstract {i+1} content about CO2 adsorption",
            metadata={
                'abstract_id': f'A{i+1}',
                'page': i+1,
                'source': 'test.pdf',
                'chunk_type': 'abstract'
            }
        )
        mock_chunks.append(chunk)
    
    # Test different batch sizes
    for batch_size in [1, 2, 3]:
        print(f"\n🔄 Testing with batch_size = {batch_size}")
        print("-" * 40)
        
        from agents.vector_retriever_agent import VectorStoreRetrieverAgent
        agent = VectorStoreRetrieverAgent()
        
        state = {
            'chunks': mock_chunks,
            'current_chunk_index': 0,
            'batch_size': batch_size,
            'processing_complete': False
        }
        
        batch_count = 0
        total_processed = 0
        
        while not state.get('processing_complete', False):
            batch_count += 1
            state = agent.get_next_chunk(state)
            
            current_chunks = state.get('current_chunks', [])
            if current_chunks:
                total_processed += len(current_chunks)
                chunk_ids = [c.metadata['abstract_id'] for c in current_chunks]
                print(f"  Batch {batch_count}: {len(current_chunks)} chunks ({', '.join(chunk_ids)})")
        
        print(f"  📊 Summary: {batch_count} batches, {total_processed} total chunks processed")

def show_configuration_options():
    """Show how to configure batch size"""
    print("\n📋 Batch Size Configuration Options")
    print("=" * 60)
    
    print("1. 📝 Edit config.py:")
    print("   PROCESSING_BATCH_SIZE = 2  # Change this value")
    print()
    print("2. 🔧 Or modify the initial state in your code:")
    print("   initial_state['batch_size'] = 3  # Your desired batch size")
    print()
    print("3. 🎯 Current configuration:")
    
    try:
        from config import PROCESSING_BATCH_SIZE
        print(f"   PROCESSING_BATCH_SIZE = {PROCESSING_BATCH_SIZE}")
    except:
        print("   Could not load configuration")
    
    print()
    print("💡 Recommended batch sizes:")
    print("   - batch_size = 1: Sequential processing (original behavior)")
    print("   - batch_size = 2: Balanced processing (current default)")
    print("   - batch_size = 3-5: Faster processing for large documents")
    print("   - batch_size > 5: May hit API rate limits")

def main():
    """Run batch size demonstration"""
    test_different_batch_sizes()
    show_configuration_options()
    
    print("\n🎉 Batch Processing Configuration Complete!")
    print("✅ Your workflow now processes 2 chunks at a time by default")
    print("🔧 You can easily change the batch size in config.py")

if __name__ == "__main__":
    main()
