#!/bin/bash
set -e

# Load environment variables
source .env

# Check if CONNECTION_STRING is set
if [ -z "$CONNECTION_STRING" ]; then
    echo "Error: CONNECTION_STRING not set in .env file"
    exit 1
fi

echo "Initializing migrations table..."

# Create migrations table if it doesn't exist
cat << EOF | psql "$CONNECTION_STRING" -v ON_ERROR_STOP=1
CREATE TABLE IF NOT EXISTS migrations (
    id SERIAL PRIMARY KEY,
    version BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(version)
);
EOF

echo "Migrations table initialized successfully!"