# Enhanced RAG Tool with Hybrid Search

This document describes the new RAG (Retrieval-Augmented Generation) tool that provides hybrid search capabilities combining semantic (dense vector) and keyword (sparse vector) search using PineconeVectorStore.

## Overview

The enhanced RAG tool replaces the previous explicit vector retriever agent and vector store implementation with a more sophisticated approach that:

1. **Uses PineconeVectorStore directly** from `langchain_pinecone`
2. **Implements hybrid search** combining semantic similarity and keyword matching
3. **Integrates seamlessly** with the Schema Designer Agent for enhanced property extraction
4. **Provides flexible search modes** (hybrid, semantic, keyword)

## Key Components

### 1. RAGTool (`tools/rag.py`)

The main RAG tool that provides:

- **HybridPineconeRetriever**: Custom retriever implementing hybrid search
- **Document management**: Add and index documents with hybrid embeddings
- **Multiple search modes**: Hybrid, semantic-only, or keyword-only search
- **Context extraction**: Get relevant context for schema extraction tasks

#### Key Methods:

```python
# Initialize the RAG tool
rag_tool = RAGTool()
success = rag_tool.initialize()

# Add documents with hybrid indexing
rag_tool.add_documents(documents)

# Search with different modes
results = rag_tool.search(query, query_type="hybrid", top_k=5)

# Get context for extraction tasks
context = rag_tool.get_context_for_extraction(abstract_text, query_terms)
```

### 2. Enhanced Schema Designer Agent

The updated `SchemaDesignerAgent` now:

- **Integrates RAG tool** for enhanced context retrieval
- **Uses hybrid search** to find relevant information from the knowledge base
- **Combines abstract text with retrieved context** for better property extraction
- **Tracks RAG usage** in extraction results

#### Enhanced Features:

- Automatic RAG initialization
- Context-aware property extraction
- Improved prompt templates with knowledge base context
- Metadata tracking for RAG usage

### 3. Enhanced Vector Retriever Agent

The new `EnhancedVectorRetrieverAgent` provides:

- **Direct PineconeVectorStore usage** instead of custom vector store implementation
- **Hybrid document indexing** with both dense and sparse embeddings
- **Similar document search** for cross-referencing
- **Streamlined workflow integration**

## Workflow Integration

The enhanced workflow now includes:

1. **PDF Chunking** → Extract text chunks from documents
2. **Vector Store Initialization** → Set up PineconeVectorStore with hybrid indexing
3. **RAG Tool Initialization** → Initialize RAG capabilities for schema agent
4. **Document Processing Loop**:
   - Get next chunk
   - Search for similar documents (optional)
   - Extract properties with RAG context
   - Aggregate results
5. **Export Results** → Generate CSV and console output

## Hybrid Search Algorithm

The hybrid search combines:

- **Dense Vectors (Semantic Search)**: Using Cohere embeddings for semantic similarity
- **Sparse Vectors (Keyword Search)**: Using BM25 encoding for keyword matching
- **Alpha Parameter**: Controls the balance between dense and sparse search (0.5 = 50/50)

### Search Modes:

1. **Hybrid** (α = 0.5): Balanced semantic and keyword search
2. **Semantic** (α = 1.0): Pure semantic similarity search
3. **Keyword** (α = 0.0): Pure keyword/BM25 search

## Configuration

Key configuration parameters in `config.py`:

```python
RETRIEVER_TOP_K = 20          # Number of results to retrieve
PINECONE_DIMENSION = 1024     # Vector dimension for embeddings
COHERE_EMBEDDING_MODEL = "embed-english-v3.0"  # Embedding model
```

## Usage Examples

### Basic RAG Tool Usage

```python
from tools.rag import RAGTool
from langchain_core.documents import Document

# Initialize
rag_tool = RAGTool()
rag_tool.initialize()

# Add documents
docs = [Document(page_content="CO2 adsorption...", metadata={"source": "paper1.pdf"})]
rag_tool.add_documents(docs)

# Search
results = rag_tool.search("CO2 adsorption capacity", query_type="hybrid")
```

### Schema Extraction with RAG Context

```python
from agents.schema_designer_agent import SchemaDesignerAgent

agent = SchemaDesignerAgent()

# The agent automatically uses RAG context when processing chunks
state = {
    'current_chunk': document_chunk,
    # ... other state variables
}

result = agent.extract_properties(state)
# Result includes RAG context usage information
```

### Running the Enhanced Workflow

```python
from langgraph_workflow import LiteratureMiningWorkflow

workflow = LiteratureMiningWorkflow()
result = workflow.run()

# The workflow now includes RAG-enhanced extraction
```

## Demonstration Scripts

- **`demo_rag.py`**: Comprehensive demonstration of RAG tool capabilities
- **`test_rag_integration.py`**: Integration tests for the new components

Run the demo:
```bash
uv run python demo_rag.py
```

Run integration tests:
```bash
uv run python test_rag_integration.py
```

## Benefits of the Enhanced Approach

1. **Better Property Extraction**: RAG context provides additional relevant information
2. **Hybrid Search**: Combines semantic understanding with keyword precision
3. **Simplified Architecture**: Direct use of PineconeVectorStore reduces complexity
4. **Flexible Search**: Multiple search modes for different use cases
5. **Enhanced Context**: Cross-document information retrieval for better results

## Migration from Previous Version

The enhanced version maintains compatibility with the existing workflow while providing significant improvements:

- **Automatic Migration**: Existing workflow calls work with minimal changes
- **Enhanced Results**: Better extraction quality due to RAG context
- **Backward Compatibility**: Existing state structures are preserved with additions
- **Performance**: More efficient vector operations using PineconeVectorStore directly

## Future Enhancements

Potential improvements for the RAG tool:

1. **Dynamic Alpha Tuning**: Automatically adjust hybrid search balance
2. **Query Expansion**: Enhance queries with domain-specific terms
3. **Result Reranking**: Post-process search results for better relevance
4. **Caching**: Cache frequently accessed contexts for performance
5. **Multi-modal Search**: Support for image and table content
