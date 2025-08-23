import os
from dotenv import load_dotenv
from pinecone import Pinecone
from langchain_huggingface import HuggingFaceEmbeddings
# from langchain_openai import OpenAIEmbeddings
from pinecone_text.sparse import BM25Encoder
from langchain_community.retrievers import PineconeHybridSearchRetriever
from langchain_cohere import CohereRerank
from langchain.chains import ConversationalRetrievalChain
from langchain_groq import ChatGroq

# Load environment variables from your .env file
load_dotenv()

class RAGPipeline:
    """
    A complete RAG pipeline that can be used as a tool by an ADK agent.
    It handles retrieval, reranking, and generation using Groq as the LLM.
    """
    def __init__(self):
        print("Initializing RAG Pipeline with Groq LLM...")
        # --- Initialize Connections and Models ---
        pinecone_api_key = os.getenv("PINECONE_API_KEY")
        cohere_api_key = os.getenv("COHERE_API_KEY")
        groq_api_key = os.getenv("GROQ_API_KEY")

        if not all([pinecone_api_key, cohere_api_key, groq_api_key]):
            raise ValueError("API keys for Pinecone, Cohere, and Groq must be set.")

        # Initialize Pinecone
        pc = Pinecone(api_key=pinecone_api_key)
        index_name = "hybrid-search-langchain"
        if index_name not in pc.list_indexes().names():
            raise ValueError(f"Pinecone index '{index_name}' does not exist. Please run the first script to create and populate it.")
        self.index = pc.Index(index_name)

        # Initialize Embeddings and Encoders
        self.embeddings = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")

        self.bm25_encoder = BM25Encoder().default()

        # Initialize Retriever with Hybrid Search
        self.retriever = PineconeHybridSearchRetriever(
            embeddings=self.embeddings,
            sparse_encoder=self.bm25_encoder,
            index=self.index
        )

        # Initialize Reranker
        self.reranker = CohereRerank(cohere_api_key=cohere_api_key, top_n=3)

        # Initialize the Conversational Chain with Groq LLM
        self.qa_chain = ConversationalRetrievalChain.from_llm(
            llm=ChatGroq(groq_api_key=groq_api_key, model_name="llama3-8b-8192", temperature=0),
            retriever=self.retriever,
            return_source_documents=True,
        )
        print("RAG Pipeline Initialized Successfully.")

    def query(self, question: str, chat_history: list = []) -> dict:
        """
        Executes a query against the RAG pipeline.

        Args:
            question: The user's question.
            chat_history: The conversation history.

        Returns:
            A dictionary containing the answer and reranked source documents.
        """
        print(f"Executing query: {question}")
        # Get initial results from the chain
        result = self.qa_chain({"question": question, "chat_history": chat_history})

        # Rerank the retrieved documents for better relevance
        reranked_docs = self.reranker.compress_documents(
            documents=result['source_documents'],
            query=question
        )

        # Format the sources for a clean output
        sources = [
            {
                "source": doc.metadata.get('source', 'Unknown'),
                "page": doc.metadata.get('page', 0),
                "content": doc.page_content[:250] + "..."
            }
            for doc in reranked_docs
        ]

        return {
            "answer": result["answer"],
            "sources": sources
        }