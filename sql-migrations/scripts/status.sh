#!/bin/bash
set -e

# Load environment variables
source .env

# Check if CONNECTION_STRING is set
if [ -z "$CONNECTION_STRING" ]; then
    echo "Error: CONNECTION_STRING not set in .env file"
    exit 1
fi

# Get current migration status
echo "Current migration status:"
echo "------------------------"

# Get the latest applied migration
LATEST_MIGRATION=$(psql "$CONNECTION_STRING" -t -c "SELECT version FROM migrations ORDER BY version DESC LIMIT 1;")
LATEST_MIGRATION=$(echo "$LATEST_MIGRATION" | tr -d '[:space:]')

if [ -z "$LATEST_MIGRATION" ]; then
    echo "No migrations have been applied yet."
else
    echo "Latest applied migration: $LATEST_MIGRATION"
fi

# List all available migrations
echo ""
echo "Available migrations:"
echo "------------------------"

# Count available migrations in up directory
UP_MIGRATIONS=$(find up -name "*.sql" | sort)

if [ -z "$UP_MIGRATIONS" ]; then
    echo "No migrations available in 'up' directory."
else
    # Calculate how many migrations are pending
    TOTAL_COUNT=$(echo "$UP_MIGRATIONS" | wc -l)
    
    # List all migrations with their status (applied or pending)
    echo "$UP_MIGRATIONS" | while read -r migration; do
        filename=$(basename "$migration")
        version=${filename%%-*}
        name=${filename#*-}
        name=${name%.sql}
        
        # Check if migration is applied
        is_applied=$(psql "$CONNECTION_STRING" -t -c "SELECT 1 FROM migrations WHERE version = $version LIMIT 1;")
        is_applied=$(echo "$is_applied" | tr -d '[:space:]')
        
        if [ -n "$is_applied" ]; then
            status="[APPLIED]"
        else
            status="[PENDING]"
        fi
        
        echo "$status $version - $name"
    done
fi