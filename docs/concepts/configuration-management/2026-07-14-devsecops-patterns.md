---
last_verified: 2026-07-14
tool_version: n/a
sources:
  - https://www.articsledge.com/post/configuration-management
  - https://aws.amazon.com/what-is/configuration-management/
  - https://adevguide.com/what-is-configuration-management/
---

# Configuration Management in DevSecOps — what I've figured out so far

I've been practicing with Ansible playbooks and reading about how CM fits into DevSecOps. Here's what I've noticed about the common patterns.

## Why CM matters for security

The big realization for me was that security scanning is unreliable if you don't know what state your systems are in. If a server has drifted from its baseline — maybe someone manually installed a different nginx version or left a debug port open — then your Trivy scan report is misleading. Configuration management closes that gap by making the target state predictable.

## Patterns I've seen

**Desired state as source of truth.** You write the config you want (YAML, HCL, whatever), check it into Git, and the CM tool reconciles the actual system against it. Ansible calls this "playbooks," Terraform calls it "configuration." Same idea.

**Idempotency is non-negotiable.** Running the same playbook ten times should produce the same result as running it once. I hit this early: my first Ansible playbook would append firewall rules every run instead of replacing them. That's the opposite of idempotent.

**Pull vs push.** Ansible uses a push model (SSH from a control node), while Puppet uses a pull model (agents poll a server). For DevSecOps I've mostly used push — it's simpler to integrate into CI pipelines where a runner kicks off the playbook after a Terraform apply.

**GitOps for drift detection.** ArgoCD or Flux continuously compare the cluster state to what's in Git. If someone `kubectl edit`s a deployment directly, the GitOps controller reverts it. This is CM applied to Kubernetes, and it pairs well with policy engines like OPA/Gatekeeper that validate the config before it lands.

## What I'd try next

I want to combine a CM playbook with a vulnerability scanner — run an Ansible playbook to hardener OS settings, then have Trivy scan the result and feed findings back into the pipeline.
