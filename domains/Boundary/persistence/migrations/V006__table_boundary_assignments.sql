-- Normalized assignments: VTD → higher district boundaries (one row per layer assignment)
-- Populate during TIGER import via spatial joins where VTD geometry exists
-- PK is composite (vtd_geoid + assigned_layer) to enforce one assignment per layer per VTD
CREATE TABLE boundary_assignments (
    vtd_geoid VARCHAR(20) NOT NULL,
    assigned_layer boundary_layer NOT NULL,
    assigned_geoid VARCHAR(20) NOT NULL,
    state_fips CHAR(2) NOT NULL,
    effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
    expiration_date DATE,
    is_current BOOLEAN GENERATED ALWAYS AS (expiration_date IS NULL) STORED,

    CONSTRAINT pk_boundary_assignments PRIMARY KEY (vtd_geoid, assigned_layer),
    CONSTRAINT fk_vtd FOREIGN KEY (vtd_geoid) REFERENCES geo_us_boundaries(geoid) ON DELETE CASCADE,
    CONSTRAINT fk_assigned FOREIGN KEY (assigned_geoid) REFERENCES geo_us_boundaries(geoid)
);