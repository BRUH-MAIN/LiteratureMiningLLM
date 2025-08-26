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
        """Retrieve next abstract chunk for processing"""
        chunks = state.get('chunks', [])
        current_idx = state.get('current_chunk_index', 0)
        
        if current_idx >= len(chunks):
            print("🏁 All chunks processed")
            return {**state, 'processing_complete': True, 'current_chunk': None}
        
        current_chunk = chunks[current_idx]
        print(f"📝 Processing chunk {current_idx + 1}/{len(chunks)}: {current_chunk.metadata['abstract_id']}")
        
        return {
            **state, 
            'current_chunk': current_chunk,
            'current_chunk_index': current_idx + 1,
            'processing_complete': False
        }
    
    def get_runnable_init(self):
        return RunnableLambda(self.initialize_vector_store)
    
    def get_runnable_next(self):
        return RunnableLambda(self.get_next_chunk)
