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


def run_evaluator():
    """Run property relevance evaluation"""
    logger = setup_logging()
    logger.info("Starting Property Relevance Evaluation")
    
    try:
        from app.config import Config
        logger.info(f"Using LLM Provider: {Config.LLM_PROVIDER}")
        
        # Create analytics instance
        analytics = Analytics()
        
        # Run evaluation
        logger.info("Running property relevance evaluation...")
        evaluation_df = analytics.evaluate_property_relevance(batch_size=3)
        
        if evaluation_df.empty:
            logger.warning("No evaluation results generated")
            return
        
        # Create results directory
        output_dir = project_root / "results"
        output_dir.mkdir(exist_ok=True)
        
        # Save evaluation results to CSV
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        csv_path = output_dir / f"property_relevance_evaluation_{timestamp}.csv"
        evaluation_df.to_csv(csv_path, index=False)
        logger.info(f"Evaluation results saved to {csv_path}")
        
        # Generate and save evaluation report
        report_path = output_dir / f"evaluation_report_{timestamp}.txt"
        report = analytics.generate_evaluation_report(evaluation_df, str(report_path))
        
        # Print summary
        total = len(evaluation_df)
        relevant = evaluation_df['relevance_score'].sum()
        relevance_rate = (relevant / total) * 100 if total > 0 else 0
        
        logger.info("\n" + "="*50)
        logger.info("EVALUATION SUMMARY")
        logger.info("="*50)
        logger.info(f"Total Evaluations: {total}")
        logger.info(f"Relevant Properties: {relevant}")
        logger.info(f"Relevance Rate: {relevance_rate:.1f}%")
        logger.info(f"Detailed report saved to: {report_path}")
        logger.info("Evaluation completed successfully!")
        
    except Exception as e:
        logger.error(f"Evaluation failed: {e}")
        raise


def main():
    """Main runner for the literature mining pipeline"""
    logger = setup_logging()
    logger.info("Starting Literature Mining LLM Pipeline")
    
    try:
        # Initialize all agents
        logger.info("Initializing agents...")
        preprocessor = Preprocessor()
        
        # Initialize extractor with configured LLM provider
        from app.config import Config
        logger.info(f"Using LLM provider: {Config.LLM_PROVIDER}")
        extractor = Extractor()  # Will use Config.LLM_PROVIDER by default
        
        validator = Validator()
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
        
        # Check if paper count is configured
        if Config.PAPER_COUNT > 0:
            papers_to_process = processed_papers[:Config.PAPER_COUNT]
            logger.info(f"Processing {len(papers_to_process)} papers (configured limit: {Config.PAPER_COUNT})")
        else:
            papers_to_process = processed_papers
            logger.info(f"Processing all {len(processed_papers)} papers (no limit configured)")
        
        # 3. Run extraction with configured LLM
        logger.info(f"Step 3: Running extraction with {Config.LLM_PROVIDER.upper()} LLM...")
        extracted_papers = extractor.extract_from_papers(papers_to_process)
        logger.info(f"Extraction completed for {len(extracted_papers)} papers")
        
        # 4. Validate results
        logger.info("Step 4: Validating extracted data...")
        validated_papers = validator.validate_papers(extracted_papers)
        logger.info(f"Validation completed for {len(validated_papers)} papers")
        
        # 5. Insert into PostgreSQL
        logger.info("Step 5: Loading data into PostgreSQL...")
        load_stats = db_loader.load_papers_to_database(validated_papers)
        logger.info(f"Database loading completed. Stats: {load_stats}")
        
        # 6. Run analytics queries
        logger.info("Step 6: Running analytics...")
        
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
    parser = argparse.ArgumentParser(description="Literature Mining LLM Pipeline")
    parser.add_argument("--evaluate", action="store_true", 
                       help="Run property relevance evaluation instead of full pipeline")
    
    args = parser.parse_args()
    
    if args.evaluate:
        run_evaluator()
    else:
        main()
