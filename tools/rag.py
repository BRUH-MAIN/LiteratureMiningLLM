from langchain_pinecone import PineconeVectorStore
from langchain_core.documents import Document
from langchain_core.retrievers import BaseRetriever
from langchain_core.callbacks import CallbackManagerForRetrieverRun
from langchain_core.runnables import RunnableLambda
from typing import List, Dict, Any, Optional
from pinecone_manager import initialize_pinecone
from embeddings import initialize_embeddings
from config import RETRIEVER_TOP_K
import json


class HybridPineconeRetriever(BaseRetriever):
    """Custom retriever that performs hybrid search using PineconeVectorStore with both semantic and keyword search"""
    
    def __init__(self, vector_store: PineconeVectorStore, bm25_encoder, top_k: int = RETRIEVER_TOP_K, alpha: float = 0.5):
        super().__init__()
        self.vector_store = vector_store
        self.bm25_encoder = bm25_encoder
        self.top_k = top_k
        self.alpha = alpha  # Balance between dense (semantic) and sparse (keyword) search
        
    def _get_relevant_documents(
        self, query: str, *, run_manager: CallbackManagerForRetrieverRun
    ) -> List[Document]:
        """Perform hybrid search combining semantic and keyword search"""
        try:
            # Generate dense embeddings for semantic search
            dense_vector = self.vector_store.embeddings.embed_query(query)
            
            # Generate sparse embeddings for keyword search
            sparse_vector = self.bm25_encoder.encode_queries([query])[0]
            
            # Perform hybrid search in Pinecone
            results = self.vector_store._index.query(
                vector=dense_vector,
                sparse_vector=sparse_vector,
                top_k=self.top_k,
                include_metadata=True,
                alpha=self.alpha  # Hybrid search parameter
            )
            
            # Convert results to Document objects
            documents = []
            for match in results.matches:
                metadata = match.metadata or {}
                doc = Document(
                    page_content=metadata.get('text', ''),
                    metadata={
                        'score': match.score,
                        'source': metadata.get('source', 'Unknown'),
                        'page': metadata.get('page', 0),
                        'id': match.id
                    }
                )
                documents.append(doc)
                
            return documents
            
        except Exception as e:
            print(f"Error in hybrid search: {e}")
            return []


