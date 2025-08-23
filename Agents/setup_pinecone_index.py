#!/usr/bin/env python3
"""
Setup script to create and populate the Pinecone index for the RAG pipeline.
Run this script before using the RAG agent.
"""

import os
from dotenv import load_dotenv
from pinecone import Pinecone, ServerlessSpec

# Load environment variables
load_dotenv()

def setup_pinecone_index():
    """Create the Pinecone index if it doesn't exist."""
    pinecone_api_key = os.getenv("PINECONE_API_KEY")
    
    if not pinecone_api_key:
        raise ValueError("PINECONE_API_KEY must be set in your .env file")
    
    # Initialize Pinecone
    pc = Pinecone(api_key=pinecone_api_key)
    
    index_name = "hybrid-search-langchain"
    dimension = 384  # Dimension for all-MiniLM-L6-v2 embeddings
    
    # Check if index exists
    existing_indexes = pc.list_indexes().names()
    
    if index_name not in existing_indexes:
        print(f"Creating Pinecone index: {index_name}")
        
        # Create the index with serverless spec
        pc.create_index(
            name=index_name,
            dimension=dimension,
            metric='cosine',
            spec=ServerlessSpec(
                cloud='aws',
                region='us-east-1'  # Change this to your preferred region
            )
        )
        print(f"✅ Index '{index_name}' created successfully!")
    else:
        print(f"✅ Index '{index_name}' already exists!")
    
    return pc.Index(index_name)

if __name__ == "__main__":
    try:
        index = setup_pinecone_index()
        print(f"Index stats: {index.describe_index_stats()}")
        print("\n🎉 Setup complete! You can now run your RAG agent.")
    except Exception as e:
        print(f"❌ Error setting up Pinecone index: {e}")
        print("Please check your PINECONE_API_KEY and try again.")
