#!/bin/bash

# Minimal GitGuardian pre-commit hook integration

if ! command -v ggshield >/dev/null 2>&1; then
  echo "ggshield is not installed. Install it first, then rerun this script."
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Run this from inside a Git repository."
  exit 1
fi

echo "Installing ggshield pre-commit hook..."
ggshield install pre-commit

echo "Scanning staged changes..."
ggshield scan pre-commit
