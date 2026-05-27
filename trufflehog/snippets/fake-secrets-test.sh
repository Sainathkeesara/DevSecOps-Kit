#!/bin/bash
# Create a test file with fake secrets and scan it with TruffleHog

mkdir -p /tmp/trufflehog-test
cat > /tmp/trufflehog-test/creds.txt << 'EOF'
# Fake secrets for testing
aws_access_key_id = "AKIAIOSFODNN7EXAMPLE"
github_token = "ghp_xxxxxxxxxxxxxxxxxxxx"
password = "this-is-a-fake-password-123"
EOF

trufflehog filesystem --path=/tmp/trufflehog-test/ --no-verification --json=false

rm -rf /tmp/trufflehog-test
