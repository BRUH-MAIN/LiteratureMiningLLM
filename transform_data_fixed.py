#!/usr/bin/env python3
import json
import os

def transform_data_more_accurately(input_file, output_file):
    """
    Transform data.json to better match gold.json structure for BERT score calculation
    with particular attention to matching the entry structure
    """
    with open(input_file, 'r') as f:
        data = json.load(f)
    
    # Check the structure of the data
    if isinstance(data, list) and len(data) > 0 and 'result' in data[0]:
        # Current structure has a single entry with 'result' key containing all the data
        # We need to convert this to multiple entries similar to gold.json
        result = data[0]['result']
        
        # Create a new list of entries based on materials
        new_data = []
        
        # Group properties and applications by material_id
        properties_by_material = {}
        applications_by_material = {}
        
        if 'properties' in result:
            for prop in result['properties']:
                material_id = prop.get('material_id')
                if material_id not in properties_by_material:
                    properties_by_material[material_id] = []
                # Remove material_id from property
                prop_copy = {k: v for k, v in prop.items() if k != 'material_id'}
                # Ensure keys are in the same order as gold.json
                prop_copy = {
                    'property_type': prop_copy.get('property_type', ''),
                    'value': prop_copy.get('value', 0),
                    'unit': prop_copy.get('unit', ''),
                    'test_conditions': prop_copy.get('test_conditions', '')
                }
                properties_by_material[material_id].append(prop_copy)
        
        if 'applications' in result:
            for app in result['applications']:
                material_id = app.get('material_id')
                if material_id not in applications_by_material:
                    applications_by_material[material_id] = []
                # Remove material_id from application
                app_copy = {k: v for k, v in app.items() if k != 'material_id'}
                # Ensure keys are in the same order as gold.json
                app_copy = {
                    'application_type': app_copy.get('application_type', ''),
                    'metric': app_copy.get('metric', ''),
                    'value': app_copy.get('value', 0),
                    'unit': app_copy.get('unit', ''),
                    'notes': app_copy.get('notes', '')
                }
                applications_by_material[material_id].append(app_copy)
        
        # Create entries for each material with its properties and applications
        if 'materials' in result:
            for material in result['materials']:
                material_id = material.get('material_id')
                if material_id is None:
                    continue
                
                # Remove material_id from material
                material_copy = {k: v for k, v in material.items() if k != 'material_id'}
                # Ensure keys are in the same order as gold.json
                material_copy = {
                    'mxene_composition': material_copy.get('mxene_composition', ''),
                    'composite_material': material_copy.get('composite_material', ''),
                    'synthesis_method': material_copy.get('synthesis_method', ''),
                    'fabrication_method': material_copy.get('fabrication_method', '')
                }
                
                # Create a new entry
                entry = {
                    'materials': [material_copy],
                    'properties': properties_by_material.get(material_id, []),
                    'applications': applications_by_material.get(material_id, [])
                }
                new_data.append(entry)
        
        # Update data to use the new format
        data = new_data
    else:
        # Already in the expected format, just normalize the entries
        for entry in data:
            if 'materials' in entry:
                for material in entry['materials']:
                    if 'material_id' in material:
                        del material['material_id']
            
            if 'properties' in entry:
                for prop in entry['properties']:
                    if 'material_id' in prop:
                        del prop['material_id']
            
            if 'applications' in entry:
                for app in entry['applications']:
                    if 'material_id' in app:
                        del app['material_id']
    
    # Write transformed data
    with open(output_file, 'w') as f:
        json.dump(data, f, indent=2)
    
    print(f"Transformed data saved to {output_file}")

if __name__ == "__main__":
    # Transform data
    transform_data_more_accurately('data.json', 'transformed_data_fixed.json')