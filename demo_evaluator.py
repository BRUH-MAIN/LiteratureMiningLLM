#!/usr/bin/env python3
"""
Demo script for Property Relevance Evaluator

This script demonstrates how to use the property relevance evaluator
to assess the quality of extracted properties against paper abstracts/conclusions.
"""

import os
import sys
import logging
from datetime import datetime
from pathlib import Path

# Add the project root to Python path
project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

from app.analytics import Analytics
from app.config import Config
from app.models import get_session, Paper, Material, Property


def setup_logging():
    """Setup logging configuration"""
    os.makedirs('logs', exist_ok=True)
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_filename = f'logs/evaluator_demo_{timestamp}.log'
    
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_filename),
            logging.StreamHandler(sys.stdout)
        ]
    )
    
    return logging.getLogger(__name__)


def check_database_status():
    """Check if database has data for evaluation"""
    logger = logging.getLogger(__name__)
    
    try:
        session = get_session()
        
        # Count papers, materials, and properties
        paper_count = session.query(Paper).count()
        material_count = session.query(Material).count() 
        property_count = session.query(Property).count()
        
        logger.info(f"Database status:")
        logger.info(f"  Papers: {paper_count}")
        logger.info(f"  Materials: {material_count}")
        logger.info(f"  Properties: {property_count}")
        
        if paper_count == 0:
            logger.warning("No papers found in database. Run the main pipeline first.")
            return False
        
        if property_count == 0:
            logger.warning("No properties found in database. Run the extraction pipeline first.")
            return False
        
        # Check for papers with both abstract/conclusion and properties
        papers_with_text = session.query(Paper).filter(
            (Paper.abstract.isnot(None)) | (Paper.conclusion.isnot(None))
        ).count()
        
        logger.info(f"  Papers with abstract/conclusion: {papers_with_text}")
        
        if papers_with_text == 0:
            logger.warning("No papers with abstract or conclusion text found.")
            return False
        
        session.close()
        return True
        
    except Exception as e:
        logger.error(f"Error checking database status: {e}")
        return False


def demo_evaluator():
    """Demonstrate the property relevance evaluator"""
    logger = logging.getLogger(__name__)
    
    try:
        logger.info("Property Relevance Evaluator Demo")
        logger.info("=" * 50)
        
        # Check database status
        if not check_database_status():
            logger.error("Database check failed. Please ensure data is loaded first.")
            return
        
        # Initialize analytics
        analytics = Analytics()
        
        # Show current LLM configuration
        logger.info(f"LLM Provider: {Config.LLM_PROVIDER}")
        if Config.LLM_PROVIDER == 'gemini':
            if not Config.GEMINI_API_KEY:
                logger.error("GEMINI_API_KEY not configured. Please set it in your environment.")
                return
            logger.info(f"Gemini Model: {Config.GEMINI_MODEL}")
        elif Config.LLM_PROVIDER == 'groq':
            if not Config.GROQ_API_KEY:
                logger.error("GROQ_API_KEY not configured. Please set it in your environment.")
                return
            logger.info(f"Groq Model: {Config.GROQ_MODEL}")
        elif Config.LLM_PROVIDER == 'llamacpp':
            logger.info(f"Llama.cpp URL: {Config.LLAMACPP_BASE_URL}")
            logger.info(f"Llama.cpp Model: {Config.LLAMACPP_MODEL}")
        
        # Run evaluation on a small batch first
        logger.info("\nRunning evaluation on a small batch (3 papers at a time)...")
        evaluation_df = analytics.evaluate_property_relevance(batch_size=3)
        
        if evaluation_df.empty:
            logger.warning("No evaluation results generated.")
            return
        
        # Display results
        logger.info(f"\nEvaluation completed!")
        logger.info(f"Total property-paper combinations evaluated: {len(evaluation_df)}")
        
        # Calculate summary statistics
        total = len(evaluation_df)
        relevant = evaluation_df['relevance_score'].sum()
        relevance_rate = (relevant / total) * 100 if total > 0 else 0
        
        logger.info(f"Relevant properties: {relevant}/{total} ({relevance_rate:.1f}%)")
        
        # Show breakdown by property type
        if 'property_type' in evaluation_df.columns:
            logger.info("\nBreakdown by property type:")
            prop_stats = evaluation_df.groupby('property_type').agg({
                'relevance_score': ['count', 'sum']
            })
            
            for prop_type in prop_stats.index:
                count = prop_stats.loc[prop_type, ('relevance_score', 'count')]
                relevant_props = prop_stats.loc[prop_type, ('relevance_score', 'sum')]
                rate = (relevant_props / count) * 100 if count > 0 else 0
                logger.info(f"  {prop_type}: {relevant_props}/{count} ({rate:.1f}%)")
        
        # Show some examples
        logger.info("\nSample results:")
        
        # Show a few relevant examples
        relevant_examples = evaluation_df[evaluation_df['relevance_score'] == 1].head(3)
        if not relevant_examples.empty:
            logger.info("✓ Relevant properties:")
            for _, row in relevant_examples.iterrows():
                logger.info(f"  Paper {row['paper_id']}: {row['property_type']}")
                if 'reasoning' in row and row['reasoning']:
                    logger.info(f"    Reason: {row['reasoning']}")
        
        # Show a few irrelevant examples
        irrelevant_examples = evaluation_df[evaluation_df['relevance_score'] == 0].head(3)
        if not irrelevant_examples.empty:
            logger.info("✗ Irrelevant properties:")
            for _, row in irrelevant_examples.iterrows():
                logger.info(f"  Paper {row['paper_id']}: {row['property_type']}")
                if 'reasoning' in row and row['reasoning']:
                    logger.info(f"    Reason: {row['reasoning']}")
        
        # Save results
        os.makedirs('results', exist_ok=True)
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # Save CSV
        csv_path = f'results/evaluation_demo_{timestamp}.csv'
        evaluation_df.to_csv(csv_path, index=False)
        logger.info(f"\nResults saved to: {csv_path}")
        
        # Generate and save report
        report_path = f'results/evaluation_report_demo_{timestamp}.txt'
        report = analytics.generate_evaluation_report(evaluation_df, report_path)
        logger.info(f"Detailed report saved to: {report_path}")
        
        logger.info("\nDemo completed successfully!")
        logger.info("You can now run the full evaluation with: python main.py --evaluate")
        
    except Exception as e:
        logger.error(f"Demo failed: {e}")
        raise


def main():
    """Main demo function"""
    logger = setup_logging()
    
    try:
        demo_evaluator()
    except KeyboardInterrupt:
        logger.info("Demo interrupted by user")
    except Exception as e:
        logger.error(f"Demo error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
