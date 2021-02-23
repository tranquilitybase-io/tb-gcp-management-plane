# Use bash instead of sh
SHELL := /usr/bin/env bash

.PHONY: lint
lint:
	@source scripts/lint.sh

.PHONY: setup
setup:
	@source scripts/setup.sh

.PHONY: init
init:
	@source scripts/tg-wrapper.sh init

.PHONY: validate
validate:
	@source scripts/tg-wrapper.sh validate

.PHONY: refresh
refresh:
	@source scripts/tg-wrapper.sh refresh

.PHONY: plan
plan:
	@source scripts/tg-wrapper.sh plan

.PHONY: apply
apply:
	@source scripts/tg-wrapper.sh apply

.PHONY: destroy
destroy:
	@source scripts/tg-wrapper.sh destroy

.PHONY: clean
clean:
	@source scripts/clean.sh
