from langchain.docstore.document import Document
from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI
from typing import List
from langchain.docstore.document import Document

from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI
load_dotenv()
from pydantic import BaseModel
from langchain import hub
from langchain_text_splitters import RecursiveCharacterTextSplitter
from typing import List


load_dotenv()


def chunker_agentic(docs: List[Document]) -> List[Document]:
    prompt_template = hub.pull("wfh/proposal-indexing")
    llm = ChatGoogleGenerativeAI(model="gemini-2.0-flash")
    runnable = prompt_template | llm

    class Sentences(BaseModel):
        Sentences: List[str]

    structured_llm = llm.with_structured_output(Sentences)

    def get_propositions(text: str) -> List[str]:
        runnable_output = runnable.invoke({"input": text}).content
        
        # Directly get the structured response
        result: Sentences = structured_llm.invoke(runnable_output)
        return result.Sentences

    proposition_docs: List[Document] = []

    for doc in docs:
        paragraphs = doc.page_content.split("\n\n")

        for para in paragraphs:
            propositions = get_propositions(para)
            for proposition in propositions:
                proposition_docs.append(
                    Document(
                        page_content=proposition,
                        metadata=doc.metadata  # preserve metadata
                    )
                )

    return proposition_docs

def chunker_recursive(document: list[Document]):
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size = 800,
        chunk_overlap = 80,
        length_function= len,
        is_separator_regex=False
    )
    return text_splitter.split_documents(document)






    


    

