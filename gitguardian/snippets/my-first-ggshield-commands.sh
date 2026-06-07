#!/bin/bash

# Scan current directory for secrets
ggshield scan path .

# Scan only staged changes (pre-commit style)
ggshield scan pre-commit

# Scan the last 5 commits
ggshield scan commit-range HEAD~5..HEAD

# Output as JSON for CI pipelines
ggshield scan path . --json
