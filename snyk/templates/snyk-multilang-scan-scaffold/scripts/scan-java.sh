#!/usr/bin/env bash
# last_verified: 2026-09-02 · snyk (template scaffold)
# scan-java.sh — Snyk scan for Java/Maven/Gradle projects under the repo root.

set -e

if ! ls pom.xml build.gradle build.gradle.kts >/dev/null 2>&1; then
  echo "java: no manifest found, skipping"
  exit 0
fi

echo "java: scanning"
snyk test --all-projects --severity-threshold=medium --json \
  | tee snyk-results/snyk-java.json >/dev/null