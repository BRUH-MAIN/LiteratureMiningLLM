#!/usr/bin/env python3
"""
Paper Conclusion Extractor
Specialized tool to extract conclusions from academic papers using various methods.
Focuses on legally accessible content and open access papers.
"""

import json
import requests
import time
import re
from pathlib import Path
from typing import Dict, List, Any, Optional
import logging
from urllib.parse import urljoin, urlparse

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class ConclusionExtractor:
    """Extracts conclusions from academic papers."""
    
    def __init__(self, delay: float = 2.0):
        self.delay = delay
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (compatible; Academic Research Bot; +mailto:research@university.edu)'
        })
    
    def find_open_access_pdf(self, doi: str) -> Optional[str]:
        """Find open access PDF URL for a paper."""
        try:
            doi_clean = doi.replace('https://doi.org/', '').replace('http://dx.doi.org/', '')
            url = f"https://api.unpaywall.org/v2/{doi_clean}?email=research@university.edu"
            
            response = self.session.get(url, timeout=10)
            if response.status_code == 200:
                data = response.json()
                if data.get('is_oa', False):
                    for location in data.get('oa_locations', []):
                        if location.get('url_for_pdf'):
                            return location['url_for_pdf']
                        elif location.get('url') and location.get('url').endswith('.pdf'):
                            return location['url']
            return None
        except Exception as e:
            logger.error(f"Error finding open access PDF for {doi}: {e}")
            return None
    
    def extract_from_html_page(self, url: str) -> Dict[str, Any]:
        """Extract conclusion from HTML page."""
        try:
            response = self.session.get(url, timeout=15)
            if response.status_code != 200:
                return {'error': f'HTTP {response.status_code}'}
            
            content = response.text.lower()
            result = {}
            
            # Common patterns for conclusions in HTML
            conclusion_patterns = [
                # Standard conclusion sections
                r'<(?:section|div)[^>]*(?:class|id)="[^"]*conclusion[^"]*"[^>]*>(.*?)</(?:section|div)>',
                r'<h[2-6][^>]*>(?:\d+\.?\s*)?conclusions?\s*</h[2-6]>(.*?)(?=<h[2-6]|$)',
                r'<h[2-6][^>]*>(?:\d+\.?\s*)?concluding remarks\s*</h[2-6]>(.*?)(?=<h[2-6]|$)',
                
                # Summary and conclusion patterns
                r'<h[2-6][^>]*>(?:\d+\.?\s*)?summary and conclusions?\s*</h[2-6]>(.*?)(?=<h[2-6]|$)',
                r'<h[2-6][^>]*>(?:\d+\.?\s*)?final remarks\s*</h[2-6]>(.*?)(?=<h[2-6]|$)',
                
                # Generic patterns
                r'<p[^>]*>[^<]*(?:in conclusion|to conclude|in summary)[^<]*</p>(.*?)(?=<h[2-6]|<section|$)',
            ]
            
            for pattern in conclusion_patterns:
                matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
                if matches:
                    # Clean HTML and extract text
                    conclusion_html = matches[0]
                    # Remove HTML tags
                    conclusion_text = re.sub(r'<[^>]+>', ' ', conclusion_html)
                    # Clean whitespace
                    conclusion_text = ' '.join(conclusion_text.split())
                    
                    if len(conclusion_text) > 50:  # Minimum length check
                        result['conclusion'] = conclusion_text
                        result['extraction_method'] = 'html_pattern'
                        break
            
            # Also try to find other sections
            sections_of_interest = [
                ('discussion', r'<h[2-6][^>]*>(?:\d+\.?\s*)?discussions?\s*</h[2-6]>(.*?)(?=<h[2-6]|$)'),
                ('results', r'<h[2-6][^>]*>(?:\d+\.?\s*)?results\s*</h[2-6]>(.*?)(?=<h[2-6]|$)'),
                ('implications', r'<h[2-6][^>]*>(?:\d+\.?\s*)?implications\s*</h[2-6]>(.*?)(?=<h[2-6]|$)')
            ]
            
            for section_name, pattern in sections_of_interest:
                matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
                if matches:
                    section_text = re.sub(r'<[^>]+>', ' ', matches[0])
                    section_text = ' '.join(section_text.split())
                    if len(section_text) > 50:
                        result[f'{section_name}_section'] = section_text
            
            return result
            
        except Exception as e:
            logger.error(f"Error extracting from HTML page {url}: {e}")
            return {'error': str(e)}
    
    def extract_from_sciencedirect(self, sciencedirect_url: str) -> Dict[str, Any]:
        """Specifically extract from ScienceDirect pages."""
        try:
            response = self.session.get(sciencedirect_url, timeout=15)
            if response.status_code != 200:
                return {'error': f'HTTP {response.status_code}'}
            
            content = response.text
            result = {}
            
            # ScienceDirect-specific patterns
            sd_patterns = [
                # Abstract might be enhanced
                r'<div[^>]*class="[^"]*abstract[^"]*"[^>]*>(.*?)</div>',
                # Look for section indicators
                r'<span[^>]*class="[^"]*section-title[^"]*"[^>]*>conclusions?</span>[^<]*<div[^>]*>(.*?)</div>',
                # Keywords
                r'<span[^>]*class="[^"]*keyword[^"]*"[^>]*>(.*?)</span>',
            ]
            
            for pattern in sd_patterns:
                matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
                if matches:
                    for match in matches:
                        clean_text = re.sub(r'<[^>]+>', ' ', match)
                        clean_text = ' '.join(clean_text.split())
                        if len(clean_text) > 30:
                            if 'enhanced_content' not in result:
                                result['enhanced_content'] = []
                            result['enhanced_content'].append(clean_text)
            
            # Check if full text is available
            if any(term in content.lower() for term in ['download pdf', 'full text', 'view pdf']):
                result['full_text_available'] = True
                
                # Try to find PDF link
                pdf_patterns = [
                    r'href="([^"]*\.pdf[^"]*)"',
                    r'href="([^"]*download[^"]*pdf[^"]*)"'
                ]
                
                for pattern in pdf_patterns:
                    matches = re.findall(pattern, content)
                    if matches:
                        # Make absolute URL
                        pdf_url = urljoin(sciencedirect_url, matches[0])
                        result['potential_pdf_url'] = pdf_url
                        break
            
            return result
            
        except Exception as e:
            logger.error(f"Error extracting from ScienceDirect {sciencedirect_url}: {e}")
            return {'error': str(e)}
    
    def try_semantic_scholar(self, title: str) -> Dict[str, Any]:
        """Try to get paper info from Semantic Scholar API."""
        try:
            # Search by title
            search_url = "https://api.semanticscholar.org/graph/v1/paper/search"
            params = {
                'query': title,
                'fields': 'title,abstract,authors,year,venue,openAccessPdf,tldr'
            }
            
            response = self.session.get(search_url, params=params, timeout=10)
            if response.status_code == 200:
                data = response.json()
                papers = data.get('data', [])
                
                if papers:
                    paper = papers[0]  # Take first match
                    result = {
                        'semantic_scholar_id': paper.get('paperId'),
                        'semantic_scholar_abstract': paper.get('abstract'),
                        'semantic_scholar_tldr': paper.get('tldr', {}).get('text') if paper.get('tldr') else None,
                        'open_access_pdf': paper.get('openAccessPdf', {}).get('url') if paper.get('openAccessPdf') else None
                    }
                    return result
            
            return {}
            
        except Exception as e:
            logger.error(f"Error with Semantic Scholar API for {title}: {e}")
            return {}
    
    def extract_conclusion(self, citation: Dict[str, Any]) -> Dict[str, Any]:
        """Extract conclusion from a single citation."""
        result = citation.copy()
        
        title = citation.get('title', '')
        doi_url = citation.get('doi_url', '')
        sciencedirect_url = citation.get('sciencedirect_url', '')
        
        logger.info(f"Extracting from: {title[:60]}...")
        
        extraction_results = {}
        
        # 1. Try Semantic Scholar first (has TLDR which is like a conclusion)
        if title:
            semantic_data = self.try_semantic_scholar(title)
            if semantic_data:
                extraction_results['semantic_scholar'] = semantic_data
        
        time.sleep(self.delay)
        
        # 2. Check for open access PDF
        if doi_url:
            pdf_url = self.find_open_access_pdf(doi_url)
            if pdf_url:
                extraction_results['open_access_pdf_url'] = pdf_url
                logger.info(f"  Found open access PDF: {pdf_url}")
        
        time.sleep(self.delay)
        
        # 3. Try ScienceDirect page
        if sciencedirect_url:
            sd_content = self.extract_from_sciencedirect(sciencedirect_url)
            if sd_content and 'error' not in sd_content:
                extraction_results['sciencedirect_extraction'] = sd_content
        
        time.sleep(self.delay)
        
        # 4. If we have open access, try to extract from the actual page
        if extraction_results.get('open_access_pdf_url'):
            # Try to get the paper page (not PDF, but the page hosting it)
            try:
                pdf_url = extraction_results['open_access_pdf_url']
                # Try to get the page instead of PDF
                if 'arxiv.org' in pdf_url:
                    # Convert arXiv PDF to abs page
                    abs_url = pdf_url.replace('/pdf/', '/abs/').replace('.pdf', '')
                    page_content = self.extract_from_html_page(abs_url)
                    if page_content:
                        extraction_results['arxiv_content'] = page_content
                elif 'pmc' in pdf_url.lower():
                    # Try PMC page
                    page_content = self.extract_from_html_page(pdf_url.replace('.pdf', ''))
                    if page_content:
                        extraction_results['pmc_content'] = page_content
            except:
                pass
        
        # Add extraction results to citation
        if extraction_results:
            result['conclusion_extraction'] = extraction_results
        
        return result
    
    def process_citations(self, citations: List[Dict[str, Any]], 
                         max_papers: Optional[int] = None) -> List[Dict[str, Any]]:
        """Process multiple citations to extract conclusions."""
        processed = []
        total = min(len(citations), max_papers) if max_papers else len(citations)
        
        logger.info(f"Starting conclusion extraction for {total} papers...")
        
        for i, citation in enumerate(citations[:max_papers] if max_papers else citations):
            logger.info(f"Processing {i+1}/{total}")
            
            try:
                result = self.extract_conclusion(citation)
                processed.append(result)
                
                if (i + 1) % 5 == 0:
                    logger.info(f"Completed {i+1}/{total}")
                    
            except Exception as e:
                logger.error(f"Error processing citation {i+1}: {e}")
                processed.append(citation)
        
        return processed


