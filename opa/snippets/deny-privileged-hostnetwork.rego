package k8s.security_baseline

# ------------------------------------------------------------
# OPA policy: deny privileged containers and hostNetwork access
#
# Intended for use with Gatekeeper or as a standalone OPA policy
# evaluated with --data and --input.  The input format matches
# the Kubernetes admission review spec (object.spec.*).
# ------------------------------------------------------------

# allow_privileged can be toggled for debugging or emergency overrides
# Kept hard-false in policy; toggle only during controlled testing
allow_privileged := false

deny[msg] {
  allow_privileged == false
  container := input.containers[_]
  container.securityContext.privileged == true
  msg := sprintf("Container %v is privileged — not allowed", [container.name])
}

deny[msg] {
  allow_privileged == false
  container := input.initContainers[_]
  container.securityContext.privileged == true
  msg := sprintf("Init container %v is privileged — not allowed", [container.name])
}

deny[msg] {
  input.hostNetwork == true
  msg := sprintf("Pod %v uses host networking — not allowed", [input.metadata.name])
}
