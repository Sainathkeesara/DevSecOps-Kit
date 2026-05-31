#!/usr/bin/env bash

# Scan an image for vulnerabilities
grype alpine:latest

# Focus on fixable high-severity issues
grype nginx:latest --only-fixed

# Generate an SBOM with Syft and scan it offline
syft alpine:latest -o syft-json > alpine-sbom.json
grype sbom:alpine-sbom.json
