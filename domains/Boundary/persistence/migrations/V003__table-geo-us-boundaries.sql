-- Enable required PostGIS extensions
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Master table for all TIGER-imported geometries (partitioned by state for scale)
CREATE TABLE geo_us_boundaries (
    gid UUID DEFAULT gen_random_uuid(),
    layer boundary_layer NOT NULL,
    state_fips CHAR(2) NOT NULL,
    geom GEOMETRY(MultiPolygon, 4326) NOT NULL,
    geoid VARCHAR(20) NOT NULL,           -- Census GEOID (unique per layer nationwide)
    namelsad VARCHAR(100),
    aland BIGINT,
    awater BIGINT,
    mtfcc VARCHAR(5),
    funcstat VARCHAR(1),
    effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
    expiration_date DATE,
    is_current BOOLEAN GENERATED ALWAYS AS (expiration_date IS NULL) STORED,

    CONSTRAINT pk_geo_us_boundaries PRIMARY KEY (gid),
    CONSTRAINT uq_geoid_current UNIQUE (geoid, is_current) DEFERRABLE INITIALLY DEFERRED
) PARTITION BY LIST (state_fips);