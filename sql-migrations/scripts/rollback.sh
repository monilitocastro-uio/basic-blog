#!/bin/bash
set -e

# Load environment variables
source .env

# Check if CONNECTION_STRING is set
if [ -z "$CONNECTION_STRING" ]; then
    echo "Error: CONNECTION_STRING not set in .env file"
    exit 1
fi

# Check if an argument is provided (number of migrations to rollback or target version)
if [ -z "$1" ]; then
    echo "Error: Please specify the number of migrations to rollback or a target version"
    echo "Usage: ./rollback.sh N  # Rollback N migrations"
    echo "       ./rollback.sh VERSION  # Rollback to specific version"
    exit 1
fi

TARGET=$1

# If $TARGET is numeric and less than 1000, treat it as count
# Otherwise, treat it as a timestamp/version
if [[ "$TARGET" =~ ^[0-9]+$ ]] && [ "$TARGET" -lt 1000 ]; then
    echo "Rolling back $TARGET migration(s)..."
    MIGRATIONS=$(psql "$CONNECTION_STRING" -t -c "SELECT version FROM migrations ORDER BY version DESC LIMIT $TARGET;")
else
    echo "Rolling back to version $TARGET..."
    MIGRATIONS=$(psql "$CONNECTION_STRING" -t -c "SELECT version FROM migrations WHERE version > $TARGET ORDER BY version DESC;")
fi

# Trim whitespace
MIGRATIONS=$(echo "$MIGRATIONS" | tr -d '[:space:]')

if [ -z "$MIGRATIONS" ]; then
    echo "No migrations to roll back."
    exit 0
fi

# Convert to array
MIGRATION_ARRAY=($MIGRATIONS)

# Rollback each migration
for version in "${MIGRATION_ARRAY[@]}"; do
    # Find the corresponding down migration file
    DOWN_FILE=$(find down -name "${version}-*.sql")
    
    if [ -z "$DOWN_FILE" ]; then
        echo "Error: Down migration file for version $version not found!"
        exit 1
    fi
    
    filename=$(basename "$DOWN_FILE")
    name=${filename#*-}
    name=${name%.sql}
    
    echo "Rolling back migration: $version - $name"
    
    # Apply the rollback migration within a transaction
    if psql "$CONNECTION_STRING" -v ON_ERROR_STOP=1 -1 -f "$DOWN_FILE"; then
        # Remove the migration record
        psql "$CONNECTION_STRING" -v ON_ERROR_STOP=1 -c "DELETE FROM migrations WHERE version = $version;"
        echo "Migration $version - $name rolled back successfully!"
    else
        echo "Error rolling back migration $version - $name"
        exit 1
    fi
done

echo "Rollback completed!"