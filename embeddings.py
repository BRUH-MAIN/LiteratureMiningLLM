from langchain_cohere import CohereEmbeddings
from pinecone_text.sparse import BM25Encoder
from config import COHERE_EMBEDDING_MODEL


def initialize_embeddings():
    print("Initializing embeddings...")
    
    # Dense embeddings 
    embeddings = CohereEmbeddings(model=COHERE_EMBEDDING_MODEL)
    
    # Sparse embeddings using BM25
    bm25_encoder = BM25Encoder().default()
    
    print("Embeddings and sparse encoder initialized.")
    return embeddings, bm25_encoder
