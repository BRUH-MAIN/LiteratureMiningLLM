from langchain_community.document_loaders import PyPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_core.messages import BaseMessage
from langchain_core.runnables import RunnableLambda
from typing import List, Dict, Any
import re
from config import PDF_FILE, CHUNK_SIZE, CHUNK_OVERLAP


class PDFChunkingAgent:
    def __init__(self):
        self.text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=CHUNK_SIZE,
            chunk_overlap=CHUNK_OVERLAP,
            separators=["\n\nAbstract:", "\n\n", "\n", " ", ""]
        )
    
    def load_and_chunk_pdf(self, state: Dict[str, Any]) -> Dict[str, Any]:
        """Load PDF and split into abstract chunks with metadata"""
        print("📄 Loading and chunking PDF...")
        
        loader = PyPDFLoader(PDF_FILE)
        documents = loader.load()
        
        chunks = []
        abstract_id = 1
        
        for doc in documents:
            page_content = doc.page_content
            page_num = doc.metadata.get('page', 1)
            
            # Split by Abstract markers first
            abstract_sections = re.split(r'(?i)abstract:', page_content)
            
            for i, section in enumerate(abstract_sections):
                if i == 0 and not section.strip():
                    continue
                    
                if section.strip():
                    # Create document with metadata
                    chunk_docs = self.text_splitter.create_documents(
                        [section.strip()],
                        metadatas=[{
                            'abstract_id': f'A{abstract_id}',
                            'page': page_num,
                            'source': PDF_FILE,
                            'chunk_type': 'abstract'
                        }]
                    )
                    chunks.extend(chunk_docs)
                    abstract_id += 1
        
        print(f"✅ Created {len(chunks)} abstract chunks")
        return {**state, 'chunks': chunks, 'total_chunks': len(chunks)}
    
    def get_runnable(self):
        return RunnableLambda(self.load_and_chunk_pdf)