def main():
    """Main function."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Extract conclusions from papers")
    parser.add_argument("--input", default="dataset/processed/combined_citations.json")
    parser.add_argument("--output", default="dataset/processed/citations_with_conclusions.json")
    parser.add_argument("--max-papers", type=int, default=10, help="Max papers to process")
    parser.add_argument("--delay", type=float, default=2.0, help="Delay between requests")
    
    args = parser.parse_args()
    
    # Load citations
    with open(args.input, 'r') as f:
        citations = json.load(f)
    
    logger.info(f"Loaded {len(citations)} citations")
    
    # Extract conclusions
    extractor = ConclusionExtractor(delay=args.delay)
    processed = extractor.process_citations(citations, max_papers=args.max_papers)
    
    # Save results
    with open(args.output, 'w') as f:
        json.dump(processed, f, indent=2, ensure_ascii=False)
    
    # Summary
    conclusion_count = sum(1 for c in processed if 'conclusion_extraction' in c)
    oa_pdf_count = sum(1 for c in processed 
                      if c.get('conclusion_extraction', {}).get('open_access_pdf_url'))
    tldr_count = sum(1 for c in processed 
                    if c.get('conclusion_extraction', {}).get('semantic_scholar', {}).get('semantic_scholar_tldr'))
    
    print(f"\n📊 CONCLUSION EXTRACTION SUMMARY")
    print(f"Papers processed: {len(processed)}")
    print(f"Papers with extraction attempts: {conclusion_count}")
    print(f"Open access PDFs found: {oa_pdf_count}")
    print(f"TL;DR summaries found: {tldr_count}")


if __name__ == "__main__":
    main()
