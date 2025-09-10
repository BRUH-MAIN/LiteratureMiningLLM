import json
import requests
import time
import re
import pandas as pd
from typing import List, Dict, Optional
import logging
import os
from dotenv import load_dotenv
import xml.etree.ElementTree as ET
from concurrent.futures import ThreadPoolExecutor, as_completed
import threading
from queue import Queue

# Load environment variables
load_dotenv()

# Set up logging with thread-safe formatting
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(threadName)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class ThreadedElsevierConclusionExtractor:
    def __init__(self, max_workers: int = 5):
        # Get API key from environment
        self.api_key = os.getenv('ELSEVIER_API_KEY')
        if not self.api_key:
            raise ValueError("ELSEVIER_API_KEY not found in environment variables")
        
        # Thread-local session storage
        self.local = threading.local()
        
        # Base URLs for Elsevier Text Mining API
        self.article_base_url = "https://api.elsevier.com/content/article"
        self.search_url = "https://api.elsevier.com/content/search/scidir"
        
        # Threading configuration
        self.max_workers = max_workers
        self.request_delay = 0.5  # Reduced delay for threading
        
        # Thread-safe request tracking
        self.request_lock = threading.Lock()
        self.request_count = 0
        
        logger.info(f"Initialized with API key: {self.api_key[:8]}... using {max_workers} threads")
    
    def get_session(self):
        """Get thread-local session"""
        if not hasattr(self.local, 'session'):
            self.local.session = requests.Session()
            self.local.session.headers.update({
                'X-ELS-APIKey': self.api_key,
            })
        return self.local.session
    
    def rate_limit(self):
        """Thread-safe rate limiting"""
        with self.request_lock:
            self.request_count += 1
            if self.request_count % 10 == 0:  # Log every 10 requests
                logger.info(f"Made {self.request_count} API requests so far")
        time.sleep(self.request_delay)
    
    def load_json_data(self, file_path: str) -> List[Dict]:
        """Load papers from JSON file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                if isinstance(data, list):
                    return data
                else:
                    return [data]
        except Exception as e:
            logger.error(f"Error loading JSON data: {e}")
            return []
    
    def extract_doi_from_url(self, doi_url: str) -> Optional[str]:
        """Extract DOI from DOI URL"""
        if not doi_url:
            return None
        
        patterns = [
            r'doi\.org/(.+)',
            r'dx\.doi\.org/(.+)',
            r'doi:(.+)'
        ]
        
        for pattern in patterns:
            match = re.search(pattern, doi_url)
            if match:
                return match.group(1).strip()
        
        return None
    
    def extract_pii_from_sciencedirect_url(self, url: str) -> Optional[str]:
        """Extract PII from ScienceDirect URL"""
        if not url or 'sciencedirect' not in url.lower():
            return None
        
        # Pattern: /science/article/pii/S0925838825016536
        match = re.search(r'/pii/([A-Z0-9]+)', url, re.IGNORECASE)
        if match:
            return match.group(1)
        
        return None
    
    def get_paper_content(self, doi: str = None, pii: str = None, format_type: str = 'xml') -> Optional[Dict]:
        """Get paper content using DOI or PII"""
        try:
            if doi:
                url = f"{self.article_base_url}/doi/{doi}"
                identifier = f"DOI: {doi}"
            elif pii:
                url = f"{self.article_base_url}/pii/{pii}"
                identifier = f"PII: {pii}"
            else:
                return None
            
            session = self.get_session()
            headers = {
                'Accept': 'text/xml' if format_type == 'xml' else 'text/plain'
            }
            
            params = {
                'view': 'FULL'
            }
            
            self.rate_limit()  # Rate limiting
            
            logger.debug(f"[{threading.current_thread().name}] Fetching {format_type} content for {identifier}")
            response = session.get(url, headers=headers, params=params, timeout=30)
            
            if response.status_code == 200:
                return {
                    'content': response.text,
                    'format': format_type,
                    'identifier': identifier,
                    'status_code': response.status_code
                }
            elif response.status_code == 404:
                logger.debug(f"Article not found for {identifier}")
                return None
            elif response.status_code == 403:
                logger.debug(f"Access denied for {identifier}")
                return None
            else:
                logger.warning(f"API request failed for {identifier}: {response.status_code}")
                return None
                
        except Exception as e:
            logger.error(f"Error fetching content: {e}")
            return None
    
    def extract_conclusion_from_xml(self, xml_content: str) -> Optional[str]:
        """Extract conclusion from XML content"""
        try:
            root = ET.fromstring(xml_content)
            
            # Look for conclusion sections using simple iteration
            conclusion_keywords = ['conclusion', 'conclusions', 'concluding', 'summary', 'final remarks']
            
            # Search through all elements for sections
            for elem in root.iter():
                if elem.tag and ('section' in elem.tag.lower() or 'sec' in elem.tag.lower()):
                    # Check section title
                    section_title = ''
                    
                    # Try different ways to get section title
                    if elem.get('title'):
                        section_title = elem.get('title').lower()
                    else:
                        # Look for title child elements
                        for child in elem:
                            if 'title' in child.tag.lower() and child.text:
                                section_title = child.text.lower()
                                break
                    
                    # Check if this is a conclusion section
                    if any(keyword in section_title for keyword in conclusion_keywords):
                        text = self._extract_text_from_element(elem)
                        if text and len(text.strip()) > 100:  # Ensure substantial content
                            return text.strip()
                    
                    # Check for numbered conclusions (e.g., "4. Conclusion")
                    if re.search(r'\d+\.?\s*(conclusion|conclusions)', section_title):
                        text = self._extract_text_from_element(elem)
                        if text and len(text.strip()) > 100:
                            return text.strip()
            
            # Fallback: look for conclusion text in any element
            for elem in root.iter():
                if elem.text and any(keyword in elem.text.lower() for keyword in conclusion_keywords):
                    # Try to get surrounding context
                    parent = elem.getparent() if hasattr(elem, 'getparent') else None
                    if parent is not None:
                        text = self._extract_text_from_element(parent)
                        if text and len(text.strip()) > 200:
                            return text.strip()[:2000]  # Limit length
            
            return None
            
        except ET.ParseError as e:
            logger.error(f"XML parsing error: {e}")
            return None
        except Exception as e:
            logger.error(f"Error extracting conclusion from XML: {e}")
            return None
    
    def extract_conclusion_from_plain_text(self, plain_text: str) -> Optional[str]:
        """Extract conclusion from plain text"""
        try:
            # Clean and normalize text
            lines = [line.strip() for line in plain_text.split('\n') if line.strip()]
            text = ' '.join(lines)
            
            # Patterns to find conclusion sections
            conclusion_patterns = [
                # Strong patterns with clear section boundaries
                r'(?:^|\n)\s*(?:\d+\.?\s*)?conclusions?\s*[:\n](.*?)(?=\n\s*(?:\d+\.?\s*)?(?:references|bibliography|acknowledgment|funding|declaration|appendix|supplementary|competing interests)|\Z)',
                r'(?:^|\n)\s*(?:\d+\.?\s*)?concluding remarks\s*[:\n](.*?)(?=\n\s*(?:\d+\.?\s*)?(?:references|bibliography|acknowledgment|funding|declaration|appendix|supplementary)|\Z)',
                r'(?:^|\n)\s*(?:\d+\.?\s*)?summary and conclusions?\s*[:\n](.*?)(?=\n\s*(?:\d+\.?\s*)?(?:references|bibliography|acknowledgment|funding|declaration|appendix|supplementary)|\Z)',
                
                # Weaker patterns for inline conclusions
                r'(?:\d+\.?\s*)?conclusions?\s*:?\s*(.*?)(?=\s*references|bibliography|acknowledgment|funding|declaration|appendix|supplementary|\Z)',
                r'in conclusion[,.]?\s*(.*?)(?=\s*references|bibliography|acknowledgment|funding|declaration|appendix|supplementary|\Z)',
                r'to conclude[,.]?\s*(.*?)(?=\s*references|bibliography|acknowledgment|funding|declaration|appendix|supplementary|\Z)'
            ]
            
            for pattern in conclusion_patterns:
                matches = re.finditer(pattern, text, re.IGNORECASE | re.DOTALL | re.MULTILINE)
                for match in matches:
                    conclusion = match.group(1).strip()
                    
                    # Filter conclusions by length and quality
                    if 150 < len(conclusion) < 3000:  # Reasonable length
                        # Clean up the conclusion text
                        conclusion = re.sub(r'\s+', ' ', conclusion)  # Normalize whitespace
                        conclusion = re.sub(r'^[^\w]*', '', conclusion)  # Remove leading non-word chars
                        
                        # Ensure it's not just references or metadata
                        if not re.match(r'^\s*\[?\d+\]?\s*$', conclusion) and \
                           'references' not in conclusion.lower()[:50]:
                            return conclusion
            
            return None
            
        except Exception as e:
            logger.error(f"Error extracting conclusion from plain text: {e}")
            return None
    
    def _extract_text_from_element(self, element) -> str:
        """Extract all text from an XML element and its children"""
        if element is None:
            return ''
        
        text_parts = []
        
        if element.text:
            text_parts.append(element.text.strip())
        
        for child in element:
            child_text = self._extract_text_from_element(child)
            if child_text:
                text_parts.append(child_text)
            
            if child.tail:
                text_parts.append(child.tail.strip())
        
        return ' '.join(text_parts)
    
    def extract_conclusion_for_paper(self, paper: Dict) -> Dict:
        """Extract conclusion for a single paper"""
        result = {
            'title': paper.get('title', ''),
            'authors': paper.get('authors', ''),
            'journal': paper.get('journal', ''),
            'year': paper.get('year', ''),
            'doi_url': paper.get('doi_url', ''),
            'sciencedirect_url': paper.get('sciencedirect_url', ''),
            'conclusion': None,
            'status': 'failed',
            'error': None,
            'extraction_method': None,
            'thread_name': threading.current_thread().name
        }
        
        try:
            doi = None
            pii = None
            
            # Extract identifiers
            if paper.get('doi_url'):
                doi = self.extract_doi_from_url(paper['doi_url'])
            
            if paper.get('sciencedirect_url'):
                pii = self.extract_pii_from_sciencedirect_url(paper['sciencedirect_url'])
            
            # Try different methods to get content and extract conclusions
            methods = [
                ('plain_doi', 'plain', lambda: self.get_paper_content(doi=doi, format_type='plain') if doi else None),
                ('plain_pii', 'plain', lambda: self.get_paper_content(pii=pii, format_type='plain') if pii else None),
                ('xml_doi', 'xml', lambda: self.get_paper_content(doi=doi, format_type='xml') if doi else None),
                ('xml_pii', 'xml', lambda: self.get_paper_content(pii=pii, format_type='xml') if pii else None),
            ]
            
            for method_name, content_format, method_func in methods:
                try:
                    content_response = method_func()
                    if content_response and content_response.get('content'):
                        content = content_response['content']
                        
                        # Extract conclusion based on content format
                        if content_format == 'xml':
                            conclusion = self.extract_conclusion_from_xml(content)
                        else:
                            conclusion = self.extract_conclusion_from_plain_text(content)
                        
                        if conclusion:
                            result['conclusion'] = conclusion
                            result['status'] = 'success'
                            result['extraction_method'] = method_name
                            
                            logger.info(f"[{threading.current_thread().name}] ✅ Extracted conclusion using {method_name} for: {result['title'][:50]}...")
                            return result
                    
                except Exception as e:
                    logger.debug(f"Method {method_name} failed for {result['title'][:50]}...: {e}")
                    continue
            
            result['error'] = 'Could not extract conclusion using any method'
            logger.debug(f"[{threading.current_thread().name}] ❌ Failed to extract conclusion for: {result['title'][:50]}...")
            
        except Exception as e:
            result['error'] = str(e)
            logger.error(f"Error processing paper '{result['title']}': {e}")
        
        return result
    
    def process_papers_batch(self, papers_batch: List[Dict], batch_id: int) -> List[Dict]:
        """Process a batch of papers in a single thread"""
        logger.info(f"[Batch-{batch_id}] Starting to process {len(papers_batch)} papers")
        results = []
        
        for i, paper in enumerate(papers_batch):
            logger.debug(f"[Batch-{batch_id}] Processing paper {i+1}/{len(papers_batch)}: {paper.get('title', 'Unknown')[:30]}...")
            result = self.extract_conclusion_for_paper(paper)
            results.append(result)
        
        successful = sum(1 for r in results if r['status'] == 'success')
        logger.info(f"[Batch-{batch_id}] Completed: {successful}/{len(results)} successful extractions")
        
        return results
    
    def process_all_papers(self, papers: List[Dict]) -> List[Dict]:
        """Process all papers using threading"""
        total_papers = len(papers)
        logger.info(f"Starting to process {total_papers} papers using {self.max_workers} threads...")
        
        # Split papers into batches for threading
        batch_size = max(1, total_papers // self.max_workers)
        paper_batches = [papers[i:i + batch_size] for i in range(0, total_papers, batch_size)]
        
        logger.info(f"Created {len(paper_batches)} batches (avg {batch_size} papers per batch)")
        
        all_results = []
        
        # Process batches using ThreadPoolExecutor
        with ThreadPoolExecutor(max_workers=self.max_workers, thread_name_prefix="Paper") as executor:
            # Submit all batches
            future_to_batch = {
                executor.submit(self.process_papers_batch, batch, i): i 
                for i, batch in enumerate(paper_batches)
            }
            
            # Collect results as they complete
            for future in as_completed(future_to_batch):
                batch_id = future_to_batch[future]
                try:
                    batch_results = future.result()
                    all_results.extend(batch_results)
                    
                    completed = len(all_results)
                    logger.info(f"Progress: {completed}/{total_papers} papers processed ({completed/total_papers:.1%})")
                    
                except Exception as e:
                    logger.error(f"Batch {batch_id} failed: {e}")
        
        logger.info(f"Completed processing all {total_papers} papers")
        return all_results
    
    def save_results(self, results: List[Dict], output_file: str):
        """Save results focusing on conclusions"""
        # Save complete results as JSON
        json_file = output_file if output_file.endswith('.json') else f"{output_file}.json"
        with open(json_file, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, ensure_ascii=False)
        
        # Create a conclusions-focused CSV
        conclusions_data = []
        for result in results:
            conclusion_row = {
                'title': result['title'],
                'authors': result['authors'],
                'journal': result['journal'],
                'year': result['year'],
                'doi_url': result.get('doi_url', ''),
                'status': result['status'],
                'extraction_method': result.get('extraction_method', ''),
                'conclusion': result.get('conclusion') or '',
                'conclusion_length': len(result.get('conclusion') or ''),
                'has_conclusion': bool(result.get('conclusion')),
                'error': result.get('error', ''),
                'thread_name': result.get('thread_name', '')
            }
            conclusions_data.append(conclusion_row)
        
        # Save conclusions CSV
        csv_file = json_file.replace('.json', '_conclusions.csv')
        df = pd.DataFrame(conclusions_data)
        df.to_csv(csv_file, index=False, encoding='utf-8')
        
        # Calculate and save processing summary
        successful = sum(1 for r in results if r['status'] == 'success')
        total = len(results)
        
        # Get conclusion length statistics
        conclusion_lengths = [len(r.get('conclusion') or '') for r in results if r.get('conclusion')]
        
        summary = {
            'total_papers': total,
            'successful_extractions': successful,
            'failed_extractions': total - successful,
            'success_rate': successful / total if total > 0 else 0,
            'extraction_methods': {},
            'conclusion_stats': {
                'total_conclusions': len(conclusion_lengths),
                'avg_conclusion_length': sum(conclusion_lengths) / len(conclusion_lengths) if conclusion_lengths else 0,
                'min_conclusion_length': min(conclusion_lengths) if conclusion_lengths else 0,
                'max_conclusion_length': max(conclusion_lengths) if conclusion_lengths else 0
            },
            'total_requests_made': self.request_count
        }
        
        # Count extraction methods used
        for result in results:
            if result['status'] == 'success':
                method = result.get('extraction_method', 'unknown')
                summary['extraction_methods'][method] = summary['extraction_methods'].get(method, 0) + 1
        
        # Save summary
        summary_file = json_file.replace('.json', '_summary.json')
        with open(summary_file, 'w', encoding='utf-8') as f:
            json.dump(summary, f, indent=2)
        
        logger.info(f"📁 Results saved:")
        logger.info(f"   Full results: {json_file}")
        logger.info(f"   Conclusions CSV: {csv_file}")
        logger.info(f"   Summary: {summary_file}")
        logger.info(f"📊 Final stats: {successful}/{total} successful ({summary['success_rate']:.1%})")
        logger.info(f"🚀 Total API requests made: {self.request_count}")
        
        return summary
    
    def append_conclusions_to_combined_citations(self, conclusion_results: List[Dict], original_citations_file: str, output_file: str = None):
        """Append extracted conclusions to the original combined citations JSON file"""
        if not output_file:
            output_file = original_citations_file.replace('.json', '_with_conclusions.json')
        
        # Load original citations
        try:
            with open(original_citations_file, 'r', encoding='utf-8') as f:
                original_citations = json.load(f)
            logger.info(f"📚 Loaded {len(original_citations)} papers from {original_citations_file}")
        except Exception as e:
            logger.error(f"Error loading original citations: {e}")
            return None
        
        # Create lookup dictionary for conclusions by DOI and title
        conclusions_lookup = {}
        
        for result in conclusion_results:
            # Create lookup keys
            doi_key = None
            if result.get('doi_url'):
                doi_key = result['doi_url'].strip().lower()
            
            title_key = result.get('title', '').strip().lower()
            
            # Store conclusion data
            conclusion_data = {
                'extracted_conclusion': result.get('conclusion'),
                'conclusion_extraction_status': result.get('status'),
                'conclusion_extraction_method': result.get('extraction_method'),
                'conclusion_extraction_error': result.get('error'),
                'conclusion_length': len(result.get('conclusion') or ''),
                'has_extracted_conclusion': bool(result.get('conclusion'))
            }
            
            if doi_key:
                conclusions_lookup[doi_key] = conclusion_data
            if title_key:
                conclusions_lookup[title_key] = conclusion_data
        
        # Append conclusions to original citations
        enriched_citations = []
        matched_count = 0
        
        for citation in original_citations:
            # Create a copy of the original citation
            enriched_citation = citation.copy()
            
            # Try to match by DOI first
            doi_match = False
            if citation.get('doi_url'):
                doi_key = citation['doi_url'].strip().lower()
                if doi_key in conclusions_lookup:
                    enriched_citation.update(conclusions_lookup[doi_key])
                    matched_count += 1
                    doi_match = True
            
            # If no DOI match, try to match by title
            if not doi_match and citation.get('title'):
                title_key = citation['title'].strip().lower()
                if title_key in conclusions_lookup:
                    enriched_citation.update(conclusions_lookup[title_key])
                    matched_count += 1
            
            # If no match found, add empty conclusion fields
            if 'extracted_conclusion' not in enriched_citation:
                enriched_citation.update({
                    'extracted_conclusion': None,
                    'conclusion_extraction_status': 'not_processed',
                    'conclusion_extraction_method': None,
                    'conclusion_extraction_error': None,
                    'conclusion_length': 0,
                    'has_extracted_conclusion': False
                })
            
            enriched_citations.append(enriched_citation)
        
        # Save enriched citations
        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(enriched_citations, f, indent=2, ensure_ascii=False)
            
            logger.info(f"✅ Enriched citations saved to: {output_file}")
            logger.info(f"📊 Matched conclusions for {matched_count}/{len(original_citations)} papers ({matched_count/len(original_citations):.1%})")
            
            return {
                'output_file': output_file,
                'total_papers': len(enriched_citations),
                'matched_conclusions': matched_count,
                'match_rate': matched_count / len(original_citations) if original_citations else 0
            }
            
        except Exception as e:
            logger.error(f"Error saving enriched citations: {e}")
            return None
    
    def test_api_connection(self) -> bool:
        """Test if API key is working"""
        try:
            # Test with a known DOI
            test_url = f"{self.article_base_url}/doi/10.1016/j.cell.2021.02.002"
            session = self.get_session()
            headers = {'Accept': 'application/json'}
            
            response = session.get(test_url, headers=headers, timeout=10)
            
            if response.status_code == 200:
                logger.info("✅ API key is working correctly!")
                return True
            elif response.status_code == 401:
                logger.error("❌ API key authentication failed - check your key")
                return False
            elif response.status_code == 403:
                logger.warning("⚠️ API key valid but access denied - check permissions")
                return True  # Key is valid, just limited access
            else:
                logger.warning(f"⚠️ API test returned status code: {response.status_code}")
                return True  # Assume key is valid
                
        except Exception as e:
            logger.error(f"Error testing API connection: {e}")
            return False

# Main execution function
def main():
    try:
        # Initialize extractor with threading (adjust max_workers as needed)
        extractor = ThreadedElsevierConclusionExtractor(max_workers=16)
        
        # Test API connection
        if not extractor.test_api_connection():
            print("❌ API connection test failed. Please check your API key and try again.")
            return
        
        # Load your papers
        combined_citations_file = '/home/rohan/LiteratureMiningLLM/dataset/processed/combined_citations.json'
        papers = extractor.load_json_data(combined_citations_file)
        
        if not papers:
            print("❌ No papers loaded. Please check your JSON file.")
            return
        
        print(f"📚 Loaded {len(papers)} papers for conclusion extraction.")
        
        # Process papers with threading
        start_time = time.time()
        results = extractor.process_all_papers(papers)
        end_time = time.time()
        
        # Save results
        summary = extractor.save_results(results, 'paper_conclusions')
        
        # Append conclusions to combined citations and create enriched file
        print("\n📝 Appending conclusions to combined citations...")
        enriched_output_file = '/home/rohan/LiteratureMiningLLM/dataset/processed/combined_citations_with_conclusions.json'
        enrichment_result = extractor.append_conclusions_to_combined_citations(
            results, 
            combined_citations_file, 
            enriched_output_file
        )
        
        processing_time = end_time - start_time
        
        print(f"\n🎉 PROCESSING COMPLETE!")
        print(f"⏱️  Total processing time: {processing_time:.2f} seconds")
        print(f"📊 Total papers: {summary['total_papers']}")
        print(f"✅ Successful extractions: {summary['successful_extractions']}")
        print(f"❌ Failed extractions: {summary['failed_extractions']}")
        print(f"📈 Success rate: {summary['success_rate']:.1%}")
        print(f"🚀 Total API requests: {summary['total_requests_made']}")
        print(f"⚡ Avg papers/second: {len(papers)/processing_time:.2f}")
        
        if enrichment_result:
            print(f"\n📄 ENRICHED DATASET CREATED:")
            print(f"   File: {enrichment_result['output_file']}")
            print(f"   Total papers: {enrichment_result['total_papers']}")
            print(f"   Papers with conclusions: {enrichment_result['matched_conclusions']}")
            print(f"   Match rate: {enrichment_result['match_rate']:.1%}")
        
        if summary['extraction_methods']:
            print(f"\n📋 Extraction methods used:")
            for method, count in summary['extraction_methods'].items():
                print(f"   {method}: {count} papers")
        
        if summary['conclusion_stats']['total_conclusions'] > 0:
            stats = summary['conclusion_stats']
            print(f"\n📝 Conclusion statistics:")
            print(f"   Average length: {stats['avg_conclusion_length']:.0f} characters")
            print(f"   Range: {stats['min_conclusion_length']}-{stats['max_conclusion_length']} characters")
                
    except Exception as e:
        logger.error(f"Fatal error in main execution: {e}")
        print(f"❌ Fatal error: {e}")

# Quick test function
def test_single_paper(paper_index: int = 0):
    """Test conclusion extraction on a single paper"""
    try:
        extractor = ThreadedElsevierConclusionExtractor(max_workers=1)
        papers = extractor.load_json_data('/home/rohan/LiteratureMiningLLM/dataset/processed/combined_citations.json')
        
        if not papers or paper_index >= len(papers):
            print("❌ Invalid paper index or no papers loaded")
            return
        
        paper = papers[paper_index]
        print(f"🧪 Testing conclusion extraction for: {paper.get('title', 'Unknown')[:50]}...")
        
        result = extractor.extract_conclusion_for_paper(paper)
        
        if result['status'] == 'success':
            conclusion = result['conclusion']
            print(f"✅ Success! Method: {result['extraction_method']}")
            print(f"📝 Conclusion length: {len(conclusion)} characters")
            print(f"📖 Conclusion preview:")
            print("-" * 50)
            print(conclusion[:500] + "..." if len(conclusion) > 500 else conclusion)
            print("-" * 50)
        else:
            print(f"❌ Failed: {result.get('error', 'Unknown error')}")
            
    except Exception as e:
        print(f"❌ Test failed: {e}")

# Function to create enriched dataset only (if you already have conclusion results)
def create_enriched_dataset_from_existing_results(conclusion_results_file: str = 'paper_conclusions.json'):
    """Create enriched dataset from existing conclusion extraction results"""
    try:
        extractor = ThreadedElsevierConclusionExtractor(max_workers=1)
        
        # Load existing conclusion results
        with open(conclusion_results_file, 'r', encoding='utf-8') as f:
            conclusion_results = json.load(f)
        
        print(f"📚 Loaded {len(conclusion_results)} conclusion results from {conclusion_results_file}")
        
        # Create enriched dataset
        combined_citations_file = '/home/rohan/LiteratureMiningLLM/dataset/processed/combined_citations.json'
        enriched_output_file = '/home/rohan/LiteratureMiningLLM/dataset/processed/combined_citations_with_conclusions.json'
        
        enrichment_result = extractor.append_conclusions_to_combined_citations(
            conclusion_results, 
            combined_citations_file, 
            enriched_output_file
        )
        
        if enrichment_result:
            print(f"\n✅ ENRICHED DATASET CREATED:")
            print(f"   File: {enrichment_result['output_file']}")
            print(f"   Total papers: {enrichment_result['total_papers']}")
            print(f"   Papers with conclusions: {enrichment_result['matched_conclusions']}")
            print(f"   Match rate: {enrichment_result['match_rate']:.1%}")
        else:
            print("❌ Failed to create enriched dataset")
            
    except Exception as e:
        print(f"❌ Error creating enriched dataset: {e}")

if __name__ == "__main__":
    # Option 1: Run full conclusion extraction and create enriched dataset
    main()
    
    # Option 2: If you already have conclusion results and just want to create enriched dataset:
    # create_enriched_dataset_from_existing_results('paper_conclusions.json')
    
    # Option 3: Test a single paper first:
    # test_single_paper(0)