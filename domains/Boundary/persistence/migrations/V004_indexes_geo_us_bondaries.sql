-- Critical indexes (applied to the parent table - inherited by partitions)
CREATE INDEX ix_geo_us_boundaries_geom ON geo_us_boundaries USING GIST (geom);
CREATE INDEX ix_geo_us_boundaries_geoid ON geo_us_boundaries (geoid);
CREATE INDEX ix_geo_us_boundaries_layer ON geo_us_boundaries (layer);
CREATE INDEX ix_geo_us_boundaries_current ON geo_us_boundaries (is_current) WHERE is_current = true;