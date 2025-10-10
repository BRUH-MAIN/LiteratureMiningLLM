#!/usr/bin/env python3
import json
import sys
import os
from bert_score import score
import torch

def calculate_bert_score(pred_file, gold_file):
    """
    Calculate BERT score between predicted and gold standard files
    """
    # Load the files
    with open(pred_file, 'r') as f:
        pred_data = json.load(f)
    
    with open(gold_file, 'r') as f:
        gold_data = json.load(f)
    
    # Convert to strings for BERT score calculation
    pred_texts = [json.dumps(entry) for entry in pred_data]
    gold_texts = [json.dumps(entry) for entry in gold_data]
    
    # Calculate BERT scores
    P, R, F1 = score(pred_texts, gold_texts, lang="en", verbose=True)
    
    # Print results
    print(f"\nBERT Score Results:")
    print(f"Precision: {P.mean().item():.4f}")
    print(f"Recall: {R.mean().item():.4f}")
    print(f"F1: {F1.mean().item():.4f}")
    
    # Calculate per-entry scores
    print("\nPer-entry scores:")
    for i, (p, r, f1) in enumerate(zip(P, R, F1)):
        print(f"Entry {i+1}: P={p.item():.4f}, R={r.item():.4f}, F1={f1.item():.4f}")
    
    return P.mean().item(), R.mean().item(), F1.mean().item()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python calc_bert_score.py <predicted_json> <gold_json>")
        sys.exit(1)
    
    pred_file = sys.argv[1]
    gold_file = sys.argv[2]
    
    # Calculate BERT score
    print(f"Calculating BERT score between {pred_file} and {gold_file}...")
    calculate_bert_score(pred_file, gold_file)
