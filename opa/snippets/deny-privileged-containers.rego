# last_verified: 2026-11-16 · OPA n/a
package k8s.pod_security

# Deny pods that run containers with privileged security context.
# The input shape matches a Kubernetes admission review object:
# { "containers": [{ "name": "...", "securityContext": {...} }] }

deny[msg] {
  container := input.containers[_]
  container.securityContext.privileged == true
  msg := sprintf("Container %v runs privileged — not allowed", [container.name])
}

deny[msg] {
  container := input.initContainers[_]
  container.securityContext.privileged == true
  msg := sprintf("Init container %v runs privileged — not allowed", [container.name])
}
