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
from app.prompt_loader import PromptLoader
from app.config import Config


class Extractor:
    """Extraction agent using configurable LLM providers for structured data extraction"""

    def __init__(self, llm_provider: str = None, llm_interface: Optional[LLMInterface] = None):
        self.logger = logging.getLogger(__name__)
        # llm_interface lets callers inject a pre-built LLMInterface wrapping a specific
        # provider variant (e.g. LLMInterface.from_provider(GeminiProvider(model='gemini-3.1-pro',
        # thinking_level='high'), 'gemini')) instead of the single Config-driven default per provider type.
        self.llm = llm_interface or LLMInterface(llm_provider)
        self.prompt_loader = PromptLoader()

        # Log which provider is being used
        provider_info = self.llm.get_provider_info()
        self.logger.info(f"Initialized extractor with {provider_info['provider']} - {provider_info.get('model', 'N/A')}")

    def create_extraction_prompt(self, title: str, abstract: str, conclusion: str) -> str:
        """Create a schema-guided prompt for data extraction from the shared prompts/extraction_prompt.txt template"""
        prompt = self.prompt_loader.format_prompt(
            'extraction_prompt', title=title, abstract=abstract, conclusion=conclusion
        )
        if not prompt:
            raise RuntimeError("Failed to load/format prompts/extraction_prompt.txt")
        return prompt
    
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
                    time.sleep(0.5)  # 500ms delay between requests
                    
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
