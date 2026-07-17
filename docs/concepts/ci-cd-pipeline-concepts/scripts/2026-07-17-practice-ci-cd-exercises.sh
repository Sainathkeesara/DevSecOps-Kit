#!/usr/bin/env bash
# last_verified: 2026-07-17 · bash 5.x

# practice-ci-cd-exercises.sh
# I wrote this to practice the core ideas behind a CI/CD pipeline —
# stages, conditions, and exit codes — without needing a real CI server.

ENVIRONMENT="${1:-staging}"

echo "[pipeline] starting CI/CD simulation — environment: $ENVIRONMENT"

# Stage 1: Build
# In a real pipeline this would compile code or build a container image.
echo "[build] compiling source..."
BUILD_STATUS="success"
echo "[build] build status: $BUILD_STATUS"

# Stage 2: Test
# Running unit tests here to catch bugs before deployment.
echo "[test] running unit tests..."
TEST_STATUS="success"
echo "[test] test status: $TEST_STATUS"

# Stage 3: Conditional deploy
# Only deploy if both build and test passed — this is the gating logic.
if [[ "$BUILD_STATUS" == "success" && "$TEST_STATUS" == "success" ]]; then
  echo "[deploy] deploying to $ENVIRONMENT..."
  DEPLOY_STATUS="success"
  echo "[deploy] deployment status: $DEPLOY_STATUS"
else
  echo "[deploy] blocked — build or test failed"
  DEPLOY_STATUS="failed"
fi

# Final pipeline status
# CI servers use the exit code to mark the whole run as passed or failed.
if [[ "$DEPLOY_STATUS" == "success" ]]; then
  echo "[pipeline] PASSED"
  exit 0
else
  echo "[pipeline] FAILED"
  exit 1
fi
