#!/usr/bin/env python3
"""
DOI-based Paper Content Fetcher
Attempts to fetch additional content from papers using their DOI URLs.
Focuses on legally accessible content like enhanced abstracts and open access papers.
"""

import json
import requests
import time
import re
from pathlib import Path
from urllib.parse import urlparse
from typing import Dict, List, Any, Optional
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class PaperContentFetcher:
    """Fetches additional paper content using DOI URLs."""
    
    def __init__(self, delay: float = 1.0):
        """
        Initialize the fetcher.
        
        Args:
            delay: Delay between requests to be respectful to servers
        """
        self.delay = delay
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (compatible; Academic Research Tool; +mailto:researcher@example.com)'
        })
        
    def check_open_access(self, doi: str) -> Dict[str, Any]:
        """
        Check if a paper is open access using Unpaywall API.
        
        Args:
            doi: DOI of the paper
            
        Returns:
            Dictionary with open access information
        """
        try:
            # Clean DOI
            doi_clean = doi.replace('https://doi.org/', '').replace('http://dx.doi.org/', '')
            
            # Unpaywall API (free, no key required)
            url = f"https://api.unpaywall.org/v2/{doi_clean}?email=researcher@example.com"
            
            response = self.session.get(url, timeout=10)
            
            if response.status_code == 200:
                data = response.json()
                return {
                    'is_oa': data.get('is_oa', False),
                    'oa_locations': data.get('oa_locations', []),
                    'journal_is_oa': data.get('journal_is_oa', False),
                    'publisher': data.get('publisher', ''),
                    'journal_name': data.get('journal_name', '')
                }
            else:
                logger.warning(f"Unpaywall API error for {doi}: {response.status_code}")
                return {'error': f'API error: {response.status_code}'}
                
        except Exception as e:
            logger.error(f"Error checking open access for {doi}: {str(e)}")
            return {'error': str(e)}
    
    def get_crossref_metadata(self, doi: str) -> Dict[str, Any]:
        """
        Get enhanced metadata from CrossRef API.
        
        Args:
            doi: DOI of the paper
            
        Returns:
            Dictionary with enhanced metadata
        """
        try:
            # Clean DOI
            doi_clean = doi.replace('https://doi.org/', '').replace('http://dx.doi.org/', '')
            
            # CrossRef API (free, no key required)
            url = f"https://api.crossref.org/works/{doi_clean}"
            
            response = self.session.get(url, timeout=10)
            
            if response.status_code == 200:
                data = response.json()
                work = data.get('message', {})
                
                return {
                    'title': work.get('title', [None])[0],
                    'authors': work.get('author', []),
                    'published_date': work.get('published-print', {}).get('date-parts', [[None]])[0],
                    'journal': work.get('container-title', [None])[0],
                    'publisher': work.get('publisher', ''),
                    'type': work.get('type', ''),
                    'subject': work.get('subject', []),
                    'references_count': work.get('references-count', 0),
                    'is_referenced_by_count': work.get('is-referenced-by-count', 0),
                    'license': work.get('license', []),
                    'issn': work.get('ISSN', []),
                    'volume': work.get('volume', ''),
                    'issue': work.get('issue', ''),
                    'page': work.get('page', ''),
                    'abstract': work.get('abstract', ''),  # Often available
                    'funding': work.get('funder', [])
                }
            else:
                logger.warning(f"CrossRef API error for {doi}: {response.status_code}")
                return {'error': f'API error: {response.status_code}'}
                
        except Exception as e:
            logger.error(f"Error getting CrossRef metadata for {doi}: {str(e)}")
            return {'error': str(e)}
    
    def attempt_sciencedirect_abstract(self, doi: str, sciencedirect_url: str = None) -> Dict[str, Any]:
        """
        Attempt to get enhanced abstract from ScienceDirect (if available).
        
        Args:
            doi: DOI of the paper
            sciencedirect_url: Direct ScienceDirect URL
            
        Returns:
            Dictionary with any available content
        """
        try:
            # Try to access the ScienceDirect page
            if sciencedirect_url:
                response = self.session.get(sciencedirect_url, timeout=10)
                
                if response.status_code == 200:
                    # Basic pattern matching for abstract and other sections
                    content = response.text
                    
                    result = {}
                    
                    # Try to extract enhanced abstract
                    abstract_patterns = [
                        r'<div[^>]*class="[^"]*abstract[^"]*"[^>]*>(.*?)</div>',
                        r'<section[^>]*class="[^"]*abstract[^"]*"[^>]*>(.*?)</section>',
                    ]
                    
                    for pattern in abstract_patterns:
                        matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
                        if matches:
                            # Clean HTML tags
                            abstract = re.sub(r'<[^>]+>', ' ', matches[0])
                            abstract = ' '.join(abstract.split())  # Clean whitespace
                            result['enhanced_abstract'] = abstract
                            break
                    
                    # Try to find keywords
                    keyword_patterns = [
                        r'<span[^>]*class="[^"]*keyword[^"]*"[^>]*>(.*?)</span>',
                        r'"keywords":\s*\[(.*?)\]',
                    ]
                    
                    for pattern in keyword_patterns:
                        matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
                        if matches:
                            result['additional_keywords'] = matches
                            break
                    
                    # Check if full text is available
                    if 'pdf' in content.lower() and 'download' in content.lower():
                        result['has_pdf_link'] = True
                    
                    return result
                else:
                    return {'error': f'HTTP {response.status_code}'}
                    
        except Exception as e:
            logger.error(f"Error accessing ScienceDirect for {doi}: {str(e)}")
            return {'error': str(e)}
        
        return {}
    
    def enrich_citation(self, citation: Dict[str, Any]) -> Dict[str, Any]:
        """
        Enrich a single citation with additional metadata.
        
        Args:
            citation: Original citation dictionary
            
        Returns:
            Enriched citation dictionary
        """
        enriched = citation.copy()
        doi = citation.get('doi_url', '')
        sciencedirect_url = citation.get('sciencedirect_url', '')
        
        if not doi:
            logger.info(f"No DOI for: {citation.get('title', 'Unknown title')}")
            return enriched
        
        logger.info(f"Enriching: {citation.get('title', 'Unknown title')[:60]}...")
        
        # Check open access status
        oa_info = self.check_open_access(doi)
        if 'error' not in oa_info:
            enriched['open_access'] = oa_info
        
        time.sleep(self.delay)  # Be respectful
        
        # Get CrossRef metadata
        crossref_data = self.get_crossref_metadata(doi)
        if 'error' not in crossref_data:
            enriched['crossref_metadata'] = crossref_data
            
            # Use enhanced abstract if available and current one is short
            if crossref_data.get('abstract') and len(crossref_data['abstract']) > len(citation.get('abstract', '')):
                enriched['enhanced_abstract'] = crossref_data['abstract']
        
        time.sleep(self.delay)  # Be respectful
        
        # Try ScienceDirect for additional content
        if sciencedirect_url:
            sd_content = self.attempt_sciencedirect_abstract(doi, sciencedirect_url)
            if sd_content and 'error' not in sd_content:
                enriched['sciencedirect_content'] = sd_content
        
        time.sleep(self.delay)  # Be respectful
        
        return enriched
    
    def process_citations(self, citations: List[Dict[str, Any]], 
                         max_papers: Optional[int] = None) -> List[Dict[str, Any]]:
        """
        Process multiple citations to enrich them with additional content.
        
        Args:
            citations: List of citation dictionaries
            max_papers: Maximum number of papers to process (for testing)
            
        Returns:
            List of enriched citations
        """
        enriched_citations = []
        total = min(len(citations), max_papers) if max_papers else len(citations)
        
        logger.info(f"Starting to enrich {total} citations...")
        
        for i, citation in enumerate(citations[:max_papers] if max_papers else citations):
            logger.info(f"Processing {i+1}/{total}")
            
            try:
                enriched = self.enrich_citation(citation)
                enriched_citations.append(enriched)
                
                # Progress update
                if (i + 1) % 10 == 0:
                    logger.info(f"Completed {i+1}/{total} citations")
                    
            except Exception as e:
                logger.error(f"Error processing citation {i+1}: {str(e)}")
                enriched_citations.append(citation)  # Keep original if error
        
        return enriched_citations


