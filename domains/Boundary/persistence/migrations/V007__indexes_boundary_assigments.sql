CREATE INDEX ix_boundary_assignments_vtd_geoid ON boundary_assignments (vtd_geoid);
CREATE INDEX ix_boundary_assignments_assigned_layer ON boundary_assignments (assigned_layer);
CREATE INDEX ix_boundary_assignments_current ON boundary_assignments (is_current) WHERE is_current = true;
CREATE INDEX ix_boundary_assignments_state ON boundary_assignments (state_fips);