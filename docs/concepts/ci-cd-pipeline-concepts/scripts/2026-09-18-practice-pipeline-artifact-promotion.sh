#!/usr/bin/env bash
# last_verified: 2026-09-18 · ci-cd-pipeline-concepts n/a

# I wrote this to practice a second CI/CD idea: artifact promotion.
# The last exercise covered stage gating, so here I wanted to see how
# one build artifact moves staging -> prod only when checks pass.

APP_VERSION="${1:-0.1.0}"
WORKDIR="./.pipeline-practice"

echo "[pipeline] practicing artifact promotion for version $APP_VERSION"

# I build once and keep the artifact — a pipeline should never rebuild per env.
mkdir -p "$WORKDIR/build" "$WORKDIR/staging" "$WORKDIR/prod"
echo "hello from build $APP_VERSION" > "$WORKDIR/build/app-$APP_VERSION.txt"
echo "[build] saved artifact: $WORKDIR/build/app-$APP_VERSION.txt"

# I run a quick check on the artifact before it is allowed to move on.
if grep -q "$APP_VERSION" "$WORKDIR/build/app-$APP_VERSION.txt"; then
  echo "[check] artifact contents look right, promoting to staging"
  cp "$WORKDIR/build/app-$APP_VERSION.txt" "$WORKDIR/staging/"
else
  echo "[check] artifact contents wrong, stopping here"
  exit 1
fi

# I only promote staging -> prod when staging got the exact same file.
if cmp -s "$WORKDIR/build/app-$APP_VERSION.txt" "$WORKDIR/staging/app-$APP_VERSION.txt"; then
  echo "[promote] staging matches build, promoting to prod"
  cp "$WORKDIR/staging/app-$APP_VERSION.txt" "$WORKDIR/prod/"
  echo "[pipeline] PASSED — version $APP_VERSION is live in prod/"
  exit 0
else
  echo "[promote] staging does not match build, blocked"
  exit 1
fi
