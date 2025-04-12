#!/bin/bash
set -e

# Check if a name is provided
if [ -z "$1" ]; then
    echo "Error: Please provide a name for the migration"
    echo "Usage: ./create-migration.sh \"Create users table\""
    exit 1
fi

# Get the name and convert spaces to underscores
NAME=$(echo "$1" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')

# Generate timestamp for the migration (POSIX time)
TIMESTAMP=$(date +%s)

# Create up and down directories if they don't exist
mkdir -p up
mkdir -p down

# Create the migration files
UP_FILE="up/${TIMESTAMP}-${NAME}.sql"
DOWN_FILE="down/${TIMESTAMP}-${NAME}.sql"

# Create up file with template
cat > "$UP_FILE" << EOF
-- Migration: $1
-- Created at: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
-- Description: Add your description here

BEGIN;

-- Write your UP migration SQL here
-- Example:
-- CREATE TABLE users (
--     id SERIAL PRIMARY KEY,
--     username VARCHAR(255) NOT NULL,
--     email VARCHAR(255) NOT NULL,
--     created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
-- );

COMMIT;
EOF

# Create down file with template
cat > "$DOWN_FILE" << EOF
-- Migration: $1 (rollback)
-- Created at: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
-- Description: Rollback of "$1"

BEGIN;

-- Write your DOWN migration SQL here
-- Example:
-- DROP TABLE IF EXISTS users;

COMMIT;
EOF

echo "Migration created successfully:"
echo "UP:   $UP_FILE"
echo "DOWN: $DOWN_FILE"
echo ""
echo "Don't forget to edit these files with your actual migration code!"