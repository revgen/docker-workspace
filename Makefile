##Usage: make <command>
##
##Commands:
IMAGE_NAME := $(shell grep "ARG NAME" ./Dockerfile | cut -d'"' -f2)
CONTAINER_NAME := $(shell grep "ARG NAME" ./Dockerfile | cut -d'"' -f2 | sed 's/\//-/g')
IMAGE_VERSION := $(shell grep "ARG VERSION" ./Dockerfile | cut -d'"' -f2)

.PHONY: build serve help

default: help

build:			## Build docker image
	@echo "Build $(IMAGE_NAME) v$(IMAGE_VERSION)..."
	@docker build -t "$(IMAGE_NAME)" ./
	@docker tag "$(IMAGE_NAME)" "$(IMAGE_NAME):$(IMAGE_VERSION)"
	@echo "Create image $(IMAGE_NAME):$(IMAGE_VERSION) done."
	@docker image ls $(IMAGE_NAME)

serve:			## Start docker image locally
	@clear
	@docker run -it --rm --network host --hostname vws -v "$(HOME)/Documents:/home/dev/Documents" -v "$(PWD):/home/dev/workspace" --name "$(CONTAINER_NAME)" "$(IMAGE_NAME)"

help:			## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
