#!/usr/bin/env bash
# last_verified: 2026-09-21 · sonarqube n/a

# Set up and run a SonarQube scan against a project directory.
# Gotchas from the tutorial: tokens hide after display, server needs a
# minute before it accepts connections, and projectKey must be passed explicitly.

PROJECT_KEY="${1:?Project key required}"
PROJECT_NAME="${2:?Project name required}"
PROJECT_DIR="${3:-.}"
SONAR_HOST="${SONAR_HOST:-http://localhost:9000}"
SONAR_TOKEN="${SONAR_TOKEN:?SonarQube token required}"

echo "Waiting for SonarQube at ${SONAR_HOST}..."
for _ in $(seq 1 30); do
  if curl -sf "${SONAR_HOST}/api/system/status" >/dev/null 2>&1; then
    echo "SonarQube is ready."
    break
  fi
  sleep 2
done

echo "Running scanner for ${PROJECT_KEY}..."
sonar-scanner \
  -Dsonar.projectKey="${PROJECT_KEY}" \
  -Dsonar.projectName="${PROJECT_NAME}" \
  -Dsonar.sources="${PROJECT_DIR}" \
  -Dsonar.host.url="${SONAR_HOST}" \
  -Dsonar.token="${SONAR_TOKEN}"

echo "Scan complete. Check the dashboard for results."