def main():
    """Main function to enrich citation data."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Enrich citation data with DOI-based content")
    parser.add_argument("--input", default="dataset/processed/combined_citations.json",
                       help="Input citations JSON file")
    parser.add_argument("--output", default="dataset/processed/enriched_citations.json",
                       help="Output enriched citations JSON file")
    parser.add_argument("--max-papers", type=int, default=None,
                       help="Maximum number of papers to process (for testing)")
    parser.add_argument("--delay", type=float, default=1.0,
                       help="Delay between requests in seconds")
    
    args = parser.parse_args()
    
    # Load citations
    try:
        with open(args.input, 'r', encoding='utf-8') as f:
            citations = json.load(f)
        logger.info(f"Loaded {len(citations)} citations from {args.input}")
    except FileNotFoundError:
        logger.error(f"Input file not found: {args.input}")
        return
    
    # Initialize fetcher
    fetcher = PaperContentFetcher(delay=args.delay)
    
    # Process citations
    enriched_citations = fetcher.process_citations(citations, max_papers=args.max_papers)
    
    # Save results
    with open(args.output, 'w', encoding='utf-8') as f:
        json.dump(enriched_citations, f, indent=2, ensure_ascii=False)
    
    logger.info(f"Saved {len(enriched_citations)} enriched citations to {args.output}")
    
    # Generate summary
    oa_count = sum(1 for c in enriched_citations if c.get('open_access', {}).get('is_oa', False))
    enhanced_abstract_count = sum(1 for c in enriched_citations if 'enhanced_abstract' in c)
    crossref_count = sum(1 for c in enriched_citations if 'crossref_metadata' in c)
    
    print(f"\n📊 ENRICHMENT SUMMARY")
    print(f"Total papers processed: {len(enriched_citations)}")
    print(f"Open access papers found: {oa_count}")
    print(f"Enhanced abstracts found: {enhanced_abstract_count}")
    print(f"CrossRef metadata added: {crossref_count}")
    
    if oa_count > 0:
        print(f"\n✅ Found {oa_count} open access papers - these may have full text available!")


if __name__ == "__main__":
    main()
