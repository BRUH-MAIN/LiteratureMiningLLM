#!/usr/bin/env python3
"""
Quick Analysis Tool for Citation Data
Simple utility to explore and analyze the processed citation data.
"""

import json
from pathlib import Path
from collections import Counter
import argparse


def load_data(data_file: str = "dataset/processed/combined_citations.json"):
    """Load the processed citation data."""
    with open(data_file, 'r', encoding='utf-8') as f:
        return json.load(f)


def search_citations(citations, query, field='title'):
    """Search citations by a specific field."""
    query = query.lower()
    results = []
    
    for i, citation in enumerate(citations):
        if field in citation:
            if isinstance(citation[field], str):
                if query in citation[field].lower():
                    results.append((i, citation))
            elif isinstance(citation[field], list):
                if any(query in item.lower() for item in citation[field]):
                    results.append((i, citation))
    
    return results


def analyze_keywords(citations, top_n=20):
    """Analyze keyword frequency and co-occurrence."""
    all_keywords = []
    keyword_pairs = []
    
    for citation in citations:
        if citation.get('keywords'):
            keywords = citation['keywords']
            all_keywords.extend(keywords)
            
            # Generate keyword pairs for co-occurrence
            for i, kw1 in enumerate(keywords):
                for kw2 in keywords[i+1:]:
                    pair = tuple(sorted([kw1, kw2]))
                    keyword_pairs.append(pair)
    
    keyword_freq = Counter(all_keywords)
    cooccurrence = Counter(keyword_pairs)
    
    print(f"📊 KEYWORD ANALYSIS")
    print(f"Total keywords: {len(all_keywords)}")
    print(f"Unique keywords: {len(keyword_freq)}")
    
    print(f"\n🔝 Top {top_n} Keywords:")
    for keyword, count in keyword_freq.most_common(top_n):
        print(f"  {keyword}: {count}")
    
    print(f"\n🔗 Top 10 Keyword Co-occurrences:")
    for pair, count in cooccurrence.most_common(10):
        print(f"  {pair[0]} + {pair[1]}: {count}")


def journal_analysis(citations):
    """Analyze journal distribution and impact."""
    journal_stats = Counter()
    journal_years = {}
    
    for citation in citations:
        journal = citation.get('journal', 'Unknown')
        year = citation.get('year')
        
        journal_stats[journal] += 1
        
        if journal not in journal_years:
            journal_years[journal] = []
        if year:
            journal_years[journal].append(year)
    
    print(f"📖 JOURNAL ANALYSIS")
    print(f"Total journals: {len(journal_stats)}")
    
    print(f"\n🏆 Top 10 Journals by Paper Count:")
    for journal, count in journal_stats.most_common(10):
        years = journal_years.get(journal, [])
        year_range = f"({min(years)}-{max(years)})" if years else ""
        print(f"  {journal}: {count} papers {year_range}")


def author_analysis(citations, top_n=15):
    """Analyze author productivity and collaboration."""
    author_counts = Counter()
    author_collabs = {}
    
    for citation in citations:
        if citation.get('authors'):
            authors = [a.strip().rstrip(',') for a in citation['authors'].split(',')]
            authors = [a for a in authors if a]  # Remove empty strings
            
            for author in authors:
                author_counts[author] += 1
                
                if author not in author_collabs:
                    author_collabs[author] = set()
                
                # Add other authors as collaborators
                for other_author in authors:
                    if other_author != author:
                        author_collabs[author].add(other_author)
    
    print(f"👨‍🔬 AUTHOR ANALYSIS")
    print(f"Total author mentions: {sum(author_counts.values())}")
    print(f"Unique authors: {len(author_counts)}")
    
    print(f"\n🏆 Top {top_n} Most Productive Authors:")
    for author, count in author_counts.most_common(top_n):
        collabs = len(author_collabs.get(author, set()))
        print(f"  {author}: {count} papers ({collabs} collaborators)")


