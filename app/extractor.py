"""
Extraction Agent using configurable LLM providers

This module handles:
- Using multiple LLM providers (Gemini, Llama.cpp) with schema-guided prompts
- Extracting materials, properties, applications from abstract + conclusion
- Ensuring output follows normalized JSON schema
"""

import json
import logging
from typing import List, Dict, Any, Optional
import time

from app.llm_interface import LLMInterface
from app.prompt_loader import prompt_loader
from app.config import Config


class Extractor:
    """Extraction agent using configurable LLM providers for structured data extraction"""
    
    def __init__(self, llm_provider: str = None):
        self.logger = logging.getLogger(__name__)
        self.llm = LLMInterface(llm_provider)
        
        # Log which provider is being used
        provider_info = self.llm.get_provider_info()
        self.logger.info(f"Initialized extractor with {provider_info['provider']} - {provider_info.get('model', 'N/A')}")
        
    def setup_gemini(self):
        """Deprecated method - keeping for backward compatibility"""
        self.logger.warning("setup_gemini() is deprecated. LLM initialization is now handled by LLMInterface")
        pass
    
    def create_extraction_prompt(self, title: str, abstract: str, conclusion: str) -> str:
        """Create a schema-guided prompt for data extraction from loaded prompt file"""
        
        # Load prompt from file and format with paper data
        formatted_prompt = prompt_loader.format_prompt(
            "extraction_prompt",
            title=title,
            abstract=abstract,
            conclusion=conclusion
        )
        
        if not formatted_prompt:
            self.logger.error("Failed to load extraction prompt from file")
            # Fallback to a basic prompt if file loading fails
            return f"""
Extract structured data from this MXene research paper:
TITLE: {title}
ABSTRACT: {abstract}
CONCLUSION: {conclusion}

Return a JSON object with materials, properties, and applications data.
"""
        
        return formatted_prompt
    
    def extract_and_validate_data(self, title: str, abstract: str, conclusion: str, validator_agent=None) -> Optional[Dict[str, Any]]:
        """Extract data and optionally validate with validator agent"""
        # First, do normal extraction
        extracted_data = self.extract_data_from_text(title, abstract, conclusion)
        
        if not extracted_data:
            return None
        
        # If validator agent is provided, run validation and correction
        if validator_agent:
            try:
                final_data, validation_summary = validator_agent.validate_and_correct(
                    title, abstract, conclusion, extracted_data
                )
                
                # Add validation metadata to the result
                result = final_data.copy()
                result['_validation_summary'] = validation_summary
                
                return result
                
            except Exception as e:
                self.logger.error(f"Error during validation for paper: {title[:50]}...: {e}")
                # Return original extraction if validation fails
                return extracted_data
        
        return extracted_data
    
    def extract_data_from_text(self, title: str, abstract: str, conclusion: str) -> Optional[Dict[str, Any]]:
        """Extract structured data from paper text using configured LLM"""
        try:
            # Combine abstract and conclusion for better context
            combined_text = f"{abstract}\n\n{conclusion}"
            
            # Skip if text is too short or missing
            if len(combined_text.strip()) < 100:
                self.logger.warning(f"Insufficient text for extraction in paper: {title[:50]}...")
                return None
            
            prompt = self.create_extraction_prompt(title, abstract, conclusion)
            
            # Call LLM API through unified interface
            response_text = self.llm.generate_response(prompt)
            
            if not response_text:
                self.logger.error(f"Empty response from LLM for paper: {title[:50]}...")
                return None
            
            self.logger.debug(f"Raw LLM response: {response_text[:200]}...")
            
            # Parse JSON response using the unified interface
            extracted_data = self.llm.extract_json_from_response(response_text)
            
            if extracted_data:
                self.logger.debug(f"Successfully extracted data for paper: {title[:50]}...")
                return extracted_data
            else:
                self.logger.error(f"Failed to parse JSON from LLM response for paper: {title[:50]}...")
                return None
                
        except Exception as e:
            self.logger.error(f"Error extracting data for paper {title[:50]}...: {e}")
            return None
    
    def extract_from_papers(self, papers: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Extract data from multiple papers"""
        extracted_papers = []
        failed_count = 0
        
        self.logger.info(f"Starting extraction for {len(papers)} papers using {self.llm.get_provider_info()['provider']}...")
        self.logger.info(f"Estimated processing time: {len(papers) * 3 / 60:.1f} minutes")
        
        for i, paper in enumerate(papers):
            # Progress indicator every 10 papers
            if i % 10 == 0 and i > 0:
                progress = (i / len(papers)) * 100
                self.logger.info(f"Progress: {i}/{len(papers)} papers ({progress:.1f}%) - Success rate: {((i - failed_count) / i * 100):.1f}%")
            
            self.logger.info(f"Processing paper {i+1}/{len(papers)}: {paper.get('title', 'Unknown')[:50]}...")
            
            try:
                title = paper.get('title', '')
                abstract = paper.get('abstract', '')
                conclusion = paper.get('conclusion', '')
                
                # Extract structured data
                extracted_data = self.extract_data_from_text(title, abstract, conclusion)
                
                if extracted_data:
                    # Combine original paper metadata with extracted data
                    paper_with_extraction = paper.copy()
                    paper_with_extraction['extracted_data'] = extracted_data
                    extracted_papers.append(paper_with_extraction)
                else:
                    # Still include paper but mark as failed extraction
                    paper_with_extraction = paper.copy()
                    paper_with_extraction['extracted_data'] = {
                        "materials": [],
                        "properties": [],
                        "applications": []
                    }
                    paper_with_extraction['extraction_failed'] = True
                    extracted_papers.append(paper_with_extraction)
                    failed_count += 1
                
                # Add small delay to respect API rate limits
                if i < len(papers) - 1:  # Don't delay after the last paper
                    time.sleep(Config.REQUEST_DELAY)  # 500ms delay between requests
                    
            except Exception as e:
                self.logger.error(f"Error processing paper {i+1}: {e}")
                # Still include paper with empty extraction
                paper_with_extraction = paper.copy()
                paper_with_extraction['extracted_data'] = {
                    "materials": [],
                    "properties": [],
                    "applications": []
                }
                paper_with_extraction['extraction_failed'] = True
                extracted_papers.append(paper_with_extraction)
                failed_count += 1
                continue
        
        success_rate = ((len(extracted_papers) - failed_count) / len(extracted_papers) * 100) if extracted_papers else 0
        self.logger.info(f"Extraction completed for {len(extracted_papers)} papers")
        self.logger.info(f"Successfully extracted: {len(extracted_papers) - failed_count}, Failed: {failed_count}")
        self.logger.info(f"Overall success rate: {success_rate:.1f}%")
        return extracted_papers
    
    def extract_from_papers_with_validation(self, papers: List[Dict[str, Any]], validator_agent=None) -> List[Dict[str, Any]]:
        """
        Extract data from multiple papers with optional validation
        
        Args:
            papers: List of paper dictionaries
            validator_agent: Optional ValidatorAgent for hallucination detection
            
        Returns:
            List of papers with extracted data and validation results
        """
        if not papers:
            self.logger.warning("No papers provided for extraction")
            return []
        
        self.logger.info(f"Starting extraction from {len(papers)} papers")
        if validator_agent:
            self.logger.info("Validation and correction enabled")
        
        extracted_papers = []
        failed_count = 0
        validation_summaries = []
        
        for i, paper in enumerate(papers):
            try:
                self.logger.info(f"Processing paper {i+1}/{len(papers)}: {paper.get('title', 'Unknown')[:50]}...")
                
                title = paper.get('title', '')
                abstract = paper.get('abstract', '')
                conclusion = paper.get('conclusion', '')
                
                # Extract data with validation if validator agent provided
                extracted_data = self.extract_and_validate_data(title, abstract, conclusion, validator_agent)
                
                if extracted_data:
                    # Extract validation summary if present
                    validation_summary = extracted_data.pop('_validation_summary', None)
                    if validation_summary:
                        validation_summaries.append(validation_summary)
                    
                    # Combine original paper metadata with extracted data
                    paper_with_extraction = paper.copy()
                    paper_with_extraction['extracted_data'] = extracted_data
                    
                    # Add validation metadata if available
                    if validation_summary:
                        paper_with_extraction['validation_summary'] = validation_summary
                    
                    extracted_papers.append(paper_with_extraction)
                else:
                    # Still include paper but mark as failed extraction
                    paper_with_extraction = paper.copy()
                    paper_with_extraction['extracted_data'] = {
                        "materials": [],
                        "properties": [],
                        "applications": []
                    }
                    paper_with_extraction['extraction_failed'] = True
                    extracted_papers.append(paper_with_extraction)
                    failed_count += 1
                
                # Add small delay to respect API rate limits
                if i < len(papers) - 1:  # Don't delay after the last paper
                    time.sleep(Config.REQUEST_DELAY)  # 500ms delay between requests
                    
            except Exception as e:
                self.logger.error(f"Error processing paper {i+1}: {e}")
                # Still include paper with empty extraction
                paper_with_extraction = paper.copy()
                paper_with_extraction['extracted_data'] = {
                    "materials": [],
                    "properties": [],
                    "applications": []
                }
                paper_with_extraction['extraction_failed'] = True
                extracted_papers.append(paper_with_extraction)
                failed_count += 1
                continue
        
        success_rate = ((len(extracted_papers) - failed_count) / len(extracted_papers) * 100) if extracted_papers else 0
        self.logger.info(f"Extraction completed for {len(extracted_papers)} papers")
        self.logger.info(f"Successfully extracted: {len(extracted_papers) - failed_count}, Failed: {failed_count}")
        self.logger.info(f"Overall success rate: {success_rate:.1f}%")
        
        # Log validation statistics if validation was performed
        if validator_agent and validation_summaries:
            validation_stats = validator_agent.get_validation_stats(validation_summaries)
            self.logger.info("Validation Statistics:")
            self.logger.info(f"  Validation rate: {validation_stats.get('validation_rate', 0):.2%}")
            self.logger.info(f"  Correction rate: {validation_stats.get('correction_rate', 0):.2%}")
            self.logger.info(f"  Average issues per paper: {validation_stats.get('avg_issues_per_paper', 0):.1f}")
            self.logger.info(f"  Status distribution: {validation_stats.get('status_distribution', {})}")
        
        return extracted_papers
