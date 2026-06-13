#!/bin/bash
# My first ZAP spider scan via API
# Simple wrapper around the ZAP REST API for spider scanning

TARGET="${1:-http://example.com}"
API_KEY="${2:-}"
PORT="${3:-8090}"

if [ -z "$TARGET" ]; then
  echo "Usage: $0 <target_url> [api_key] [port]"
  exit 1
fi

# Start spider scan
SPIDER_ID=$(curl -s "http://localhost:$PORT/JSON/spider/action/scan/?apikey=$API_KEY&url=$TARGET" | jq -r '.scan')

if [ "$SPIDER_ID" = "null" ] || [ -z "$SPIDER_ID" ]; then
  echo "Failed to start spider scan"
  exit 1
fi

echo "Started spider scan with ID: $SPIDER_ID"

# Poll for completion
while true; do
  STATUS=$(curl -s "http://localhost:$PORT/JSON/spider/view/status/?apikey=$API_KEY&scanId=$SPIDER_ID" | jq -r '.status')
  echo "Spider progress: $STATUS%"
  [ "$STATUS" = "100" ] && break
  sleep 5
done

# Get discovered URLs
URLS=$(curl -s "http://localhost:$PORT/JSON/spider/view/results/?apikey=$API_KEY&scanId=$SPIDER_ID" | jq -r '.spider[0].urls[]')
echo "Discovered URLs:"
echo "$URLS"