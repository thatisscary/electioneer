# domains/Boundary/persistence/scripts/import-sample.sh
#!/usr/bin/env bash
docker exec -it electioneer-postgis bash -c "
  ogr2ogr  -f PostgreSQL PG:\"dbname=electioneer user=postgres password=postgres\" \
    ../sql/imports/sample-precinct.geojson \
    -nln boundary.geography \
    -nlt PROMOTE_TO_MULTI \
    -lco GEOMETRY_NAME=geom \
    -lco SPATIAL_INDEX=YES \
    --config PG_USE_COPY YES
"
