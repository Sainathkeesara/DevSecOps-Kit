# Trivy Cache Configuration for Accelerated Repeated Scans

---
SQUIRREL:
  title: "Trivy Cache Configuration"
  category: "trivy"
  tags: ["trivy", "cache", "performance", "ci-cd", "optimization"]
  last_verified: "2026-05-10"
  version: "Trivy 0.57+"
---

## Purpose

This guide provides steps to configure Trivy cache for accelerated repeated vulnerability scans. Caching vulnerability database and layer scanning results reduces scan time significantly in CI/CD pipelines with frequent builds.

## When to use

- CI/CD pipelines with frequent image builds
- Repeated scans of similar images or codebases
- Performance optimization for security scanning
- Reducing pipeline execution time for Trivy scans

## Prerequisites

- Trivy installed (version 0.57+ recommended)
- CI/CD environment with persistent cache storage
- Understanding of Trivy cache directory structure
- Sufficient disk space for cache storage (~500MB+ for vulnerability database)

---

## Cache Types

Trivy maintains two types of cache:

| Cache Type | Purpose | Location |
|------------|---------|----------|
| Vulnerability DB | CVE definitions | `~/.cache/trivy/db/` |
| Image Layers | Scanned layer results | `~/.cache/trivy/` |

---

## Cache Directory Configuration

### Custom Cache Path

```bash
# Set custom cache directory
export TRIVY_CACHE_DIR=/var/cache/trivy

# Or use CLI flag
trivy image --cache-dir /var/cache/trivy myapp:latest
```

### CI/CD Pipeline Configuration

#### GitHub Actions

```yaml
name: Cached Trivy Scan

on:
  push:
    branches: [main]

jobs:
  trivy-scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Cache Trivy DB
        uses: actions/cache@v4
        with:
          path: ~/.cache/trivy
          key: trivy-${{ runner.os }}-${{ hashFiles('**/go.sum', '**/package-lock.json') }}

      - name: Build Image
        run: docker build -t myapp:${{ github.sha }} .

      - name: Trivy Scan with Cache
        env:
          TRIVY_CACHE_DIR: ~/.cache/trivy
        run: |
          trivy image --severity HIGH,CRITICAL myapp:${{ github.sha }}
```

#### GitLab CI

```yaml
variables:
  TRIVY_CACHE_DIR: "$CI_PROJECT_DIR/.trivy-cache"

cache:
  key: trivy-cache
  paths:
    - .trivy-cache/

stages:
  - build
  - security

trivy-scan:
  stage: security
  image: aquasec/trivy:latest
  script:
    - trivy image --cache-dir $TRIVY_CACHE_DIR --severity HIGH,CRITICAL $IMAGE_NAME
```

---

## Cache Optimization Strategies

### Persistent Cache in CI

```yaml
# Docker-based CI with mounted volume
services:
  - name: trivy-cache
    image: alpine
    volumes:
      - trivy-cache-volume:/var/cache/trivy

volumes:
  trivy-cache-volume:
```

### Layer Caching

```bash
# When using Docker, layers are cached automatically
# Build image with same base to benefit from layer cache
FROM alpine:3.19  # Pin version for better caching

# Trivy caches layer scanning results
# Similar images will skip re-scanning identical layers
```

### Database Pre-warming

```bash
#!/usr/bin/env bash
# prewarm-trivy-cache.sh - Download vulnerability database in advance

set -euo pipefail

CACHE_DIR="${TRIVY_CACHE_DIR:-/tmp/trivy-cache}"

echo "Pre-warming Trivy cache..."

# Download vulnerability database only
trivy image --download-db-only --cache-dir "$CACHE_DIR"

# Download Java database if needed
trivy image --download-java-db-only --cache-dir "$CACHE_DIR" || true

# Verify cache contents
echo "Cache contents:"
ls -la "$CACHE_DIR/db/"

echo "Cache pre-warmed successfully"
```

---

## Performance Comparison

### Without Cache

```bash
# First scan - downloads database, scans all layers
time trivy image --cache-dir /tmp/fresh myapp:latest
# real    1m30s
```

### With Cache

```bash
# Second scan - uses cached database and layer results
time trivy image --cache-dir ~/.cache/trivy myapp:latest
# real    0m15s
```

---

## Cache Management

### Cleanup Old Cache

```bash
# Remove cache older than 7 days
find ~/.cache/trivy -type f -mtime +7 -delete

# Clear entire cache
rm -rf ~/.cache/trivy

# Trivy built-in cleanup
trivy image --reset
```

### Cache Size Optimization

```bash
# Check cache size
du -sh ~/.cache/trivy

# Limit cache size (example script)
#!/usr/bin/env bash
MAX_SIZE_GB=2
CURRENT_SIZE=$(du -sm ~/.cache/trivy | cut -f1)

if [[ $CURRENT_SIZE -gt $((MAX_SIZE_GB * 1024)) ]]; then
    echo "Cache size ($CURRENT_SIZE MB) exceeds limit, cleaning..."
    find ~/.cache/trivy -type f -mtime +1 -delete
fi
```

---

## CI/CD Implementation Patterns

### GitHub Actions - Advanced Caching

```yaml
name: Optimized Trivy Scan

on:
  push:
    branches: [main]

jobs:
  trivy-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Cache Trivy DB and Layers
        uses: actions/cache@v4
        with:
          path: |
            ~/.cache/trivy/db
            ~/.cache/trivy/repositories
          key: trivy-${{ runner.os }}-${{ github.sha }}
          restore-keys: |
            trivy-${{ runner.os }}-

      - name: Build
        run: docker build -t app:${{ github.sha }} .

      - name: Parallel Scan
        run: |
          trivy image --scanners vuln,config --severity HIGH,CRITICAL app:${{ github.sha }}
```

### Kubernetes - Shared Cache Volume

```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: trivy-scanner
    image: aquasec/trivy:latest
    env:
    - name: TRIVY_CACHE_DIR
      value: /shared/trivy-cache
    volumeMounts:
    - name: trivy-cache
      mountPath: /shared/trivy-cache
  volumes:
  - name: trivy-cache
    persistentVolumeClaim:
      claimName: trivy-cache-pvc
```

---

## Verification

### Verify Cache is Working

```bash
# Check cache directory
ls -la ~/.cache/trivy/

# Check database exists
ls -la ~/.cache/trivy/db/

# Monitor cache hits
TRIVY_DEBUG=1 trivy image myapp:latest 2>&1 | grep -i cache
```

### Test Cache Performance

```bash
# Clear cache first
rm -rf ~/.cache/trivy

# First scan - should be slow
time trivy image alpine:latest

# Second scan - should be fast
time trivy image alpine:latest
```

---

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `cache db not found` | Cache cleared or not initialized | Run `trivy image --download-db-only` |
| `permission denied` | Insufficient permissions on cache dir | Check directory permissions |
| `slow scans` | Cache not persisted between runs | Configure persistent cache in CI |
| `cache size too large` | No cleanup policy | Implement cache age/size limits |

---

## References

- [Trivy Cache Documentation](https://aquasecurity.github.io/trivy/docs/advanced/cache/)
- [Trivy Performance Tuning](https://aquasecurity.github.io/trivy/docs/advanced/performance/)
- [GitHub Actions Cache](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows)