# SQL Migration Framework Makefile

.PHONY: help init status migrate rollback list-migrations create-migration

# Load environment variables
include .env

help:
	@echo "SQL Migration Framework"
	@echo ""
	@echo "Commands:"
	@echo "  make init              - Initialize the migrations table"
	@echo "  make status            - Show current migration status"
	@echo "  make migrate           - Run all pending migrations"
	@echo "  make migrate-to [TIME] - Migrate up to specific timestamp"
	@echo "  make rollback          - Rollback the last migration"
	@echo "  make rollback-to [TIME] - Rollback to specific timestamp"
	@echo "  make list-migrations   - List all available migrations"
	@echo "  make create-migration NAME=[name] - Create new migration files"

init:
	@./scripts/init.sh

status:
	@./scripts/status.sh

migrate:
	@./scripts/migrate.sh

migrate-to:
	@./scripts/migrate.sh $(TIME)

rollback:
	@./scripts/rollback.sh 1

rollback-to:
	@./scripts/rollback.sh $(TIME)

list-migrations:
	@./scripts/list-migrations.sh

create-migration:
	@./scripts/create-migration.sh "$(NAME)"