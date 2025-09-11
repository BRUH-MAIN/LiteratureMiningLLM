"""
Extraction Agent using Gemini Flash LLM

This module handles:
- Using Gemini LLM with schema-guided prompts
- Extracting materials, properties, applications from abstract + conclusion
- Ensuring output follows normalized JSON schema
"""

import json
import logging
import google.generativeai as genai
from typing import List, Dict, Any, Optional
import os
import time
from dotenv import load_dotenv

load_dotenv()


class Extractor:
    """Extraction agent using Gemini Flash for structured data extraction"""
    
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.setup_gemini()
        
    def setup_gemini(self):
        """Setup Gemini API client"""
        api_key = os.getenv('GEMINI_API_KEY')
        if not api_key:
            raise ValueError("GEMINI_API_KEY environment variable not set")
        
        genai.configure(api_key=api_key)
        self.model = genai.GenerativeModel('gemini-1.5-flash')
        self.logger.info("Gemini Flash model initialized")
    
    def create_extraction_prompt(self, title: str, abstract: str, conclusion: str) -> str:
        """Create a schema-guided prompt for data extraction"""
        
        prompt = f"""
You are an expert materials science researcher specializing in MXenes. 
Extract structured data from the following research paper about MXenes.

PAPER TITLE: {title}

ABSTRACT: {abstract}

CONCLUSION: {conclusion}

Please extract the following information and return it as a valid JSON object with this exact structure:

{{
    "materials": [
        {{
            "mxene_composition": "string (e.g., Ti3C2Tx, Ti2CTx, etc.)",
            "composite_material": "string (any composite materials mentioned)",
            "synthesis_method": "string (method used to synthesize the MXene)",
            "fabrication_method": "string (method used to fabricate the final material/device)"
        }}
    ],
    "properties": [
        {{
            "property_type": "string (standardized: Conductivity, Modulus, Stress, Seebeck_Coefficient, Resistivity, etc.)",
            "value": "number (numeric value only)",
            "unit": "string (standardized unit)",
            "test_conditions": "string (any testing conditions mentioned)"
        }}
    ],
    "applications": [
        {{
            "application_type": "string (sensors, energy_storage, shielding, AI_applications, etc.)",
            "metric": "string (sensitivity, response_time, accuracy, threshold, etc.)",
            "value": "number (numeric value only)",
            "unit": "string (unit of the metric)",
            "notes": "string (additional context)"
        }}
    ]
}}

EXTRACTION RULES:
1. Only extract information explicitly mentioned in the text
2. For property_type, use standardized names: "Conductivity", "Young_Modulus", "Fracture_Stress", "Seebeck_Coefficient", "Resistivity", "Capacitance", "Energy_Density", etc.
3. For values, extract only numeric values (e.g., from "353.77 S m−1", extract 353.77)
4. For units, use standardized forms (e.g., "S/m" for conductivity, "MPa" for stress, "GPa" for modulus)
5. If MXene composition is not explicitly mentioned, leave as empty string
6. If no relevant data found for a category, return empty array []
7. Remove any duplicate entries within the same category

Return only the JSON object, no additional text.
"""
        return prompt
    
    def extract_data_from_text(self, title: str, abstract: str, conclusion: str) -> Optional[Dict[str, Any]]:
        """Extract structured data from paper text using Gemini"""
        try:
            # Combine abstract and conclusion for better context
            combined_text = f"{abstract}\n\n{conclusion}"
            
            # Skip if text is too short or missing
            if len(combined_text.strip()) < 100:
                self.logger.warning(f"Insufficient text for extraction in paper: {title[:50]}...")
                return None
            
            prompt = self.create_extraction_prompt(title, abstract, conclusion)
            
            # Call Gemini API
            response = self.model.generate_content(prompt)
            
            if not response.text:
                self.logger.error(f"Empty response from Gemini for paper: {title[:50]}...")
                self.logger.debug(f"Response object: {response}")
                return None
            
            self.logger.debug(f"Raw Gemini response: {response.text[:200]}...")
            
            # Parse JSON response
            try:
                # Clean up the response text
                clean_text = response.text.strip()
                if clean_text.startswith("```json"):
                    clean_text = clean_text[7:]
                if clean_text.endswith("```"):
                    clean_text = clean_text[:-3]
                clean_text = clean_text.strip()
                
                extracted_data = json.loads(clean_text)
                self.logger.debug(f"Successfully extracted data for paper: {title[:50]}...")
                return extracted_data
                
            except json.JSONDecodeError as e:
                self.logger.error(f"JSON parsing error for paper {title[:50]}...: {e}")
                self.logger.debug(f"Raw response: {response.text}")
                return None
                
        except Exception as e:
            self.logger.error(f"Error extracting data for paper {title[:50]}...: {e}")
            return None
    
    def extract_from_papers(self, papers: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Extract data from multiple papers"""
        extracted_papers = []
        failed_count = 0
        
        self.logger.info(f"Starting extraction for {len(papers)} papers...")
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
