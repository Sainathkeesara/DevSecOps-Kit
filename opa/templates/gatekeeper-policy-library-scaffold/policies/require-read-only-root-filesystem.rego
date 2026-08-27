# last_verified: 2026-08-27 · OPA Gatekeeper

package k8s.security_baseline

deny[msg] {
  container := input.review.object.spec.containers[_]
  not container.securityContext.readOnlyRootFilesystem == true
  msg := sprintf("Container %v must set readOnlyRootFilesystem=true", [container.name])
}
