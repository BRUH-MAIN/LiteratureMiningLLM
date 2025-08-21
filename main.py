import sys
from tools.rag import rag
from dotenv import load_dotenv
load_dotenv()

def main():
    if len(sys.argv) < 2:
        print("Usage: python main.py <path_to_pdf>")
        sys.exit(1)

    file_path = sys.argv[1]
    rag_chain = rag(file_path)

    print("✅ RAG system is ready!")
    print("Type your questions below (or 'exit' to quit):\n")

    while True:
        query = input(">> ")
        if query.lower() in ["exit", "quit", "q"]:
            break

        result =  rag_chain.invoke({"query": query})   
        print("\nAnswer:", result['result'])
        print("Sources:")
        for doc in result["source_documents"]:
            print(" -", doc.metadata.get("source", "Unknown"))
        print("\n")


if __name__ == "__main__":
    main()
