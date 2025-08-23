import os
from dotenv import load_dotenv
load_dotenv()

PINECONE_API_KEY = os.getenv("PINECONE_API_KEY")
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GROQ_API_KEY = os.getenv("GROQ_API_KEY")
COHERE_API_KEY = os.getenv("COHERE_API_KEY")
INDEX_NAME = "langchain-test-index"
PINECONE_DIMENSION = 1024
PINECONE_METRIC = "dotproduct"
PINECONE_CLOUD = "aws"
PINECONE_REGION = "us-east-1"


CHUNK_SIZE = 1000
CHUNK_OVERLAP = 200
BATCH_SIZE = 100


COHERE_EMBEDDING_MODEL = "embed-english-v3.0"
GROQ_MODEL = "llama-3.3-70b-versatile"
COHERE_RERANK_MODEL = "rerank-english-v3.0"
LLM_TEMPERATURE = 0.2
LLM_MAX_TOKENS = 32000
RETRIEVER_TOP_K = 20

PDF_FILE = "Carbon_adsorption.pdf"
