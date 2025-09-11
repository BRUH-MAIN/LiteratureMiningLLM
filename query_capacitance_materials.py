#!/usr/bin/env python3
"""
Query script to extract materials with capacitance properties
"""

from app.models import get_session
from sqlalchemy import text
import pandas as pd

def query_capacitance_materials():
    """Execute SQL query for materials with capacitance properties"""
    session = get_session()
    
    try:
        # SQL query to get materials with capacitance properties
        query = text("""
        SELECT DISTINCT 
            m.material_id,
            m.mxene_composition,
            m.composite_material,
            m.synthesis_method,
            m.fabrication_method,
            p.title as paper_title,
            p.authors,
            p.journal,
            p.year,
            prop.value as capacitance_value,
            prop.unit as capacitance_unit,
            prop.test_conditions
        FROM materials m
        INNER JOIN papers p ON m.paper_id = p.paper_id
        INNER JOIN properties prop ON m.material_id = prop.material_id
        WHERE 
            (m.mxene_composition IS NOT NULL OR m.composite_material IS NOT NULL)
            AND prop.property_type = 'Capacitance'
        ORDER BY prop.value DESC;
        """)
        
        # Execute query and convert to DataFrame
        result = session.execute(query)
        columns = [
            'material_id', 'mxene_composition', 'composite_material', 
            'synthesis_method', 'fabrication_method', 'paper_title',
            'authors', 'journal', 'year', 'capacitance_value', 
            'capacitance_unit', 'test_conditions'
        ]
        
        df = pd.DataFrame(result.fetchall(), columns=columns)
        
        print(f"📊 Found {len(df)} materials with capacitance properties")
        print(f"🔋 Capacitance range: {df['capacitance_value'].min():.2f} - {df['capacitance_value'].max():.2f} {df['capacitance_unit'].iloc[0] if len(df) > 0 else 'N/A'}")
        
        # Display summary statistics
        print("\n📈 Capacitance Statistics:")
        print(f"   Mean: {df['capacitance_value'].mean():.2f}")
        print(f"   Median: {df['capacitance_value'].median():.2f}")
        print(f"   Std Dev: {df['capacitance_value'].std():.2f}")
        
        # Show top 10 results
        print("\n🏆 Top 10 Materials by Capacitance:")
        print(df[['mxene_composition', 'composite_material', 'capacitance_value', 'capacitance_unit', 'year']].head(10).to_string(index=False))
        
        # Export to CSV
        output_file = 'output/capacitance_materials_query.csv'
        df.to_csv(output_file, index=False)
        print(f"\n💾 Results exported to: {output_file}")
        
        return df
        
    except Exception as e:
        print(f"❌ Error executing query: {e}")
        return pd.DataFrame()
    finally:
        session.close()

if __name__ == "__main__":
    query_capacitance_materials()
