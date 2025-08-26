#!/usr/bin/env python3
"""
Demonstration script for the enhanced RAG tool with hybrid search capabilities.
This script shows how to use the RAG tool independently for testing and validation.
"""

from tools.rag import RAGTool
from langchain_core.documents import Document
import json


def demo_rag_tool():
    """Demonstrate the RAG tool capabilities"""
    print("🚀 RAG Tool Demonstration")
    print("="*50)
    
    # Initialize RAG tool
    rag_tool = RAGTool()
    print("1. Initializing RAG tool...")
    
    success = rag_tool.initialize()
    if not success:
        print("❌ Failed to initialize RAG tool")
        return
    
    print("✅ RAG tool initialized successfully\n")
    
    # Demo documents (simulating CO2 adsorption research papers)
    demo_docs = [
        Document(
            page_content="The MOF-5 material showed excellent CO2 adsorption capacity of 120 mg/g at 273K and 1 bar pressure. The BET surface area was measured at 1200 m²/g with a pore volume of 0.8 cm³/g.",
            metadata={"source": "paper1.pdf", "page": 1, "abstract_id": "abs_001"}
        ),
        Document(
            page_content="Zeolite 13X demonstrated high CO2/N2 selectivity of 25:1 at room temperature. The material has microporous structure with average pore size of 1.2 nm and shows rapid adsorption kinetics.",
            metadata={"source": "paper2.pdf", "page": 1, "abstract_id": "abs_002"}
        ),
        Document(
            page_content="The novel carbon-based adsorbent achieved CO2 uptake of 4.5 mmol/g under ambient conditions. Temperature-programmed desorption revealed strong CO2 binding sites with activation energy of 45 kJ/mol.",
            metadata={"source": "paper3.pdf", "page": 1, "abstract_id": "abs_003"}
        ),
        Document(
            page_content="Activated carbon derived from biomass showed promising results with CO2 adsorption capacity of 95 mg/g. The material synthesis involves carbonization at 800°C followed by KOH activation.",
            metadata={"source": "paper4.pdf", "page": 1, "abstract_id": "abs_004"}
        ),
        Document(
            page_content="The metal-organic framework exhibits outstanding stability under cyclic operation with minimal capacity loss after 100 cycles. Langmuir isotherm model fitted well with experimental data.",
            metadata={"source": "paper5.pdf", "page": 1, "abstract_id": "abs_005"}
        )
    ]
    
    # Add documents to RAG tool
    print("2. Adding demonstration documents...")
    success = rag_tool.add_documents(demo_docs)
    if not success:
        print("❌ Failed to add documents")
        return
    
    print("✅ Added 5 demonstration documents\n")
    
    # Demonstrate different search types
    queries = [
        ("CO2 adsorption capacity", "hybrid"),
        ("surface area measurements", "semantic"),
        ("temperature activation", "keyword"),
        ("MOF materials performance", "hybrid")
    ]
    
    print("3. Demonstrating search capabilities:")
    print("-" * 40)
    
    for query, search_type in queries:
        print(f"\n🔍 Query: '{query}' (Search type: {search_type})")
        
        results = rag_tool.search(query, query_type=search_type, top_k=3)
        
        for i, doc in enumerate(results, 1):
            score = doc.metadata.get('score', 'N/A')
            source = doc.metadata.get('source', 'Unknown')
            print(f"  Result {i}: {doc.page_content[:100]}... (Score: {score:.4f}, Source: {source})")
    
    # Demonstrate context extraction
    print("\n\n4. Demonstrating context extraction for schema design:")
    print("-" * 55)
    
    test_abstract = """
    A novel zinc-based MOF was synthesized and tested for CO2 capture applications. 
    The material showed remarkable performance with high adsorption capacity and excellent selectivity.
    Characterization revealed optimal pore structure for CO2 molecules.
    """
    
    print(f"📝 Test Abstract: {test_abstract}")
    
    context = rag_tool.get_context_for_extraction(
        abstract_text=test_abstract,
        query_terms=["CO2 adsorption", "MOF synthesis", "selectivity", "pore structure"]
    )
    
    if context:
        print(f"\n📚 Retrieved Context ({len(context.split())} words):")
        print(f"{context[:300]}...")
    else:
        print("\n❌ No context retrieved")
    
    print("\n" + "="*50)
    print("✅ RAG Tool demonstration completed successfully!")


def demo_integration_with_schema_extraction():
    """Demonstrate how RAG tool integrates with schema extraction"""
    print("\n🔬 Schema Extraction Integration Demo")
    print("="*50)
    
    # This would typically be done by the SchemaDesignerAgent
    test_cases = [
        {
            "abstract": "The activated carbon material achieved CO2 adsorption of 4.2 mmol/g at 298K and 1 bar.",
            "expected_properties": ["adsorption_capacity", "temperature", "pressure"]
        },
        {
            "abstract": "BET surface area analysis revealed 1150 m²/g with mesoporous structure and pore volume of 0.65 cm³/g.",
            "expected_properties": ["surface_area", "pore_volume", "pore_structure"]
        }
    ]
    
    rag_tool = RAGTool()
    if not rag_tool.initialize():
        print("❌ Failed to initialize RAG tool for integration demo")
        return
    
    for i, test_case in enumerate(test_cases, 1):
        print(f"\n📄 Test Case {i}:")
        print(f"Abstract: {test_case['abstract']}")
        
        context = rag_tool.get_context_for_extraction(test_case['abstract'])
        
        print(f"Context Quality: {'Good' if len(context) > 100 else 'Limited'}")
        print(f"Expected Properties: {', '.join(test_case['expected_properties'])}")
        
        # In real implementation, this context would be passed to the LLM
        # along with the abstract for enhanced property extraction
    
    print("\n✅ Integration demonstration completed!")


if __name__ == "__main__":
    try:
        demo_rag_tool()
        demo_integration_with_schema_extraction()
        
    except Exception as e:
        print(f"❌ Demo failed: {e}")
        import traceback
        traceback.print_exc()
