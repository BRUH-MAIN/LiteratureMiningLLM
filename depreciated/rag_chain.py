from langchain.chains import ConversationalRetrievalChain


def create_rag_chain(llm, retriever):
    print("Creating Conversational RAG Chain...")

    qa_chain = ConversationalRetrievalChain.from_llm(
        llm=llm,
        retriever=retriever,
        condense_question_llm=llm,
        return_source_documents=True
    )
    
    print("Conversational RAG Chain created successfully.")
    return qa_chain


def run_rag_agent(qa_chain, reranker):
    print("\n--- RAG Agent is Ready ---")
    chat_history = []
    
    while True:
        query = input("You: ")
        if query.lower() in ["exit", "quit"]:
            break
        
        result = qa_chain({"question": query, "chat_history": chat_history})
        reranked_docs = reranker.compress_documents(
            documents=result['source_documents'],
            query=query
        )
        
        print("\n--- Answer ---")
        print(result['answer'])
        print("\n--- Reranked Sources ---")
        for doc in reranked_docs:
            print(f"Source: {doc.metadata['source']}, Page: {doc.metadata['page']}")
            print(f"Content: {doc.page_content[:200]}...")
            print("-" * 20)
        chat_history.append((query, result["answer"]))
