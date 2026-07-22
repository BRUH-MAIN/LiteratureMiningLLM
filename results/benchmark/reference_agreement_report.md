# Reference Panel Agreement Report

Panel: `claude-opus-4.8` vs `gpt-5.6-sol` (symmetric agreement, not candidate-vs-gold)

This is the noise floor of the extraction task itself: no candidate model scored against the consensus gold standard should be expected to exceed these agreement figures, since even the two strongest reference models don't agree perfectly with each other.

| Category | Precision | Recall | F1 | Value mismatches | Contested items |
|---|---|---|---|---|---|
| materials | 0.626 | 0.588 | 0.606 | 0 | 74 |
| properties | 0.662 | 0.527 | 0.586 | 23 | 159 |
| applications | 0.500 | 0.606 | 0.548 | 9 | 146 |