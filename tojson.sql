WITH top_materials AS (
  SELECT material_id 
  FROM materials 
  ORDER BY material_id 
  LIMIT 10
),
material_data AS (
  SELECT 
    json_agg(
      json_build_object(
        'material_id', m.material_id,
        'mxene_composition', m.mxene_composition,
        'composite_material', m.composite_material,
        'synthesis_method', m.synthesis_method,
        'fabrication_method', m.fabrication_method
      )
    ) as materials_json
  FROM materials m
  WHERE m.material_id IN (SELECT material_id FROM top_materials)
),
properties_data AS (
  SELECT 
    json_agg(
      json_build_object(
        'material_id', p.material_id,
        'property_type', p.property_type,
        'value', p.value,
        'unit', p.unit,
        'test_conditions', COALESCE(p.test_conditions, '')
      )
    ) as properties_json
  FROM properties p
  WHERE p.material_id IN (SELECT material_id FROM top_materials)
),
applications_data AS (
  SELECT 
    json_agg(
      json_build_object(
        'material_id', a.material_id,
        'application_type', a.application_type,
        'metric', a.metric,
        'value', a.value,
        'unit', a.unit,
        'notes', COALESCE(a.notes, '')
      )
    ) as applications_json
  FROM applications a
  WHERE a.material_id IN (SELECT material_id FROM top_materials)
)
SELECT 
  json_build_object(
    'materials', md.materials_json,
    'properties', pd.properties_json,
    'applications', ad.applications_json
  )::jsonb as result
FROM material_data md, properties_data pd, applications_data ad;