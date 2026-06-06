#!/bin/bash

# Authenticated ZAP scan with a context configuration
# Uses ZAP daemon mode (headless) + a pre-exported context file

ZAP_CMD="zap.sh"
TARGET_URL="${1:-http://example.com}"
CONTEXT_FILE="${2:-my-app.context}"
REPORT_FILE="zap-report.html"

# Start ZAP daemon in the background
$ZAP_CMD -daemon -port 8080 -host 127.0.0.1 &
ZAP_PID=$!

# Wait for ZAP to finish starting up
sleep 15

# Import the authentication context so ZAP knows how to log in
# The context file includes form-based auth config, user credentials, and URL regexes
curl -s "http://127.0.0.1:8080/JSON/context/action/importContext/" \
  --data "filePath=$(pwd)/$CONTEXT_FILE"

# Run the spider against the target to discover pages
curl -s "http://127.0.0.1:8080/JSON/spider/action/scan/" \
  --data "url=$TARGET_URL&contextName=MyApp&maxChildren=5"

# Wait for spider to finish (polling approach)
sleep 10

# Run active scan on the discovered URLs
curl -s "http://127.0.0.1:8080/JSON/ascan/action/scan/" \
  --data "url=$TARGET_URL&contextName=MyApp&recurse=true"

# Give the scan time to complete
sleep 30

# Export the HTML report
curl -s "http://127.0.0.1:8080/OTHER/core/other/htmlreport/" \
  -o "$REPORT_FILE"

# Clean up — shut down the daemon
curl -s "http://127.0.0.1:8080/JSON/core/action/shutdown/"
wait $ZAP_PID 2>/dev/null

echo "Report saved to $REPORT_FILE"
