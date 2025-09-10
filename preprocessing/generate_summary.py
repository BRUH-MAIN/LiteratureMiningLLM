#!/usr/bin/env python3
"""
Summary script showing the complete citation conversion and analysis workflow.
This script provides an overview of all the files created and the processing pipeline.
"""

import json
from pathlib import Path
from datetime import datetime


def get_file_info():
    """Get information about all the files in the current directory."""
    files_info = {}
    
    # Text files (original data)
    txt_files = list(Path('dataset/raw').glob('ScienceDirect_citations_*.txt'))
    for txt_file in txt_files:
        size = txt_file.stat().st_size
        files_info[str(txt_file)] = {'type': 'Original Text Data', 'size': size}
    
    # Individual JSON files
    json_files = list(Path('dataset/processed').glob('ScienceDirect_citations_*.json'))
    for json_file in json_files:
        with open(json_file, 'r') as f:
            data = json.load(f)
        files_info[str(json_file)] = {'type': 'Individual JSON', 'citations': len(data)}
    
    # Combined files
    combined_files = ['dataset/processed/combined_citations.json', 'dataset/processed/analysis_results.json']
    for combined_file in combined_files:
        if Path(combined_file).exists():
            with open(combined_file, 'r') as f:
                data = json.load(f)
            file_type = 'Combined JSON' if 'combined_citations' in combined_file else 'Analysis JSON'
            files_info[combined_file] = {'type': file_type, 'citations': len(data) if isinstance(data, list) else 'N/A'}
    
    # Analysis files
    analysis_files = [
        'dataset/processed/analysis_results.json',
        'dataset/processed/processing_report.txt'
    ]
    for analysis_file in analysis_files:
        if Path(analysis_file).exists():
            size = Path(analysis_file).stat().st_size
            files_info[analysis_file] = {'type': 'Analysis/Report', 'size': size}
    
    # Scripts
    script_files = [
        'preprocessing/process_citations.py',
        'preprocessing/analyze_data.py',
        'preprocessing/generate_summary.py'
    ]
    for script_file in script_files:
        if Path(script_file).exists():
            lines = len(Path(script_file).read_text().split('\n'))
            files_info[script_file] = {'type': 'Python Script', 'lines': lines}
    
    return files_info


def generate_summary_report():
    """Generate a comprehensive summary report."""
    report = []
    report.append("=" * 80)
    report.append("SCIENCEDIRECT CITATION CONVERSION PROJECT SUMMARY")
    report.append("=" * 80)
    report.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Project overview
    report.append("\n🎯 PROJECT OVERVIEW")
    report.append("This project converts ScienceDirect citation text files to structured JSON format")
    report.append("and provides comprehensive analysis tools for literature research.")
    
    # Workflow description
    report.append("\n🔄 PROCESSING WORKFLOW")
    report.append("1. Text Parsing: Raw citation text files → Individual JSON files")
    report.append("2. Data Combination: Multiple JSON files → Single combined dataset")
    report.append("3. Data Analysis: Statistical analysis and insights generation")
    report.append("4. Data Validation: Quality checks and data cleaning")
    
    # File inventory
    files_info = get_file_info()
    report.append(f"\n📁 FILE INVENTORY ({len(files_info)} files)")
    
    # Group files by type
    file_groups = {}
    for filename, info in files_info.items():
        file_type = info['type']
        if file_type not in file_groups:
            file_groups[file_type] = []
        file_groups[file_type].append((filename, info))
    
    for file_type, files in file_groups.items():
        report.append(f"\n  📄 {file_type}:")
        for filename, info in files:
            if 'citations' in info:
                report.append(f"    • {filename} ({info['citations']} citations)")
            elif 'size' in info:
                size_kb = info['size'] / 1024
                report.append(f"    • {filename} ({size_kb:.1f} KB)")
            elif 'lines' in info:
                report.append(f"    • {filename} ({info['lines']} lines)")
            else:
                report.append(f"    • {filename}")
    
    # Data statistics (if analysis file exists)
    if Path('dataset/processed/analysis_results.json').exists():
        with open('dataset/processed/analysis_results.json', 'r') as f:
            analysis = json.load(f)
        
        report.append(f"\n📊 DATA STATISTICS")
        report.append(f"Total Citations: {analysis['total_citations']}")
        report.append(f"Unique Journals: {analysis['unique_journals']}")
        report.append(f"Unique Authors: {analysis['unique_authors']}")
        report.append(f"Unique Keywords: {analysis['unique_keywords']}")
        
        if analysis.get('year_range'):
            report.append(f"Year Range: {analysis['year_range'][0]} - {analysis['year_range'][1]}")
        
        # Top journals
        report.append(f"\n📖 TOP 5 JOURNALS:")
        for journal, count in list(analysis['top_journals'].items())[:5]:
            report.append(f"  • {journal}: {count} papers")
        
        # Top keywords
        report.append(f"\n🔑 TOP 10 KEYWORDS:")
        for keyword, count in list(analysis['top_keywords'].items())[:10]:
            report.append(f"  • {keyword}: {count} mentions")
    
    # Usage instructions
    report.append(f"\n🚀 USAGE INSTRUCTIONS")
    report.append("1. Convert and process all citation files:")
    report.append("   python preprocessing/process_citations.py")
    report.append("")
    report.append("2. Analyze processed data:")
    report.append("   python preprocessing/analyze_data.py --all")
    report.append("")
    report.append("3. Generate project summary:")
    report.append("   python preprocessing/generate_summary.py")
    
    # Data structure explanation
    report.append(f"\n📋 JSON DATA STRUCTURE")
    report.append("Each citation contains the following fields:")
    report.append("  • authors: List of paper authors")
    report.append("  • title: Paper title")
    report.append("  • journal: Journal name")
    report.append("  • volume_info: Volume, issue, and page information")
    report.append("  • year: Publication year")
    report.append("  • article_id: Article identifier")
    report.append("  • issn: Journal ISSN")
    report.append("  • doi_url: DOI URL")
    report.append("  • sciencedirect_url: ScienceDirect URL")
    report.append("  • abstract: Paper abstract")
    report.append("  • keywords: List of keywords")
    
    # Recommendations
    report.append(f"\n💡 RECOMMENDATIONS")
    report.append("• Use 'dataset/processed/combined_citations.json' for analysis (cleaned data)")
    report.append("• Refer to processing report for data quality insights")
    report.append("• Keywords are ideal for topic modeling and research trends")
    report.append("• Author data can be used for collaboration network analysis")
    report.append("• Journal distribution shows research focus areas")
    
    return '\n'.join(report)


def main():
    """Generate and save the summary report."""
    report = generate_summary_report()
    
    # Print to console
    print(report)
    
    # Save to file
    with open('project_summary.txt', 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"\n✅ Summary report saved to: project_summary.txt")


if __name__ == "__main__":
    main()
