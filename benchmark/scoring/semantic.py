"""
Optional supplementary semantic-similarity scoring for free-text fields
(Property.test_conditions, Application.notes) on already-matched
(gold, candidate) item pairs. This is a secondary diagnostic signal only -
it never feeds into the structured precision/recall/F1 in metrics.py.

Requires the 'semantic' extra: `uv sync --extra semantic`. Imports are
deferred so the rest of benchmark/ works without sentence-transformers/torch
installed.
"""

from typing import List, Tuple

_model = None


def _get_model(model_name: str = "all-MiniLM-L6-v2"):
    global _model
    if _model is None:
        from sentence_transformers import SentenceTransformer
        _model = SentenceTransformer(model_name)
    return _model


def semantic_similarity(pairs: List[Tuple[str, str]], model_name: str = "all-MiniLM-L6-v2") -> List[float]:
    """Cosine similarity between each (gold_text, candidate_text) pair's sentence embeddings"""
    if not pairs:
        return []

    from sentence_transformers import util

    model = _get_model(model_name)
    gold_texts, cand_texts = zip(*pairs)
    gold_emb = model.encode(list(gold_texts), convert_to_tensor=True)
    cand_emb = model.encode(list(cand_texts), convert_to_tensor=True)

    similarities = util.cos_sim(gold_emb, cand_emb)
    return [float(similarities[i][i]) for i in range(len(pairs))]
