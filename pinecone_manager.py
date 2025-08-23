from pinecone import Pinecone, ServerlessSpec
from config import (
    PINECONE_API_KEY, INDEX_NAME, PINECONE_DIMENSION, 
    PINECONE_METRIC, PINECONE_CLOUD, PINECONE_REGION
)


def initialize_pinecone():
    print("Initializing Pinecone...")
    if not PINECONE_API_KEY:
        raise ValueError("PINECONE_API_KEY not found in environment variables.")

    index_name = "langchain-test-index"  # change if desired
    pc = Pinecone(api_key=PINECONE_API_KEY)
    if not pc.has_index(index_name):
        pc.create_index(
            name=index_name,
            dimension=PINECONE_DIMENSION,
            metric=PINECONE_METRIC,
            spec=ServerlessSpec(cloud=PINECONE_CLOUD, region=PINECONE_REGION),
        )

    index = pc.Index(index_name)
    return pc, index
