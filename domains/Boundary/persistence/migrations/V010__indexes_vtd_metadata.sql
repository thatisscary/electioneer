CREATE INDEX ix_vtd_metadata_state_county ON vtd_metadata (state_fips, county_fips);
CREATE INDEX ix_vtd_metadata_full_code ON vtd_metadata (full_code);
CREATE INDEX ix_vtd_metadata_current ON vtd_metadata (is_current) WHERE is_current = true;