SELECT precinct_id, ST_AsText(geom) FROM boundary.geography WHERE precinct_id = '01-001';

INSERT INTO boundary.boundary_set (id,jurisdiction_id, name, imported_by, is_current)
VALUES ('400ab93e-2016-4cfd-a3ed-7fb00486d06a','00000000-0000-0000-0000-000000000001', 'Sample Downtown Precinct', '00000000-0000-0000-0000-000000000000', true);


SELECT * FROM boundary.boundary_set WHERE name = 'Sample Downtown Precinct';


ALTER TABLE boundary.geography 
  ALTER COLUMN boundary_set_id DROP NOT NULL,
  ALTER COLUMN created_by DROP NOT NULL;

ALTER TABLE boundary.geography 
  ALTER COLUMN boundary_set_id SET DEFAULT '00000000-0000-0000-0000-000000000000'::uuid,
  ALTER COLUMN created_by SET DEFAULT '00000000-0000-0000-0000-000000000000'::uuid;

-- 2. Create a default boundary_set if none exists
INSERT INTO boundary.boundary_set (id, jurisdiction_id, name, imported_by, is_current)
VALUES ('00000000-0000-0000-0000-000000000000', 
        '00000000-0000-0000-0000-000000000001', 
        'Local Dev Default Set', 
        '00000000-0000-0000-0000-000000000000', 
        true)
ON CONFLICT (id) DO NOTHING;