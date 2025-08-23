from tqdm.auto import tqdm
from config import BATCH_SIZE


def upsert_documents_to_pinecone(docs, embeddings, bm25_encoder, index):
    print("Upserting documents to Pinecone with hybrid search...")
    for i in tqdm(range(0, len(docs), BATCH_SIZE)):
        i_end = min(i + BATCH_SIZE, len(docs))
        docs_batch = docs[i:i_end]
        docs_content = [doc.page_content for doc in docs_batch]
        sparse_embeds = bm25_encoder.encode_documents(docs_content)
        dense_embeds = embeddings.embed_documents(docs_content)
        metadata = [
            {
                "text": doc.page_content,
                "source": doc.metadata.get("source", "Unknown"),
                "page": doc.metadata.get("page", 0),
            }
            for doc in docs_batch
        ]
        ids = [f"doc_{i+j}" for j in range(len(docs_batch))]       
        vectors_to_upsert = []
        for doc_id, sparse, dense, meta in zip(ids, sparse_embeds, dense_embeds, metadata):
            vectors_to_upsert.append({
                "id": doc_id,
                "sparse_values": sparse,
                "values": dense,
                "metadata": meta,
            })
        index.upsert(vectors=vectors_to_upsert)
    print("Documents upserted to Pinecone.")
