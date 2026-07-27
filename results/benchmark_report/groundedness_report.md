# Groundedness / Faithfulness Report

Measures whether extracted items trace back to the source text given to the model (title+abstract+conclusion) - independent of the consensus gold standard entirely. Numeric fields: is a matching value+unit found in the text? Free-text material fields: does a fuzzy substring match exist? Not a correctness check - a grounded item can still be scientifically wrong, and an ungrounded item might be a legitimate paraphrase our matcher missed (see the flagged items below for spot-checking).

| Run | Materials | Properties | Applications | Flagged items |
|---|---|---|---|---|
| claude-opus-4.8 | 0.822 | 0.914 | 0.979 | 77 |
| gpt-5.6-sol | 0.721 | 0.913 | 0.952 | 93 |
| gpt-oss-20b__low | 0.853 | 0.918 | 0.969 | 53 |
| gpt-oss-20b__medium | 0.868 | 0.907 | 0.935 | 54 |
| gpt-oss-20b__high | 0.885 | 0.932 | 0.924 | 50 |
| qwen3.6-35b-a3b__thinking-on | 0.904 | 0.921 | 0.844 | 71 |
| qwen3.6-35b-a3b__thinking-off | 0.904 | 0.921 | 0.855 | 71 |
| gemma-4-12b-it__low | 0.868 | 0.912 | 0.812 | 84 |
| gemma-4-12b-it__medium | 0.857 | 0.903 | 0.781 | 96 |
| gemma-4-12b-it__high | 0.862 | 0.907 | 0.819 | 86 |
| claude-sonnet-4.6 | 0.663 | 0.918 | 0.886 | 159 |
| gpt-5.6-terra | 0.728 | 0.934 | 0.973 | 88 |
| gemini-3.6-flash | 0.907 | 0.960 | 0.943 | 35 |
| glm-5 | 0.955 | 0.972 | 0.982 | 17 |
| deepseek-v3.1 | 0.946 | 0.934 | 0.913 | 35 |