#!/bin/bash
# last_verified: 2026-07-16 · sonar-scanner

sonar-scanner \
  -Dsonar.projectKey=my-first-project \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=sqp_abc123
