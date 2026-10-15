---
last_verified: 2026-10-15
tool_version: "2.15+"
sources:
  - https://scalr.com/learning-center/ultimate-guide-to-using-terraform-with-ansible
  - https://www.ansiblepilot.com/articles/ansible-terraform-integration-orchestrate-infrastructure-and-configuration-together
  - https://developer.hashicorp.com/validated-patterns/terraform/terraform-integrate-ansible-automation-platform
  - https://dev.to/yutee_okon/advanced-kubernetes-deployment-with-gitops-a-hands-on-guide-to-terraform-ansible-argocd-and-5c07
---

# Ansible Roles Scaffold — Staging & Production Inventories

## Purpose
A minimal, production-ready Ansible project structure that separates environment-specific configuration (staging/production) from reusable role logic. Designed for teams adopting Ansible after Terraform provisions infrastructure.

## When to use
- You have Terraform-provisioned hosts and need Day 1+ configuration management
- You want a clear separation between role code and environment inventory
- You need to maintain staging and production parity with environment-specific overrides

## Prerequisites
- Ansible Core 2.15+ (or ansible-core 2.16+)
- Python 3.10+ on control node
- SSH access to target hosts from control node
- Terraform outputs available for inventory generation (see `ansible-013` for the generator script)

## Directory layout
```
.
├── ansible.cfg                 # Central configuration (inventory, roles_path, defaults)
├── requirements.yml            # Galaxy/collection dependencies
├── site.yml                    # Entry point playbook
├── roles/
│   └── common/                 # Example base role — replace/extend with your roles
│       ├── tasks/main.yml
│       ├── handlers/main.yml
│       ├── templates/
│       ├── vars/main.yml
│       ├── defaults/main.yml
│       └── meta/main.yml
└── inventories/
    ├── staging/
    │   ├── hosts.yml           # Staging host groups and vars
    │   └── group_vars/all.yml  # Staging-wide variables
    └── production/
        ├── hosts.yml           # Production host groups and vars
        └── group_vars/all.yml  # Production-wide variables
```

## Steps to adopt
1. Copy this directory to your repository (e.g. `infra/ansible/`)
2. Replace `roles/common/` with your actual roles (nginx, postgres, monitoring, etc.)
3. Edit `inventories/staging/hosts.yml` and `inventories/production/hosts.yml` with your host IPs/DNS (or generate them from Terraform outputs)
4. Set environment-specific variables in `inventories/*/group_vars/all.yml`
5. Run: `ansible-playbook -i inventories/staging site.yml` (or `production`)

## Verify
```bash
# Syntax check
ansible-playbook --syntax-check site.yml

# Dry run against staging
ansible-playbook -i inventories/staging site.yml --check --diff

# Lint roles (requires ansible-lint)
ansible-lint roles/
```

## Common errors
| Symptom | Cause | Fix |
|---------|-------|-----|
| `UNREACHABLE` on first run | SSH keys not in agent / wrong user | `ssh-add` key; set `ansible_user` in group_vars |
| `FAILED! => {"msg": "Could not match supplied host pattern"}` | Inventory file not found or empty | Verify `-i inventories/staging` path; check `hosts.yml` has hosts |
| Role not found | `roles_path` in `ansible.cfg` doesn't include `./roles` | Ensure `roles_path = ./roles:~/.ansible/roles:/usr/share/ansible/roles` |

## References
- [Terraform → Ansible handoff patterns](https://scalr.com/learning-center/ultimate-guide-to-using-terraform-with-ansible)
- [Ansible orchestrating Terraform](https://www.ansiblepilot.com/articles/ansible-terraform-integration-orchestrate-infrastructure-and-configuration-together)
- [Enterprise integration (AAP)](https://developer.hashicorp.com/validated-patterns/terraform/terraform-integrate-ansible-automation-platform)
- [Advanced Kubernetes deployment with GitOps](https://dev.to/yutee_okon/advanced-kubernetes-deployment-with-gitops-a-hands-on-guide-to-terraform-ansible-argocd-and-5c07)