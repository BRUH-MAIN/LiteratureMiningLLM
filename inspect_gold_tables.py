#!/usr/bin/env python3
"""
Supabase Gold Standard Table Inspector

This script allows you to inspect the gold standard tables in Supabase
and see what data has been extracted.
"""

import sys
from pathlib import Path
from sqlalchemy import create_engine, text

# Add project root to Python path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

from app.config import Config


def inspect_gold_tables():
    """Inspect the gold standard tables in Supabase"""
    print("=" * 60)
    print("SUPABASE GOLD STANDARD TABLES INSPECTOR")
    print("=" * 60)
    
    try:
        # Connect to Supabase
        engine = create_engine(Config.POSTGRES_URL)
        
        with engine.connect() as conn:
            print("\n📋 CHECKING TABLE STATUS:")
            print("-" * 40)
            
            # Check if gold tables exist
            tables_check = conn.execute(text("""
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name LIKE 'gold_%'
                ORDER BY table_name
            """))
            
            gold_tables = [row[0] for row in tables_check]
            
            if not gold_tables:
                print("❌ No gold standard tables found!")
                print("💡 Run the gold standard extraction first to create tables")
                return
            
            print(f"✅ Found {len(gold_tables)} gold standard tables:")
            for table in gold_tables:
                print(f"   - {table}")
            
            print("\n📊 TABLE DATA COUNTS:")
            print("-" * 40)
            
            # Count data in each table
            for table in gold_tables:
                try:
                    count_result = conn.execute(text(f"SELECT COUNT(*) FROM {table}"))
                    count = count_result.fetchone()[0]
                    print(f"   {table:<20}: {count:>6} rows")
                except Exception as e:
                    print(f"   {table:<20}: ERROR - {e}")
            
            # If we have data, show some sample records
            papers_count = conn.execute(text("SELECT COUNT(*) FROM gold_papers")).fetchone()[0]
            
            if papers_count > 0:
                print(f"\n📄 SAMPLE PAPERS (Latest 5):")
                print("-" * 40)
                
                papers_sample = conn.execute(text("""
                    SELECT paper_id, title, year, journal
                    FROM gold_papers 
                    ORDER BY paper_id DESC 
                    LIMIT 5
                """))
                
                for row in papers_sample:
                    paper_id, title, year, journal = row
                    title_short = (title[:50] + '...') if len(title) > 50 else title
                    print(f"   [{paper_id:>3}] {year} - {title_short}")
                    print(f"        📖 {journal}")
                    print()
                
                print(f"🔬 MATERIALS & PROPERTIES BREAKDOWN:")
                print("-" * 40)
                
                # Show materials breakdown
                materials_breakdown = conn.execute(text("""
                    SELECT 
                        COUNT(DISTINCT m.material_id) as material_count,
                        COUNT(DISTINCT p.property_id) as property_count,
                        COUNT(DISTINCT a.app_id) as application_count
                    FROM gold_materials m
                    LEFT JOIN gold_properties p ON m.material_id = p.material_id
                    LEFT JOIN gold_applications a ON m.material_id = a.material_id
                """))
                
                stats = materials_breakdown.fetchone()
                if stats:
                    print(f"   Materials extracted:     {stats[0]:>6}")
                    print(f"   Properties extracted:    {stats[1]:>6}")
                    print(f"   Applications extracted:  {stats[2]:>6}")
                
                # Show top MXene compositions
                print(f"\n🧪 TOP MXENE COMPOSITIONS:")
                print("-" * 40)
                
                mxene_stats = conn.execute(text("""
                    SELECT mxene_composition, COUNT(*) as count
                    FROM gold_materials 
                    WHERE mxene_composition IS NOT NULL
                    AND mxene_composition != ''
                    GROUP BY mxene_composition
                    ORDER BY count DESC
                    LIMIT 5
                """))
                
                for row in mxene_stats:
                    comp, count = row
                    print(f"   {comp:<20}: {count:>3} papers")
                
                # Show top property types
                print(f"\n⚡ TOP PROPERTY TYPES:")
                print("-" * 40)
                
                property_stats = conn.execute(text("""
                    SELECT property_type, COUNT(*) as count
                    FROM gold_properties 
                    WHERE property_type IS NOT NULL
                    AND property_type != ''
                    GROUP BY property_type
                    ORDER BY count DESC
                    LIMIT 5
                """))
                
                for row in property_stats:
                    prop_type, count = row
                    print(f"   {prop_type:<20}: {count:>3} entries")
            
            else:
                print("\n📭 No data found in gold standard tables")
                print("💡 Run the gold standard extraction to populate tables")
    
    except Exception as e:
        print(f"❌ Error connecting to Supabase: {e}")
        print(f"🔧 Check your POSTGRES_URL in .env file")
        return
    
    print("\n" + "=" * 60)
    print("✅ Gold standard table inspection complete!")


if __name__ == "__main__":
    inspect_gold_tables()