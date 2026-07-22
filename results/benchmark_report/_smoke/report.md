# Benchmark Report

Gold standard: `consensus-gold`

| Model | Mean F1 | Materials F1 | Properties F1 | Applications F1 | Avg latency (s) | Est. cost (USD) |
|---|---|---|---|---|---|---|
| consensus-gold | 1.000 (reference) | 1.000 | 1.000 | 1.000 | - | - |
| gemini-3.5-flash__high | 0.523 | 0.571 | 0.581 | 0.417 | 10.60 | $0.0328 |
| gemini-3.5-flash__low | 0.426 | 0.571 | 0.516 | 0.190 | 2.58 | $0.0313 |

Precision/recall/F1 are computed via schema-aware item matching (see `benchmark/scoring/matching.py`) with a 10% relative-value tolerance on numeric properties/applications, not naive JSON string comparison.
