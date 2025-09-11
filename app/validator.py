"""
Validation Agent for Literature Mining

This module handles:
- Parsing and validating numbers and units
- Standardizing property_type vocabulary  
- Removing duplicates
- Flagging missing or ambiguous values
"""

import re
import logging
from typing import List, Dict, Any, Optional, Tuple
from decimal import Decimal, InvalidOperation


class Validator:
    """Validation agent for cleaning and standardizing extracted data"""
    
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        
        # Standardized property type mappings
        self.property_type_mappings = {
            'conductivity': 'Conductivity',
            'electrical conductivity': 'Conductivity',
            'modulus': 'Young_Modulus',
            'young modulus': 'Young_Modulus',
            'youngs modulus': 'Young_Modulus',
            'elastic modulus': 'Young_Modulus',
            'stress': 'Fracture_Stress',
            'fracture stress': 'Fracture_Stress',
            'tensile stress': 'Fracture_Stress',
            'seebeck coefficient': 'Seebeck_Coefficient',
            'resistivity': 'Resistivity',
            'capacitance': 'Capacitance',
            'specific capacitance': 'Specific_Capacitance',
            'energy density': 'Energy_Density',
            'power density': 'Power_Density',
            'sensitivity': 'Sensitivity',
            'response time': 'Response_Time',
            'recovery time': 'Recovery_Time',
            'detection threshold': 'Detection_Threshold'
        }
        
        # Standardized unit mappings
        self.unit_mappings = {
            's m−1': 'S/m',
            's/m': 'S/m',
            'siemens/meter': 'S/m',
            'gpa': 'GPa',
            'mpa': 'MPa',
            'kpa': 'kPa',
            'pa': 'Pa',
            'mv/k': 'mV/K',
            'μv/k': 'μV/K',
            'ω·m': 'Ω·m',
            'ohm·m': 'Ω·m',
            'f/g': 'F/g',
            'mf/cm²': 'mF/cm²',
            'f/cm³': 'F/cm³',
            'wh/kg': 'Wh/kg',
            'μwh/cm²': 'μWh/cm²',
            'w/kg': 'W/kg',
            'kpa⁻¹': 'kPa⁻¹',
            'mm⁻¹': 'mm⁻¹',
            'ms': 'ms',
            's': 's'
        }
    
    def parse_value_and_unit(self, value_str: str) -> Tuple[Optional[float], Optional[str]]:
        """Parse value and unit from a string like '353.77 S m−1'"""
        if not value_str or not isinstance(value_str, str):
            return None, None
        
        # Remove extra whitespace
        value_str = value_str.strip()
        
        # Pattern to match number followed by optional unit
        pattern = r'([+-]?\d*\.?\d+(?:[eE][+-]?\d+)?)\s*([^\d\s]*)'
        match = re.match(pattern, value_str)
        
        if match:
            try:
                value = float(match.group(1))
                unit = match.group(2).strip() if match.group(2) else None
                return value, unit
            except ValueError:
                return None, None
        
        return None, None
    
    def standardize_property_type(self, property_type: str) -> str:
        """Standardize property type vocabulary"""
        if not property_type:
            return ''
        
        # Convert to lowercase for matching
        property_lower = property_type.lower().strip()
        
        # Check for exact matches first
        if property_lower in self.property_type_mappings:
            return self.property_type_mappings[property_lower]
        
        # Check for partial matches
        for key, value in self.property_type_mappings.items():
            if key in property_lower or property_lower in key:
                return value
        
        # If no match found, return title case version
        return property_type.title().replace(' ', '_')
    
    def standardize_unit(self, unit: str) -> str:
        """Standardize unit notation"""
        if not unit:
            return ''
        
        # Convert to lowercase for matching
        unit_lower = unit.lower().strip()
        
        # Check for exact matches
        if unit_lower in self.unit_mappings:
            return self.unit_mappings[unit_lower]
        
        # Return original if no standardization found
        return unit.strip()
    
    def validate_numeric_value(self, value: Any) -> Optional[float]:
        """Validate and convert numeric values"""
        if value is None:
            return None
        
        try:
            if isinstance(value, (int, float)):
                return float(value)
            elif isinstance(value, str):
                # Try to extract number from string
                parsed_value, _ = self.parse_value_and_unit(value)
                return parsed_value
            else:
                return None
        except (ValueError, TypeError):
            return None
    
    def remove_duplicates_in_category(self, items: List[Dict[str, Any]], 
                                    key_fields: List[str]) -> List[Dict[str, Any]]:
        """Remove duplicates within a category based on key fields"""
        seen = set()
        unique_items = []
        
        for item in items:
            # Create a tuple of key values for comparison
            key_tuple = tuple(str(item.get(field, '')).lower().strip() 
                            for field in key_fields)
            
            if key_tuple not in seen and any(key_tuple):  # Don't add if all keys are empty
                seen.add(key_tuple)
                unique_items.append(item)
        
        return unique_items
    
    def validate_material_data(self, materials: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Validate and clean material data"""
        validated_materials = []
        
        for material in materials:
            validated_material = {}
            
            # Copy string fields as-is but clean them
            string_fields = ['mxene_composition', 'composite_material', 
                           'synthesis_method', 'fabrication_method']
            
            for field in string_fields:
                value = material.get(field, '')
                if isinstance(value, str):
                    validated_material[field] = value.strip()
                else:
                    validated_material[field] = str(value).strip() if value else ''
            
            validated_materials.append(validated_material)
        
        # Remove duplicates based on all fields
        return self.remove_duplicates_in_category(
            validated_materials, 
            ['mxene_composition', 'composite_material', 'synthesis_method', 'fabrication_method']
        )
    
    def validate_property_data(self, properties: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Validate and clean property data"""
        validated_properties = []
        
        for prop in properties:
            validated_prop = {}
            
            # Standardize property type
            prop_type = prop.get('property_type', '')
            validated_prop['property_type'] = self.standardize_property_type(prop_type)
            
            # Validate numeric value
            value = self.validate_numeric_value(prop.get('value'))
            if value is not None:
                validated_prop['value'] = value
            else:
                # Try to parse from a combined value+unit string
                raw_value = prop.get('value', '')
                if isinstance(raw_value, str):
                    parsed_value, parsed_unit = self.parse_value_and_unit(raw_value)
                    validated_prop['value'] = parsed_value
                    if parsed_unit and not prop.get('unit'):
                        validated_prop['unit'] = self.standardize_unit(parsed_unit)
                else:
                    validated_prop['value'] = None
            
            # Standardize unit
            unit = prop.get('unit', '')
            if not validated_prop.get('unit'):  # Only if not set above
                validated_prop['unit'] = self.standardize_unit(unit)
            
            # Copy test conditions
            validated_prop['test_conditions'] = str(prop.get('test_conditions', '')).strip()
            
            # Only add if we have a valid property type and value
            if validated_prop['property_type'] and validated_prop.get('value') is not None:
                validated_properties.append(validated_prop)
        
        # Remove duplicates based on property_type, value, and unit
        return self.remove_duplicates_in_category(
            validated_properties, 
            ['property_type', 'value', 'unit']
        )
    
    def validate_application_data(self, applications: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Validate and clean application data"""
        validated_applications = []
        
        for app in applications:
            validated_app = {}
            
            # Copy string fields
            string_fields = ['application_type', 'metric', 'notes']
            for field in string_fields:
                value = app.get(field, '')
                validated_app[field] = str(value).strip() if value else ''
            
            # Validate numeric value
            value = self.validate_numeric_value(app.get('value'))
            validated_app['value'] = value
            
            # Standardize unit
            unit = app.get('unit', '')
            validated_app['unit'] = self.standardize_unit(unit)
            
            # Only add if we have application type
            if validated_app['application_type']:
                validated_applications.append(validated_app)
        
        # Remove duplicates based on application_type, metric, and value
        return self.remove_duplicates_in_category(
            validated_applications, 
            ['application_type', 'metric', 'value']
        )
    
    def validate_extracted_data(self, extracted_data: Dict[str, Any]) -> Dict[str, Any]:
        """Validate complete extracted data structure"""
        validated_data = {
            'materials': [],
            'properties': [],
            'applications': []
        }
        
        try:
            # Validate materials
            materials = extracted_data.get('materials', [])
            if isinstance(materials, list):
                validated_data['materials'] = self.validate_material_data(materials)
            
            # Validate properties
            properties = extracted_data.get('properties', [])
            if isinstance(properties, list):
                validated_data['properties'] = self.validate_property_data(properties)
            
            # Validate applications
            applications = extracted_data.get('applications', [])
            if isinstance(applications, list):
                validated_data['applications'] = self.validate_application_data(applications)
            
        except Exception as e:
            self.logger.error(f"Error validating extracted data: {e}")
        
        return validated_data
    
    def validate_papers(self, papers: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Validate extracted data for multiple papers"""
        validated_papers = []
        
        for i, paper in enumerate(papers):
            self.logger.info(f"Validating paper {i+1}/{len(papers)}")
            
            try:
                paper_copy = paper.copy()
                
                # Validate extracted data if present
                if 'extracted_data' in paper:
                    validated_data = self.validate_extracted_data(paper['extracted_data'])
                    paper_copy['extracted_data'] = validated_data
                    
                    # Flag papers with no valid extracted data
                    total_items = (len(validated_data['materials']) + 
                                 len(validated_data['properties']) + 
                                 len(validated_data['applications']))
                    
                    if total_items == 0:
                        paper_copy['validation_warning'] = 'No valid extracted data found'
                
                validated_papers.append(paper_copy)
                
            except Exception as e:
                self.logger.error(f"Error validating paper {i+1}: {e}")
                validated_papers.append(paper)  # Keep original if validation fails
        
        self.logger.info(f"Validation completed for {len(validated_papers)} papers")
        return validated_papers
