#!/usr/bin/env bash
# Multi-repository TruffleHog scan with centralized configuration
# Reads repos from repos.txt, applies centralized config, aggregates results

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="${ROOT_DIR}/.trufflehog/config.yaml"
ALLOWLIST_FILE="${ROOT_DIR}/.trufflehog/allowlist.yaml"
REPOS_FILE="${ROOT_DIR}/repos.txt"
OUTPUT_DIR="${ROOT_DIR}/reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Scan multiple repositories listed in repos.txt using centralized TruffleHog config.

Options:
  -f, --file <file>    Path to repos file (default: ${REPOS_FILE})
  -o, --output <dir>   Output directory (default: ${OUTPUT_DIR})
  -c, --config <file>  Config file path (default: ${CONFIG_FILE})
  -h, --help           Show this help

Environment:
  TRUFFLEHOG_TOKEN     Optional GitHub/GitLab token for higher API rate limits
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--file)
            shift
            REPOS_FILE="$1"
            shift
            ;;
        -o|--output)
            shift
            OUTPUT_DIR="$1"
            shift
            ;;
        -c|--config)
            shift
            CONFIG_FILE="$1"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

if [[ ! -f "$REPOS_FILE" ]]; then
    echo "Error: repos file not found: $REPOS_FILE"
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: config file not found: $CONFIG_FILE"
    exit 1
fi

if ! command -v trufflehog &>/dev/null; then
    echo "Error: trufflehog not installed. Install with: pip install trufflehog"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "TruffleHog Multi-Repository Scan"
echo "================================="
echo "Config: $CONFIG_FILE"
echo "Repos file: $REPOS_FILE"
echo "Output: $OUTPUT_DIR"
echo ""

declare -a REPOS
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    REPOS+=("$line")
done < "$REPOS_FILE"

if [[ ${#REPOS[@]} -eq 0 ]]; then
    echo "Error: No repositories listed in $REPOS_FILE"
    exit 1
fi

echo "Repositories to scan: ${#REPOS[@]}"
echo ""

total_findings=0

scan_repo() {
    local repo_url="$1"
    local repo_name
    repo_name=$(basename "$repo_url" .git)
    local tmpdir
    tmpdir=$(mktemp -d)
    
    echo -n "Scanning $repo_name..."
    
    # Clone with depth 1 for speed
    if ! git clone --depth 1 --quiet "$repo_url" "$tmpdir" 2>/dev/null; then
        echo " FAILED (clone error)"
        rm -rf "$tmpdir"
        return 1
    fi
    
    # Build command with config and allowlist
    local cmd=(
        "trufflehog" "filesystem"
        "--config" "$CONFIG_FILE"
        "--json"
        "--no-verification"
    )
    
    if [[ -f "$ALLOWLIST_FILE" ]]; then
        cmd+=("--allow-rules" "$ALLOWLIST_FILE")
    fi
    
    cmd+=("$tmpdir")
    
    # Run scan
    local result
    if result=$("${cmd[@]}" 2>/dev/null); then
        local count
        count=$(echo "$result" | grep -c . || echo 0)
        echo " $count findings"
        total_findings=$((total_findings + count))
        
        if [[ -n "$result" ]]; then
            echo "$result" > "${OUTPUT_DIR}/${repo_name}-${TIMESTAMP}.json"
        fi
    else
        echo " error during scan"
    fi
    
    rm -rf "$tmpdir"
}

for repo in "${REPOS[@]}"; do
    scan_repo "$repo"
done

echo ""
echo "Total findings across all repositories: $total_findings"
echo "Reports saved to: $OUTPUT_DIR"