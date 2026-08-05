#!/bin/bash
# last_verified: 2026-08-05 · tetragon n/a

# I wanted a simple pipeline that collects Tetragon events,
# exports them as JSON, and forwards them to an external endpoint.
# This is the script I wrote after following the Tetragon quickstart.

OUTPUT_FILE="tetragon-events.json"
FORWARD_URL="${FORWARD_URL:-}"

# I'm using tetragon collect to grab events and pipe them to JSON output.
# The --output json flag gives me structured events I can ship elsewhere.
tetragon collect --output json > "$OUTPUT_FILE"

# If a forward URL is set, I POST the collected events there.
# I'm keeping this simple — just a single curl call with the JSON file as the body.
if [ -n "$FORWARD_URL" ]; then
  curl -X POST \
    -H "Content-Type: application/json" \
    -d @"$OUTPUT_FILE" \
    "$FORWARD_URL"
fi

echo "Events collected to $OUTPUT_FILE"