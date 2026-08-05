---
last_verified: 2026-08-05
tool_version: n/a
---

# Dockerfile optimization patterns for CI

## Purpose

CI pipelines rebuild Docker images on every commit, so each layer that can be cached saves time and compute cost. One approach that tends to work well is ordering instructions so the cache stays hot, and another is using multi-stage builds to keep the final image lean. This guide covers both patterns and the trade-offs I've noticed when using them in CI.

## When to use

Use these patterns when:
- The same base image is reused across many builds.
- Build times exceed a few minutes and caching is not already effective.
- Security policy requires minimal attack surface in production images.

## Prerequisites

- A Dockerfile that builds successfully locally.
- A CI runner with Docker engine access.
- Familiarity with `docker build` and basic image commands.

## Steps

### 1. Order layers from least to most volatile

Docker caches each layer independently. If a layer changes, every layer after it is rebuilt. Place package installation and dependency setup before copying application source.

```dockerfile
FROM python:3.12-slim
WORKDIR /app

# Install dependencies first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source last
COPY . .
CMD ["python", "main.py"]
```

This way, edits to `main.py` do not invalidate the `pip install` layer.

### 2. Combine related commands

Each `RUN` instruction creates a layer. Consolidating commands reduces layer count and intermediate image size. Use shell `&&` to chain commands within a single `RUN`.

```dockerfile
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*
```

### 3. Use multi-stage builds to strip build-time dependencies

A multi-stage build uses one stage to compile or install dependencies and a second, minimal stage to run the application. Only the final stage is packaged.

```dockerfile
# Build stage
FROM python:3.12-slim AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Runtime stage
FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /install /usr/local
COPY main.py .
CMD ["python", "main.py"]
```

The runtime stage does not contain the compiler, headers, or build cache.

## Verify

Run `docker build` and inspect the image size. A well-ordered single-stage image should show cache hits on dependency layers after a source-only change. A multi-stage image should be noticeably smaller than the build stage.

```bash
docker build -t ci-optimized .
docker images ci-optimized
```

If `pip install` or `apt-get install` reruns on every build, the layer above it is changing. Move those instructions higher in the Dockerfile or verify that the copied files are actually stable.
