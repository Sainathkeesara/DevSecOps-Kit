#!/usr/bin/env bash
# last_verified: 2026-10-23 · bash 5.2

# CI/CD Pipeline Concepts: common patterns
# Personal scratch notes — patterns I keep reaching for when building pipelines

# ── Pattern 1: Build → Test → Package → Deploy stages ──

run_pipeline() {
  local repo_root="${1:-.}"
  local stage="${2:-all}"
  local environment="${3:-staging}"

  case "${stage}" in
    build)
      echo "=== BUILD STAGE ==="
      # Compile, lint, type-check
      make build 2>&1 | tee build.log
      ;;
    test)
      echo "=== TEST STAGE ==="
      # Unit + integration tests with coverage gate
      make test COVERAGE_THRESHOLD=80 2>&1 | tee test.log
      ;;
    package)
      echo "=== PACKAGE STAGE ==="
      # Container image, SBOM, provenance
      docker build -t "myapp:${GIT_SHA:-dev}" .
      syft "myapp:${GIT_SHA:-dev}" -o spdx-json > sbom.spdx.json
      cosign sign --yes "myapp:${GIT_SHA:-dev}"
      ;;
    deploy)
      echo "=== DEPLOY STAGE ==="
      # GitOps-style: update manifests, ArgoCD picks up
      kustomize build "overlays/${environment}" | kubectl apply -f -
      ;;
    all)
      run_pipeline "${repo_root}" build "${environment}"
      run_pipeline "${repo_root}" test "${environment}"
      run_pipeline "${repo_root}" package "${environment}"
      run_pipeline "${repo_root}" deploy "${environment}"
      ;;
    *)
      echo "Unknown stage: ${stage}" >&2
      return 1
      ;;
  esac
}

# ── Pattern 2: Artifact promotion between environments ──

promote_artifact() {
  local artifact_tag="${1}"
  local _from_env="${2}"  # kept for signature compatibility; not used in this snippet
  local to_env="${3}"

  # Verify artifact exists in source registry
  if ! crane manifest "${artifact_tag}" >/dev/null 2>&1; then
    echo "Artifact ${artifact_tag} not found in registry" >&2
    return 1
  fi

  # Tag for target environment (immutable promotion)
  local promoted_tag="${artifact_tag%-*}-${to_env}"
  crane tag "${artifact_tag}" "${promoted_tag}"

  # Update GitOps repo with new image tag
  cd "/tmp/gitops-${to_env}" || return 1
  yq eval ".spec.template.spec.containers[0].image = \"${promoted_tag}\"" -i "k8s/deployment.yaml"
  git commit -am "Promote ${artifact_tag} to ${to_env}"
  git push
}

# ── Pattern 3: Pipeline gate with manual approval ──

require_approval() {
  local environment="${1}"
  local approvers="${2:-platform-team}"

  if [[ "${environment}" == "prod" ]]; then
    echo "=== PROD DEPLOYMENT REQUIRES APPROVAL ==="
    echo "Approvers: ${approvers}"
    echo "Run: gh api /repos/{owner}/{repo}/deployments/{id}/approvals --method POST"
    read -rp "Approval granted? [y/N] " confirm
    [[ "${confirm,,}" == "y" ]] || { echo "Deployment cancelled"; return 1; }
  fi
}

# ── Pattern 4: Rollback on health check failure ──

deploy_with_rollback() {
  local namespace="${1}"
  local deployment="${2}"
  local timeout="${3:-300}"

  # Record current revision for potential rollback
  local previous_revision
  previous_revision=$(kubectl rollout history "deployment/${deployment}" -n "${namespace}" --revision=0 -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}')

  # Apply new version
  kubectl rollout restart "deployment/${deployment}" -n "${namespace}"

  # Wait for rollout with timeout
  if ! kubectl rollout status "deployment/${deployment}" -n "${namespace}" --timeout="${timeout}s"; then
    echo "Rollout failed — rolling back to revision ${previous_revision}"
    kubectl rollout undo "deployment/${deployment}" -n "${namespace}" --to-revision="${previous_revision}"
    kubectl rollout status "deployment/${deployment}" -n "${namespace}" --timeout="${timeout}s"
    return 1
  fi

  # Post-deploy health check
  sleep 10
  local desired_replicas
  desired_replicas=$(kubectl get "deployment/${deployment}" -n "${namespace}" -o jsonpath='{.spec.replicas}')
  local ready_replicas
  ready_replicas=$(kubectl get "deployment/${deployment}" -n "${namespace}" -o jsonpath='{.status.readyReplicas}')
  if [[ "${ready_replicas}" != "${desired_replicas}" ]]; then
    echo "Health check failed — rolling back"
    kubectl rollout undo "deployment/${deployment}" -n "${namespace}" --to-revision="${previous_revision}"
    return 1
  fi

  echo "Deployment healthy"
}

# ── Pattern 5: Matrix build for multi-arch / multi-env ──

matrix_build() {
  local arches=("amd64" "arm64")
  local envs=("staging" "prod")

  for arch in "${arches[@]}"; do
    for env in "${envs[@]}"; do
      echo "Building for ${arch}/${env}"
      docker buildx build \
        --platform "linux/${arch}" \
        --build-arg "ENVIRONMENT=${env}" \
        -t "myapp:${GIT_SHA}-${arch}-${env}" \
        --push .
    done
  done
}

# ── Usage example ──

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  # Demo: run full pipeline for staging
  run_pipeline "." all
  # promote_artifact "myapp:abc123" "staging" "prod"
  # deploy_with_rollback "staging" "myapp"
fi

# What I'd try next:
# - Add policy-as-code gate (OPA/Checkov) between test and package
# - Implement canary deployment pattern with Istio/Flagger
# - Wire up DefectDojo for unified vulnerability findings across stages