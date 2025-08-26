from langchain_core.runnables import RunnableLambda
from typing import Dict, Any
import pandas as pd
import json
from config import OUTPUT_FILE
from datetime import datetime


class ExporterAgent:
    def __init__(self):
        pass
    
    def export_to_csv(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Export results to CSV file and display summary"""
        csv_data = state.get('csv_data', [])
        
        if not csv_data:
            print("❌ No data to export")
            return {**state, 'export_complete': True, 'csv_file': None}
        
        try:
            # Create DataFrame
            df = pd.DataFrame(csv_data)
            
            # Generate filename with timestamp
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            csv_filename = OUTPUT_FILE.replace('.csv', f'_{timestamp}.csv')

            # Save to CSV
            df.to_csv(csv_filename, index=False)
            
            print(f"📁 Exported {len(csv_data)} rows to {csv_filename}")
            
            # Display summary
            self._display_summary(df)
            
            return {
                **state, 
                'export_complete': True, 
                'csv_file': csv_filename,
                'export_summary': {
                    'total_rows': len(csv_data),
                    'unique_abstracts': df['Abstract_ID'].nunique(),
                    'unique_properties': df['Property'].nunique()
                }
            }
            
        except Exception as e:
            print(f"❌ Error exporting to CSV: {e}")
            return {**state, 'export_complete': True, 'csv_file': None}
    
    def _display_summary(self, df: pd.DataFrame):
        """Display extraction summary"""
        print("\n" + "="*50)
        print("📊 EXTRACTION SUMMARY")
        print("="*50)
        
        print(f"Total Rows: {len(df)}")
        print(f"Unique Abstracts: {df['Abstract_ID'].nunique()}")
        print(f"Unique Properties: {df['Property'].nunique()}")
        
        print("\n📋 Properties Found:")
        property_counts = df['Property'].value_counts()
        for prop, count in property_counts.items():
            print(f"  • {prop}: {count} instances")
        
        print("\n📄 Sample Results:")
        print(df.head(10).to_string(index=False))
        
        print("\n" + "="*50)
    
    def display_console_results(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Display results in console format"""
        aggregated_results = state.get('aggregated_results', [])
        
        print("\n" + "="*60)
        print("🔬 CO2 ADSORPTION PROPERTIES EXTRACTION RESULTS")
        print("="*60)
        
        for result in aggregated_results:
            print(f"\n📑 Abstract ID: {result['abstract_id']} (Page {result['page_number']})")
            print("-" * 40)
            
            for prop in result['properties']:
                print(f"  {prop['property']}: {prop['value']}")
        
        print("\n" + "="*60)
        return state
    
    def get_runnable_csv(self):
        return RunnableLambda(self.export_to_csv)
    
    def get_runnable_console(self):
        return RunnableLambda(self.display_console_results)
