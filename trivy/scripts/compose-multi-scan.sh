#!/bin/sh
# Scan all container images used in a Docker Compose project with Trivy
# Aggregates per-image reports into a summary table
# Usage: ./compose-multi-scan.sh [project-dir] [output-dir]
#   project-dir  — directory containing docker-compose.yml (default: .)
#   output-dir   — where to save reports (default: ./trivy-compose-reports)

PROJECT_DIR="${1:-.}"
OUTDIR="${2:-./trivy-compose-reports}"
COMPOSE_FILE="$PROJECT_DIR/docker-compose.yml"

if [ ! -f "$COMPOSE_FILE" ]; then
  echo "[!] No docker-compose.yml found in $PROJECT_DIR"
  exit 1
fi

# Check that Trivy is installed
if ! command -v trivy >/dev/null 2>&1; then
  echo "[!] Trivy is not installed. See https://trivy.dev"
  exit 1
fi

mkdir -p "$OUTDIR"

# Extract image names from docker-compose.yml — handles both:
#   image: nginx:1.25         (direct image reference)
#   build: ./app + image: myapp:v1  (build with explicit image name)
# Uses awk to grab lines starting with 'image:'
IMAGES=$(awk -F': *' '/^[[:space:]]*image:/ {print $2}' "$COMPOSE_FILE" | tr -d '"' | tr -d "'" | sed 's/^[[:space:]]*//')

if [ -z "$IMAGES" ]; then
  echo "[!] No image: directives found in $COMPOSE_FILE"
  exit 1
fi

echo "[+] Found images in $COMPOSE_FILE:"
echo "$IMAGES" | nl -w2 -s') '
echo ""

TOTAL_CRIT=0
IMAGE_COUNT=0

for IMAGE in $IMAGES; do
  IMAGE_COUNT=$((IMAGE_COUNT + 1))
  SAFE_NAME=$(echo "$IMAGE" | tr '/:' '_')
  echo "[$IMAGE_COUNT] Scanning $IMAGE ..."

  # Table output for human review
  trivy image "$IMAGE" \
    --format table \
    --severity CRITICAL,HIGH,MEDIUM,LOW \
    --ignore-unfixed \
    --quiet \
    --output "$OUTDIR/${SAFE_NAME}-table.txt"
  T1_EXIT=$?

  # JSON output for aggregation
  trivy image "$IMAGE" \
    --format json \
    --severity CRITICAL,HIGH,MEDIUM \
    --quiet \
    --output "$OUTDIR/${SAFE_NAME}-vulns.json" 2>/dev/null
  T2_EXIT=$?

  if [ "$T1_EXIT" -ne 0 ] || [ "$T2_EXIT" -ne 0 ]; then
    echo "  [!] Trivy scan returned errors for $IMAGE (exit codes: $T1_EXIT, $T2_EXIT)"
    echo "  — some images (e.g. platform-specific) may not be scannable on this host"
    echo "  — continuing with remaining images"
    continue
  fi

  # Count CRITICAL vulnerabilities for this image
  CRIT_COUNT=$(jq '[.Results[]? | .Vulnerabilities[]? | select(.Severity == "CRITICAL")] | length' "$OUTDIR/${SAFE_NAME}-vulns.json" 2>/dev/null || echo 0)
  TOTAL_CRIT=$((TOTAL_CRIT + CRIT_COUNT))

  echo "  -> $CRIT_COUNT CRITICAL, report: $OUTDIR/${SAFE_NAME}-table.txt"
done

# Generate summary
SUMMARY="$OUTDIR/aggregated-summary.txt"
{
  echo "=== Aggregated Trivy Scan Summary ==="
  echo "Project  : $PROJECT_DIR"
  echo "Date     : $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  echo "Images   : $IMAGE_COUNT"
  echo "---"
  echo "Total CRITICAL vulnerabilities : $TOTAL_CRIT"
  echo ""
  echo "Per-image reports:"
  for IMAGE in $IMAGES; do
    SAFE_NAME=$(echo "$IMAGE" | tr '/:' '_')
    if [ -f "$OUTDIR/${SAFE_NAME}-table.txt" ]; then
      IMAGE_CRIT=$(jq '[.Results[]? | .Vulnerabilities[]? | select(.Severity == "CRITICAL")] | length' "$OUTDIR/${SAFE_NAME}-vulns.json" 2>/dev/null || echo 0)
      echo "  $IMAGE  —  $IMAGE_CRIT critical"
    else
      echo "  $IMAGE  —  (scan skipped or failed)"
    fi
  done
} > "$SUMMARY"

echo ""
echo "[+] Reports saved to $OUTDIR/"
echo "[+] Summary: $SUMMARY"
echo "[+] Total CRITICAL across all images: $TOTAL_CRIT"

if [ "$TOTAL_CRIT" -gt 0 ]; then
  echo "[!] Pipeline gate — $TOTAL_CRIT CRITICAL vulnerabilities found"
  exit 1
fi

exit 0
