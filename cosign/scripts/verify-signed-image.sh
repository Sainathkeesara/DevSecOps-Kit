#!/bin/bash

# Verify a signed container image with Cosign

# Check signature with a public key
cosign verify --key cosign.pub localhost:5000/nginx:latest

# Check signature without specifying key (keyless) — pulls cert from Rekor
cosign verify localhost:5000/nginx:latest

# Show verification output as JSON
cosign verify --key cosign.pub localhost:5000/nginx:latest --output json
