# last_verified: 2026-09-02 · snyk (template scaffold)

SHELL := /bin/bash

# Detect available subscan scripts and build the per-language target list
LANG_SCRIPS := $(wildcard scripts/scan-*.sh)

.PHONY: scan scan-node scan-python scan-java scan-go scan-ruby clean

scan: scan-node scan-python scan-java scan-go scan-ruby

scan-node:
	@bash scripts/scan-node.sh

scan-python:
	@bash scripts/scan-python.sh

scan-java:
	@bash scripts/scan-java.sh

scan-go:
	@bash scripts/scan-go.sh

scan-ruby:
	@bash scripts/scan-ruby.sh

clean:
	@rm -rf snyk-results