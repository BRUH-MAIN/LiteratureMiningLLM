from agents.vector_store import upsert_documents_to_pinecone
from langchain_core.runnables import RunnableLambda
from typing import Dict, Any
from pinecone_manager import initialize_pinecone
from embeddings import initialize_embeddings



class VectorStoreRetrieverAgent:
    def __init__(self):
        self.pc = None
        self.index = None
        self.embeddings = None
        self.bm25_encoder = None
        self.current_chunk_index = 0
    
    def initialize_vector_store(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Initialize Pinecone and embeddings, upsert chunks"""
        print("🔍 Initializing vector store...")
        
        # Initialize Pinecone
        self.pc, self.index = initialize_pinecone()
        
        # Initialize embeddings
        self.embeddings, self.bm25_encoder = initialize_embeddings()
        
        # Upsert documents to Pinecone
        chunks = state.get('chunks', [])
        if chunks:
            upsert_documents_to_pinecone(chunks, self.embeddings, self.bm25_encoder, self.index)
        
        print(f"✅ Vector store initialized with {len(chunks)} chunks")
        return {**state, 'vector_store_ready': True, 'current_chunk_index': 0}
    
    def get_next_chunk(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Retrieve next batch of abstract chunks for processing"""
        chunks = state.get('chunks', [])
        current_idx = state.get('current_chunk_index', 0)
        batch_size = state.get('batch_size', 2)
        
        if current_idx >= len(chunks):
            print("🏁 All chunks processed")
            return {**state, 'processing_complete': True, 'current_chunks': []}
        
        # Get the next batch of chunks
        end_idx = min(current_idx + batch_size, len(chunks))
        current_chunks = chunks[current_idx:end_idx]
        
        chunk_ids = [chunk.metadata['abstract_id'] for chunk in current_chunks]
        print(f"📝 Processing batch {current_idx//batch_size + 1}: chunks {current_idx + 1}-{end_idx}/{len(chunks)} ({', '.join(chunk_ids)})")
        
        return {
            **state, 
            'current_chunks': current_chunks,
            'current_chunk_index': end_idx,
            'processing_complete': False
        }
    
    def get_runnable_init(self):
        return RunnableLambda(self.initialize_vector_store)
    
    def get_runnable_next(self):
        return RunnableLambda(self.get_next_chunk)
