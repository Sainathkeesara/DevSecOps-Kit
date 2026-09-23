#!/usr/bin/env bash
# last_verified: 2026-09-23 · docker 27.3.1

# Purpose: reusable Docker image build script for the DevSecOps-Kit.
# Supports single and multi-stage builds, build arguments, cache-from,
# multi-tag output (latest, git-sha, semver), and optional registry push.
#
# When to use
# - Building kit Docker images locally or in CI.
# - Needing consistent tagging and cache behavior across projects.
#
# Prerequisites
# - Docker engine 20.10+ with BuildKit enabled (DOCKER_BUILDKIT=1).
# - Git repository for sha-based tagging.
# - For registry push: authenticated docker login to target registry.

set -euo pipefail

# --- Configuration defaults ---
BUILD_CONTEXT="."
DOCKERFILE="Dockerfile"
IMAGE_NAME=""
REGISTRY=""
TAG_LATEST="true"
TAG_GIT_SHA="true"
TAG_SEMVER=""
CACHE_FROM=""
BUILD_ARGS=()
TARGET_STAGE=""
PLATFORM=""
PUSH="false"
LOAD="true"
QUIET="false"
VERBOSE="false"

# --- Helper functions ---
log() {
    local level="$1"
    shift
    local msg="$*"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    if [ "$level" = "ERROR" ] || [ "$QUIET" != "true" ]; then
        echo "[$timestamp] [$level] $msg" >&2
    fi
}

usage() {
    cat <<'USAGE'
Usage: reusable-build.sh [OPTIONS]

Build a Docker image with consistent tagging and caching for the DevSecOps-Kit.

Options:
  -c, --context PATH       Build context path (default: .)
  -f, --file PATH          Dockerfile path relative to context (default: Dockerfile)
  -n, --name NAME          Image name (required, e.g. myapp or myorg/myapp)
  -r, --registry REGISTRY  Registry hostname (e.g. ghcr.io, docker.io)
  -t, --tag-semver VER     Additional semantic version tag (e.g. 1.2.3)
  --no-latest              Disable 'latest' tag
  --no-git-sha             Disable git SHA tag
  --cache-from IMAGE       Use image as cache source (can repeat)
  --build-arg KEY=VALUE    Build argument (can repeat)
  --target STAGE           Target build stage for multi-stage Dockerfile
  --platform PLATFORM      Target platform (e.g. linux/amd64,linux/arm64)
  --push                   Push tags to registry after build
  --no-load                Do not load image into local daemon (for multi-platform)
  -q, --quiet              Suppress non-error output
  -v, --verbose            Enable verbose build output
  -h, --help               Show this help

Examples:
  # Build and tag locally
  reusable-build.sh -n myapp -c . -f Dockerfile

  # Build with cache from registry, push multi-arch
  reusable-build.sh -n myorg/myapp -r ghcr.io --cache-from ghcr.io/myorg/myapp:cache \
    --platform linux/amd64,linux/arm64 --push --no-load

  # Build specific target with build args
  reusable-build.sh -n myapp --target builder --build-arg BUILDKIT_INLINE_CACHE=1
USAGE
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--context)
                BUILD_CONTEXT="$2"
                shift 2
                ;;
            -f|--file)
                DOCKERFILE="$2"
                shift 2
                ;;
            -n|--name)
                IMAGE_NAME="$2"
                shift 2
                ;;
            -r|--registry)
                REGISTRY="$2"
                shift 2
                ;;
            -t|--tag-semver)
                TAG_SEMVER="$2"
                shift 2
                ;;
            --no-latest)
                TAG_LATEST="false"
                shift
                ;;
            --no-git-sha)
                TAG_GIT_SHA="false"
                shift
                ;;
            --cache-from)
                CACHE_FROM="${CACHE_FROM} $2"
                shift 2
                ;;
            --build-arg)
                BUILD_ARGS+=("$2")
                shift 2
                ;;
            --target)
                TARGET_STAGE="$2"
                shift 2
                ;;
            --platform)
                PLATFORM="$2"
                shift 2
                ;;
            --push)
                PUSH="true"
                shift
                ;;
            --no-load)
                LOAD="false"
                shift
                ;;
            -q|--quiet)
                QUIET="true"
                shift
                ;;
            -v|--verbose)
                VERBOSE="true"
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                log ERROR "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    if [ -z "$IMAGE_NAME" ]; then
        log ERROR "Image name is required (-n/--name)"
        usage
        exit 1
    fi

    if [ ! -d "$BUILD_CONTEXT" ]; then
        log ERROR "Build context directory does not exist: $BUILD_CONTEXT"
        exit 1
    fi

    if [ ! -f "$BUILD_CONTEXT/$DOCKERFILE" ]; then
        log ERROR "Dockerfile not found: $BUILD_CONTEXT/$DOCKERFILE"
        exit 1
    fi
}