def temporal_analysis(citations):
    """Analyze publication trends over time."""
    year_counts = Counter()
    journal_year_counts = {}
    
    for citation in citations:
        year = citation.get('year')
        journal = citation.get('journal', 'Unknown')
        
        if year:
            year_counts[year] += 1
            
            if journal not in journal_year_counts:
                journal_year_counts[journal] = Counter()
            journal_year_counts[journal][year] += 1
    
    print(f"📅 TEMPORAL ANALYSIS")
    if year_counts:
        print(f"Year range: {min(year_counts.keys())} - {max(year_counts.keys())}")
        print(f"Total papers with years: {sum(year_counts.values())}")
        
        print(f"\n📈 Publications by Year:")
        for year in sorted(year_counts.keys()):
            count = year_counts[year]
            bar = "█" * (count // 5) if count >= 5 else "▌" * (count)
            print(f"  {year}: {count:3d} {bar}")


def search_interface(citations):
    """Interactive search interface."""
    print("\n🔍 SEARCH INTERFACE")
    print("Search options: title, authors, journal, keywords, abstract")
    print("Type 'quit' to exit")
    
    while True:
        query = input("\nEnter search query: ").strip()
        if query.lower() == 'quit':
            break
        
        field = input("Search in field (default: title): ").strip() or 'title'
        
        results = search_citations(citations, query, field)
        
        if results:
            print(f"\n✅ Found {len(results)} results:")
            for i, (idx, citation) in enumerate(results[:10]):  # Show first 10
                print(f"\n{i+1}. [{idx}] {citation.get('title', 'No title')}")
                print(f"   Journal: {citation.get('journal', 'Unknown')}")
                print(f"   Year: {citation.get('year', 'Unknown')}")
                if citation.get('keywords'):
                    print(f"   Keywords: {', '.join(citation['keywords'][:3])}...")
            
            if len(results) > 10:
                print(f"\n... and {len(results) - 10} more results")
        else:
            print("❌ No results found")


def main():
    parser = argparse.ArgumentParser(description="Analyze citation data")
    parser.add_argument("--data", default="dataset/processed/combined_citations.json",
                       help="Path to citation JSON file")
    parser.add_argument("--search", action="store_true", help="Start interactive search")
    parser.add_argument("--keywords", action="store_true", help="Analyze keywords")
    parser.add_argument("--journals", action="store_true", help="Analyze journals")
    parser.add_argument("--authors", action="store_true", help="Analyze authors")
    parser.add_argument("--temporal", action="store_true", help="Analyze temporal trends")
    parser.add_argument("--all", action="store_true", help="Run all analyses")
    
    args = parser.parse_args()
    
    # Load data
    try:
        citations = load_data(args.data)
        print(f"📚 Loaded {len(citations)} citations from {args.data}")
    except FileNotFoundError:
        print(f"❌ Data file not found: {args.data}")
        return
    
    # Run analyses based on arguments
    if args.all or args.keywords:
        analyze_keywords(citations)
        print("\n" + "="*60)
    
    if args.all or args.journals:
        journal_analysis(citations)
        print("\n" + "="*60)
    
    if args.all or args.authors:
        author_analysis(citations)
        print("\n" + "="*60)
    
    if args.all or args.temporal:
        temporal_analysis(citations)
        print("\n" + "="*60)
    
    if args.search:
        search_interface(citations)
    
    # If no specific analysis requested, show basic stats
    if not any([args.search, args.keywords, args.journals, args.authors, args.temporal, args.all]):
        print(f"\n📊 BASIC STATISTICS")
        print(f"Total citations: {len(citations)}")
        
        # Quick stats
        journals = set(c.get('journal') for c in citations if c.get('journal'))
        authors = set()
        keywords = set()
        years = []
        
        for c in citations:
            if c.get('authors'):
                authors.update(a.strip().rstrip(',') for a in c['authors'].split(','))
            if c.get('keywords'):
                keywords.update(c['keywords'])
            if c.get('year'):
                years.append(c['year'])
        
        print(f"Unique journals: {len(journals)}")
        print(f"Unique authors: {len(authors)}")
        print(f"Unique keywords: {len(keywords)}")
        if years:
            print(f"Year range: {min(years)} - {max(years)}")
        
        print(f"\nFor detailed analysis, use:")
        print(f"  python {__file__} --all")
        print(f"  python {__file__} --search")


if __name__ == "__main__":
    main()
