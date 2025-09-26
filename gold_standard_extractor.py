"""
Gold Standard Extraction Script for Literature Mining LLM

This script extracts structured data from research papers with strict Gemini API rate limiting
and stores results in a separate gold-standard database.

Rate Limits for Gemini 2.5 Pro:
- 5 RPM (Requests Per Minute)
- 250,000 TPM (Tokens Per Minute) 
- 100 RPD (Requests Per Day)
"""

import json
import logging
import sys
import time
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Any, Optional
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

# Add the project root to Python path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

from app.config import Config
from app.models import Base, Paper, Material, Property, Application
from app.preprocessor import Preprocessor
from app.extractor import Extractor
from app.validator import Validator
from app.llm_interface import LLMInterface


class RateLimitedExtractor:
    """
    Extraction agent with strict rate limiting for Gemini API
    """
    
    def __init__(self, use_separate_schema: bool = False):
        self.logger = logging.getLogger(__name__)
        
        # Rate limiting parameters for Gemini 2.5 Pro
        self.requests_per_minute = 5
        self.tokens_per_minute = 250000
        self.requests_per_day = 100
        
        # Request tracking
        self.request_times = []
        self.daily_requests = 0
        self.daily_tokens = 0
        self.day_start = datetime.now().date()
        
        # Initialize LLM with Gemini provider
        self.llm = LLMInterface('gemini')
        
        # Setup gold standard database - use same DB but different table names
        self.gold_engine = create_engine(Config.POSTGRES_URL)
        self.gold_session_factory = sessionmaker(bind=self.gold_engine)
        self.use_separate_schema = use_separate_schema
        
        # Create gold standard tables with different names
        self.setup_gold_tables()
        self.logger.info(f"Gold standard tables initialized in Supabase database")
        
    def setup_gold_tables(self):
        """
        Create gold standard tables with 'gold_' prefix in the same database
        """
        with self.gold_engine.connect() as conn:
            # Create gold standard tables based on existing schema but with 'gold_' prefix
            conn.execute(text("""
                -- Create gold_papers table
                CREATE TABLE IF NOT EXISTS gold_papers (
                    paper_id SERIAL PRIMARY KEY,
                    title TEXT,
                    authors TEXT,
                    journal TEXT,
                    year INTEGER,
                    doi_url TEXT UNIQUE,
                    sciencedirect_url TEXT,
                    issn VARCHAR,
                    abstract TEXT,
                    conclusion TEXT,
                    keywords TEXT[]
                );
                
                -- Create gold_materials table
                CREATE TABLE IF NOT EXISTS gold_materials (
                    material_id SERIAL PRIMARY KEY,
                    paper_id INTEGER REFERENCES gold_papers(paper_id) ON DELETE CASCADE,
                    mxene_composition TEXT,
                    composite_material TEXT,
                    synthesis_method TEXT,
                    fabrication_method TEXT
                );
                
                -- Create gold_properties table
                CREATE TABLE IF NOT EXISTS gold_properties (
                    property_id SERIAL PRIMARY KEY,
                    material_id INTEGER REFERENCES gold_materials(material_id) ON DELETE CASCADE,
                    property_type TEXT,
                    value DECIMAL,
                    unit TEXT,
                    test_conditions TEXT
                );
                
                -- Create gold_applications table
                CREATE TABLE IF NOT EXISTS gold_applications (
                    app_id SERIAL PRIMARY KEY,
                    material_id INTEGER REFERENCES gold_materials(material_id) ON DELETE CASCADE,
                    application_type TEXT,
                    metric TEXT,
                    value DECIMAL,
                    unit TEXT,
                    notes TEXT
                );
                
                -- Create indexes for better performance
                CREATE INDEX IF NOT EXISTS idx_gold_materials_paper_id ON gold_materials(paper_id);
                CREATE INDEX IF NOT EXISTS idx_gold_properties_material_id ON gold_properties(material_id);
                CREATE INDEX IF NOT EXISTS idx_gold_applications_material_id ON gold_applications(material_id);
                CREATE INDEX IF NOT EXISTS idx_gold_papers_doi ON gold_papers(doi_url);
            """))
            conn.commit()
            self.logger.info("Gold standard tables created successfully")
        
    def check_rate_limits(self, estimated_tokens: int = 1000):
        """
        Check and enforce rate limits before making API request
        """
        current_time = time.time()
        current_date = datetime.now().date()
        
        # Reset daily counters if new day
        if current_date > self.day_start:
            self.daily_requests = 0
            self.daily_tokens = 0
            self.day_start = current_date
            self.logger.info("Daily counters reset for new day")
        
        # Check daily limits first
        if self.daily_requests >= self.requests_per_day:
            raise Exception(f"Daily request limit reached ({self.requests_per_day}). Wait until tomorrow.")
        
        if self.daily_tokens + estimated_tokens > 250000:
            raise Exception(f"Daily token limit would be exceeded. Current: {self.daily_tokens}, Estimated: {estimated_tokens}")
        
        # Remove requests older than 1 minute
        minute_ago = current_time - 60
        self.request_times = [t for t in self.request_times if t > minute_ago]
        
        # Check requests per minute limit
        if len(self.request_times) >= self.requests_per_minute:
            # Calculate wait time until oldest request is > 1 minute old
            wait_time = 61 - (current_time - self.request_times[0])
            self.logger.info(f"Rate limit reached. Waiting {wait_time:.1f} seconds...")
            time.sleep(wait_time)
            
            # Clean up old requests again after waiting
            current_time = time.time()
            minute_ago = current_time - 60
            self.request_times = [t for t in self.request_times if t > minute_ago]
        
        return True
    
    def make_rate_limited_request(self, prompt: str) -> Optional[str]:
        """
        Make an API request with rate limiting
        """
        # Estimate tokens (rough approximation: ~4 characters per token)
        estimated_tokens = len(prompt) // 4 + 500  # Add buffer for response
        
        try:
            # Check rate limits
            self.check_rate_limits(estimated_tokens)
            
            # Record request time
            request_time = time.time()
            self.request_times.append(request_time)
            
            # Make the request
            self.logger.info(f"Making API request (daily: {self.daily_requests + 1}/{self.requests_per_day})")
            response = self.llm.generate_response(prompt)
            
            # Update counters
            self.daily_requests += 1
            self.daily_tokens += estimated_tokens
            
            self.logger.info(f"Request successful. Daily tokens used: {self.daily_tokens}")
            return response
            
        except Exception as e:
            self.logger.error(f"Rate limited request failed: {e}")
            return None
    
    def extract_paper_data(self, paper: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Extract structured data from a single paper with rate limiting
        """
        title = paper.get('title', '')
        abstract = paper.get('abstract', '')
        conclusion = paper.get('conclusion', '')
        
        if not abstract or not conclusion:
            self.logger.warning(f"Skipping paper due to missing abstract/conclusion: {title[:50]}...")
            return None
        
        # Create extraction prompt (reusing existing logic from Extractor)
        extractor = Extractor('gemini')
        prompt = extractor.create_extraction_prompt(title, abstract, conclusion)
        
        # Make rate-limited request
        response = self.make_rate_limited_request(prompt)
        
        if response:
            try:
                # Parse JSON response
                extracted_data = self.llm.extract_json_from_response(response)
                if extracted_data:
                    self.logger.info(f"Successfully extracted data for: {title[:50]}...")
                    return extracted_data
                else:
                    self.logger.warning(f"Failed to parse JSON response for: {title[:50]}...")
                    return None
            except Exception as e:
                self.logger.error(f"Error parsing response for {title[:50]}...: {e}")
                return None
        
        return None
    
    def store_extracted_data(self, paper_data: Dict[str, Any], extracted_data: Dict[str, Any]):
        """
        Store extracted data in gold standard tables with 'gold_' prefix
        """
        session = self.gold_session_factory()
        try:
            # Insert paper record into gold_papers table
            paper_insert = text("""
                INSERT INTO gold_papers (title, authors, journal, year, doi_url, 
                                       sciencedirect_url, issn, abstract, conclusion, keywords)
                VALUES (:title, :authors, :journal, :year, :doi_url, 
                       :sciencedirect_url, :issn, :abstract, :conclusion, :keywords)
                RETURNING paper_id
            """)
            
            result = session.execute(paper_insert, {
                'title': paper_data.get('title'),
                'authors': paper_data.get('authors'),
                'journal': paper_data.get('journal'),
                'year': paper_data.get('year'),
                'doi_url': paper_data.get('doi_url'),
                'sciencedirect_url': paper_data.get('sciencedirect_url'),
                'issn': paper_data.get('issn'),
                'abstract': paper_data.get('abstract'),
                'conclusion': paper_data.get('conclusion'),
                'keywords': paper_data.get('keywords', [])
            })
            
            paper_id = result.fetchone()[0]
            
            # Store materials
            for material_data in extracted_data.get('materials', []):
                material_insert = text("""
                    INSERT INTO gold_materials (paper_id, mxene_composition, composite_material,
                                              synthesis_method, fabrication_method)
                    VALUES (:paper_id, :mxene_composition, :composite_material,
                           :synthesis_method, :fabrication_method)
                    RETURNING material_id
                """)
                
                material_result = session.execute(material_insert, {
                    'paper_id': paper_id,
                    'mxene_composition': material_data.get('mxene_composition'),
                    'composite_material': material_data.get('composite_material'),
                    'synthesis_method': material_data.get('synthesis_method'),
                    'fabrication_method': material_data.get('fabrication_method')
                })
                
                material_id = material_result.fetchone()[0]
                
                # Store properties for this material
                for prop_data in extracted_data.get('properties', []):
                    prop_insert = text("""
                        INSERT INTO gold_properties (material_id, property_type, value, unit, test_conditions)
                        VALUES (:material_id, :property_type, :value, :unit, :test_conditions)
                    """)
                    
                    session.execute(prop_insert, {
                        'material_id': material_id,
                        'property_type': prop_data.get('property_type'),
                        'value': prop_data.get('value'),
                        'unit': prop_data.get('unit'),
                        'test_conditions': prop_data.get('test_conditions')
                    })
                
                # Store applications for this material
                for app_data in extracted_data.get('applications', []):
                    app_insert = text("""
                        INSERT INTO gold_applications (material_id, application_type, metric, value, unit, notes)
                        VALUES (:material_id, :application_type, :metric, :value, :unit, :notes)
                    """)
                    
                    session.execute(app_insert, {
                        'material_id': material_id,
                        'application_type': app_data.get('application_type'),
                        'metric': app_data.get('metric'),
                        'value': app_data.get('value'),
                        'unit': app_data.get('unit'),
                        'notes': app_data.get('notes')
                    })
            
            session.commit()
            self.logger.info(f"Successfully stored data for paper: {paper_data.get('title', 'Unknown')[:50]}...")
            
        except Exception as e:
            session.rollback()
            self.logger.error(f"Error storing data: {e}")
            raise
        finally:
            session.close()


def setup_logging():
    """Setup logging configuration"""
    log_dir = Path("logs")
    log_dir.mkdir(exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = log_dir / f"gold_standard_extraction_{timestamp}.log"
    
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file),
            logging.StreamHandler(sys.stdout)
        ]
    )


def main():
    """
    Main execution function for gold standard extraction
    """
    setup_logging()
    logger = logging.getLogger(__name__)
    
    logger.info("Starting Gold Standard Literature Mining Extraction")
    logger.info("Rate Limits: 5 RPM, 250K TPM, 100 RPD")
    
    # Configuration
    paper_limit = 50  # Process only 50 papers
    
    logger.info(f"Using Supabase database with gold standard tables (gold_ prefix)")
    
    try:
        # Initialize rate-limited extractor (uses same DB, different tables)
        extractor = RateLimitedExtractor()
        
        # Load and preprocess data
        logger.info("Loading and preprocessing paper data...")
        preprocessor = Preprocessor()
        
        # Load JSON data
        input_file = Path(Config.DATA_DIR) / Config.INPUT_FILE
        papers = preprocessor.load_json_data(str(input_file))
        
        # Preprocess papers
        papers = preprocessor.preprocess_papers(papers)
        
        # Limit to first 50 papers
        papers = papers[:paper_limit]
        logger.info(f"Processing {len(papers)} papers for gold standard dataset")
        
        # Initialize validator
        validator = Validator()
        
        # Process papers with rate limiting
        processed_count = 0
        failed_count = 0
        
        start_time = time.time()
        
        for i, paper in enumerate(papers):
            logger.info(f"\n--- Processing paper {i+1}/{len(papers)} ---")
            logger.info(f"Title: {paper.get('title', 'N/A')[:100]}...")
            
            try:
                # Extract data with rate limiting
                extracted_data = extractor.extract_paper_data(paper)
                
                if extracted_data:
                    # Validate extracted data - format like the main extractor does
                    paper_with_extraction = paper.copy()
                    paper_with_extraction['extracted_data'] = extracted_data
                    
                    validated_papers = validator.validate_papers([paper_with_extraction])
                    
                    if validated_papers and len(validated_papers) > 0:
                        validated_data = validated_papers[0]['extracted_data']
                        # Store in gold standard database
                        extractor.store_extracted_data(paper, validated_data)
                        processed_count += 1
                        logger.info(f"✅ Successfully processed paper {i+1}")
                    else:
                        failed_count += 1
                        logger.warning(f"❌ Validation failed for paper {i+1}")
                else:
                    failed_count += 1
                    logger.warning(f"❌ Failed to extract data for paper {i+1}")
                
            except Exception as e:
                failed_count += 1
                logger.error(f"❌ Error processing paper {i+1}: {e}")
                
                # If it's a rate limit error, we should stop
                if "Daily request limit" in str(e) or "Daily token limit" in str(e):
                    logger.error("Daily limits reached. Stopping extraction.")
                    break
        
        # Summary
        elapsed_time = time.time() - start_time
        logger.info(f"\n=== EXTRACTION COMPLETE ===")
        logger.info(f"Total papers processed: {processed_count}")
        logger.info(f"Failed extractions: {failed_count}")
        logger.info(f"Success rate: {processed_count/(processed_count+failed_count)*100:.1f}%")
        logger.info(f"Total time: {elapsed_time/60:.1f} minutes")
        logger.info(f"Average time per paper: {elapsed_time/len(papers):.1f} seconds")
        logger.info(f"Daily requests used: {extractor.daily_requests}/{extractor.requests_per_day}")
        logger.info(f"Daily tokens used: {extractor.daily_tokens}/250000")
        
        # Generate summary report
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        report_file = Path("results") / f"gold_standard_report_{timestamp}.txt"
        report_file.parent.mkdir(exist_ok=True)
        
        with open(report_file, 'w') as f:
            f.write("Gold Standard Literature Mining Extraction Report\n")
            f.write("=" * 50 + "\n\n")
            f.write(f"Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"Papers processed: {processed_count}\n")
            f.write(f"Failed extractions: {failed_count}\n")
            f.write(f"Success rate: {processed_count/(processed_count+failed_count)*100:.1f}%\n")
            f.write(f"Total time: {elapsed_time/60:.1f} minutes\n")
            f.write(f"Average time per paper: {elapsed_time/len(papers):.1f} seconds\n")
            f.write(f"Daily requests used: {extractor.daily_requests}/{extractor.requests_per_day}\n")
            f.write(f"Daily tokens used: {extractor.daily_tokens}/250000\n")
            f.write(f"Database: Supabase with gold standard tables (gold_ prefix)\n")
        
        logger.info(f"Report saved to: {report_file}")
        
    except Exception as e:
        logger.error(f"Fatal error in main execution: {e}")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())