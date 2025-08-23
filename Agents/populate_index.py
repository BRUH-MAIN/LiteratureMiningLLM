#!/usr/bin/env python3
"""
Script to populate the Pinecone index with sample documents.
This creates some sample documents for testing the RAG pipeline.
"""

import os
from dotenv import load_dotenv
from pinecone import Pinecone
from langchain_huggingface import HuggingFaceEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.docstore.document import Document
from pinecone_text.sparse import BM25Encoder
import uuid

# Load environment variables
load_dotenv()

def populate_index_with_sample_data():
    """Populate the Pinecone index with sample documents."""
    pinecone_api_key = os.getenv("PINECONE_API_KEY")
    
    if not pinecone_api_key:
        raise ValueError("PINECONE_API_KEY must be set in your .env file")
    
    # Initialize Pinecone
    pc = Pinecone(api_key=pinecone_api_key)
    index = pc.Index("hybrid-search-langchain")
    
    # Initialize embeddings and sparse encoder
    embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
    bm25_encoder = BM25Encoder().default()
    
    # Sample documents (you can replace these with your actual documents)
    sample_documents = [
        {
            "content": "The LLaMA (Large Language Model Meta AI) is a foundational language model designed to help researchers advance their work in AI. LLaMA models range from 7B to 65B parameters and were trained on a diverse dataset of text from the internet.",
            "metadata": {"source": "llama_paper.pdf", "page": 1}
        },
        {
            "content": "LLaMA uses the transformer architecture as its backbone. The model employs RMSNorm for normalization and uses the SwiGLU activation function, which has been shown to improve performance over traditional activation functions.",
            "metadata": {"source": "llama_paper.pdf", "page": 2}
        },
        {
            "content": "The training dataset for LLaMA consists of CommonCrawl, C4, GitHub, Wikipedia, Books, ArXiv, and StackExchange. This diverse collection of data sources helps the model develop a broad understanding of different domains and writing styles.",
            "metadata": {"source": "llama_paper.pdf", "page": 3}
        },
        {
            "content": "LLaMA models demonstrate strong performance on various benchmarks including reading comprehension, mathematical reasoning, and code generation tasks. The 65B parameter model achieves competitive results with much larger models.",
            "metadata": {"source": "llama_paper.pdf", "page": 4}
        },
        {
            "content": "One of the key innovations in LLaMA is its efficient training approach. The researchers used techniques like gradient checkpointing and model parallelism to train large models efficiently on a limited computational budget.",
            "metadata": {"source": "llama_paper.pdf", "page": 5}
        }
    ]
    
    print("Processing and uploading documents to Pinecone...")
    
    # Process each document
    vectors_to_upsert = []
    
    for i, doc in enumerate(sample_documents):
        # Create document object
        document = Document(
            page_content=doc["content"],
            metadata=doc["metadata"]
        )
        
        # Generate dense embedding
        dense_vector = embeddings.embed_query(doc["content"])
        
        # Generate sparse vector (BM25)
        sparse_vector = bm25_encoder.encode_documents([doc["content"]])[0]
        
        # Create vector for upsert
        vector_id = str(uuid.uuid4())
        vectors_to_upsert.append({
            "id": vector_id,
            "values": dense_vector,
            "sparse_values": sparse_vector,
            "metadata": {
                "text": doc["content"],
                "source": doc["metadata"]["source"],
                "page": doc["metadata"]["page"]
            }
        })
    
    # Upsert vectors to Pinecone
    index.upsert(vectors=vectors_to_upsert)
    
    print(f"✅ Successfully uploaded {len(vectors_to_upsert)} documents to Pinecone!")
    
    # Check index stats
    stats = index.describe_index_stats()
    print(f"Index now contains {stats['total_vector_count']} vectors")
    
    return index

if __name__ == "__main__":
    try:
        index = populate_index_with_sample_data()
        print("\n🎉 Index population complete! Your RAG agent is ready to use.")
    except Exception as e:
        print(f"❌ Error populating index: {e}")
        print("Please check your setup and try again.")
