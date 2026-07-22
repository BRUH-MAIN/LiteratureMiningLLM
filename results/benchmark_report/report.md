# Benchmark Report

Gold standard: `consensus-gold`

| Model | Mean F1 | Materials F1 | Properties F1 | Applications F1 | Avg latency (s) | Est. cost (USD) |
|---|---|---|---|---|---|---|
| consensus-gold | 1.000 (reference) | 1.000 | 1.000 | 1.000 | - | - |
| gemma-4-12b-it__low | 0.526 | 0.559 | 0.549 | 0.469 | 48.93 | - |
| gemma-4-12b-it__high | 0.511 | 0.541 | 0.519 | 0.474 | 49.76 | - |
| gemma-4-12b-it__medium | 0.497 | 0.525 | 0.510 | 0.455 | 49.70 | - |
| qwen3.6-35b-a3b__thinking-on | 0.495 | 0.552 | 0.434 | 0.498 | 128.22 | - |
| qwen3.6-35b-a3b__thinking-off | 0.494 | 0.569 | 0.424 | 0.489 | 131.26 | - |
| gpt-oss-20b__medium | 0.411 | 0.571 | 0.144 | 0.518 | 46.65 | - |
| gpt-oss-20b__high | 0.379 | 0.526 | 0.158 | 0.454 | 44.12 | - |
| gpt-oss-20b__low | 0.364 | 0.465 | 0.135 | 0.491 | 41.28 | - |

Precision/recall/F1 are computed via schema-aware item matching (see `benchmark/scoring/matching.py`) with a 10% relative-value tolerance on numeric properties/applications, not naive JSON string comparison.
