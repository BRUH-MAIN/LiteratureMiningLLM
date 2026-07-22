#!/usr/bin/env python3
"""
Comprehensive Citation Preprocessing Pipeline
This script processes all ScienceDirect citation text files to JSON format,
performs analysis, validation, and cleaning in a single workflow.
"""

import json
import re
import sys
from pathlib import Path
from collections import Counter, defaultdict
from typing import List, Dict, Any, Tuple
from datetime import datetime


class CitationProcessor:
    """Main class for processing ScienceDirect citations."""
    
    def __init__(self, raw_data_dir: str = "dataset/raw", 
                 output_dir: str = "dataset/processed"):
        self.raw_data_dir = Path(raw_data_dir)
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
    def parse_citation_text(self, text: str) -> List[Dict[str, Any]]:
        """Parse citation text file and extract structured data."""
        citations = []
        citation_blocks = re.split(r'\n\n(?=[A-Z])', text.strip())
        
        for block in citation_blocks:
            if not block.strip():
                continue
            citation = self._parse_single_citation(block.strip())
            if citation:
                citations.append(citation)
        
        return citations
    
    def _parse_single_citation(self, block: str) -> Dict[str, Any]:
        """Parse a single citation block into structured data."""
        lines = [line.strip() for line in block.split('\n') if line.strip()]
        
        if len(lines) < 5:
            return None
        
        citation = {}
        i = 0
        
        # Authors (first line)
        citation['authors'] = lines[i]
        i += 1
        
        # Title (second line)
        citation['title'] = lines[i].rstrip(',')
        i += 1
        
        # Journal (third line)
        citation['journal'] = lines[i].rstrip(',')
        i += 1
        
        # Volume/Issue information
        volume_info = []
        while i < len(lines) and not lines[i].isdigit() and 'ISSN' not in lines[i]:
            if lines[i].rstrip(','):
                volume_info.append(lines[i].rstrip(','))
            i += 1
        citation['volume_info'] = volume_info
        
        # Year
        if i < len(lines) and lines[i].isdigit() and len(lines[i]) == 4:
            citation['year'] = int(lines[i])
            i += 1
        
        # Article ID
        if i < len(lines) and 'ISSN' not in lines[i] and 'https' not in lines[i]:
            citation['article_id'] = lines[i].rstrip(',')
            i += 1
        
        # ISSN
        if i < len(lines) and lines[i].startswith('ISSN'):
            citation['issn'] = lines[i].replace('ISSN ', '').rstrip(',')
            i += 1
        
        # DOI URL
        if i < len(lines) and lines[i].startswith('https://doi.org'):
            citation['doi_url'] = lines[i].rstrip('.')
            i += 1
        
        # ScienceDirect URL
        if i < len(lines) and lines[i].startswith('(https://www.sciencedirect.com'):
            citation['sciencedirect_url'] = lines[i].strip('()')
            i += 1
        
        # Abstract and Keywords
        abstract_start = keywords_start = None
        for j in range(i, len(lines)):
            if lines[j].startswith('Abstract:'):
                abstract_start = j
            elif lines[j].startswith('Keywords:'):
                keywords_start = j
                break
        
        if abstract_start is not None:
            if keywords_start is not None:
                abstract_lines = lines[abstract_start:keywords_start]
            else:
                abstract_lines = lines[abstract_start:]
            abstract_text = ' '.join(abstract_lines)
            citation['abstract'] = abstract_text.replace('Abstract: ', '', 1)
        
        if keywords_start is not None:
            keywords_line = ' '.join(lines[keywords_start:])
            keywords_text = keywords_line.replace('Keywords: ', '', 1)
            keywords = [kw.strip() for kw in keywords_text.split(';') if kw.strip()]
            citation['keywords'] = keywords
        
        return citation
    
    def clean_citation(self, citation: Dict[str, Any]) -> Dict[str, Any]:
        """Clean and normalize a citation dictionary."""
        cleaned = citation.copy()
        
        # Clean authors (remove trailing comma)
        if cleaned.get('authors'):
            cleaned['authors'] = cleaned['authors'].rstrip(',').strip()
        
        # Clean title and journal
        for field in ['title', 'journal']:
            if cleaned.get(field):
                cleaned[field] = cleaned[field].strip()
        
        # Clean keywords
        if cleaned.get('keywords') and isinstance(cleaned['keywords'], list):
            cleaned['keywords'] = [kw.strip() for kw in cleaned['keywords'] if kw.strip()]
        
        # Clean ISSN
        if cleaned.get('issn'):
            cleaned['issn'] = cleaned['issn'].strip()
        
        # Extract year from volume_info if not present
        if not cleaned.get('year') and cleaned.get('volume_info'):
            for item in cleaned['volume_info']:
                if isinstance(item, str) and item.isdigit() and len(item) == 4:
                    try:
                        year = int(item)
                        if 1900 <= year <= 2030:
                            cleaned['year'] = year
                            break
                    except ValueError:
                        pass
        
        return cleaned
    
    def find_duplicates(self, citations: List[Dict[str, Any]]) -> List[List[int]]:
        """Find potential duplicate citations based on title similarity."""
        title_groups = {}
        
        for i, citation in enumerate(citations):
            title = citation.get('title', '').lower().strip()
            if title:
                normalized_title = title.replace(' ', '').replace('-', '').replace(',', '')
                if normalized_title not in title_groups:
                    title_groups[normalized_title] = []
                title_groups[normalized_title].append(i)
        
        return [indices for indices in title_groups.values() if len(indices) > 1]
    
    def analyze_citations(self, citations: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Analyze citations and generate statistics."""
        analysis = {
            'total_citations': len(citations),
            'timestamp': datetime.now().isoformat()
        }
        
        # Year distribution
        years = [c.get('year') for c in citations if c.get('year')]
        if years:
            analysis['year_range'] = (min(years), max(years))
            analysis['year_distribution'] = dict(Counter(years))
        
        # Journal distribution
        journals = [c.get('journal', '').strip() for c in citations if c.get('journal')]
        analysis['unique_journals'] = len(set(journals))
        analysis['top_journals'] = dict(Counter(journals).most_common(10))
        
        # Author analysis
        all_authors = []
        for citation in citations:
            if citation.get('authors'):
                authors = [author.strip().rstrip(',') for author in citation['authors'].split(',')]
                all_authors.extend([author for author in authors if author])
        
        analysis['total_author_mentions'] = len(all_authors)
        analysis['unique_authors'] = len(set(all_authors))
        analysis['top_authors'] = dict(Counter(all_authors).most_common(10))
        
        # Keyword analysis
        all_keywords = []
        for citation in citations:
            if citation.get('keywords'):
                all_keywords.extend(citation['keywords'])
        
        analysis['total_keywords'] = len(all_keywords)
        analysis['unique_keywords'] = len(set(all_keywords))
        analysis['top_keywords'] = dict(Counter(all_keywords).most_common(20))
        
        # Field completion rates
        field_completion = {}
        for field in ['title', 'authors', 'journal', 'year', 'abstract', 'keywords', 'doi_url', 'issn']:
            count = sum(1 for c in citations if c.get(field))
            field_completion[field] = {
                'count': count,
                'percentage': (count / len(citations)) * 100 if citations else 0
            }
        analysis['field_completion'] = field_completion
        
        return analysis
    
    def process_all_files(self) -> Tuple[List[Dict[str, Any]], Dict[str, Any]]:
        """Process all citation text files in the raw data directory."""
        all_citations = []
        file_stats = {}
        
        txt_files = list(self.raw_data_dir.glob('ScienceDirect_citations_*.txt'))
        
        if not txt_files:
            raise FileNotFoundError(f"No citation files found in {self.raw_data_dir}")
        
        print(f"🔍 Found {len(txt_files)} citation files to process")
        
        for txt_file in txt_files:
            print(f"📄 Processing: {txt_file.name}")
            
            # Read file with proper encoding
            try:
                with open(txt_file, 'r', encoding='utf-8') as f:
                    text = f.read()
            except UnicodeDecodeError:
                with open(txt_file, 'r', encoding='latin-1') as f:
                    text = f.read()
            
            # Parse citations
            citations = self.parse_citation_text(text)
            print(f"  ✅ Extracted {len(citations)} citations")
            
            # Save individual file
            individual_json = self.output_dir / f"{txt_file.stem}.json"
            with open(individual_json, 'w', encoding='utf-8') as f:
                json.dump(citations, f, indent=2, ensure_ascii=False)
            
            all_citations.extend(citations)
            file_stats[txt_file.name] = {
                'citations': len(citations),
                'size_bytes': txt_file.stat().st_size
            }
        
        print(f"📊 Total citations extracted: {len(all_citations)}")
        
        # Clean all citations
        print("🧹 Cleaning citations...")
        cleaned_citations = [self.clean_citation(citation) for citation in all_citations]
        
        # Find duplicates
        duplicates = self.find_duplicates(cleaned_citations)
        if duplicates:
            print(f"⚠️  Found {len(duplicates)} groups of potential duplicates")
        
        # Analyze citations
        print("📈 Analyzing citations...")
        analysis = self.analyze_citations(cleaned_citations)
        analysis['file_stats'] = file_stats
        analysis['duplicates'] = duplicates
        
        return cleaned_citations, analysis
    
    def save_results(self, citations: List[Dict[str, Any]], analysis: Dict[str, Any]):
        """Save all results to output files."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # Save combined citations
        citations_file = self.output_dir / "combined_citations.json"
        with open(citations_file, 'w', encoding='utf-8') as f:
            json.dump(citations, f, indent=2, ensure_ascii=False)
        print(f"💾 Combined citations: {citations_file}")
        
        # Save analysis
        analysis_file = self.output_dir / "analysis_results.json"
        with open(analysis_file, 'w', encoding='utf-8') as f:
            json.dump(analysis, f, indent=2, ensure_ascii=False)
        print(f"📊 Analysis results: {analysis_file}")
        
        # Generate and save report
        report = self._generate_report(citations, analysis)
        report_file = self.output_dir / "processing_report.txt"
        with open(report_file, 'w', encoding='utf-8') as f:
            f.write(report)
        print(f"📋 Processing report: {report_file}")
        
        return citations_file, analysis_file, report_file
    
    def _generate_report(self, citations: List[Dict[str, Any]], analysis: Dict[str, Any]) -> str:
        """Generate a comprehensive processing report."""
        report = []
        report.append("=" * 80)
        report.append("CITATION PROCESSING REPORT")
        report.append("=" * 80)
        report.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        
        # Processing summary
        report.append(f"\n📊 PROCESSING SUMMARY")
        report.append(f"Total Citations Processed: {analysis['total_citations']}")
        report.append(f"Input Files: {len(analysis['file_stats'])}")
        report.append(f"Unique Journals: {analysis['unique_journals']}")
        report.append(f"Unique Authors: {analysis['unique_authors']}")
        report.append(f"Unique Keywords: {analysis['unique_keywords']}")
        
        if analysis.get('year_range'):
            report.append(f"Year Range: {analysis['year_range'][0]} - {analysis['year_range'][1]}")
        
        # File processing details
        report.append(f"\n📁 FILE PROCESSING DETAILS")
        for filename, stats in analysis['file_stats'].items():
            size_kb = stats['size_bytes'] / 1024
            report.append(f"  • {filename}: {stats['citations']} citations ({size_kb:.1f} KB)")
        
        # Data quality
        report.append(f"\n✅ DATA QUALITY")
        for field, stats in analysis['field_completion'].items():
            report.append(f"  {field}: {stats['count']}/{analysis['total_citations']} ({stats['percentage']:.1f}%)")
        
        # Duplicates
        if analysis.get('duplicates'):
            report.append(f"\n🔄 DUPLICATE DETECTION")
            report.append(f"Found {len(analysis['duplicates'])} groups of potential duplicates")
            for i, group in enumerate(analysis['duplicates'][:5]):
                report.append(f"  Group {i+1}: Citations {group}")
        
        # Top statistics
        report.append(f"\n📖 TOP JOURNALS")
        for journal, count in list(analysis['top_journals'].items())[:5]:
            report.append(f"  • {journal}: {count} papers")
        
        report.append(f"\n🔑 TOP KEYWORDS")
        for keyword, count in list(analysis['top_keywords'].items())[:10]:
            report.append(f"  • {keyword}: {count} mentions")
        
        # Cleaning summary
        report.append(f"\n🧹 CLEANING PERFORMED")
        report.append("  • Removed trailing commas from author names")
        report.append("  • Trimmed whitespace from all text fields")
        report.append("  • Cleaned and normalized keywords")
        report.append("  • Extracted years from volume information when missing")
        report.append("  • Standardized field formats")
        
        return '\n'.join(report)


def main():
    """Main function to run the complete preprocessing pipeline."""
    print("🚀 Starting Citation Preprocessing Pipeline")
    print("=" * 60)
    
    # Initialize processor
    processor = CitationProcessor()
    
    try:
        # Process all files
        citations, analysis = processor.process_all_files()
        
        # Save results
        citations_file, analysis_file, report_file = processor.save_results(citations, analysis)
        
        print("\n" + "=" * 60)
        print("✅ PREPROCESSING COMPLETE!")
        print("=" * 60)
        print(f"📊 Processed {len(citations)} citations from {len(analysis['file_stats'])} files")
        print(f"💾 Output files saved to: dataset/processed/")
        print(f"📋 Check '{report_file.name}' for detailed results")
        
        return citations, analysis
        
    except Exception as e:
        print(f"❌ Error during processing: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()
