CREATE SCHEMA IF NOT EXISTS boundary AUTHORIZATION boundary_owner;

-- Create roles if they don't exist (Flyway runs as a privileged user)
DO $$  
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'boundary_app') THEN
        CREATE ROLE boundary_app WITH LOGIN PASSWORD 'temp';  -- Password overridden at runtime
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'boundary_owner') THEN
        CREATE ROLE boundary_owner WITH LOGIN PASSWORD 'secure_owner_pass';  -- Change in env vars/secrets
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'boundary_app') THEN
        CREATE ROLE boundary_app WITH LOGIN PASSWORD 'secure_app_pass';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'boundary_reader') THEN
        CREATE ROLE boundary_reader WITH LOGIN PASSWORD 'secure_reader_pass';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'boundary_importer') THEN
        CREATE ROLE boundary_importer WITH LOGIN PASSWORD 'secure_importer_pass';
    END IF;
END $$;

-- Grant schema usage to roles

GRANT USAGE ON SCHEMA boundary TO boundary_app, boundary_reader, boundary_importer;
-- Use ALTER DEFAULT PRIVILEGES as before

ALTER DEFAULT PRIVILEGES IN SCHEMA boundary
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO boundary_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA boundary
    GRANT SELECT ON TABLES TO boundary_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA boundary
    GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON TABLES TO boundary_importer;

ALTER DEFAULT PRIVILEGES IN SCHEMA boundary
    GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO boundary_app, boundary_importer;
ALTER DEFAULT PRIVILEGES IN SCHEMA boundary
    GRANT USAGE, SELECT ON SEQUENCES TO boundary_reader;
