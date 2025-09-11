You are tasked with creating a modular Python program that implements an agentic flow for extracting structured research data about MXenes from JSON metadata files and storing it in a PostgreSQL database.

## Overall Goal
Input: JSON file containing multiple paper metadata entries (title, authors, abstract, conclusion, keywords, etc.).
Output: Normalized structured data stored in PostgreSQL using a relational schema with tables: papers, materials, properties, applications.

## Requirements

### 1. Preprocessing Agent
- Read JSON input (multiple papers).
- Normalize keys (abstract, conclusion, keywords).
- Clean raw text (remove LaTeX equations, special characters).
- Deduplicate entries using DOI.

### 2. Extraction Agent
- Use an LLM (OpenAI, HuggingFace, or local model) with a schema-guided prompt.
- Extract the following from abstract + conclusion:
  - **Materials**: MXene composition, composite materials, synthesis method, fabrication method.
  - **Properties**: conductivity, modulus, stress, Seebeck coefficient, resistivity, etc.
  - **Applications**: sensors, energy storage, shielding, AI applications.
  - **Performance metrics**: sensitivity, response time, accuracy, threshold, etc.
- Ensure output follows a normalized JSON schema matching the DB schema.

### 3. Validation Agent
- Parse and validate numbers and units (e.g., "353.77 S m−1" → 353.77, S/m).
- Standardize property_type vocabulary (e.g., conductivity always as "Conductivity").
- Remove duplicates if the same value appears in both abstract and conclusion.
- Flag missing or ambiguous values.

### 4. Database Loader Agent
- Use psycopg2 or SQLAlchemy to connect to PostgreSQL.
- Insert into normalized schema:

  TABLE papers (
      paper_id SERIAL PRIMARY KEY,
      title TEXT,
      authors TEXT,
      journal TEXT,
      year INT,
      doi_url TEXT UNIQUE,
      sciencedirect_url TEXT,
      issn TEXT,
      abstract TEXT,
      keywords TEXT[]
  );

  TABLE materials (
      material_id SERIAL PRIMARY KEY,
      paper_id INT REFERENCES papers(paper_id) ON DELETE CASCADE,
      mxene_composition TEXT,
      composite_material TEXT,
      synthesis_method TEXT,
      fabrication_method TEXT
  );

  TABLE properties (
      property_id SERIAL PRIMARY KEY,
      material_id INT REFERENCES materials(material_id) ON DELETE CASCADE,
      property_type TEXT,
      value DOUBLE PRECISION,
      unit TEXT,
      test_conditions TEXT
  );

  TABLE applications (
      app_id SERIAL PRIMARY KEY,
      material_id INT REFERENCES materials(material_id) ON DELETE CASCADE,
      application_type TEXT,
      metric TEXT,
      value DOUBLE PRECISION,
      unit TEXT,
      notes TEXT
  );

### 5. Analytics Agent (Optional)
- Provide functions to query the DB, e.g.:
  - List all conductivity values with MXene composition.
  - Find papers with sensor applications.
  - Plot histogram of conductivity values.

## Program Structure
- Use modular Python classes or functions:
  - `Preprocessor`
  - `Extractor`
  - `Validator`
  - `DBLoader`
  - `Analytics`
- Main runner should:
  1. Load JSON
  2. Run preprocessing
  3. Run extraction with LLM
  4. Validate results
  5. Insert into PostgreSQL
  6. (Optional) Run analytics queries

## Deliverables
- Python code with the above structure.
- Example run on the provided sample metadata JSON.
- Clear docstrings and comments.

Follow best practices:
- Modular code
- Error handling (e.g., missing DOI, DB connection errors)
- Logging for each agent stage
