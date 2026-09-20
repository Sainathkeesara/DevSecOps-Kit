#!/usr/bin/env bash
# last_verified: 2026-09-20 · snippets L1
# My first snippet: a simple log function with timestamp
# Usage: log "message" -> [2026-09-20 10:30:45] message

log() {
  local level="${2:-INFO}"
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$timestamp] [$level] $1"
}

# Example usage
log "Script started"
log "Processing item 42" "DEBUG"
log "Completed successfully" "SUCCESS"