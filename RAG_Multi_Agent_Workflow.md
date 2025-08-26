
# 🧠 RAG-Based Multi-Agent Workflow: Multi-Abstract Extraction & CSV Export

This document outlines a detailed agent-based workflow for processing a PDF containing multiple scientific abstracts. The goal is to extract structured material properties using a Retrieval-Augmented Generation (RAG) setup and output a CSV file with traceable metadata.

---

## ✅ Overview of Workflow

1. **PDF Loader + Chunking Agent**
2. **Vector Store Retriever Agent**
3. **Schema_Designer Agent**
4. **Result Aggregator Agent**
5. **Exporter Agent**

---

## 1. 📄 PDF Loader + Chunking Agent

### Role:
Parses the input PDF and splits it into individual abstract chunks with metadata.

### Responsibilities:
- Identifies abstract boundaries (e.g., using “Abstract:” markers).
- Tags each chunk with metadata:
  - `abstract_id`
  - `page_number`
  - `title` (if available)
- Stores chunks in a vector database with embeddings.

---

## 2. 🔍 Vector Store Retriever Agent

### Role:
Retrieves **one abstract at a time** from the vector DB for processing.

### Responsibilities:
- Iterates through all embedded chunks in a loop.
- For each chunk:
  - Retrieves the abstract text
  - Retrieves the metadata (abstract ID, page number, etc.)
  - Sends it to the Schema_Designer Agent
- Waits for processing to complete before retrieving the next chunk.

---

## 3. 🧪 Schema_Designer Agent

### Role:
Extracts relevant material properties from a single abstract.

### Responsibilities:
- Receives one abstract at a time.
- Parses the text and extracts `property-value` pairs.
- Returns structured JSON output, e.g.:
```json
{
  "abstract_id": "A2",
  "page_number": 7,
  "properties": [
    { "property": "CO2 Adsorption", "value": "3.58 mmol/g" },
    { "property": "Temperature Range", "value": "25–80 °C" }
  ]
}
```

---

## 4. 📊 Result Aggregator Agent

### Role:
Collects outputs from all Schema_Designer invocations and prepares data for CSV export.

### Responsibilities:
- Stores each structured result (with metadata) in a growing dataset.
- Ensures consistency in formatting.
- Organizes into a row-wise tabular format with fields like:
  - Abstract ID
  - Page Number
  - Property
  - Value

---

## 5. 📁 Exporter Agent

### Role:
Creates and exports the final CSV file.

### Responsibilities:
- Accepts the full aggregated dataset.
- Converts the structured JSON into CSV format.
- Returns a downloadable file (or uploads if needed).

---

## 🔁 Agent Interaction Flow

### Abstract-wise Iterative Process:

```
[Vector DB]
   ↓ (chunk 1)
[Retriever Agent]
   ↓
[Schema_Designer Agent]
   ↓
[Result Aggregator Agent]
   ↓
←—— go to next chunk ——←
```

- Loop continues until all abstracts are processed.
- Finally, the Exporter Agent is triggered.

---

## ✅ Output Format

- CSV with columns like:
  - Abstract ID
  - Page Number
  - Property
  - Value

---

## Optional Enhancements

- **Validator Agent** for schema compliance.
- **Metadata Enrichment Agent** if extra fields (DOI, title, etc.) are needed.
- **Parallelization** support for processing abstracts faster.

---

## 🧾 Final Outcome

A clean, structured CSV that contains extracted material properties from each abstract, along with traceability back to the original source.
