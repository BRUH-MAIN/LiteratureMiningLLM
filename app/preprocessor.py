"""
Preprocessing Agent for Literature Mining

This module handles:
- Reading JSON input (multiple papers)
- Normalizing keys (abstract, conclusion, keywords)
- Cleaning raw text (remove LaTeX equations, special characters)
- Deduplicating entries using DOI
"""

import json
import re
import logging
from typing import List, Dict, Any
from pathlib import Path


class Preprocessor:
    """Preprocessing agent for cleaning and normalizing paper data"""
    
    def __init__(self):
        self.logger = logging.getLogger(__name__)
    
    def load_json_data(self, file_path: str) -> List[Dict[str, Any]]:
        """Load JSON data from file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            self.logger.info(f"Loaded {len(data)} papers from {file_path}")
            return data
        except Exception as e:
            self.logger.error(f"Error loading JSON file {file_path}: {e}")
            raise
    
    def normalize_keys(self, paper_data: Dict[str, Any]) -> Dict[str, Any]:
        """Normalize paper data keys to standardized format"""
        normalized = {}
        
        # Standard key mappings
        key_mappings = {
            'title': 'title',
            'authors': 'authors',
            'journal': 'journal',
            'year': 'year',
            'doi_url': 'doi_url',
            'sciencedirect_url': 'sciencedirect_url',
            'issn': 'issn',
            'abstract': 'abstract',
            'conclusion': 'conclusion',
            'keywords': 'keywords'
        }
        
        for standard_key, source_key in key_mappings.items():
            normalized[standard_key] = paper_data.get(source_key, '')
        
        # Handle keywords - convert to list if string
        if isinstance(normalized['keywords'], str):
            # If keywords are comma-separated string, split them
            normalized['keywords'] = [kw.strip() for kw in normalized['keywords'].split(',') if kw.strip()]
        elif not isinstance(normalized['keywords'], list):
            normalized['keywords'] = []
        
        return normalized
    
    def clean_text(self, text: str) -> str:
        """Clean raw text by removing LaTeX equations, special characters, and extra whitespace"""
        if not text:
            return ""
        
        # Remove LaTeX equations (both inline and display)
        text = re.sub(r'\$\$.*?\$\$', ' ', text, flags=re.DOTALL)  # Display equations
        text = re.sub(r'\$.*?\$', ' ', text)  # Inline equations
        
        # Remove other LaTeX commands
        text = re.sub(r'\\[a-zA-Z]+\{[^}]*\}', ' ', text)  # \command{content}
        text = re.sub(r'\\[a-zA-Z]+', ' ', text)  # \command
        
        # Remove special characters but keep basic punctuation
        text = re.sub(r'[^\w\s\.\,\;\:\!\?\(\)\-\+\=\<\>\[\]\{\}]', ' ', text)
        
        # Clean up whitespace
        text = re.sub(r'\s+', ' ', text).strip()
        
        return text
    
    def deduplicate_by_doi(self, papers: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Remove duplicate papers based on DOI"""
        seen_dois = set()
        unique_papers = []
        
        for paper in papers:
            doi = paper.get('doi_url', '')
            if doi and doi not in seen_dois:
                seen_dois.add(doi)
                unique_papers.append(paper)
            elif not doi:
                # Keep papers without DOI for now (could add title-based dedup later)
                unique_papers.append(paper)
        
        self.logger.info(f"Deduplicated {len(papers)} papers to {len(unique_papers)} unique papers")
        return unique_papers
    
    def preprocess_papers(self, papers: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Main preprocessing pipeline"""
        processed_papers = []
        
        for paper in papers:
            try:
                # Normalize keys
                normalized_paper = self.normalize_keys(paper)
                
                # Clean text fields
                text_fields = ['title', 'abstract', 'conclusion', 'authors', 'journal']
                for field in text_fields:
                    if normalized_paper.get(field):
                        normalized_paper[field] = self.clean_text(normalized_paper[field])
                
                processed_papers.append(normalized_paper)
                
            except Exception as e:
                self.logger.error(f"Error processing paper: {e}")
                continue
        
        # Deduplicate by DOI
        unique_papers = self.deduplicate_by_doi(processed_papers)
        
        self.logger.info(f"Preprocessing completed. {len(unique_papers)} papers processed successfully")
        return unique_papers
    
    def process_file(self, input_file: str) -> List[Dict[str, Any]]:
        """Complete preprocessing workflow for a file"""
        # Load data
        papers = self.load_json_data(input_file)
        
        # Preprocess
        processed_papers = self.preprocess_papers(papers)
        
        return processed_papers
