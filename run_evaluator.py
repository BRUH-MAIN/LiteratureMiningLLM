#!/usr/bin/env python3
"""
Property Relevance Evaluator

This script runs the property relevance evaluation on the database,
comparing extracted properties with abstract/conclusion text using LLM.
"""

import os
import sys
import logging
from datetime import datetime
from pathlib import Path

# Add the app directory to Python path
sys.path.append(os.path.join(os.path.dirname(__file__), 'app'))

from app.analytics import Analytics
from app.config import Config


def setup_logging():
    """Setup logging configuration"""
    # Create logs directory if it doesn't exist
    os.makedirs('logs', exist_ok=True)
    
    # Setup logging
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_filename = f'logs/evaluator_{timestamp}.log'
    
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_filename),
            logging.StreamHandler(sys.stdout)
        ]
    )
    
    return logging.getLogger(__name__)


def main():
    """Main evaluation function"""
    logger = setup_logging()
    
    try:
        logger.info("Starting Property Relevance Evaluation")
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
        os.makedirs('results', exist_ok=True)
        
        # Save evaluation results to CSV
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        csv_path = f'results/property_relevance_evaluation_{timestamp}.csv'
        evaluation_df.to_csv(csv_path, index=False)
        logger.info(f"Evaluation results saved to {csv_path}")
        
        # Generate and save evaluation report
        report_path = f'results/evaluation_report_{timestamp}.txt'
        report = analytics.generate_evaluation_report(evaluation_df, report_path)
        
        # Print summary to console
        logger.info("\n" + "="*50)
        logger.info("EVALUATION SUMMARY")
        logger.info("="*50)
        
        total = len(evaluation_df)
        relevant = evaluation_df['relevance_score'].sum()
        relevance_rate = (relevant / total) * 100 if total > 0 else 0
        
        logger.info(f"Total Evaluations: {total}")
        logger.info(f"Relevant Properties: {relevant}")
        logger.info(f"Relevance Rate: {relevance_rate:.1f}%")
        
        # Show property type breakdown
        if 'property_type' in evaluation_df.columns:
            logger.info("\nRelevance by Property Type:")
            prop_stats = evaluation_df.groupby('property_type').agg({
                'relevance_score': ['count', 'sum']
            })
            
            for prop_type in prop_stats.index:
                count = prop_stats.loc[prop_type, ('relevance_score', 'count')]
                relevant_props = prop_stats.loc[prop_type, ('relevance_score', 'sum')]
                rate = (relevant_props / count) * 100 if count > 0 else 0
                logger.info(f"  {prop_type}: {relevant_props}/{count} ({rate:.1f}%)")
        
        logger.info(f"\nDetailed report saved to: {report_path}")
        logger.info("Evaluation completed successfully!")
        
    except Exception as e:
        logger.error(f"Evaluation failed: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
