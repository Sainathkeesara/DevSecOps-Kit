#!/bin/bash
# test a project and show summary
snyk test --severity-threshold=high

# push snapshot to dashboard for monitoring
snyk monitor --project-name=my-api

# view test results as JSON (pipe to jq for filtering)
snyk test --json | jq '.vulnerabilities[] | {id: .id, severity: .severity, title: .title}'

# scan all sub-projects in a monorepo
snyk test --all-projects --exclude=tests,examples
