from langchain_community.retrievers import PineconeHybridSearchRetriever
from langchain_cohere import CohereRerank
from langchain_groq import ChatGroq
from config import (
    RETRIEVER_TOP_K, COHERE_API_KEY, COHERE_RERANK_MODEL,
    GROQ_API_KEY, GROQ_MODEL, LLM_TEMPERATURE, LLM_MAX_TOKENS
)


def initialize_retriever(embeddings, bm25_encoder, index):
    print("Initializing retriever with hybrid search...")
    
    retriever = PineconeHybridSearchRetriever(
        embeddings=embeddings, 
        sparse_encoder=bm25_encoder, 
        index=index, 
        text_key="text", 
        top_k=RETRIEVER_TOP_K
    )
    
    print("Retriever initialized.")
    return retriever


def initialize_llm():
    if not GROQ_API_KEY:
        raise ValueError("GROQ_API_KEY not found in environment variables.")
    llm = ChatGroq(
        model=GROQ_MODEL,
        temperature=LLM_TEMPERATURE,
        max_tokens=LLM_MAX_TOKENS
    )
    
    return llm


def initialize_reranker():
    print("Initializing Cohere reranker...")
    
    if not COHERE_API_KEY:
        raise ValueError("COHERE_API_KEY not found in environment variables.")
    
    reranker = CohereRerank(model=COHERE_RERANK_MODEL)
    print("Reranker initialized.")
    
    return reranker
