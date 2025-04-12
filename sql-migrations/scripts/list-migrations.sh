#!/bin/bash
set -e

# List all available migrations in both up and down directories

echo "Available migrations:"
echo "------------------------"
echo "UP migrations:"

# Find all migrations in the up directory
UP_MIGRATIONS=$(find up -name "*.sql" | sort)

if [ -z "$UP_MIGRATIONS" ]; then
    echo "  No migrations available in 'up' directory."
else
    echo "$UP_MIGRATIONS" | while read -r migration; do
        filename=$(basename "$migration")
        version=${filename%%-*}
        name=${filename#*-}
        name=${name%.sql}
        echo "  $version - $name"
    done
fi

echo ""
echo "DOWN migrations:"

# Find all migrations in the down directory
DOWN_MIGRATIONS=$(find down -name "*.sql" | sort)

if [ -z "$DOWN_MIGRATIONS" ]; then
    echo "  No migrations available in 'down' directory."
else
    echo "$DOWN_MIGRATIONS" | while read -r migration; do
        filename=$(basename "$migration")
        version=${filename%%-*}
        name=${filename#*-}
        name=${name%.sql}
        echo "  $version - $name"
    done
fi

# Check for missing down migrations
echo ""
echo "Missing DOWN migrations:"
UP_VERSIONS=$(find up -name "*.sql" | sed -E 's|.*/([0-9]+)-.*|\1|' | sort)
DOWN_VERSIONS=$(find down -name "*.sql" | sed -E 's|.*/([0-9]+)-.*|\1|' | sort)

for version in $UP_VERSIONS; do
    if ! echo "$DOWN_VERSIONS" | grep -q "^$version$"; then
        UP_NAME=$(find up -name "${version}-*.sql" | sed -E 's|.*/[0-9]+-(.*)\.sql|\1|')
        echo "  $version - $UP_NAME (missing down migration)"
    fi
done

# Check for missing up migrations
echo ""
echo "Missing UP migrations:"
for version in $DOWN_VERSIONS; do
    if ! echo "$UP_VERSIONS" | grep -q "^$version$"; then
        DOWN_NAME=$(find down -name "${version}-*.sql" | sed -E 's|.*/[0-9]+-(.*)\.sql|\1|')
        echo "  $version - $DOWN_NAME (missing up migration)"
    fi
done