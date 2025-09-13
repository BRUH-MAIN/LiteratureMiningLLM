"""
Main runner for the Literature Mining LLM application
"""

import logging
import sys
import argparse
from pathlib import Path
from datetime import datetime

# Add the project root to Python path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

from app.preprocessor import Preprocessor
from app.extractor import Extractor  
from app.validator import Validator
from app.validator_agent import ValidatorAgent  # New hallucination detection agent
from app.db_loader import DBLoader
from app.analytics import Analytics


def setup_logging():
    """Setup logging configuration"""
    log_dir = project_root / "logs"
    log_dir.mkdir(exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = log_dir / f"literature_mining_{timestamp}.log"
    
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file),
            logging.StreamHandler(sys.stdout)
        ]
    )
    
    logger = logging.getLogger(__name__)
    logger.info(f"Logging setup complete. Log file: {log_file}")
    return logger


def main():
    """Main runner for the literature mining pipeline"""
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Literature Mining LLM Pipeline')
    parser.add_argument('--demo', action='store_true', 
                       help='Run in demo mode (process only 5 papers)')
    parser.add_argument('--demo-count', type=int, default=5,
                       help='Number of papers to process in demo mode (default: 5)')
    parser.add_argument('--llm-provider', choices=['gemini', 'llamacpp'],
                       help='Override LLM provider (gemini or llamacpp)')
    parser.add_argument('--fast', action='store_true',
                       help='Fast mode: skip LLM validation (extraction only)')
    parser.add_argument('--validate-only', action='store_true',
                       help='Validation-only mode: check for issues but do not correct them')
    parser.add_argument('--skip-db', action='store_true',
                       help='Skip database loading and analytics')
    parser.add_argument('--papers', type=int, default=None,
                       help='Number of papers to process (overrides demo mode)')
    
    args = parser.parse_args()
    
    logger = setup_logging()
    logger.info("Starting Literature Mining LLM Pipeline")
    
    # Override config settings based on command line arguments
    from app.config import Config
    if args.demo:
        Config.DEMO_MODE = True
        Config.DEMO_PAPER_COUNT = args.demo_count
        logger.info(f"Demo mode enabled: Processing {Config.DEMO_PAPER_COUNT} papers")
    
    if args.llm_provider:
        Config.LLM_PROVIDER = args.llm_provider
        logger.info(f"LLM provider overridden to: {Config.LLM_PROVIDER}")
    
    # Set fast mode configurations for better performance
    if args.fast or args.demo:
        Config.REQUEST_DELAY = 0.1  # Reduce delay for faster processing
        logger.info("Fast mode enabled: Reduced request delays")
    
    # Determine how many papers to process
    if args.papers:
        papers_limit = args.papers
        logger.info(f"Processing limited to {papers_limit} papers")
    elif args.demo:
        papers_limit = args.demo_count
    else:
        papers_limit = None
    
    try:
        # Initialize all agents
        logger.info("Initializing agents...")
        preprocessor = Preprocessor()
        
        # Initialize extractor with configured LLM provider
        from app.config import Config
        logger.info(f"Using LLM provider: {Config.LLM_PROVIDER}")
        extractor = Extractor()  # Will use Config.LLM_PROVIDER by default
        
        # Initialize validation agents
        validator = Validator()  # Data cleaning and standardization
        validator_agent = ValidatorAgent()  # LLM-based hallucination detection
        db_loader = DBLoader()
        analytics = Analytics()
        
        # 1. Load JSON data
        logger.info("Step 1: Loading JSON data...")
        input_file = project_root / "data" / "processed" / "combined_papers_merged.json"
        
        if not input_file.exists():
            raise FileNotFoundError(f"Input file not found: {input_file}")
        
        papers = preprocessor.load_json_data(str(input_file))
        logger.info(f"Loaded {len(papers)} papers")
        
        # 2. Run preprocessing
        logger.info("Step 2: Running preprocessing...")
        processed_papers = preprocessor.preprocess_papers(papers)
        logger.info(f"Preprocessed {len(processed_papers)} papers")
        
        # Determine papers to process based on arguments
        if papers_limit:
            papers_to_process = processed_papers[:papers_limit]
            logger.info(f"Processing limited to {len(papers_to_process)} papers")
        elif Config.DEMO_MODE:
            demo_papers = processed_papers[:Config.DEMO_PAPER_COUNT]
            logger.info(f"Demo mode: Processing only first {len(demo_papers)} papers")
            papers_to_process = demo_papers
        else:
            logger.info(f"Full processing mode: Processing all {len(processed_papers)} papers")
            papers_to_process = processed_papers
        
        # 3. EXTRACTOR: Extract data using LLM
        logger.info(f"Step 3: EXTRACTOR - Running data extraction with {Config.LLM_PROVIDER.upper()} LLM...")
        extracted_papers = extractor.extract_from_papers(papers_to_process)
        logger.info(f"Extraction completed for {len(extracted_papers)} papers")
        
        # 4. CHECKER: Validate for hallucinations and errors (if not in fast mode)
        if args.fast:
            logger.info("Step 4: CHECKER - Skipped (fast mode enabled)")
            checked_papers = extracted_papers
        elif args.validate_only:
            logger.info("Step 4: CHECKER - Running validation analysis only (no corrections)...")
            checked_papers = []
            validation_stats = {"papers_checked": 0, "issues_found": 0, "papers_with_issues": 0}
            
            for paper in extracted_papers:
                if paper.get('extraction_failed', False):
                    checked_papers.append(paper)
                    continue
                    
                title = paper.get('title', '')
                abstract = paper.get('abstract', '')
                conclusion = paper.get('conclusion', '')
                extracted_data = paper.get('extracted_data', {})
                
                # Run validation only (no correction)
                validation_result = validator_agent.validate_extracted_data(
                    title, abstract, conclusion, extracted_data
                )
                
                # Update paper with validation results but keep original data
                paper_with_validation = paper.copy()
                if validation_result:
                    paper_with_validation['validation_result'] = validation_result
                    issues_count = len(validation_result.get('issues_found', []))
                    validation_stats["issues_found"] += issues_count
                    if issues_count > 0:
                        validation_stats["papers_with_issues"] += 1
                    
                    validation_status = validation_result.get('validation_status', 'UNKNOWN')
                    logger.info(f"Paper: {title[:50]}... - Status: {validation_status}, Issues: {issues_count}")
                
                validation_stats["papers_checked"] += 1
                checked_papers.append(paper_with_validation)
                
            logger.info(f"Validation-only completed for {len(checked_papers)} papers")
            logger.info(f"Validation Statistics: {validation_stats}")
        else:
            logger.info("Step 4: CHECKER - Running hallucination detection and error checking...")
            checked_papers = []
            for paper in extracted_papers:
                if paper.get('extraction_failed', False):
                    checked_papers.append(paper)
                    continue
                    
                title = paper.get('title', '')
                abstract = paper.get('abstract', '')
                conclusion = paper.get('conclusion', '')
                extracted_data = paper.get('extracted_data', {})
                
                # Run validation and correction
                final_data, validation_summary = validator_agent.validate_and_correct(
                    title, abstract, conclusion, extracted_data
                )
                
                # Update paper with corrected data
                paper_corrected = paper.copy()
                paper_corrected['extracted_data'] = final_data
                paper_corrected['validation_summary'] = validation_summary
                checked_papers.append(paper_corrected)
                
            logger.info(f"Checking completed for {len(checked_papers)} papers")
        
        # 5. FORMATTER: Clean and standardize data format
        logger.info("Step 5: FORMATTER - Running data formatting and standardization...")
        formatted_papers = validator.validate_papers(checked_papers)
        logger.info(f"Formatting completed for {len(formatted_papers)} papers")
        
        if args.skip_db:
            logger.info("Skipping database and analytics steps (--skip-db flag)")
            logger.info("Pipeline completed successfully!")
            return
        
        # 6. Insert into PostgreSQL
        logger.info("Step 6: Loading data into PostgreSQL...")
        load_stats = db_loader.load_papers_to_database(formatted_papers)
        logger.info(f"Database loading completed. Stats: {load_stats}")
        
        # 7. Run analytics queries
        logger.info("Step 7: Running analytics...")
        
        # Get database statistics
        db_stats = db_loader.get_database_stats()
        logger.info(f"Database statistics: {db_stats}")
        
        # Generate summary report
        summary_report = analytics.generate_summary_report()
        logger.info("Summary Report:")
        logger.info(summary_report)
        
        # Export results
        output_dir = project_root / "results"
        output_dir.mkdir(exist_ok=True)
        
        # Save summary report
        report_file = output_dir / f"summary_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
        with open(report_file, 'w') as f:
            f.write(summary_report)
        logger.info(f"Summary report saved to {report_file}")
        
        # Export data to CSV
        analytics.export_data_to_csv(str(output_dir))
        
        # Generate visualizations
        try:
            analytics.plot_conductivity_histogram(str(output_dir / "conductivity_histogram.png"))
            analytics.plot_mxene_composition_distribution(str(output_dir / "mxene_composition_distribution.png"))
            logger.info("Visualizations generated")
        except Exception as e:
            logger.warning(f"Visualization error: {e}")
        
        logger.info("Pipeline completed successfully!")
        
    except Exception as e:
        logger.error(f"Pipeline error: {e}")
        raise


if __name__ == "__main__":
    main()
