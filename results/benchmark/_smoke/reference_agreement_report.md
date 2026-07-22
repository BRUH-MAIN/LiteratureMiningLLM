# Reference Panel Agreement Report

Panel: `deepseek-v4-pro` vs `deepseek-v4-flash` (symmetric agreement, not candidate-vs-gold)

This is the noise floor of the extraction task itself: no candidate model scored against the consensus gold standard should be expected to exceed these agreement figures, since even the two strongest reference models don't agree perfectly with each other.

| Category | Precision | Recall | F1 | Value mismatches | Contested items |
|---|---|---|---|---|---|
| materials | 0.500 | 0.400 | 0.444 | 0 | 5 |
| properties | 0.600 | 0.714 | 0.652 | 3 | 13 |
| applications | 0.667 | 0.833 | 0.741 | 0 | 7 |