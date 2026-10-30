SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help
.PHONY: help check test

# Show available targets.
help:
	@printf '%s\n' "Usage: make TARGET" "" "Targets:"
	@awk '\
	/^[[:space:]]*#[[:space:]]/ { \
		description = $$0; \
		sub(/^[[:space:]]*#[[:space:]]*/, "", description); \
		next; \
	} \
	/^[a-zA-Z0-9_-]+:/ { \
		target = $$0; \
		sub(/:.*/, "", target); \
		printf "  %-15s %s\n", target, description; \
		description = ""; \
		next; \
	} \
	{ description = "" }' [Mm]akefile

# Run all project checks.
check: test

# Run the regression tests.
test:
	./tests/test_mcreport_toc.sh
