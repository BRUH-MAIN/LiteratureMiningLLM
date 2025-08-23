from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from config import CHUNK_SIZE, CHUNK_OVERLAP, PDF_FILE


def load_and_split_documents():
    """Load PDF document and split into chunks"""
    print("Loading and splitting documents...")
    
    # Load PDF
    loader = PyPDFLoader(PDF_FILE)
    documents = loader.load()
    
    # Split into chunks
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=CHUNK_SIZE, 
        chunk_overlap=CHUNK_OVERLAP
    )
    docs = text_splitter.split_documents(documents)
    
    print(f"Loaded and split {len(docs)} chunks.")
    return docs
