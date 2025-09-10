#!/usr/bin/env python3
"""
Institutional Paper Scraper
Scrapes paper conclusions using institutional access to publisher websites.
Designed for legitimate academic use with proper credentials.
"""

import json
import requests
import time
import re
from pathlib import Path
from typing import Dict, List, Any, Optional
from urllib.parse import urljoin, urlparse
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import TimeoutException, NoSuchElementException
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class InstitutionalScraper:
    """Scrapes paper content using institutional access."""
    
    def __init__(self, use_selenium: bool = True, headless: bool = True, delay: float = 3.0):
        """
        Initialize the scraper.
        
        Args:
            use_selenium: Whether to use Selenium for JavaScript-heavy sites
            headless: Run browser in headless mode
            delay: Delay between requests
        """
        self.delay = delay
        self.use_selenium = use_selenium
        
        # Setup requests session
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.5',
            'Accept-Encoding': 'gzip, deflate',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1',
        })
        
        # Setup Selenium if needed
        self.driver = None
        if use_selenium:
            self.setup_selenium(headless)
    
    def setup_selenium(self, headless: bool = True):
        """Setup Selenium WebDriver."""
        try:
            chrome_options = Options()
            if headless:
                chrome_options.add_argument('--headless')
            chrome_options.add_argument('--no-sandbox')
            chrome_options.add_argument('--disable-dev-shm-usage')
            chrome_options.add_argument('--disable-gpu')
            chrome_options.add_argument('--window-size=1920,1080')
            chrome_options.add_argument('--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
            
            self.driver = webdriver.Chrome(options=chrome_options)
            self.driver.implicitly_wait(10)
            logger.info("Selenium WebDriver initialized successfully")
        except Exception as e:
            logger.error(f"Failed to initialize Selenium: {e}")
            logger.info("Falling back to requests-only mode")
            self.use_selenium = False
    
    def extract_sciencedirect_content(self, url: str) -> Dict[str, Any]:
        """Extract content from ScienceDirect papers."""
        try:
            if self.use_selenium and self.driver:
                return self._extract_sciencedirect_selenium(url)
            else:
                return self._extract_sciencedirect_requests(url)
        except Exception as e:
            logger.error(f"Error extracting from ScienceDirect {url}: {e}")
            return {'error': str(e)}
    
    def _extract_sciencedirect_selenium(self, url: str) -> Dict[str, Any]:
        """Extract using Selenium for ScienceDirect."""
        try:
            self.driver.get(url)
            time.sleep(self.delay)
            
            result = {}
            
            # Wait for page to load
            WebDriverWait(self.driver, 20).until(
                EC.presence_of_element_located((By.TAG_NAME, "body"))
            )
            
            # Extract enhanced abstract
            abstract_selectors = [
                '[data-testid="abstract-content"]',
                '.abstract-content',
                '.abstract',
                '#abstract',
                '.u-font-serif.abstract'
            ]
            
            for selector in abstract_selectors:
                try:
                    abstract_elem = self.driver.find_element(By.CSS_SELECTOR, selector)
                    if abstract_elem:
                        abstract_text = abstract_elem.get_attribute('textContent').strip()
                        if len(abstract_text) > 100:
                            result['enhanced_abstract'] = abstract_text
                            break
                except NoSuchElementException:
                    continue
            
            # Look for conclusion section
            conclusion_selectors = [
                # Direct conclusion sections
                '[data-testid="conclusion"]',
                '[id*="conclusion"]',
                '[class*="conclusion"]',
                
                # Section headers containing "conclusion"
                'h2:contains("Conclusion")',
                'h3:contains("Conclusion")',
                'h2:contains("Conclusions")',
                'h3:contains("Conclusions")',
                
                # More generic patterns
                '.section-title:contains("Conclusion")',
                '.section-header:contains("Conclusion")'
            ]
            
            for selector in conclusion_selectors:
                try:
                    if ':contains(' in selector:
                        # Handle contains selector differently
                        elements = self.driver.find_elements(By.XPATH, f"//*[contains(text(), 'Conclusion')]")
                    else:
                        elements = self.driver.find_elements(By.CSS_SELECTOR, selector)
                    
                    for elem in elements:
                        # Try to get the content after the header
                        try:
                            parent = elem.find_element(By.XPATH, './..')
                            content = parent.get_attribute('textContent').strip()
                            
                            # Clean and validate
                            if len(content) > 150 and 'conclusion' in content.lower():
                                # Extract just the conclusion part
                                conclusion_match = re.search(r'conclusions?\s*\.?\s*(.*?)(?:\n\n|\nreferences|\nreference|\nacknowledgment|$)', 
                                                           content, re.IGNORECASE | re.DOTALL)
                                if conclusion_match:
                                    conclusion_text = conclusion_match.group(1).strip()
                                    if len(conclusion_text) > 50:
                                        result['conclusion'] = conclusion_text
                                        result['extraction_method'] = 'selenium_section'
                                        break
                        except:
                            continue
                except:
                    continue
                
                if 'conclusion' in result:
                    break
            
            # Try to find full text content and extract conclusion patterns
            if 'conclusion' not in result:
                try:
                    # Get all text content
                    page_text = self.driver.find_element(By.TAG_NAME, 'body').get_attribute('textContent')
                    
                    # Pattern matching for conclusions
                    conclusion_patterns = [
                        r'(\d+\.?\s*conclusions?\s*\.?\s*)(.*?)(?=\d+\.?\s*(?:references?|acknowledgment|appendix)|$)',
                        r'(conclusions?\s*\.?\s*)(.*?)(?=references?|acknowledgment|appendix|$)',
                        r'(in conclusion,?\s*)(.*?)(?=references?|acknowledgment|$)',
                        r'(to conclude,?\s*)(.*?)(?=references?|acknowledgment|$)',
                    ]
                    
                    for pattern in conclusion_patterns:
                        matches = re.finditer(pattern, page_text, re.IGNORECASE | re.DOTALL)
                        for match in matches:
                            conclusion_text = match.group(2).strip()
                            # Clean up extra whitespace and newlines
                            conclusion_text = ' '.join(conclusion_text.split())
                            if 50 <= len(conclusion_text) <= 2000:  # Reasonable length
                                result['conclusion'] = conclusion_text
                                result['extraction_method'] = 'selenium_pattern'
                                break
                        if 'conclusion' in result:
                            break
                except:
                    pass
            
            # Extract keywords if available
            keyword_selectors = [
                '[data-testid="keywords"]',
                '.keywords',
                '#keywords',
                '.keyword-list'
            ]
            
            for selector in keyword_selectors:
                try:
                    keyword_elem = self.driver.find_element(By.CSS_SELECTOR, selector)
                    if keyword_elem:
                        keywords_text = keyword_elem.get_attribute('textContent')
                        # Parse keywords
                        keywords = [kw.strip() for kw in re.split(r'[;,\n]', keywords_text) if kw.strip()]
                        if keywords:
                            result['additional_keywords'] = keywords
                            break
                except NoSuchElementException:
                    continue
            
            # Check if PDF is available
            pdf_selectors = [
                'a[href*=".pdf"]',
                'a[title*="PDF"]',
                'a[aria-label*="PDF"]',
                '[data-testid*="pdf"]'
            ]
            
            for selector in pdf_selectors:
                try:
                    pdf_elem = self.driver.find_element(By.CSS_SELECTOR, selector)
                    if pdf_elem:
                        result['pdf_available'] = True
                        pdf_url = pdf_elem.get_attribute('href')
                        if pdf_url:
                            result['pdf_url'] = pdf_url
                        break
                except NoSuchElementException:
                    continue
            
            return result
            
        except Exception as e:
            logger.error(f"Selenium extraction error for {url}: {e}")
            return {'error': str(e)}
    
    def _extract_sciencedirect_requests(self, url: str) -> Dict[str, Any]:
        """Extract using requests for ScienceDirect."""
        try:
            response = self.session.get(url, timeout=15)
            if response.status_code != 200:
                return {'error': f'HTTP {response.status_code}'}
            
            content = response.text
            result = {}
            
            # Enhanced abstract extraction
            abstract_patterns = [
                r'<div[^>]*class="[^"]*abstract[^"]*"[^>]*>(.*?)</div>',
                r'<section[^>]*id="[^"]*abstract[^"]*"[^>]*>(.*?)</section>',
                r'"abstract":\s*"([^"]+)"',
            ]
            
            for pattern in abstract_patterns:
                matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
                if matches:
                    abstract_text = matches[0]
                    # Clean HTML
                    abstract_text = re.sub(r'<[^>]+>', ' ', abstract_text)
                    abstract_text = ' '.join(abstract_text.split())
                    if len(abstract_text) > 100:
                        result['enhanced_abstract'] = abstract_text
                        break
            
            # Conclusion extraction patterns
            conclusion_patterns = [
                r'<(?:div|section)[^>]*(?:class|id)="[^"]*conclusion[^"]*"[^>]*>(.*?)</(?:div|section)>',
                r'<h[2-6][^>]*>(?:\d+\.?\s*)?conclusions?\s*</h[2-6]>\s*(.*?)(?=<h[2-6]|<div[^>]*class="[^"]*references|$)',
                r'(\d+\.?\s*conclusions?\s*\.?\s*)(.*?)(?=\d+\.?\s*(?:references?|acknowledgment)|$)',
            ]
            
            for pattern in conclusion_patterns:
                matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
                if matches:
                    if isinstance(matches[0], tuple):
                        conclusion_text = matches[0][1]
                    else:
                        conclusion_text = matches[0]
                    
                    # Clean HTML and format
                    conclusion_text = re.sub(r'<[^>]+>', ' ', conclusion_text)
                    conclusion_text = ' '.join(conclusion_text.split())
                    
                    if 50 <= len(conclusion_text) <= 2000:
                        result['conclusion'] = conclusion_text
                        result['extraction_method'] = 'requests_pattern'
                        break
            
            return result
            
        except Exception as e:
            logger.error(f"Requests extraction error for {url}: {e}")
            return {'error': str(e)}
    
    def extract_other_publishers(self, url: str) -> Dict[str, Any]:
        """Extract from other publishers (Springer, Wiley, etc.)."""
        try:
            domain = urlparse(url).netloc.lower()
            
            if 'springer' in domain:
                return self._extract_springer(url)
            elif 'wiley' in domain:
                return self._extract_wiley(url)
            elif 'ieee' in domain:
                return self._extract_ieee(url)
            else:
                return self._extract_generic(url)
                
        except Exception as e:
            logger.error(f"Error extracting from {url}: {e}")
            return {'error': str(e)}
    
    def _extract_generic(self, url: str) -> Dict[str, Any]:
        """Generic extraction for any publisher."""
        try:
            if self.use_selenium and self.driver:
                self.driver.get(url)
                time.sleep(self.delay)
                
                page_text = self.driver.find_element(By.TAG_NAME, 'body').get_attribute('textContent')
            else:
                response = self.session.get(url, timeout=15)
                page_text = response.text
                # Remove HTML tags
                page_text = re.sub(r'<[^>]+>', ' ', page_text)
            
            result = {}
            
            # Generic conclusion patterns
            conclusion_patterns = [
                r'(\d+\.?\s*conclusions?\s*\.?\s*)(.*?)(?=\d+\.?\s*(?:references?|acknowledgment|appendix)|$)',
                r'(conclusions?\s*\.?\s*)(.*?)(?=references?|acknowledgment|appendix|$)',
                r'(concluding remarks?\s*\.?\s*)(.*?)(?=references?|acknowledgment|$)',
            ]
            
            for pattern in conclusion_patterns:
                matches = re.finditer(pattern, page_text, re.IGNORECASE | re.DOTALL)
                for match in matches:
                    conclusion_text = match.group(2).strip()
                    conclusion_text = ' '.join(conclusion_text.split())
                    if 50 <= len(conclusion_text) <= 2000:
                        result['conclusion'] = conclusion_text
                        result['extraction_method'] = 'generic_pattern'
                        break
                if 'conclusion' in result:
                    break
            
            return result
            
        except Exception as e:
            logger.error(f"Generic extraction error for {url}: {e}")
            return {'error': str(e)}
    
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
                logger.info(f"  Extracting from ScienceDirect...")
                sd_data = self.extract_sciencedirect_content(sciencedirect_url)
                if sd_data and 'error' not in sd_data:
                    extraction_data['sciencedirect'] = sd_data
                    if 'conclusion' in sd_data:
                        logger.info(f"  ✅ Found conclusion ({len(sd_data['conclusion'])} chars)")
                time.sleep(self.delay)
            
            # If no conclusion found and we have DOI, try the publisher directly
            if 'conclusion' not in extraction_data.get('sciencedirect', {}) and doi_url:
                logger.info(f"  Trying publisher website...")
                publisher_data = self.extract_other_publishers(doi_url)
                if publisher_data and 'error' not in publisher_data:
                    extraction_data['publisher'] = publisher_data
                    if 'conclusion' in publisher_data:
                        logger.info(f"  ✅ Found conclusion from publisher ({len(publisher_data['conclusion'])} chars)")
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
                
                result['extraction_summary'] = found_items
            
        except Exception as e:
            logger.error(f"Error processing {title}: {e}")
            result['extraction_error'] = str(e)
        
        return result
    
    def process_citations(self, citations: List[Dict[str, Any]], 
                         max_papers: Optional[int] = None,
                         start_from: int = 0) -> List[Dict[str, Any]]:
        """Process multiple citations."""
        processed = []
        total = min(len(citations), max_papers) if max_papers else len(citations)
        
        logger.info(f"Starting extraction for {total} papers (starting from {start_from})...")
        
        citations_slice = citations[start_from:start_from + total] if max_papers else citations[start_from:]
        
        for i, citation in enumerate(citations_slice):
            logger.info(f"Processing {start_from + i + 1}/{len(citations)}")
            
            try:
                result = self.process_citation(citation)
                processed.append(result)
                
                # Progress update
                if (i + 1) % 5 == 0:
                    conclusions_found = sum(1 for c in processed 
                                          if any('conclusion' in data 
                                               for data in c.get('content_extraction', {}).values()))
                    logger.info(f"Progress: {i + 1}/{len(citations_slice)} processed, {conclusions_found} conclusions found")
                
            except Exception as e:
                logger.error(f"Error processing citation {start_from + i + 1}: {e}")
                processed.append(citation)  # Keep original
        
        return processed
    
    def cleanup(self):
        """Clean up resources."""
        if self.driver:
            self.driver.quit()


def main():
    """Main function."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Extract conclusions using institutional access")
    parser.add_argument("--input", default="dataset/processed/combined_citations.json")
    parser.add_argument("--output", default="dataset/processed/citations_with_conclusions.json")
    parser.add_argument("--max-papers", type=int, default=None, help="Max papers to process")
    parser.add_argument("--start-from", type=int, default=0, help="Start from paper number")
    parser.add_argument("--delay", type=float, default=3.0, help="Delay between requests")
    parser.add_argument("--no-selenium", action="store_true", help="Don't use Selenium")
    parser.add_argument("--headless", action="store_true", default=True, help="Run browser in headless mode")
    
    args = parser.parse_args()
    
    # Load citations
    with open(args.input, 'r') as f:
        citations = json.load(f)
    
    logger.info(f"Loaded {len(citations)} citations")
    
    # Initialize scraper
    scraper = InstitutionalScraper(
        use_selenium=not args.no_selenium,
        headless=args.headless,
        delay=args.delay
    )
    
    try:
        # Process citations
        processed = scraper.process_citations(
            citations, 
            max_papers=args.max_papers,
            start_from=args.start_from
        )
        
        # If continuing from existing file, merge results
        if Path(args.output).exists() and args.start_from > 0:
            with open(args.output, 'r') as f:
                existing = json.load(f)
            
            # Update existing with new results
            for i, new_citation in enumerate(processed):
                existing[args.start_from + i] = new_citation
            
            processed = existing
        
        # Save results
        with open(args.output, 'w') as f:
            json.dump(processed, f, indent=2, ensure_ascii=False)
        
        # Summary
        conclusion_count = sum(1 for c in processed 
                              if any('conclusion' in data 
                                   for data in c.get('content_extraction', {}).values()))
        enhanced_abstract_count = sum(1 for c in processed 
                                    if any('enhanced_abstract' in data 
                                         for data in c.get('content_extraction', {}).values()))
        
        print(f"\n📊 EXTRACTION SUMMARY")
        print(f"Papers processed: {len(processed)}")
        print(f"Conclusions found: {conclusion_count}")
        print(f"Enhanced abstracts found: {enhanced_abstract_count}")
        
        if conclusion_count > 0:
            print(f"\n✅ Successfully extracted {conclusion_count} conclusions!")
            print(f"💾 Results saved to: {args.output}")
        
    finally:
        scraper.cleanup()


if __name__ == "__main__":
    main()
