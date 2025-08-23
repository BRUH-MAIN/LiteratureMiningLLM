#!/usr/bin/env python3
"""
Literature Mining LLM - Main Application
A RAG-based system for mining literature using LangChain, Pinecone, and LLMs
"""

from document_processor import load_and_split_documents
from pinecone_manager import initialize_pinecone, delete_pinecone_index
from embeddings import initialize_embeddings
from vector_store import upsert_documents_to_pinecone
from retrieval import initialize_retriever, initialize_llm, initialize_reranker
from rag_chain import create_rag_chain, run_rag_agent


def main():
    """Main function to run the literature mining system"""
    try:
        # 1. Load and process documents
        docs = load_and_split_documents()
        
        # 2. Initialize Pinecone
        pc, index = initialize_pinecone()
        
        # 3. Initialize embeddings
        embeddings, bm25_encoder = initialize_embeddings()
        
        # 4. Check index stats
        print("Num doc chunks:", len(docs))
        print("Index stats:", index.describe_index_stats())
        
        # 5. Upsert documents to Pinecone
        upsert_documents_to_pinecone(docs, embeddings, bm25_encoder, index)
        
        # 6. Initialize retriever
        retriever = initialize_retriever(embeddings, bm25_encoder, index)
        
        # 7. Initialize LLM
        llm = initialize_llm()
        
        # 8. Initialize reranker
        reranker = initialize_reranker()
        
        # 9. Create RAG chain
        qa_chain = create_rag_chain(llm, retriever)
        
        # 10. Run the RAG agent
        run_rag_agent(qa_chain, reranker)
        
    except KeyboardInterrupt:
        print("\nExiting...")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        # Optional: Clean up by deleting the index
        delete_pinecone_index()
        pass


if __name__ == "__main__":
    main()
