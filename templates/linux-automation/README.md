# Linux System Automation Template

## Purpose

This template provides a comprehensive, production-ready framework for automating Linux system administration tasks in DevOps workflows. It includes standardized patterns for configuration management, service orchestration, monitoring, logging, and security hardening across heterogeneous environments.

## When to Use

- Building standardized infrastructure automation pipelines
- Managing fleet-wide configuration deployments
- Implementing self-healing infrastructure patterns
- Automating security compliance and hardening
- Orchestrating multi-tier application deployments
- Managing containerized workloads on Linux hosts
- Implementing infrastructure-as-code for bare-metal or VMs

## Prerequisites

- Target Linux systems running RHEL/CentOS 8+, Ubuntu 20.04+, or Debian 10+
- SSH key-based authentication configured
- Ansible 2.9+ or equivalent automation tool installed
- Python 3.8+ on control node and target nodes
- Sudo/root access on target systems
- Network connectivity between control node and target nodes
- Git for version control of automation templates
- Container runtime (Docker/Podman) for containerized tasks (optional)

## Steps

### 1. Project Structure Setup

```bash
# Create automation project structure
ansible-galaxy init linux-automation-template
cd linux-automation-template

# Or use this template directly:
cp -r /path/to/templates/linux-automation/* .
```

Directory layout:

```
linux-automation-template/
├── inventory/          # Dynamic/static inventory files
├── group_vars/         # Variables by host group
├── host_vars/          # Variables by individual host
├── roles/              # Reusable Ansible roles
├── playbooks/          # Main automation playbooks
├── templates/          # Jinja2 configuration templates
├── scripts/            # Helper scripts
└── files/              # Static files to deploy
```

### 2. Inventory Configuration

Create `inventory/production.yml`:

```yaml
---
all:
  children:
    webservers:
      hosts:
        web01.example.com:
          ansible_host: 192.168.1.10
        web02.example.com:
          ansible_host: 192.168.1.11
      vars:
        http_port: 80
        max_clients: 200

    databases:
      hosts:
        db01.example.com:
          ansible_host: 192.168.1.20
      vars:
        db_port: 5432

    loadbalancers:
      hosts:
        lb01.example.com:
          ansible_host: 192.168.1.5

  vars:
    ansible_user: ansible
    ansible_ssh_private_key_file: ~/.ssh/automation_key
    ansible_python_interpreter: /usr/bin/python3
```

### 3. Base System Configuration Role

Create `roles/base/`:

**`roles/base/tasks/main.yml`:**

```yaml
---
- name: Update package cache
  apt:
    update_cache: yes
    cache_valid_time: 3600
  when: ansible_os_family == "Debian"

- name: Update package cache (RHEL)
  yum:
    update_cache: yes
  when: ansible_os_family == "RedHat"

- name: Install base packages
  package:
    name: "{{ item }}"
    state: present
  loop:
    - curl
    - wget
    - vim
    - htop
    - net-tools
    - git
    - python3-pip
    - unattended-upgrades

- name: Configure timezone
  timezone:
    name: "{{ system_timezone }}"
  when: system_timezone is defined

- name: Set hostname
  hostname:
    name: "{{ inventory_hostname }}"
```

### 4. Service Orchestration Role

Create `roles/orchestrator/`:

```yaml
---
- name: Create application user
  user:
    name: "{{ app_user }}"
    system: yes
    shell: /bin/bash
    create_home: yes

- name: Deploy systemd service files
  template:
    src: services/{{ item }}.j2
    dest: /etc/systemd/system/{{ item }}
    mode: '0644'
  loop: "{{ services }}"
  notify: reload systemd

- name: Enable and start services
  systemd:
    name: "{{ item }}"
    enabled: yes
    state: started
  loop: "{{ services }}"
```

### 5. Monitoring Integration

Create `roles/monitoring/`:

```yaml
---
- name: Install Prometheus Node Exporter
  package:
    name: prometheus-node-exporter
    state: present

- name: Enable node exporter
  systemd:
    name: prometheus-node-exporter
    enabled: yes
    state: started
```

### 6. Security Hardening

Create `roles/security/`:

```yaml
---
- name: Configure firewall rules
  ufw:
    rule: "{{ item.rule }}"
    port: "{{ item.port }}"
    proto: "{{ item.proto | default('tcp') }}"
    state: enabled
  loop: "{{ firewall_rules }}"
  when: ansible_os_family == "Debian"

- name: Apply kernel security parameters
  sysctl:
    name: "{{ item.key }}"
    value: "{{ item.value }}"
    state: present
    reload: yes
  loop:
    - { key: net.ipv4.ip_forward, value: 0 }
    - { key: net.ipv4.conf.all.send_redirects, value: 0 }
```

### 7. Main Playbook

Create `playbooks/deploy.yml`:

```yaml
---
- name: Deploy and configure Linux systems
  hosts: all
  become: yes
  gather_facts: yes

  roles:
    - role: base
      tags: [base, always]

    - role: security
      tags: [security]

    - role: monitoring
      tags: [monitoring]
      when: enable_monitoring | default(true)

    - role: orchestrator
      tags: [orchestrator]
      when: enable_services | default(true)
```

### 8. Deployment Script

Create `scripts/deploy.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT=${1:-production}
DRY_RUN="${DRY_RUN:-false}"

if [[ "$DRY_RUN" == "true" ]]; then
    ansible-playbook -i "inventory/${ENVIRONMENT}.yml" playbooks/deploy.yml --check --diff
else
    ansible-playbook -i "inventory/${ENVIRONMENT}.yml" playbooks/deploy.yml
fi
```

## Verify

### 1. Syntax Check

```bash
ansible-playbook -i inventory/production.yml playbooks/deploy.yml --syntax-check
```

### 2. Dry Run

```bash
ansible-playbook -i inventory/production.yml playbooks/deploy.yml --check --diff
```

### 3. Test Connectivity

```bash
ansible all -i inventory/production.yml -m ping
```

### 4. Verify Services

```bash
ansible webservers -i inventory/production.yml -m systemd -a "name=myapp state=started"
```

## Rollback

### 1. Via Git

```bash
git log --oneline -10
git checkout <previous-commit-hash>
./scripts/deploy.sh production
```

### 2. Manual Rollback

```bash
ansible all -i inventory/production.yml -m systemd -a "name=myapp state=stopped enabled=no"
```

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| Failed to connect to host | SSH connectivity issue | Verify SSH keys and inventory |
| Syntax Error while loading YAML | Invalid YAML formatting | Replace tabs with spaces |
| No package matching | Package not in repos | Update package cache first |
| Permission denied | Insufficient privileges | Ensure become: yes is set |

## References

- [Ansible Documentation](https://docs.ansible.com/)
- [Systemd Service Unit Files](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [Prometheus Node Exporter](https://github.com/prometheus/node_exporter)
- [Linux Security Hardening Guide](https://www.cisecurity.org/cis-benchmarks/)