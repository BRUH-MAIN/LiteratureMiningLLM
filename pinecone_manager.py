from pinecone import Pinecone, ServerlessSpec
from config import (
    PINECONE_API_KEY, INDEX_NAME, PINECONE_DIMENSION, 
    PINECONE_METRIC, PINECONE_CLOUD, PINECONE_REGION
)


def initialize_pinecone():
    """Initialize Pinecone client and create/get index"""
    print("Initializing Pinecone...")
    
    if not PINECONE_API_KEY:
        raise ValueError("PINECONE_API_KEY not found in environment variables.")
    
    pc = Pinecone(api_key=PINECONE_API_KEY)
    
    # Create index if it doesn't exist
    if not pc.has_index(INDEX_NAME):
        pc.create_index(
            name=INDEX_NAME,
            dimension=PINECONE_DIMENSION,
            metric=PINECONE_METRIC,
            spec=ServerlessSpec(cloud=PINECONE_CLOUD, region=PINECONE_REGION),
        )
    
    index = pc.Index(INDEX_NAME)
    return pc, index


def delete_pinecone_index():
    """Delete the Pinecone index"""
    pc = Pinecone(api_key=PINECONE_API_KEY)
    if pc.has_index(INDEX_NAME):
        pc.delete_index(INDEX_NAME)
        print(f"Index {INDEX_NAME} deleted.")
    else:
        print(f"Index {INDEX_NAME} does not exist.")
