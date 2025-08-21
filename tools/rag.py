from dotenv import load_dotenv
from typing import List

from langchain_community.document_loaders import PyPDFLoader
from langchain_core.documents import Document
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_chroma import Chroma
from langchain.chains import RetrievalQA
from langchain_core.runnables import RunnableParallel, RunnablePassthrough
from langchain import hub

from .db import get_embedding_function  # custom embedding loader
from .agentic_chunker import chunker_agentic  # custom chunker

# Load environment variables (API keys, etc.)
load_dotenv()


def load_pdf(file_path: str) -> List[Document]:
    """Load PDF and return list of Documents (per page)."""
    loader = PyPDFLoader(file_path)
    return list(loader.load())


def chunker_recursive(documents: List[Document], chunk_size: int = 800, chunk_overlap: int = 80) -> List[Document]:
    """Split documents into smaller chunks for embeddings."""
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
        length_function=len,
        is_separator_regex=False,
    )
    return text_splitter.split_documents(documents)


def rag(file_path: str, chunk_size: int = 200, chunk_overlap: int = 50):
    """RAG pipeline: Load PDF, split, embed, store in Chroma, and return QA chain."""
    # Load prompt template from LangChain hub
    prompt = """
    You are an assistant for question-answering tasks. Use the following pieces of retrieved context to answer the question. 
    If you don't know the answer, just say that you don't know. Try to provide as much information as possible.
    Question: {question} 
    Context: {context} 
    Answer:"""

    from langchain_core.prompts import PromptTemplate

    prompt_template = PromptTemplate.from_template(prompt)
    # Load documents and chunk
    docs = load_pdf(file_path)
    chunks = chunker_recursive(docs)

    # Create embedding function
    embedding = get_embedding_function()
    

    # Persist vectorstore
    persist_directory = "db"
    vectorstore = Chroma.from_documents(
        documents=chunks,
        embedding=embedding,
        persist_directory=persist_directory,
    )

    retriever = vectorstore.as_retriever(search_kwargs={"k": 100})

    # Initialize LLM
    llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash")

    # Create RetrievalQA chain


    qa_chain = RetrievalQA.from_chain_type(
        llm=llm,
        chain_type="stuff",
        retriever=retriever,
        return_source_documents=True,
        chain_type_kwargs={"prompt": prompt_template},
    )

    return qa_chain  
