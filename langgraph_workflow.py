from langgraph.graph import StateGraph, END
from typing import Dict, Any, List, TypedDict
from agents.pdf_chunking_agent import PDFChunkingAgent
from agents.vector_retriever_agent import VectorStoreRetrieverAgent
from agents.schema_designer_agent import SchemaDesignerAgent
from agents.result_aggregator_agent import ResultAggregatorAgent
from agents.exporter_agent import ExporterAgent


class WorkflowState(TypedDict):
    chunks: List[Any]
    total_chunks: int
    vector_store_ready: bool
    current_chunk_index: int
    current_chunk: Any
    processing_complete: bool
    extraction_result: Dict[str, Any]
    aggregated_results: List[Dict[str, Any]]
    csv_data: List[Dict[str, Any]]
    export_complete: bool
    csv_file: str


class LiteratureMiningWorkflow:
    def __init__(self):
        self.pdf_chunking_agent = PDFChunkingAgent()
        self.vector_retriever_agent = VectorStoreRetrieverAgent()
        self.schema_designer_agent = SchemaDesignerAgent()
        self.result_aggregator_agent = ResultAggregatorAgent()
        self.exporter_agent = ExporterAgent()
        
        self.workflow = self._create_workflow()
    
    def _create_workflow(self) -> StateGraph:
        """Create the LangGraph workflow"""
        workflow = StateGraph(WorkflowState)
        
        # Add nodes
        workflow.add_node("pdf_chunking", self.pdf_chunking_agent.get_runnable())
        workflow.add_node("vector_init", self.vector_retriever_agent.get_runnable_init())
        workflow.add_node("get_next_chunk", self.vector_retriever_agent.get_runnable_next())
        workflow.add_node("extract_properties", self.schema_designer_agent.get_runnable())
        workflow.add_node("aggregate_results", self.result_aggregator_agent.get_runnable_aggregate())
        workflow.add_node("prepare_csv", self.result_aggregator_agent.get_runnable_prepare())
        workflow.add_node("export_csv", self.exporter_agent.get_runnable_csv())
        workflow.add_node("display_console", self.exporter_agent.get_runnable_console())
        
        # Set entry point
        workflow.set_entry_point("pdf_chunking")
        
        # Add edges
        workflow.add_edge("pdf_chunking", "vector_init")
        workflow.add_edge("vector_init", "get_next_chunk")
        
        # Conditional edge for processing loop
        workflow.add_conditional_edges(
            "get_next_chunk",
            self._should_continue_processing,
            {
                "continue": "extract_properties",
                "finish": "prepare_csv"
            }
        )
        
        workflow.add_edge("extract_properties", "aggregate_results")
        workflow.add_edge("aggregate_results", "get_next_chunk")
        workflow.add_edge("prepare_csv", "display_console")
        workflow.add_edge("display_console", "export_csv")
        workflow.add_edge("export_csv", END)
        
        return workflow.compile()
    
    def _should_continue_processing(self, state: WorkflowState) -> str:
        """Determine if we should continue processing or finish"""
        if state.get('processing_complete', False):
            return "finish"
        return "continue"
    
    def run(self, initial_state: WorkflowState = None) -> Dict[str, Any]:
        """Run the complete workflow"""
        if initial_state is None:
            initial_state = WorkflowState(
                chunks=[],
                total_chunks=0,
                vector_store_ready=False,
                current_chunk_index=0,
                current_chunk=None,
                processing_complete=False,
                extraction_result={},
                aggregated_results=[],
                csv_data=[],
                export_complete=False,
                csv_file=""
            )
        
        print("🚀 Starting Literature Mining Multi-Agent Workflow...")
        print("="*60)
        
        try:
            final_state = self.workflow.invoke(initial_state, {"recursion_limit": 200})

            print("🎉 Workflow completed successfully!")
            return final_state
            
        except Exception as e:
            print(f"❌ Workflow failed: {e}")
            raise e
