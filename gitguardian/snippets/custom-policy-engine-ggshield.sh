#!/bin/bash

# Custom policy engine example with ggshield CLI
# Demonstrates how to define custom detection patterns and run
# scans with a tailored policy configuration

set -e

# Create a temporary directory for our test
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

cd "$TMP_DIR"

# Create a sample .ggshield.yaml with custom policies
cat > .ggshield.yaml << 'EOF'
version: "2"

# Custom detection: flag bearer tokens that look like JWTs
custom-detectors:
  - name: "Custom JWT Bearer"
    description: "Detects JWT-like bearer tokens in source code"
    matching:
      - pattern: '(?i)bearer\s+eyJ[a-zA-Z0-9_-]+\.eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+'
        name: "JWT Token"
        severity: "high"

  - name: "Custom Cloud API Endpoint"
    description: "Detects hardcoded internal API endpoints"
    matching:
      - pattern: 'https?://(api|service)\.internal\.(corp|example)\.(com|io)/[a-zA-Z0-9/_-]+'
        name: "Internal API URL"
        severity: "medium"

# Ignore test fixtures and generated code
ignored-paths:
  - "**/*.test.*"
  - "**/generated/**"
EOF

# Create a test file with a fake JWT to trigger the custom detector
cat > app.py << 'EOF'
import requests

# This JWT is a test token for local development
TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiYWRtaW4ifQ.signature"

def call_internal_api():
    # Internal API endpoint - should not be hardcoded
    url = "https://api.internal.corp.io/v1/status"
    headers = {"Authorization": f"Bearer {TOKEN}"}
    return requests.get(url, headers=headers, timeout=10)
EOF

echo "=== Running ggshield scan with custom policy engine ==="
ggshield scan path . --config .ggshield.yaml --json 2>&1 || true

echo ""
echo "=== Custom detector summary ==="
echo "Created two custom detectors:"
echo "  - Custom JWT Bearer (high severity)"
echo "  - Custom Cloud API Endpoint (medium severity)"
echo "These run alongside ggshield's built-in detectors."
echo ""
echo "Tip: Add more patterns by extending the custom-detectors list in .ggshield.yaml"
echo "Each detector supports regex patterns and named captures for clarity."
