# last_verified: 2026-08-27 · OPA Gatekeeper

package k8s.allowed_registries

default allowed = ["docker.io", "gcr.io", "quay.io"]

allowed_registries := input.parameters.allowedRegistries {
  input.parameters.allowedRegistries
} else := allowed

registry(img) = r {
  parts := split(img, "/")
  r := parts[0]
}

deny[msg] {
  container := input.review.object.spec.containers[_]
  img := container.image
  reg := registry(img)
  not reg == allowed_registries[_]
  msg := sprintf("Image %v uses unapproved registry %v", [img, reg])
}
