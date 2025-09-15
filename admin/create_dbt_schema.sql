CREATE OR REPLACE FUNCTION admin.create_dbt_schema(p_username TEXT)
RETURNS TEXT
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    schema_name TEXT;
    result_message TEXT;
BEGIN
    -- Validate input
    IF p_username IS NULL OR LENGTH(TRIM(p_username)) = 0 THEN
        RAISE EXCEPTION 'Username cannot be null or empty';
    END IF;
    
    -- Create schema name
    schema_name := 'dev_' || LOWER(TRIM(p_username));
    
    -- Validate schema name (basic safety check)
    IF NOT schema_name ~ '^[a-z0-9_]+$' THEN
        RAISE EXCEPTION 'Invalid username. Only lowercase letters, numbers, and underscores are allowed';
    END IF;
    
    -- Check if user exists
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = p_username) THEN
        RAISE EXCEPTION 'User % does not exist', p_username;
    END IF;
    
    -- Create schema if it doesn't exist
    EXECUTE format('CREATE SCHEMA IF NOT EXISTS %I', schema_name);
    
    -- Grant schema usage to the user
    EXECUTE format('GRANT USAGE ON SCHEMA %I TO %I', schema_name, p_username);
    
    -- Grant create privileges on schema (needed for dbt to create tables/views)
    EXECUTE format('GRANT CREATE ON SCHEMA %I TO %I', schema_name, p_username);
    
    -- Grant all privileges on all existing tables in the schema
    EXECUTE format('GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA %I TO %I', schema_name, p_username);
    
    -- Grant all privileges on all existing sequences in the schema
    EXECUTE format('GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA %I TO %I', schema_name, p_username);
    
    -- Grant all privileges on all existing functions in the schema
    EXECUTE format('GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA %I TO %I', schema_name, p_username);
    
    -- Set default privileges for future objects created by any user in the schema
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL PRIVILEGES ON TABLES TO %I', schema_name, p_username);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL PRIVILEGES ON SEQUENCES TO %I', schema_name, p_username);
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT ALL PRIVILEGES ON FUNCTIONS TO %I', schema_name, p_username);
    
    -- Additional permissions that dbt typically needs:
    -- Grant privileges to create temporary tables (usually inherited from database level)
    -- Note: TEMP table creation is typically a database-level privilege
    
    result_message := format('Successfully created schema %s and granted permissions to user %s', schema_name, p_username);
    
    -- Log the action
    RAISE NOTICE '%', result_message;
    
    RETURN result_message;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log the error and re-raise
        RAISE EXCEPTION 'Error creating schema for user %: %', p_username, SQLERRM;
END;
$$;

-- Grant execute permission on the function to appropriate roles
-- Adjust this based on your security requirements
-- GRANT EXECUTE ON FUNCTION create_dbt_schema(TEXT) TO your_admin_role;

-- Example usage:
-- SELECT create_dbt_schema('john_doe');
-- This would create schema 'dev_john_doe' and grant permissions to user 'john_doe'

-- Optional: Create a more restrictive version that only allows specific users to execute
-- REVOKE EXECUTE ON FUNCTION create_dbt_schema(TEXT) FROM PUBLIC;
-- GRANT EXECUTE ON FUNCTION create_dbt_schema(TEXT) TO dbt_admin_role;