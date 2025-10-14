"""
Database models and schema for the Literature Mining application.
"""

from sqlalchemy import create_engine, Column, Integer, String, Text, ARRAY, ForeignKey, DECIMAL
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
import os
from dotenv import load_dotenv

load_dotenv()

Base = declarative_base()


class Paper(Base):
    """Paper metadata table"""
    __tablename__ = 'papers'
    
    paper_id = Column(Integer, primary_key=True)
    title = Column(Text)
    authors = Column(Text)
    journal = Column(Text)
    year = Column(Integer)
    doi_url = Column(Text, unique=True)
    sciencedirect_url = Column(Text)
    issn = Column(String)
    abstract = Column(Text)
    keywords = Column(ARRAY(String))
    
    # Relationships
    materials = relationship("Material", back_populates="paper", cascade="all, delete-orphan")


class Material(Base):
    """Materials extracted from papers"""
    __tablename__ = 'materials'
    
    material_id = Column(Integer, primary_key=True)
    paper_id = Column(Integer, ForeignKey('papers.paper_id', ondelete='CASCADE'))
    mxene_composition = Column(Text)
    composite_material = Column(Text)
    synthesis_method = Column(Text)
    fabrication_method = Column(Text)
    
    # Relationships
    paper = relationship("Paper", back_populates="materials")
    properties = relationship("Property", back_populates="material", cascade="all, delete-orphan")
    applications = relationship("Application", back_populates="material", cascade="all, delete-orphan")


class Property(Base):
    """Material properties"""
    __tablename__ = 'properties'
    
    property_id = Column(Integer, primary_key=True)
    material_id = Column(Integer, ForeignKey('materials.material_id', ondelete='CASCADE'))
    property_type = Column(Text)
    value = Column(DECIMAL)
    unit = Column(Text)
    test_conditions = Column(Text)
    
    # Relationships
    material = relationship("Material", back_populates="properties")


class Application(Base):
    """Material applications and performance metrics"""
    __tablename__ = 'applications'
    
    app_id = Column(Integer, primary_key=True)
    material_id = Column(Integer, ForeignKey('materials.material_id', ondelete='CASCADE'))
    application_type = Column(Text)
    metric = Column(Text)
    value = Column(DECIMAL)
    unit = Column(Text)
    notes = Column(Text)
    
    # Relationships
    material = relationship("Material", back_populates="applications")


def create_database_engine():
    """Create and return database engine"""
    postgres_url = os.getenv('POSTGRES_URL')
    if not postgres_url:
        raise ValueError("POSTGRES_URL environment variable not set")
    
    engine = create_engine(postgres_url)
    return engine


def create_all_tables():
    """Create all tables in the database"""
    engine = create_database_engine()
    Base.metadata.create_all(engine)
    return engine


def get_session():
    """Get database session"""
    engine = create_database_engine()
    Session = sessionmaker(bind=engine)
    return Session()
