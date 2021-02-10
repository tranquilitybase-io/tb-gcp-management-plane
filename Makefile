# Make will use bash instead of sh
SHELL := /usr/bin/env bash

.PHONY: validate
validate:
	@source scripts/tg-wrapper.sh validate

.PHONY: setup
setup:
	@source scripts/setup.sh

.PHONY: plan
plan:
	@source scripts/tg-wrapper.sh plan

.PHONY: apply
apply:
	@source scripts/tg-wrapper.sh apply

.PHONY: destroy
destroy:
	@source scripts/tg-wrapper.sh destroy
