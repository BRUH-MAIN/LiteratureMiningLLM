from langchain_groq import ChatGroq
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnableLambda
from typing import Dict, Any
import json
from config import GROQ_API_KEY, GROQ_MODEL, LLM_TEMPERATURE
from prompts import schema_designer_agent


class SchemaDesignerAgent:
    def __init__(self):
        self.llm = ChatGroq(
            groq_api_key=GROQ_API_KEY,
            model=GROQ_MODEL,
            temperature=LLM_TEMPERATURE
        )

        self.extraction_prompt = ChatPromptTemplate.from_template(schema_designer_agent.instruction)

    def extract_properties(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Extract CO2 adsorption properties from current chunk"""
        current_chunk = state.get('current_chunk')
        
        if not current_chunk:
            return {**state, 'extraction_result': None}
        
        abstract_text = current_chunk.page_content
        metadata = current_chunk.metadata
        
        print(f"🧪 Extracting properties from {metadata['abstract_id']}...")
        
        try:
            # Format prompt and get LLM response
            formatted_prompt = self.extraction_prompt.format(abstract_text=abstract_text)
            response = self.llm.invoke(formatted_prompt)
            
            # Parse JSON response
            properties_json = json.loads(response.content)
            
            # Create structured result
            extraction_result = {
                'abstract_id': metadata['abstract_id'],
                'page_number': metadata['page'],
                'source': metadata['source'],
                'properties': properties_json
            }
            
            print(f"✅ Extracted {len(properties_json)} properties")
            return {**state, 'extraction_result': extraction_result}
            
        except Exception as e:
            print(f"❌ Error extracting properties: {e}")
            # Return empty result on error
            extraction_result = {
                'abstract_id': metadata['abstract_id'],
                'page_number': metadata['page'],
                'source': metadata['source'],
                'properties': []
            }
            return {**state, 'extraction_result': extraction_result}
    
    def get_runnable(self):
        return RunnableLambda(self.extract_properties)
