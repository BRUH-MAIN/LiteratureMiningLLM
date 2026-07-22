# Reference Panel Agreement Report

Panel: `deepseek-v4-pro` vs `deepseek-v4-flash` (symmetric agreement, not candidate-vs-gold)

This is the noise floor of the extraction task itself: no candidate model scored against the consensus gold standard should be expected to exceed these agreement figures, since even the two strongest reference models don't agree perfectly with each other.

| Category | Precision | Recall | F1 | Value mismatches | Contested items |
|---|---|---|---|---|---|
| materials | 0.814 | 0.671 | 0.735 | 0 | 41 |
| properties | 0.691 | 0.650 | 0.670 | 16 | 134 |
| applications | 0.620 | 0.492 | 0.549 | 5 | 148 |