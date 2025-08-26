# Literature Mining LLM

A RAG-based system for mining literature using LangChain, Pinecone, and various LLMs.

## Project Structure

```
LiteratureMiningLLM/
├── main.py                 # Main application entry point
├── config.py              # Configuration and environment variables
├── document_processor.py   # Document loading and text splitting
├── pinecone_manager.py     # Pinecone initialization and management
├── embeddings.py          # Dense and sparse embedding initialization
├── vector_store.py        # Document upserting to Pinecone
├── retrieval.py           # Retriever, LLM, and reranker setup
├── rag_chain.py           # RAG chain creation and agent execution
├── t.ipynb               # Original notebook (for reference)
└── Carbon_adsorption.pdf  # Sample PDF document
```

## Features

- **Document Processing**: Load and split PDF documents into chunks
- **Hybrid Search**: Combines dense (Cohere) and sparse (BM25) embeddings
- **Vector Storage**: Uses Pinecone for scalable vector storage
- **Retrieval**: Hybrid search retriever with configurable top-k
- **Reranking**: Cohere reranker for improved relevance
- **LLM Integration**: Uses Groq's Llama model for question answering
- **Conversational**: Maintains chat history for context-aware responses

## Usage

1. Set up your environment variables in a `.env` file:
   ```
   PINECONE_API_KEY=your_pinecone_key
   COHERE_API_KEY=your_cohere_key
   GROQ_API_KEY=your_groq_key
   ```

2. Run the main application:
   ```bash
   python main.py
   ```

3. Interact with the system through the command-line interface.

## Dependencies

- langchain
- langchain-community
- langchain-cohere
- langchain-groq
- pinecone-client
- pinecone-text
- python-dotenv
- tqdm
- pypdf
