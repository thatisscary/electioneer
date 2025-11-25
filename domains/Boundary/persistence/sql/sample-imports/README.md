# Sample Imports for Boundary Domain

## Quick Import Test (from inside PostGIS container)

1. Copy file into container:

docker cp domains/Boundary/persistence/sql/sample-imports/sample-precinct.geojson electioneer-postgis:/tmp/

 2. Import via ogr2ogr (creates a new boundary_set):

 docker exec -it electioneer-postgis ogr2ogr -f PostgreSQL PG:"host=localhost user=postgres dbname=electioneer password=postgres" -nln boundary.temp_import /tmp/sample-precinct.geojson -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=geom

 3. Promote to live (run this SQL manually or via script):

 INSERT INTO boundary.boundary_set (jurisdiction_id, name, imported_by, is_current)
VALUES ('00000000-0000-0000-0000-000000000001', 'Sample Downtown Precinct', '00000000-0000-0000-0000-000000000000', true);
-- Then update geography rows to link to this set_id
text## Expected Result
After import, query:
SELECT precinct_id, ST_AsText(geom) FROM boundary.geography WHERE precinct_id = '01-001';
textShould return the sample polygon.
