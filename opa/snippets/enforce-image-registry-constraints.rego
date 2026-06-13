package k8s.allowed_registries

allowed_registries := {
  "docker.io/",
  "gcr.io/",
  "ghcr.io/",
  "registry.example.com/",
}

deny[msg] {
  container := input.containers[_]
  image := container.image
  not any_registry_match(image)
  msg := sprintf("Container %v uses image %v from an unapproved registry", [container.name, image])
}

deny[msg] {
  container := input.initContainers[_]
  image := container.image
  not any_registry_match(image)
  msg := sprintf("Init container %v uses image %v from an unapproved registry", [container.name, image])
}

any_registry_match(image) {
  allowed := allowed_registries[_]
  startswith(image, allowed)
}
