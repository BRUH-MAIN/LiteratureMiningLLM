"""
Database Loader Agent for Literature Mining

This module handles:
- Using psycopg2/SQLAlchemy to connect to PostgreSQL
- Inserting data into normalized schema (papers, materials, properties, applications)
- Handling database operations and transactions
- Creating schema if not exists and truncating on each run
"""

import logging
from typing import List, Dict, Any, Optional
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError, IntegrityError
from app.models import Paper, Material, Property, Application, get_session, create_all_tables
from app.config import Config


class DBLoader:
    """Database loader agent for storing processed data in PostgreSQL"""
    
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        
    def ensure_tables_exist(self, truncate=True):
        """Ensure all database tables exist and optionally truncate them"""
        try:
            # Create tables if they don't exist
            create_all_tables()
            self.logger.info("Database tables ensured to exist")
            
            # Truncate existing data if requested
            if truncate:
                self.truncate_all_tables()
                
        except Exception as e:
            self.logger.error(f"Error creating database tables: {e}")
            raise
    
    def truncate_all_tables(self):
        """Truncate all tables to clear existing data"""
        session = get_session()
        
        try:
            # Delete in reverse order due to foreign key constraints
            deleted_apps = session.query(Application).count()
            deleted_props = session.query(Property).count()
            deleted_materials = session.query(Material).count()
            deleted_papers = session.query(Paper).count()
            
            session.query(Application).delete()
            session.query(Property).delete()
            session.query(Material).delete()
            session.query(Paper).delete()
            
            session.commit()
            
            self.logger.info(f"Truncated all tables - Removed: {deleted_papers} papers, "
                           f"{deleted_materials} materials, {deleted_props} properties, "
                           f"{deleted_apps} applications")
            
        except Exception as e:
            session.rollback()
            self.logger.error(f"Error truncating tables: {e}")
            raise
        finally:
            session.close()
    
    def insert_paper(self, session: Session, paper_data: Dict[str, Any]) -> Optional[Paper]:
        """Insert a single paper into the database"""
        try:
            # Since we truncate on each run, no need to check for existing papers
            doi_url = paper_data.get('doi_url', '').strip()
            
            # Create new paper record
            paper = Paper(
                title=paper_data.get('title', ''),
                authors=paper_data.get('authors', ''),
                journal=paper_data.get('journal', ''),
                year=paper_data.get('year'),
                doi_url=doi_url,
                sciencedirect_url=paper_data.get('sciencedirect_url', ''),
                issn=paper_data.get('issn', ''),
                abstract=paper_data.get('abstract', ''),
                conclusion=paper_data.get('conclusion', ''),
                keywords=paper_data.get('keywords', [])
            )
            
            session.add(paper)
            session.flush()  # Get the paper_id without committing
            
            self.logger.debug(f"Inserted paper: {paper_data.get('title', 'Unknown')[:50]}...")
            return paper
            
        except Exception as e:
            session.rollback()
            self.logger.error(f"Error inserting paper: {e}")
            return None
    
    def insert_materials(self, session: Session, paper: Paper, 
                        materials_data: List[Dict[str, Any]]) -> List[Material]:
        """Insert materials for a paper"""
        materials = []
        
        for material_data in materials_data:
            try:
                material = Material(
                    paper_id=paper.paper_id,
                    mxene_composition=material_data.get('mxene_composition', ''),
                    composite_material=material_data.get('composite_material', ''),
                    synthesis_method=material_data.get('synthesis_method', ''),
                    fabrication_method=material_data.get('fabrication_method', '')
                )
                
                session.add(material)
                session.flush()  # Get the material_id
                materials.append(material)
                
            except Exception as e:
                self.logger.error(f"Error inserting material: {e}")
                continue
        
        return materials
    
    def insert_properties(self, session: Session, material: Material, 
                         properties_data: List[Dict[str, Any]]) -> List[Property]:
        """Insert properties for a material"""
        properties = []
        
        for prop_data in properties_data:
            try:
                # Skip if no value
                if prop_data.get('value') is None:
                    continue
                
                property_obj = Property(
                    material_id=material.material_id,
                    property_type=prop_data.get('property_type', ''),
                    value=prop_data.get('value'),
                    unit=prop_data.get('unit', ''),
                    test_conditions=prop_data.get('test_conditions', '')
                )
                
                session.add(property_obj)
                properties.append(property_obj)
                
            except Exception as e:
                self.logger.error(f"Error inserting property: {e}")
                continue
        
        return properties
    
    def insert_applications(self, session: Session, material: Material, 
                           applications_data: List[Dict[str, Any]]) -> List[Application]:
        """Insert applications for a material"""
        applications = []
        
        for app_data in applications_data:
            try:
                application = Application(
                    material_id=material.material_id,
                    application_type=app_data.get('application_type', ''),
                    metric=app_data.get('metric', ''),
                    value=app_data.get('value'),
                    unit=app_data.get('unit', ''),
                    notes=app_data.get('notes', '')
                )
                
                session.add(application)
                applications.append(application)
                
            except Exception as e:
                self.logger.error(f"Error inserting application: {e}")
                continue
        
        return applications
    
    def insert_single_paper_data(self, session: Session, paper_data: Dict[str, Any]) -> bool:
        """Insert complete data for a single paper"""
        try:
            # Insert paper
            paper = self.insert_paper(session, paper_data)
            if not paper:
                return False
            
            # Get extracted data
            extracted_data = paper_data.get('extracted_data', {})
            if not extracted_data:
                self.logger.warning(f"No extracted data for paper: {paper_data.get('title', 'Unknown')[:50]}...")
                return True  # Paper inserted successfully, but no extracted data
            
            # Insert materials
            materials_data = extracted_data.get('materials', [])
            if not materials_data:
                # Create a default material entry if no materials found
                materials_data = [{}]
            
            materials = self.insert_materials(session, paper, materials_data)
            
            # For each material, insert properties and applications
            for i, material in enumerate(materials):
                # Insert properties
                properties_data = extracted_data.get('properties', [])
                if i == 0:  # Associate all properties with first material
                    self.insert_properties(session, material, properties_data)
                
                # Insert applications
                applications_data = extracted_data.get('applications', [])
                if i == 0:  # Associate all applications with first material
                    self.insert_applications(session, material, applications_data)
            
            return True
            
        except Exception as e:
            self.logger.error(f"Error inserting paper data: {e}")
            return False
    
    def load_papers_to_database(self, papers: List[Dict[str, Any]]) -> Dict[str, int]:
        """Load multiple papers to database"""
        # Ensure tables exist and truncate existing data based on config
        truncate = getattr(Config, 'TRUNCATE_ON_RUN', True)
        self.ensure_tables_exist(truncate=truncate)
        
        stats = {
            'total_papers': len(papers),
            'successful_inserts': 0,
            'failed_inserts': 0,
            'skipped_duplicates': 0
        }
        
        session = get_session()
        
        try:
            for i, paper_data in enumerate(papers):
                self.logger.info(f"Loading paper {i+1}/{len(papers)}: {paper_data.get('title', 'Unknown')[:50]}...")
                
                try:
                    success = self.insert_single_paper_data(session, paper_data)
                    
                    if success:
                        stats['successful_inserts'] += 1
                        # Commit after each successful paper
                        session.commit()
                    else:
                        stats['failed_inserts'] += 1
                        session.rollback()
                        
                except IntegrityError:
                    stats['skipped_duplicates'] += 1
                    session.rollback()
                except Exception as e:
                    stats['failed_inserts'] += 1
                    session.rollback()
                    self.logger.error(f"Error processing paper {i+1}: {e}")
                    
        finally:
            session.close()
        
        self.logger.info(f"Database loading completed. Stats: {stats}")
        return stats
    
    def get_database_stats(self) -> Dict[str, int]:
        """Get current database statistics"""
        session = get_session()
        
        try:
            stats = {
                'total_papers': session.query(Paper).count(),
                'total_materials': session.query(Material).count(),
                'total_properties': session.query(Property).count(),
                'total_applications': session.query(Application).count()
            }
            
            return stats
            
        except Exception as e:
            self.logger.error(f"Error getting database stats: {e}")
            return {}
        finally:
            session.close()
    
    def clear_database(self) -> bool:
        """Clear all data from database (for testing)"""
        session = get_session()
        
        try:
            # Delete in reverse order due to foreign key constraints
            session.query(Application).delete()
            session.query(Property).delete()
            session.query(Material).delete()
            session.query(Paper).delete()
            
            session.commit()
            self.logger.info("Database cleared successfully")
            return True
            
        except Exception as e:
            session.rollback()
            self.logger.error(f"Error clearing database: {e}")
            return False
        finally:
            session.close()
