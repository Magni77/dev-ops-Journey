mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
envfile := ./.env


.PHONY: help up down logs sql

# help target adapted from https://gist.github.com/prwhite/8168133#gistcomment-2278355
TARGET_MAX_CHAR_NUM=20

## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  make <target>'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z_0-9-]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  %-$(TARGET_MAX_CHAR_NUM)s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)


## Start the services
up: $(envfile)
	@echo "Pulling images from Docker Hub (this may take a few minutes)"
	docker-compose pull
	@echo "Starting Docker services"
	docker-compose up

## Stop the services
down:
	docker-compose down

## Run manage.py migrate
migrate:
	docker-compose exec backend python src/manage.py migrate

## Run manage.py makemigrations
migrations:
	docker-compose exec backend python src/manage.py makemigrations

## Show the service logs (services must be running)
logs:
	docker-compose logs --follow

## Start an interactive psql session (services must running)
sql:
	docker-compose exec db psql -U postgres

$(envfile):
	@echo "Error: .env file does not exist! See the README for instructions."
	@exit 1
