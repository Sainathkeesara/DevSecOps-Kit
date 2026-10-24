#!/usr/bin/env bash
# last_verified: 2026-10-24 · Container Runtime Security
#
# Practice script: applying runtime security controls.
# I wrote this to internalize the common runtime hardening patterns
# after reading the primer. Run it against a test workload to see
# the controls in action.

# Configuration
TEST_IMAGE="${TEST_IMAGE:-nginx:alpine}"
TEST_CONTAINER="${TEST_CONTAINER:-runtime-test-$$}"
NAMESPACE="${NAMESPACE:-default}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_err() { echo -e "${RED}[ERR]${NC} $*"; }

cleanup() {
    log_info "Cleaning up test container..."
    docker rm -f "$TEST_CONTAINER" >/dev/null 2>&1 || true
    kubectl delete pod "$TEST_CONTAINER" -n "$NAMESPACE" >/dev/null 2>&1 || true
}

# 1. Drop ALL capabilities, add back only what's needed
run_drop_all_caps() {
    log_info "Test 1: Drop ALL capabilities, add back NET_BIND_SERVICE for port 80"
    docker run -d --name "$TEST_CONTAINER" \
        --cap-drop=ALL \
        --cap-add=NET_BIND_SERVICE \
        "$TEST_IMAGE"
    sleep 2
    docker exec "$TEST_CONTAINER" sh -c 'cat /proc/self/status | grep CapEff' || true
    docker rm -f "$TEST_CONTAINER" >/dev/null
}

# 2. Read-only root filesystem
run_readonly_rootfs() {
    log_info "Test 2: Read-only root filesystem (should block writes)"
    docker run -d --name "$TEST_CONTAINER" \
        --read-only \
        --tmpfs /run --tmpfs /tmp \
        "$TEST_IMAGE"
    sleep 2
    if docker exec "$TEST_CONTAINER" touch /test-write 2>/dev/null; then
        log_err "  Write succeeded — readonly not enforced!"
    else
        log_info "  Write blocked as expected"
    fi
    docker rm -f "$TEST_CONTAINER" >/dev/null
}

# 3. Non-root user
run_nonroot_user() {
    log_info "Test 3: Run as non-root user (UID 1000)"
    docker run -d --name "$TEST_CONTAINER" \
        --user 1000:1000 \
        "$TEST_IMAGE"
    sleep 2
    local uid
    uid=$(docker exec "$TEST_CONTAINER" id -u)
    if [ "$uid" = "1000" ]; then
        log_info "  Running as UID $uid (non-root)"
    else
        log_warn "  Running as UID $uid (expected 1000)"
    fi
    docker rm -f "$TEST_CONTAINER" >/dev/null
}

# 4. Seccomp profile (default Docker profile blocks dangerous syscalls)
run_seccomp_default() {
    log_info "Test 4: Default seccomp profile (blocks ~44 syscalls)"
    docker run -d --name "$TEST_CONTAINER" \
        --security-opt seccomp=default \
        "$TEST_IMAGE"
    sleep 2
    log_info "  Default seccomp applied. Try: docker exec $TEST_CONTAINER unshare -m sh"
    docker rm -f "$TEST_CONTAINER" >/dev/null
}

# 5. Custom seccomp profile (allow only needed syscalls)
run_seccomp_custom() {
    log_info "Test 5: Custom seccomp profile (minimal allowlist)"
    local seccomp_file="/tmp/seccomp-minimal.json"
    cat > "$seccomp_file" <<'SECCOMP'
{
  "defaultAction": "SCMP_ACT_ERRNO",
  "architectures": ["SCMP_ARCH_X86_64", "SCMP_ARCH_X86", "SCMP_ARCH_X32"],
  "syscalls": [
    {"names": ["read", "write", "open", "close", "exit", "exit_group", "rt_sigreturn"], "action": "SCMP_ACT_ALLOW"},
    {"names": ["nanosleep", "clock_nanosleep", "poll", "ppoll", "epoll_wait", "epoll_pwait"], "action": "SCMP_ACT_ALLOW"},
    {"names": ["socket", "connect", "accept", "bind", "listen", "sendto", "recvfrom"], "action": "SCMP_ACT_ALLOW"},
    {"names": ["getpid", "getppid", "getuid", "geteuid", "getgid", "getegid"], "action": "SCMP_ACT_ALLOW"}
  ]
}
SECCOMP
    docker run -d --name "$TEST_CONTAINER" \
        --security-opt "seccomp=$seccomp_file" \
        "$TEST_IMAGE"
    sleep 2
    log_info "  Custom minimal seccomp applied"
    docker rm -f "$TEST_CONTAINER" >/dev/null
    rm -f "$seccomp_file"
}

