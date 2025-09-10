#!/usr/bin/env python3
"""
Lightweight Institutional Paper Scraper
Scrapes paper conclusions using institutional access with requests + BeautifulSoup.
Designed for legitimate academic use with proper credentials.
"""

import json
import requests
import time
import re
from pathlib import Path
from typing import Dict, List, Any, Optional
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class LightweightScraper:
    """Lightweight scraper using requests and BeautifulSoup."""
    
    def __init__(self, delay: float = 2.0, timeout: int = 15):
        """
        Initialize the scraper.
        
        Args:
            delay: Delay between requests
            timeout: Request timeout in seconds
        """
        self.delay = delay
        self.timeout = timeout
        
        # Setup requests session with institutional headers
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.9',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1',
            'Sec-Fetch-Dest': 'document',
            'Sec-Fetch-Mode': 'navigate',
            'Sec-Fetch-Site': 'none',
            'Cache-Control': 'max-age=0'
        })
    
    def extract_sciencedirect_content(self, url: str) -> Dict[str, Any]:
        """Extract content from ScienceDirect papers."""
        try:
            logger.info(f"    Accessing ScienceDirect: {url}")
            
            response = self.session.get(url, timeout=self.timeout)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            result = {}
            
            # Extract enhanced abstract
            abstract_selectors = [
                '[data-testid="abstract-content"]',
                '.abstract-content',
                '.abstract',
                '#abstract',
                '.u-font-serif.abstract',
                '.abstract-content-wrap',
                '.abstract-author-content'
            ]
            
            for selector in abstract_selectors:
                elements = soup.select(selector)
                for elem in elements:
                    text = elem.get_text(strip=True)
                    if len(text) > 100:
                        result['enhanced_abstract'] = text
                        logger.info(f"    ✅ Enhanced abstract found ({len(text)} chars)")
                        break
                if 'enhanced_abstract' in result:
                    break
            
            # Look for conclusion sections
            conclusion_found = False
            
            # Method 1: Look for conclusion headings and their content
            conclusion_headings = soup.find_all(['h1', 'h2', 'h3', 'h4'], 
                                               string=re.compile(r'conclusions?\s*$', re.IGNORECASE))
            
            for heading in conclusion_headings:
                # Find the content section after this heading
                content_section = None
                next_elem = heading.find_next_sibling()
                
                while next_elem:
                    if next_elem.name in ['div', 'section', 'p']:
                        content_section = next_elem
                        break
                    next_elem = next_elem.find_next_sibling()
                
                if content_section:
                    text = content_section.get_text(strip=True)
                    if 50 <= len(text) <= 3000:
                        result['conclusion'] = text
                        result['extraction_method'] = 'heading_based'
                        conclusion_found = True
                        logger.info(f"    ✅ Conclusion found via heading ({len(text)} chars)")
                        break
            
            # Method 2: Look for sections with conclusion in class/id
            if not conclusion_found:
                conclusion_sections = soup.find_all(['div', 'section'], 
                                                   class_=re.compile(r'conclusion', re.IGNORECASE))
                conclusion_sections.extend(soup.find_all(['div', 'section'], 
                                                        id=re.compile(r'conclusion', re.IGNORECASE)))
                
                for section in conclusion_sections:
                    text = section.get_text(strip=True)
                    if 50 <= len(text) <= 3000:
                        result['conclusion'] = text
                        result['extraction_method'] = 'section_based'
                        conclusion_found = True
                        logger.info(f"    ✅ Conclusion found via section ({len(text)} chars)")
                        break
            
            # Method 3: Pattern matching in full text
            if not conclusion_found:
                full_text = soup.get_text()
                
                conclusion_patterns = [
                    r'(\d+\.?\s*conclusions?\s*\.?\s*)(.*?)(?=\d+\.?\s*(?:references?|acknowledgment|appendix|funding)|$)',
                    r'(conclusions?\s*\.?\s*)(.*?)(?=references?|acknowledgment|appendix|funding|declaration|conflict|author|$)',
                    r'(in conclusion,?\s*)(.*?)(?=references?|acknowledgment|funding|$)',
                    r'(to conclude,?\s*)(.*?)(?=references?|acknowledgment|funding|$)',
                    r'(concluding remarks?\s*\.?\s*)(.*?)(?=references?|acknowledgment|funding|$)'
                ]
                
                for pattern in conclusion_patterns:
                    matches = re.finditer(pattern, full_text, re.IGNORECASE | re.DOTALL)
                    for match in matches:
                        conclusion_text = match.group(2).strip()
                        # Clean up whitespace and newlines
                        conclusion_text = ' '.join(conclusion_text.split())
                        if 50 <= len(conclusion_text) <= 3000:
                            result['conclusion'] = conclusion_text
                            result['extraction_method'] = 'pattern_matching'
                            conclusion_found = True
                            logger.info(f"    ✅ Conclusion found via pattern ({len(conclusion_text)} chars)")
                            break
                    if conclusion_found:
                        break
            
            # Extract keywords
            keyword_selectors = [
                '[data-testid="keywords"]',
                '.keywords',
                '#keywords',
                '.keyword-list',
                '.keywords-content'
            ]
            
            for selector in keyword_selectors:
                elements = soup.select(selector)
                for elem in elements:
                    keywords_text = elem.get_text()
                    # Parse keywords (split by semicolon, comma, or newline)
                    keywords = [kw.strip() for kw in re.split(r'[;,\n]', keywords_text) if kw.strip()]
                    if keywords and len(keywords) > 1:
                        result['additional_keywords'] = keywords
                        logger.info(f"    ✅ Keywords found ({len(keywords)} keywords)")
                        break
                if 'additional_keywords' in result:
                    break
            
            # Check for PDF availability
            pdf_links = soup.find_all('a', href=re.compile(r'\.pdf', re.IGNORECASE))
            pdf_links.extend(soup.find_all('a', string=re.compile(r'pdf', re.IGNORECASE)))
            
            if pdf_links:
                result['pdf_available'] = True
                for link in pdf_links:
                    href = link.get('href')
                    if href and '.pdf' in href.lower():
                        if href.startswith('http'):
                            result['pdf_url'] = href
                        else:
                            result['pdf_url'] = urljoin(url, href)
                        break
            
            return result
            
        except requests.RequestException as e:
            logger.error(f"    ❌ Request error: {e}")
            return {'error': f'Request failed: {e}'}
        except Exception as e:
            logger.error(f"    ❌ Extraction error: {e}")
            return {'error': str(e)}
    
    def extract_from_publisher(self, url: str) -> Dict[str, Any]:
        """Extract from publisher website (Springer, Wiley, IEEE, etc.)."""
        try:
            domain = urlparse(url).netloc.lower()
            logger.info(f"    Accessing publisher: {domain}")
            
            response = self.session.get(url, timeout=self.timeout)
            response.raise_for_status()
            
            soup = BeautifulSoup(response.content, 'html.parser')
            result = {}
            
            # Publisher-specific patterns
            if 'springer' in domain:
                result.update(self._extract_springer_patterns(soup))
            elif 'wiley' in domain:
                result.update(self._extract_wiley_patterns(soup))
            elif 'ieee' in domain:
                result.update(self._extract_ieee_patterns(soup))
            else:
                result.update(self._extract_generic_patterns(soup))
            
            return result
            
        except requests.RequestException as e:
            logger.error(f"    ❌ Request error: {e}")
            return {'error': f'Request failed: {e}'}
        except Exception as e:
            logger.error(f"    ❌ Publisher extraction error: {e}")
            return {'error': str(e)}
    
    def _extract_springer_patterns(self, soup: BeautifulSoup) -> Dict[str, Any]:
        """Extract using Springer-specific patterns."""
        result = {}
        
        # Springer conclusion patterns
        conclusion_selectors = [
            '#Sec_Conclusion',
            '#Sec_Conclusions', 
            'section[data-title*="Conclusion"]',
            '.c-article-section__title:contains("Conclusion")'
        ]
        
        # Abstract
        abstract_elem = soup.find('div', {'id': 'Abs1-content'})
        if not abstract_elem:
            abstract_elem = soup.find('section', {'data-title': 'Abstract'})
        
        if abstract_elem:
            text = abstract_elem.get_text(strip=True)
            if len(text) > 100:
                result['enhanced_abstract'] = text
        
        return result
    
    def _extract_wiley_patterns(self, soup: BeautifulSoup) -> Dict[str, Any]:
        """Extract using Wiley-specific patterns."""
        result = {}
        
        # Wiley patterns
        abstract_elem = soup.find('div', class_='article-section__content')
        if abstract_elem:
            text = abstract_elem.get_text(strip=True)
            if len(text) > 100:
                result['enhanced_abstract'] = text
        
        return result
    
    def _extract_ieee_patterns(self, soup: BeautifulSoup) -> Dict[str, Any]:
        """Extract using IEEE-specific patterns."""
        result = {}
        
        # IEEE patterns
        abstract_elem = soup.find('div', {'class': 'abstract-text'})
        if abstract_elem:
            text = abstract_elem.get_text(strip=True)
            if len(text) > 100:
                result['enhanced_abstract'] = text
        
        return result
    
    def _extract_generic_patterns(self, soup: BeautifulSoup) -> Dict[str, Any]:
        """Generic extraction patterns."""
        result = {}
        
        # Look for any conclusion section
        full_text = soup.get_text()
        
        conclusion_patterns = [
            r'(\d+\.?\s*conclusions?\s*\.?\s*)(.*?)(?=\d+\.?\s*(?:references?|acknowledgment|appendix)|$)',
            r'(conclusions?\s*\.?\s*)(.*?)(?=references?|acknowledgment|appendix|$)',
        ]
        
        for pattern in conclusion_patterns:
            matches = re.finditer(pattern, full_text, re.IGNORECASE | re.DOTALL)
            for match in matches:
                conclusion_text = match.group(2).strip()
                conclusion_text = ' '.join(conclusion_text.split())
                if 50 <= len(conclusion_text) <= 3000:
                    result['conclusion'] = conclusion_text
                    result['extraction_method'] = 'generic_pattern'
                    break
            if 'conclusion' in result:
                break
        
        return result
    
    def process_citation(self, citation: Dict[str, Any]) -> Dict[str, Any]:
        """Process a single citation to extract conclusion."""
        result = citation.copy()
        
        title = citation.get('title', '')
        sciencedirect_url = citation.get('sciencedirect_url', '')
        doi_url = citation.get('doi_url', '')
        
        logger.info(f"Processing: {title[:60]}...")
        
        extraction_data = {}
        
        try:
            # Try ScienceDirect first if available
            if sciencedirect_url:
                sd_data = self.extract_sciencedirect_content(sciencedirect_url)
                if sd_data and 'error' not in sd_data:
                    extraction_data['sciencedirect'] = sd_data
                    if 'conclusion' in sd_data:
                        logger.info(f"  ✅ Found conclusion from ScienceDirect")
                time.sleep(self.delay)
            
            # If no conclusion found and we have DOI, try the publisher directly
            if not any('conclusion' in data for data in extraction_data.values()) and doi_url:
                publisher_data = self.extract_from_publisher(doi_url)
                if publisher_data and 'error' not in publisher_data:
                    extraction_data['publisher'] = publisher_data
                    if 'conclusion' in publisher_data:
                        logger.info(f"  ✅ Found conclusion from publisher")
                time.sleep(self.delay)
            
            if extraction_data:
                result['content_extraction'] = extraction_data
                
                # Add summary of what was found
                found_items = []
                for source, data in extraction_data.items():
                    if 'conclusion' in data:
                        found_items.append(f"conclusion from {source}")
                    if 'enhanced_abstract' in data:
                        found_items.append(f"enhanced abstract from {source}")
                    if 'additional_keywords' in data:
                        found_items.append(f"keywords from {source}")
                    if 'pdf_available' in data:
                        found_items.append(f"PDF access from {source}")
                
                result['extraction_summary'] = found_items
                
                if found_items:
                    logger.info(f"  📊 Extracted: {', '.join(found_items)}")
                else:
                    logger.info(f"  ⚠️  No additional content found")
            
        except Exception as e:
            logger.error(f"  ❌ Error processing {title}: {e}")
            result['extraction_error'] = str(e)
        
        return result
    
    def process_citations(self, citations: List[Dict[str, Any]], 
                         max_papers: Optional[int] = None,
                         start_from: int = 0) -> List[Dict[str, Any]]:
        """Process multiple citations."""
        processed = []
        
        if max_papers:
            total = min(len(citations) - start_from, max_papers)
            citations_slice = citations[start_from:start_from + max_papers]
        else:
            total = len(citations) - start_from
            citations_slice = citations[start_from:]
        
        logger.info(f"\n🚀 Starting extraction for {total} papers (starting from {start_from + 1})...")
        logger.info(f"Delay between requests: {self.delay}s")
        
        for i, citation in enumerate(citations_slice):
            current_idx = start_from + i + 1
            logger.info(f"\n📑 Processing {current_idx}/{len(citations)}")
            
            try:
                result = self.process_citation(citation)
                processed.append(result)
                
                # Progress update every 5 papers
                if (i + 1) % 5 == 0:
                    conclusions_found = sum(1 for c in processed 
                                          if any('conclusion' in data 
                                               for data in c.get('content_extraction', {}).values()))
                    abstracts_found = sum(1 for c in processed 
                                        if any('enhanced_abstract' in data 
                                             for data in c.get('content_extraction', {}).values()))
                    
                    logger.info(f"\n📊 Progress Update:")
                    logger.info(f"  Papers processed: {i + 1}/{total}")
                    logger.info(f"  Conclusions found: {conclusions_found}")
                    logger.info(f"  Enhanced abstracts: {abstracts_found}")
                    logger.info(f"  Success rate: {conclusions_found/(i+1)*100:.1f}%")
                
            except Exception as e:
                logger.error(f"❌ Error processing citation {current_idx}: {e}")
                processed.append(citation)  # Keep original
        
        return processed


