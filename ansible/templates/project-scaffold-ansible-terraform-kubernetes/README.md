---
last_verified: 2026-10-27
tool_version: n/a
sources: []
---

# Project scaffold: Ansible + Terraform + Kubernetes

L4 reference scaffold combining infrastructure provisioning (Terraform),
configuration management (Ansible), and workload deployment (Kubernetes).

## Layout

- `terraform/` — VPC + cluster provisioning
- `ansible/` — node configuration and app rollout
- `kubernetes/` — base manifests + per-environment overlays

## Usage

1. `cd terraform && terraform init && terraform apply`
2. `cd ../ansible && ansible-playbook site.yml`
3. `kubectl apply -k kubernetes/overlays/dev`
