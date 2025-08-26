# Literature Mining LLM

A comprehensive RAG-based multi-agent system for mining literature using LangChain, Pinecone, and various LLMs with enhanced hybrid search capabilities.

## 🚀 Recent Enhancements

This project now features an **Enhanced RAG Tool** with hybrid search capabilities that combines semantic and keyword search for superior information retrieval. See [RAG_ENHANCEMENT.md](RAG_ENHANCEMENT.md) for detailed documentation.

### Key New Features:
- **Hybrid Search**: Combines semantic (dense vector) and keyword (BM25) search
- **Direct PineconeVectorStore Integration**: Simplified architecture using `langchain_pinecone`
- **Enhanced Schema Designer**: Context-aware property extraction with RAG integration
- **Flexible Search Modes**: Hybrid, semantic-only, or keyword-only search options
- **Multi-Agent Workflow**: Complete LangGraph-based processing pipeline

## Project Structure

```
LiteratureMiningLLM/
├── main.py                          # Main application entry point
├── config.py                        # Configuration and environment variables
├── langgraph_workflow.py           # Enhanced multi-agent workflow
├── demo_rag.py                     # RAG tool demonstration
├── test_rag_integration.py         # Integration tests
├── tools/
│   └── rag.py                      # 🆕 Enhanced RAG tool with hybrid search
├── agents/
│   ├── pdf_chunking_agent.py       # PDF processing agent
│   ├── enhanced_vector_retriever_agent.py  # 🆕 Enhanced vector retriever
│   ├── schema_designer_agent.py    # 🆕 RAG-enhanced schema extraction
│   ├── result_aggregator_agent.py  # Results aggregation
│   └── exporter_agent.py          # Data export agent
├── prompts/
│   └── schema_designer_agent.py    # Extraction prompts
├── output/                         # Generated output files
├── depreciated/                    # Legacy implementations
└── documents/
    ├── RAG_ENHANCEMENT.md          # 🆕 RAG tool documentation
    └── RAG_Multi_Agent_Workflow.md # Workflow documentation
```

## Features

### Core Capabilities
- **📄 Document Processing**: Intelligent PDF loading and chunking
- **🔍 Hybrid Search**: Advanced retrieval combining semantic and keyword search
- **🗄️ Vector Storage**: Scalable Pinecone vector database with dual embedding support
- **🤖 Multi-Agent System**: Specialized agents for different processing tasks
- **🧠 LLM Integration**: Multiple LLM providers (Groq, OpenAI, etc.)
- **📊 Schema Extraction**: Automated property extraction from research papers
- **📈 Export Pipeline**: CSV and console output generation

### Enhanced RAG Features
- **Hybrid Retrieval**: Configurable balance between semantic and keyword search
- **Context Enhancement**: Cross-document information retrieval
- **Multiple Search Modes**: Adaptive search strategies
- **Real-time Integration**: Seamless workflow integration
- **Performance Optimization**: Efficient vector operations

## Quick Start

### 1. Environment Setup
```bash
# Clone the repository
git clone <repository-url>
cd LiteratureMiningLLM

# Install dependencies
uv sync

# Set up environment variables
cp .env.example .env
# Edit .env with your API keys
```

### 2. Required API Keys
```env
PINECONE_API_KEY=your_pinecone_key
COHERE_API_KEY=your_cohere_key
GROQ_API_KEY=your_groq_key
```

### 3. Run the Enhanced Workflow
```bash
# Run the complete multi-agent workflow
uv run python main.py

# Or demonstrate the RAG tool specifically
uv run python demo_rag.py

# Run integration tests
uv run python test_rag_integration.py
```

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
