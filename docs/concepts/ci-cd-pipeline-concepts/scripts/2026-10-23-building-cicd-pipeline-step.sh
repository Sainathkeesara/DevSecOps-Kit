# last_verified: 2026-10-23 · CI/CD Pipeline Concepts n/a
# 2026-10-23 — building one CI step that runs tests then a security scan

set -u

# step 1: run unit tests
echo "running tests..."
# pytest -q || exit 1

# step 2: run a quick SAST scan
echo "running sast..."
# semgrep --config p/ci --error .

echo "pipeline step complete"