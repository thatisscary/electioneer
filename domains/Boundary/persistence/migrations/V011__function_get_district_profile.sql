-- Resolve full district set for an address point (prioritizes VTD where available)
CREATE OR REPLACE FUNCTION get_district_profile(lon DOUBLE PRECISION, lat DOUBLE PRECISION)
RETURNS TABLE (
    layer boundary_layer,
    geoid VARCHAR(20),
    name VARCHAR(100),
    vtd_code VARCHAR(10),
    vtd_name VARCHAR(100)
) AS $$
DECLARE
    point_geom GEOMETRY := ST_SetSRID(ST_Point(lon, lat), 4326);
    vtd_rec RECORD;
BEGIN
    -- Primary path: TIGER VTD geometry (fast + assignments)
    SELECT g.geoid, g.namelsad INTO vtd_rec
    FROM geo_us_boundaries g
    WHERE g.layer = 'vtd' AND g.is_current = true AND ST_Contains(g.geom, point_geom)
    LIMIT 1;

    IF vtd_rec.geoid IS NOT NULL THEN
        -- Return VTD itself
        RETURN QUERY SELECT 'vtd'::boundary_layer, vtd_rec.geoid, vtd_rec.namelsad, NULL::VARCHAR, NULL::VARCHAR;

        -- Higher districts via normalized assignments
        RETURN QUERY
        SELECT a.assigned_layer, a.assigned_geoid,
               (SELECT namelsad FROM geo_us_boundaries WHERE geoid = a.assigned_geoid AND is_current = true)
        FROM boundary_assignments a
        WHERE a.vtd_geoid = vtd_rec.geoid AND a.is_current = true;
    ELSE
        -- Fallback: direct spatial across all layers (slower but works everywhere)
        RETURN QUERY
        SELECT b.layer, b.geoid, b.namelsad, NULL::VARCHAR, NULL::VARCHAR
        FROM geo_us_boundaries b
        WHERE b.is_current = true AND ST_Contains(b.geom, point_geom);
    END IF;
END;
$$ LANGUAGE plpgsql;