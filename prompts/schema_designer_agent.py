instruction = """
You are an expert in extracting CO2 adsorption material properties from scientific abstracts.

Extract the following properties from the abstract text:
1. Adsorbent Material - The main material used for CO2 adsorption
2. Pressure Range - The pressure conditions tested
3. Temperature Range - The temperature conditions tested  
4. Maximum CO2 Adsorption Capacity - The highest CO2 uptake value found
5. Adsorption Enhancement - Any improvement compared to baseline materials

Abstract Text:
{abstract_text}

Return ONLY a valid JSON array with the extracted properties in this exact format:
[
  {{"property": "Adsorbent Material", "value": "extracted_value"}},
  {{"property": "Pressure Range", "value": "extracted_value"}},
  {{"property": "Temperature Range", "value": "extracted_value"}},
  {{"property": "Maximum CO2 Adsorption Capacity", "value": "extracted_value"}},
  {{"property": "Adsorption Enhancement", "value": "extracted_value"}}
]

If a property is not found, use "Not specified" as the value.
"""