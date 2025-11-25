-- ./sql/init-boundary-schema.sql
CREATE SCHEMA IF NOT EXISTS boundary AUTHORIZATION postgres;

-- Enable extensions in the boundary schema
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

-- Tables from our earlier design
CREATE TABLE boundary.boundary_set (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    jurisdiction_id UUID        NOT NULL,
    name            TEXT        NOT NULL,
    imported_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    imported_by     UUID        NOT NULL,
    source_file     TEXT,
    source_format   TEXT CHECK (source_format IN ('shapefile','geojson','mggg','vtd')),
    is_current      BOOLEAN     NOT NULL DEFAULT FALSE,
    notes           TEXT,
    UNIQUE(jurisdiction_id, name)
);

CREATE TABLE boundary.geography (
    gid             BIGSERIAL PRIMARY KEY,
    boundary_set_id UUID        NOT NULL REFERENCES boundary.boundary_set(id) ON DELETE CASCADE,
    precinct_id     TEXT        NOT NULL,
    jurisdiction_id UUID        NOT NULL,
    geom            GEOMETRY(POLYGON, 4326) NOT NULL,
    properties      JSONB,
    ballot_style_id TEXT,
    effective_from  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    effective_to    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by      UUID        NOT NULL
);

-- Indexes (critical for performance)
CREATE INDEX idx_geography_geom         ON boundary.geography USING GIST (geom);
CREATE INDEX idx_geography_current      ON boundary.geography (jurisdiction_id) WHERE effective_to IS NULL;
CREATE INDEX idx_geography_precinct     ON boundary.geography (jurisdiction_id, precinct_id);
CREATE INDEX idx_boundary_set_current   ON boundary.boundary_set (jurisdiction_id) WHERE is_current = TRUE;

-- Example jurisdiction (so you can test immediately)
INSERT INTO boundary.boundary_set 
    (jurisdiction_id, name, imported_by, is_current, notes)
VALUES 
    ('00000000-0000-0000-0000-000000000001', 'Initial Empty Set', '00000000-0000-0000-0000-000000000000', true, 'Placeholder')
ON CONFLICT DO NOTHING;