class RAGTool:
    """RAG tool that combines hybrid search with context-aware information retrieval"""
    
    def __init__(self):
        self.pc = None
        self.index = None
        self.embeddings = None
        self.bm25_encoder = None
        self.vector_store = None
        self.retriever = None
        
    def initialize(self) -> bool:
        """Initialize Pinecone, embeddings, and vector store"""
        try:
            print("🔧 Initializing RAG tool...")
            
            # Initialize Pinecone
            self.pc, self.index = initialize_pinecone()
            
            # Initialize embeddings
            self.embeddings, self.bm25_encoder = initialize_embeddings()
            
            # Create PineconeVectorStore
            self.vector_store = PineconeVectorStore(
                index=self.index,
                embedding=self.embeddings,
                text_key="text"
            )
            
            # Create hybrid retriever
            self.retriever = HybridPineconeRetriever(
                vector_store=self.vector_store,
                bm25_encoder=self.bm25_encoder,
                top_k=RETRIEVER_TOP_K,
                alpha=0.5  # 50% semantic, 50% keyword search
            )
            
            print("✅ RAG tool initialized successfully")
            return True
            
        except Exception as e:
            print(f"❌ Failed to initialize RAG tool: {e}")
            return False
    
    def add_documents(self, documents: List[Document]) -> bool:
        """Add documents to the vector store with hybrid indexing"""
        try:
            if not self.vector_store:
                raise ValueError("RAG tool not initialized")
                
            print(f"📚 Adding {len(documents)} documents to vector store...")
            
            # Prepare documents for upserting with hybrid embeddings
            texts = [doc.page_content for doc in documents]
            metadatas = [doc.metadata for doc in documents]
            
            # Generate sparse embeddings for BM25
            sparse_embeds = self.bm25_encoder.encode_documents(texts)
            
            # Add sparse embeddings to metadata
            for i, metadata in enumerate(metadatas):
                metadata['sparse_values'] = sparse_embeds[i]
            
            # Add documents to vector store
            self.vector_store.add_texts(
                texts=texts,
                metadatas=metadatas
            )
            
            print("✅ Documents added successfully")
            return True
            
        except Exception as e:
            print(f"❌ Failed to add documents: {e}")
            return False
    
    def search(self, query: str, query_type: str = "hybrid", top_k: int = None) -> List[Document]:
        """
        Search for relevant documents using different search strategies
        
        Args:
            query: Search query
            query_type: "hybrid", "semantic", or "keyword"
            top_k: Number of results to return
        """
        try:
            if not self.retriever:
                raise ValueError("RAG tool not initialized")
                
            if top_k:
                self.retriever.top_k = top_k
                
            if query_type == "hybrid":
                # Use hybrid search (default)
                results = self.retriever.get_relevant_documents(query)
                
            elif query_type == "semantic":
                # Pure semantic search
                self.retriever.alpha = 1.0  # 100% dense search
                results = self.retriever.get_relevant_documents(query)
                self.retriever.alpha = 0.5  # Reset to default
                
            elif query_type == "keyword":
                # Pure keyword search
                self.retriever.alpha = 0.0  # 100% sparse search
                results = self.retriever.get_relevant_documents(query)
                self.retriever.alpha = 0.5  # Reset to default
                
            else:
                raise ValueError(f"Invalid query_type: {query_type}")
                
            print(f"🔍 Found {len(results)} relevant documents for query: '{query[:50]}...'")
            return results
            
        except Exception as e:
            print(f"❌ Search failed: {e}")
            return []
    
    def get_context_for_extraction(self, abstract_text: str, query_terms: List[str] = None) -> str:
        """
        Get relevant context for schema extraction from the abstract
        
        Args:
            abstract_text: The abstract text to analyze
            query_terms: Specific terms to search for (e.g., ["CO2", "adsorption", "capacity"])
        """
        try:
            if not query_terms:
                # Default query terms for CO2 adsorption properties
                query_terms = [
                    "CO2 adsorption capacity",
                    "surface area",
                    "pore volume",
                    "temperature",
                    "pressure",
                    "selectivity",
                    "kinetics",
                    "isotherm",
                    "material properties",
                    "synthesis conditions"
                ]
            
            # Search for each query term and collect relevant context
            all_context = []
            for term in query_terms:
                # Combine abstract text with search term for better context
                search_query = f"{term} {abstract_text[:200]}..."  # Use first 200 chars of abstract
                
                results = self.search(search_query, query_type="hybrid", top_k=3)
                for doc in results:
                    if doc.page_content not in all_context:
                        all_context.append(doc.page_content)
            
            # Combine all context
            context = "\n\n".join(all_context[:5])  # Limit to top 5 context pieces
            
            return context
            
        except Exception as e:
            print(f"❌ Failed to get context: {e}")
            return ""
    
    def get_runnable_search(self):
        """Return a runnable for searching"""
        def search_wrapper(inputs: Dict[str, Any]) -> Dict[str, Any]:
            query = inputs.get('query', '')
            query_type = inputs.get('query_type', 'hybrid')
            top_k = inputs.get('top_k', RETRIEVER_TOP_K)
            
            results = self.search(query, query_type, top_k)
            
            return {
                **inputs,
                'search_results': results,
                'context': "\n\n".join([doc.page_content for doc in results])
            }
        
        return RunnableLambda(search_wrapper)
    
    def get_runnable_context_extraction(self):
        """Return a runnable for context extraction"""
        def context_wrapper(inputs: Dict[str, Any]) -> Dict[str, Any]:
            abstract_text = inputs.get('abstract_text', '')
            query_terms = inputs.get('query_terms', None)
            
            context = self.get_context_for_extraction(abstract_text, query_terms)
            
            return {
                **inputs,
                'extraction_context': context
            }
        
        return RunnableLambda(context_wrapper)
