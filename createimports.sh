#!/usr/bin/env bash
# Add-on to setup-electioneer-repo.sh: Create sample imports for Boundary domain

echo "Adding sample imports for Boundary domain..."

mkdir -p domains/Boundary/persistence/sql/sample-imports

# Tiny GeoJSON: one fictional precinct (a simple square polygon around "City Hall")
cat > domains/Boundary/persistence/sql/sample-imports/sample-precinct.geojson <<'EOF'
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "precinct_id": "01-001",
        "jurisdiction_id": "00000000-0000-0000-0000-000000000001",
        "name": "Downtown Precinct",
        "ballot_style_id": "bs-general-2024",
        "properties": {}
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [-122.4194, 37.7749],
            [-122.4194, 37.7850],
            [-122.4085, 37.7850],
            [-122.4085, 37.7749],
            [-122.4194, 37.7749]
          ]
        ]
      }
    }
  ]
}
EOF

# README with import instructions
cat > domains/Boundary/persistence/sql/sample-imports/README.md <<'EOF'
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
EOF

echo "Sample imports added! Check domains/Boundary/persistence/sql/sample-imports/"
