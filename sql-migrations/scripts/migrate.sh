#!/bin/bash
set -e

# Load environment variables
source .env

# Check if CONNECTION_STRING is set
if [ -z "$CONNECTION_STRING" ]; then
    echo "Error: CONNECTION_STRING not set in .env file"
    exit 1
fi

# Get target migration timestamp if provided
TARGET_VERSION=$1

# Function to apply a migration
apply_migration() {
    local file=$1
    local filename=$(basename "$file")
    local version=${filename%%-*}
    local name=${filename#*-}
    name=${name%.sql}
    
    # Check if migration is already applied
    local is_applied=$(psql "$CONNECTION_STRING" -t -c "SELECT 1 FROM migrations WHERE version = $version LIMIT 1;")
    is_applied=$(echo "$is_applied" | tr -d '[:space:]')
    
    if [ -n "$is_applied" ]; then
        echo "Migration $version - $name is already applied. Skipping."
        return 0
    fi
    
    echo "Applying migration: $version - $name"
    
    # Apply the migration within a transaction
    if psql "$CONNECTION_STRING" -v ON_ERROR_STOP=1 -1 -f "$file"; then
        # Record the migration
        psql "$CONNECTION_STRING" -v ON_ERROR_STOP=1 -c "INSERT INTO migrations(version, name) VALUES($version, '$name');"
        echo "Migration $version - $name applied successfully!"
    else
        echo "Error applying migration $version - $name"
        exit 1
    fi
}

# Get available migrations
MIGRATIONS=$(find up -name "*.sql" | sort)

if [ -z "$MIGRATIONS" ]; then
    echo "No migrations available in 'up' directory."
    exit 0
fi

# Apply pending migrations
for migration in $MIGRATIONS; do
    filename=$(basename "$migration")
    version=${filename%%-*}
    
    # If a target version is specified, stop after reaching it
    if [ -n "$TARGET_VERSION" ] && [ "$version" -gt "$TARGET_VERSION" ]; then
        echo "Reached target migration version: $TARGET_VERSION"
        break
    fi
    
    apply_migration "$migration"
done

echo "Migration completed!"