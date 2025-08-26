from langchain_core.runnables import RunnableLambda
from typing import Dict, Any
from tools.rag import RAGTool


class EnhancedVectorRetrieverAgent:
    """Enhanced vector retriever that uses RAG tool with PineconeVectorStore"""
    
    def __init__(self):
        self.rag_tool = RAGTool()
        self.current_chunk_index = 0
        self.vector_store_ready = False
    
    def initialize_vector_store(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Initialize RAG tool and add documents to vector store"""
        print("🔍 Initializing enhanced vector store with RAG tool...")
        
        # Initialize RAG tool
        success = self.rag_tool.initialize()
        if not success:
            raise Exception("Failed to initialize RAG tool")
        
        # Add chunks to vector store
        chunks = state.get('chunks', [])
        if chunks:
            success = self.rag_tool.add_documents(chunks)
            if not success:
                raise Exception("Failed to add documents to vector store")
        
        self.vector_store_ready = True
        print(f"✅ Enhanced vector store initialized with {len(chunks)} chunks")
        
        return {
            **state, 
            'vector_store_ready': True, 
            'current_chunk_index': 0,
            'rag_tool_ready': True
        }
    
    def get_next_chunk(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Retrieve next abstract chunk for processing"""
        chunks = state.get('chunks', [])
        current_idx = state.get('current_chunk_index', 0)
        
        if current_idx >= len(chunks):
            print("🏁 All chunks processed")
            return {
                **state, 
                'processing_complete': True, 
                'current_chunk': None
            }
        
        current_chunk = chunks[current_idx]
        print(f"📝 Processing chunk {current_idx + 1}/{len(chunks)}: {current_chunk.metadata['abstract_id']}")
        
        return {
            **state, 
            'current_chunk': current_chunk,
            'current_chunk_index': current_idx + 1,
            'processing_complete': False
        }
    
    def search_similar_documents(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Search for similar documents using hybrid search"""
        current_chunk = state.get('current_chunk')
        
        if not current_chunk or not self.vector_store_ready:
            return {**state, 'similar_documents': []}
        
        try:
            # Search for similar documents using the current chunk content
            query = current_chunk.page_content[:500]  # Use first 500 chars as query
            
            # Perform hybrid search
            similar_docs = self.rag_tool.search(
                query=query,
                query_type="hybrid",
                top_k=5
            )
            
            # Filter out the current document itself
            abstract_id = current_chunk.metadata['abstract_id']
            filtered_docs = [
                doc for doc in similar_docs 
                if doc.metadata.get('abstract_id') != abstract_id
            ]
            
            print(f"🔍 Found {len(filtered_docs)} similar documents")
            
            return {
                **state,
                'similar_documents': filtered_docs,
                'similarity_context': "\n\n".join([doc.page_content for doc in filtered_docs[:3]])
            }
            
        except Exception as e:
            print(f"❌ Error searching similar documents: {e}")
            return {**state, 'similar_documents': [], 'similarity_context': ""}
    
    def get_runnable_init(self):
        """Get runnable for vector store initialization"""
        return RunnableLambda(self.initialize_vector_store)
    
    def get_runnable_next(self):
        """Get runnable for getting next chunk"""
        return RunnableLambda(self.get_next_chunk)
    
    def get_runnable_search(self):
        """Get runnable for searching similar documents"""
        return RunnableLambda(self.search_similar_documents)
