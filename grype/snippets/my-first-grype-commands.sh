#!/usr/bin/env bash

# My first Grype commands — scanning images and filtering results

# Scan an image — this is the simplest way to use Grype
grype alpine:latest

# Filter by severity: only show critical and high
grype nginx:latest --only-fixed

# Limit output to a specific number of results
grype python:3.12-slim -q | head -20

# Filter by CVE namespace (e.g., only Alpine-specific vulnerabilities)
grype alpine:latest --only-fixed --fail-on high
