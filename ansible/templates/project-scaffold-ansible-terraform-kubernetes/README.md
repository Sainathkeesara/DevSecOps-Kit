---
last_verified: 2026-10-27
tool_version: n/a
sources: []
---

# Project scaffold: Ansible + Terraform + Kubernetes

This is one way to combine infrastructure provisioning (Terraform), node
configuration (Ansible), and workload deployment (Kubernetes) in a single
scaffold. The docs also suggest splitting these into separate repos, but I
kept them together here to see how the pieces fit.

## Layout

- `terraform/` — VPC + cluster provisioning (includes a local VPC module)
- `ansible/` — node configuration and app rollout
- `kubernetes/` — base manifests + a dev overlay

## Usage

1. `cd terraform && terraform init && terraform apply`
2. `cd ../ansible && ansible-playbook site.yml`
3. `kubectl apply -k kubernetes/overlays/dev`

Note: the overlay only ships a dev target right now; staging and prod
overlays would follow the same pattern.
