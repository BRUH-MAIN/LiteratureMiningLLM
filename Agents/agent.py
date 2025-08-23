from google.adk.agents import Agent
# from google.adk.tools import tool
# from google.adk.runners import run_in_web
# from google.adk.models.groq import Groq
from .rag_tool import RAGPipeline

# --- 1. Initialize our custom RAG pipeline ---
# This object holds all the complex logic for our RAG system.
try:
    rag_pipeline = RAGPipeline()
except ValueError as e:
    print(f"Error initializing RAG Pipeline: {e}")
    print("Please ensure your .env file is correctly set up and the Pinecone index exists.")
    rag_pipeline = None

# --- 2. Define the ADK Tool ---
# We use the @tool decorator to make our Python function available to the ADK agent.
# The docstring is very important, as it tells the agent what the tool does.
def query_document_knowledge_base(question: str) -> str:
    """
    Use this tool to answer questions about the LLaMA paper.
    It retrieves relevant information from a document, reranks it for relevance,
    and generates a comprehensive answer.
    """
    if not rag_pipeline:
        return "RAG Pipeline is not available due to an initialization error."
    
    # Call our RAG pipeline's query method
    result = rag_pipeline.query(question=question)
    
    # Format the response for the agent
    formatted_response = f"Answer: {result['answer']}\n\nSources:\n"
    for source in result['sources']:
        formatted_response += f"- Source: {source['source']}, Page: {source['page']}\n"
        formatted_response += f"  Content: {source['content']}\n"
        
    return formatted_response

# --- 3. Define the ADK Agent ---
# This is the main agent that will use our tool. We explicitly set its
# reasoning model to Groq for consistency and speed.
main_agent = Agent(
    name="RAG_Agent",
    instruction="""
    You are a helpful research assistant.
    Your goal is to answer questions based on the provided document knowledge base.
    Use the 'query_document_knowledge_base' tool to find answers.
    Be concise and cite your sources.
    """,
    tools=[query_document_knowledge_base], # Register our custom tool
    model='gemini-2.0-flash' # Set the agent's reasoning model to Groq
)

# --- 4. Run the Agent ---
# This starts a local web server to interact with your agent.
# if __name__ == "__main__":
#     if rag_pipeline:
#         print("\n--- Starting ADK Web UI ---")
#         print("Navigate to the URL printed below to chat with your agent.")
#         run_in_web(main_agent)
#     else:
#         print("\nCould not start the agent because the RAG pipeline failed to initialize.")
