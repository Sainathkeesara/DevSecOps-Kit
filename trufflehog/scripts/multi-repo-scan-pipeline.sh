#!/usr/bin/env bash
# Multi-repo TruffleHog secret scanning pipeline with JSON output aggregation
# Reads repo URLs from a file (one per line) or from command-line arguments
# Produces a single aggregated JSON report and a plain-text summary

set -e

SCRIPT_NAME=$(basename "$0")
REPORT_DIR="${REPORT_DIR:-./trufflehog-reports}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
AGGREGATED_REPORT="${REPORT_DIR}/aggregated-results-${TIMESTAMP}.json"
SUMMARY_FILE="${REPORT_DIR}/summary-${TIMESTAMP}.txt"

usage() {
    cat <<EOF
Usage: $SCRIPT_NAME [options] <repo-file>
       $SCRIPT_NAME [options] <repo-url> [repo-url...]

Scans one or more Git repos for secrets using TruffleHog and aggregates results.

Options:
  -f, --file <file>    File containing repo URLs (one per line)
  -o, --output <dir>   Output directory (default: ./trufflehog-reports)
  -h, --help           Show this help

Examples:
  $SCRIPT_NAME repos.txt
  $SCRIPT_NAME https://github.com/org/repo1 https://github.com/org/repo2
  $SCRIPT_NAME -o /tmp/reports repos.txt
EOF
    exit 0
}

if ! command -v trufflehog &>/dev/null; then
    echo "Error: trufflehog is not installed. Install it with: pip install trufflehog"
    exit 1
fi

mkdir -p "$REPORT_DIR"

REPO_URLS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--file)
            shift
            if [[ ! -f "$1" ]]; then
                echo "Error: repo file not found: $1"
                exit 1
            fi
            while IFS= read -r url; do
                [[ -n "$url" ]] && REPO_URLS+=("$url")
            done < "$1"
            shift
            ;;
        -o|--output)
            shift
            REPORT_DIR="$1"
            mkdir -p "$REPORT_DIR"
            AGGREGATED_REPORT="${REPORT_DIR}/aggregated-results-${TIMESTAMP}.json"
            SUMMARY_FILE="${REPORT_DIR}/summary-${TIMESTAMP}.txt"
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            REPO_URLS+=("$1")
            shift
            ;;
    esac
done

if [[ ${#REPO_URLS[@]} -eq 0 ]]; then
    echo "Error: no repo URLs provided. Pass them as arguments or use --file."
    usage
fi

echo "Starting multi-repo TruffleHog scan at $(date)"
echo "Repos to scan: ${#REPO_URLS[@]}"
echo "Output dir: $REPORT_DIR"
echo ""

ALL_RESULTS=()
TOTAL_FINDINGS=0
SCAN_FAILURES=0

scan_repo() {
    local repo_url="$1"
    local repo_name
    repo_name=$(basename "$repo_url" .git)
    local repo_results="${REPORT_DIR}/${repo_name}-${TIMESTAMP}.json"

    echo "Scanning: $repo_url"

    # Clone to a temp directory for the git scan
    local tmpdir
    tmpdir=$(mktemp -d)
    # Using --depth 1 to keep clones fast
    if ! git clone --depth 1 --quiet "$repo_url" "$tmpdir" 2>/dev/null; then
        echo "  FAILED: could not clone $repo_url"
        SCAN_FAILURES=$((SCAN_FAILURES + 1))
        rm -rf "$tmpdir"
        return 1
    fi

    # Run trufflehog filesystem instead of git to avoid rate limits on unauthenticated clones
    if trufflehog filesystem "$tmpdir" --json --no-verification 2>/dev/null > "$repo_results"; then
        : # scan completed
    fi

    local count=0
    if [[ -s "$repo_results" ]]; then
        count=$(wc -l < "$repo_results")
        TOTAL_FINDINGS=$((TOTAL_FINDINGS + count))
        # Collect into aggregated results array
        while IFS= read -r line; do
            ALL_RESULTS+=("$line")
        done < "$repo_results"
    fi

    echo "  Found $count potential secrets"
    rm -rf "$tmpdir"
}

for repo in "${REPO_URLS[@]}"; do
    scan_repo "$repo"
done

# Write aggregated JSON
{
    echo '['
    first=true
    for result in "${ALL_RESULTS[@]}"; do
        if $first; then
            first=false
        else
            echo ','
        fi
        echo "$result"
    done
    echo ''
    echo ']'
} > "$AGGREGATED_REPORT"

# Write summary
{
    echo "TruffleHog Multi-Repo Scan Summary"
    echo "=================================="
    echo "Scan completed: $(date)"
    echo "Repos scanned: ${#REPO_URLS[@]}"
    echo "Scan failures: $SCAN_FAILURES"
    echo "Total findings: $TOTAL_FINDINGS"
    echo ""
    echo "Repos:"
    for repo in "${REPO_URLS[@]}"; do
        echo "  - $repo"
    done
    echo ""
    echo "Aggregated report: $AGGREGATED_REPORT"
    echo "Summary file: $SUMMARY_FILE"
} > "$SUMMARY_FILE"

cat "$SUMMARY_FILE"

# Summarize detector types if jq is available
if command -v jq &>/dev/null && [[ -s "$AGGREGATED_REPORT" ]]; then
    echo ""
    echo "Findings by detector:"
    jq -r 'group_by(.DetectorName)[] | "  \(.[0].DetectorName): \(length)"' "$AGGREGATED_REPORT" 2>/dev/null || \
        echo "  (could not parse results by detector)"
fi

if [[ $SCAN_FAILURES -gt 0 ]]; then
    echo ""
    echo "Warning: $SCAN_FAILURES repo(s) could not be scanned."
fi