resolve_tags() {
    local tags=()
    local base_name="$IMAGE_NAME"

    if [ -n "$REGISTRY" ]; then
        base_name="${REGISTRY}/${IMAGE_NAME}"
    fi

    if [ "$TAG_LATEST" = "true" ]; then
        tags+=("${base_name}:latest")
    fi

    if [ "$TAG_GIT_SHA" = "true" ]; then
        local git_sha
        if git_sha=$(git -C "$BUILD_CONTEXT" rev-parse --short HEAD 2>/dev/null); then
            tags+=("${base_name}:${git_sha}")
        else
            log WARN "Not a git repository or git unavailable; skipping git-sha tag"
        fi
    fi

    if [ -n "$TAG_SEMVER" ]; then
        tags+=("${base_name}:${TAG_SEMVER}")
    fi

    printf '%s\n' "${tags[@]}"
}

build_image() {
    local tags=("$@")
    local cache_args=()
    local build_arg_flags=()
    local target_flag=()
    local platform_flag=()
    local output_flags=()

    for cache in $CACHE_FROM; do
        cache_args+=("--cache-from" "$cache")
    done

    for arg in "${BUILD_ARGS[@]}"; do
        build_arg_flags+=("--build-arg" "$arg")
    done

    if [ -n "$TARGET_STAGE" ]; then
        target_flag=("--target" "$TARGET_STAGE")
    fi

    if [ -n "$PLATFORM" ]; then
        platform_flag=("--platform" "$PLATFORM")
    fi

    if [ "$LOAD" = "true" ] && [ "$PUSH" = "false" ]; then
        output_flags=("--load")
    elif [ "$PUSH" = "true" ]; then
        output_flags=("--push")
    else
        output_flags=("--output" "type=docker,dest=-")
    fi

    local primary_tag="${tags[0]}"
    local tag_flags=()
    for tag in "${tags[@]}"; do
        tag_flags+=("-t" "$tag")
    done

    log INFO "Building image: $primary_tag"
    [ "$VERBOSE" = "true" ] && log INFO "Context: $BUILD_CONTEXT"
    [ "$VERBOSE" = "true" ] && log INFO "Dockerfile: $DOCKERFILE"
    [ "$VERBOSE" = "true" ] && log INFO "Tags: ${tags[*]}"
    [ "$VERBOSE" = "true" ] && [ ${#cache_args[@]} -gt 0 ] && log INFO "Cache from: ${cache_args[*]}"
    [ "$VERBOSE" = "true" ] && [ ${#build_arg_flags[@]} -gt 0 ] && log INFO "Build args: ${build_arg_flags[*]}"

    DOCKER_BUILDKIT=1 docker build \
        "${cache_args[@]}" \
        "${build_arg_flags[@]}" \
        "${target_flag[@]}" \
        "${platform_flag[@]}" \
        "${output_flags[@]}" \
        "${tag_flags[@]}" \
        -f "$DOCKERFILE" \
        "$BUILD_CONTEXT"
}

verify_image() {
    local tags=("$@")

    log INFO "Verifying built image(s)..."
    for tag in "${tags[@]}"; do
        if docker image inspect "$tag" >/dev/null 2>&1; then
            local size
            size=$(docker image inspect "$tag" --format '{{.Size}}' 2>/dev/null || echo "unknown")
            log INFO "  ✓ $tag (${size} bytes)"
        else
            log WARN "  ✗ $tag not found in local daemon (may have been pushed only)"
        fi
    done
}

main() {
    parse_args "$@"

    local tags
    mapfile -t tags < <(resolve_tags)

    if [ ${#tags[@]} -eq 0 ]; then
        log ERROR "No tags resolved; at least one tag strategy must be enabled"
        exit 1
    fi

    log INFO "Starting build for ${tags[0]}"

    if ! build_image "${tags[@]}"; then
        log ERROR "Build failed"
        exit 1
    fi

    if [ "$LOAD" = "true" ] && [ "$PUSH" = "false" ]; then
        verify_image "${tags[@]}"
    fi

    log INFO "Build completed successfully"
    for tag in "${tags[@]}"; do
        echo "$tag"
    done
}

main "$@"