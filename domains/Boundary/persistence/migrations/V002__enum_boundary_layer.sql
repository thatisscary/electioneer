-- Core enumeration (mirrors future C# BoundaryLayer enum)
CREATE TYPE boundary_layer AS ENUM (
    'vtd',               -- Voting Tabulation District (precincts) - geometry where available
    'cd',                -- Congressional District
    'sldl',              -- State Legislative District Lower
    'sldu',              -- State Legislative District Upper
    'county',
    'cousub',            -- County Subdivision / MCD
    'place',             -- Incorporated places
    'unsd',              -- Unified School District
    'elsd',              -- Elementary School District
    'scsd'               -- Secondary School District
    -- Add 'bg' (block group) or 'tract' if needed for deeper fallbacks
);