def main():
    """Main function."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Extract conclusions using institutional access")
    parser.add_argument("--input", default="dataset/processed/combined_citations.json",
                       help="Input JSON file with citations")
    parser.add_argument("--output", default="dataset/processed/citations_with_conclusions.json",
                       help="Output JSON file")
    parser.add_argument("--max-papers", type=int, default=None, 
                       help="Max papers to process (useful for testing)")
    parser.add_argument("--start-from", type=int, default=0, 
                       help="Start from paper number (0-indexed)")
    parser.add_argument("--delay", type=float, default=2.0, 
                       help="Delay between requests in seconds")
    parser.add_argument("--timeout", type=int, default=15,
                       help="Request timeout in seconds")
    
    args = parser.parse_args()
    
    # Load citations
    input_path = Path(args.input)
    if not input_path.exists():
        logger.error(f"Input file not found: {args.input}")
        return
    
    with open(input_path, 'r') as f:
        citations = json.load(f)
    
    logger.info(f"📁 Loaded {len(citations)} citations from {args.input}")
    
    # Initialize scraper
    scraper = LightweightScraper(delay=args.delay, timeout=args.timeout)
    
    try:
        # Process citations
        processed = scraper.process_citations(
            citations, 
            max_papers=args.max_papers,
            start_from=args.start_from
        )
        
        # If continuing from existing file, merge results
        output_path = Path(args.output)
        if output_path.exists() and args.start_from > 0:
            logger.info("📂 Merging with existing results...")
            with open(output_path, 'r') as f:
                existing = json.load(f)
            
            # Update existing with new results
            for i, new_citation in enumerate(processed):
                existing[args.start_from + i] = new_citation
            
            processed = existing
        
        # Save results
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, 'w') as f:
            json.dump(processed, f, indent=2, ensure_ascii=False)
        
        # Final summary
        conclusion_count = sum(1 for c in processed 
                              if any('conclusion' in data 
                                   for data in c.get('content_extraction', {}).values()))
        enhanced_abstract_count = sum(1 for c in processed 
                                    if any('enhanced_abstract' in data 
                                         for data in c.get('content_extraction', {}).values()))
        keyword_count = sum(1 for c in processed 
                           if any('additional_keywords' in data 
                                for data in c.get('content_extraction', {}).values()))
        pdf_count = sum(1 for c in processed 
                       if any('pdf_available' in data 
                            for data in c.get('content_extraction', {}).values()))
        
        print(f"\n" + "="*60)
        print(f"📊 FINAL EXTRACTION SUMMARY")
        print(f"="*60)
        print(f"Total papers processed: {len(processed)}")
        print(f"Conclusions extracted: {conclusion_count} ({conclusion_count/len(processed)*100:.1f}%)")
        print(f"Enhanced abstracts: {enhanced_abstract_count} ({enhanced_abstract_count/len(processed)*100:.1f}%)")
        print(f"Additional keywords: {keyword_count} ({keyword_count/len(processed)*100:.1f}%)")
        print(f"PDF access found: {pdf_count} ({pdf_count/len(processed)*100:.1f}%)")
        print(f"="*60)
        
        if conclusion_count > 0:
            print(f"✅ Successfully extracted {conclusion_count} conclusions!")
        else:
            print(f"⚠️  No conclusions found - check access permissions or try different parameters")
        
        print(f"💾 Results saved to: {args.output}")
        
    except KeyboardInterrupt:
        print(f"\n⚠️  Interrupted by user. Partial results may be saved.")
    except Exception as e:
        logger.error(f"❌ Fatal error: {e}")


if __name__ == "__main__":
    main()
