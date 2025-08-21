---
title: "README: Agent Workflow for Multi-Abstract Extraction & CSV
  Export"
---

# Overview

This workflow uses a multi-agent system built with Google ADK to extract
structured material properties from multiple scientific paper abstracts
and export the results as a CSV file.

# Workflow Components

## 1. Root Controller Agent (Orchestrator)

\- Role: Manages the entire workflow.\
- Responsibilities:\
- Accepts input of multiple abstracts.\
- Delegates each abstract to the Schema_Designer agent.\
- Aggregates all results.\
- Sends results to the Exporter Agent for CSV generation.

## 2. Schema_Designer Agent

\- Role: Processes a single abstract.\
- Responsibilities:\
- Extracts material properties and values.\
- Returns a structured JSON array with \'property\' and \'value\' keys.\
- Stateless and reused for each abstract.

## 3. Result Aggregator Agent (Optional)

\- Role: Normalizes JSON results.\
- Responsibilities:\
- Formats extracted data into a consistent tabular format.\
- Adds context like abstract ID if necessary.\
- Prepares final dataset for CSV export.

## 4. Exporter Agent

\- Role: Converts structured data to a downloadable CSV file.\
- Responsibilities:\
- Receives final JSON dataset.\
- Converts and saves it as a CSV.\
- Can return a file or Base64 string depending on platform requirements.

# Execution Flow

1\. Input a batch of abstracts (as a list or document).\
2. Root Controller Agent dispatches each to the Schema_Designer Agent.\
3. JSON results are collected and optionally passed through the Result
Aggregator Agent.\
4. Exporter Agent produces and returns a CSV file.

# Notes

\- Agents may be run sequentially or in parallel depending on system
capabilities.\
- You can add optional Validator Agents for schema compliance.\
- The workflow is extensible for additional metadata extraction like
paper titles or DOIs.
