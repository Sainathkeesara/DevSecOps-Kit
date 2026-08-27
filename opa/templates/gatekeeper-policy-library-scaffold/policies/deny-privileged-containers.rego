# last_verified: 2026-08-27 · OPA Gatekeeper

package k8s.security_baseline

deny[msg] {
  container := input.review.object.spec.containers[_]
  container.securityContext.privileged == true
  msg := sprintf("Container %v is privileged -- not allowed", [container.name])
}
