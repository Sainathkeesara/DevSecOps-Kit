# last_verified: 2026-08-27 · OPA Gatekeeper

package k8s.security_baseline

deny[msg] {
  input.review.object.spec.hostNetwork == true
  msg := "Pod uses hostNetwork -- not allowed"
}
