from langchain_core.runnables import RunnableLambda
from typing import Dict, Any


class ResultAggregatorAgent:
    def __init__(self):
        pass
    
    def aggregate_results(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Collect and store extraction results"""
        extraction_result = state.get('extraction_result')
        aggregated_results = state.get('aggregated_results', [])
        
        if extraction_result:
            aggregated_results.append(extraction_result)
            print(f"📊 Aggregated result from {extraction_result['abstract_id']} - Total: {len(aggregated_results)}")
        
        return {**state, 'aggregated_results': aggregated_results}
    
    def prepare_csv_data(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Convert aggregated results to CSV-ready format"""
        aggregated_results = state.get('aggregated_results', [])
        csv_data = []
        
        print("📋 Preparing CSV data...")
        
        for result in aggregated_results:
            abstract_id = result['abstract_id']
            page_number = result['page_number']
            source = result['source']
            
            for prop in result['properties']:
                csv_row = {
                    'Abstract_ID': abstract_id,
                    'Page_Number': page_number,
                    'Source': source,
                    'Property': prop['property'],
                    'Value': prop['value']
                }
                csv_data.append(csv_row)
        
        print(f"✅ Prepared {len(csv_data)} CSV rows from {len(aggregated_results)} abstracts")
        return {**state, 'csv_data': csv_data}
    
    def get_runnable_aggregate(self):
        return RunnableLambda(self.aggregate_results)
    
    def get_runnable_prepare(self):
        return RunnableLambda(self.prepare_csv_data)
