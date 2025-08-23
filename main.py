#!/usr/bin/env python3
"""
Literature Mining LLM - LangGraph Multi-Agent Workflow
A multi-agent system for extracting CO2 adsorption properties from literature
"""

from langgraph_workflow import LiteratureMiningWorkflow


def main():
    """Main function to run the literature mining multi-agent workflow"""
    try:
        # Initialize and run the LangGraph workflow
        workflow = LiteratureMiningWorkflow()
        final_state = workflow.run()
        
        # Print final summary
        if final_state.get('export_complete'):
            print(f"\n✅ Successfully processed {final_state.get('total_chunks', 0)} chunks")
            print(f"📁 Results exported to: {final_state.get('csv_file', 'N/A')}")
        else:
            print("❌ Workflow did not complete successfully")
        
    except KeyboardInterrupt:
        print("\nExiting...")
    except Exception as e:
        print(f"❌ Error: {e}")


if __name__ == "__main__":
    main()