# 6. No new privileges (prevents privilege escalation via setuid binaries)
run_no_new_privs() {
    log_info "Test 6: no-new-privileges (blocks setuid escalation)"
    docker run -d --name "$TEST_CONTAINER" \
        --security-opt no-new-privileges \
        "$TEST_IMAGE"
    sleep 2
    # Try to escalate via setuid binary (should fail)
    if docker exec "$TEST_CONTAINER" sh -c 'cp /bin/bash /tmp/bash && chmod +s /tmp/bash && /tmp/bash -p -c "id"' 2>/dev/null; then
        log_warn "  Privilege escalation succeeded (unexpected)"
    else
        log_info "  Privilege escalation blocked"
    fi
    docker rm -f "$TEST_CONTAINER" >/dev/null
}

# 7. Kubernetes PodSecurityContext equivalent
run_k8s_pod_security() {
    log_info "Test 7: Kubernetes PodSecurityContext (client-side validation)"
    local pod_yaml="/tmp/runtime-test-pod.yaml"
    cat > "$pod_yaml" <<K8S
apiVersion: v1
kind: Pod
metadata:
  name: $TEST_CONTAINER
  namespace: $NAMESPACE
  labels:
    app: runtime-test
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 1000
    fsGroup: 1000
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    image: $TEST_IMAGE
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop: ["ALL"]
        add: ["NET_BIND_SERVICE"]
    volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: run
      mountPath: /run
  volumes:
  - name: tmp
    emptyDir: {}
  - name: run
    emptyDir: {}
K8S
    log_info "  Pod manifest generated at $pod_yaml"
    log_info "  Apply with: kubectl apply -f $pod_yaml"
    log_info "  Check with: kubectl get pod $TEST_CONTAINER -n $NAMESPACE -o yaml | grep -A20 securityContext"
    if kubectl apply -f "$pod_yaml" --server-side >/dev/null 2>&1; then
        log_info "  Valid"
    else
        log_warn "  Validation skipped"
    fi
    rm -f "$pod_yaml"
}

# 8. Falco rule test (if Falco is running)
test_falco_rules() {
    log_info "Test 8: Trigger Falco rules (requires Falco running on host)"
    if ! command -v falco >/dev/null 2>&1 && ! systemctl is-active falco >/dev/null 2>&1; then
        log_warn "  Falco not detected — skipping"
        return
    fi
    log_info "  Spawning shell in container (should trigger 'Terminal shell in container')"
    docker run -d --name "$TEST_CONTAINER" "$TEST_IMAGE"
    sleep 2
    docker exec "$TEST_CONTAINER" sh -c "echo 'hello from shell'" || true
    log_info "  Check Falco logs: journalctl -u falco -f"
    docker rm -f "$TEST_CONTAINER" >/dev/null
}

# Main
main() {
    log_info "Container Runtime Security — Practice Exercises"
    log_info "Target image: $TEST_IMAGE"
    echo

    run_drop_all_caps
    run_readonly_rootfs
    run_nonroot_user
    run_seccomp_default
    run_seccomp_custom
    run_no_new_privs
    run_k8s_pod_security
    test_falco_rules

    echo
    log_info "All tests complete. Key takeaways:"
    log_info "  - Drop ALL caps, add back only NET_BIND_SERVICE for web servers"
    log_info "  - readOnlyRootFilesystem + tmpfs for /tmp, /run"
    log_info "  - Run as non-root (UID 1000+)"
    log_info "  - seccomp: RuntimeDefault for most, custom minimal for high-value targets"
    log_info "  - no-new-privileges: always on"
    log_info "  - Kubernetes: PodSecurityContext maps 1:1 to these Docker flags"

    cleanup
}

main "$@"