-- State-provided VTD metadata for jurisdictions without TIGER geometries (e.g., Alabama)
CREATE TABLE vtd_metadata (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    state_fips CHAR(2) NOT NULL,
    county_fips CHAR(3) NOT NULL,
    vtd_code VARCHAR(10) NOT NULL,      -- e.g., '000005'
    full_code VARCHAR(20) NOT NULL,     -- e.g., '01077000005'
    name VARCHAR(100) NOT NULL,
    polling_place VARCHAR(100),
    sheets INTEGER,
    source_file VARCHAR(255),
    effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
    expiration_date DATE,
    is_current BOOLEAN GENERATED ALWAYS AS (expiration_date IS NULL) STORED,

    CONSTRAINT uq_vtd_full_code_current UNIQUE (full_code, is_current) DEFERRABLE INITIALLY DEFERRED
);