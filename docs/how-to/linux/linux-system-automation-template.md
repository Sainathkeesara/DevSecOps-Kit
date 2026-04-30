# Linux: System Automation Template for DevOps Workflows

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
mkdir -p linux-automation-template/{inventory,group_vars,host_vars,roles,playbooks,templates,scripts,files}
cd linux-automation-template

# Initialize git repository
git init
git add .
git commit -m "Initial automation template structure"
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
    name: "{{ base_packages }}"
    state: present
  vars:
    base_packages:
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
  when: configure_hostname | default(true)

- name: Configure /etc/hosts
  lineinfile:
    path: /etc/hosts
    regexp: "^{{ hostvars[item].ansible_host }}"
    line: "{{ hostvars[item].ansible_host }} {{ item }}"
  loop: "{{ groups['all'] }}"
  when: hostvars[item].ansible_host is defined
```

**`roles/base/templates/ssh_config.j2`:**
```
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    TCPKeepAlive yes
    Compression yes
    ControlMaster auto
    ControlPath ~/.ssh/control-%r@%h:%p
    ControlPersist 4h
```

### 4. Service Orchestration Role

Create `roles/orchestrator/`:

**`roles/orchestrator/tasks/main.yml`:**
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
    owner: root
    group: root
    mode: '0644'
  loop: "{{ services }}"
  notify: reload systemd

- name: Enable and start services
  systemd:
    name: "{{ item }}"
    enabled: yes
    state: started
    daemon_reload: yes
  loop: "{{ services }}"

- name: Create application directories
  file:
    path: "{{ item }}"
    state: directory
    owner: "{{ app_user }}"
    group: "{{ app_group }}"
    mode: '0755'
  loop:
    - "{{ app_base_dir }}/config"
    - "{{ app_base_dir }}/logs"
    - "{{ app_base_dir }}/data"
```

### 5. Monitoring and Logging Integration

Create `roles/monitoring/`:

**`roles/monitoring/tasks/main.yml`:**
```yaml
---
- name: Install Prometheus Node Exporter
  get_url:
    url: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: /tmp/node_exporter.tar.gz
  register: download_result

- name: Extract node_exporter
  unarchive:
    src: /tmp/node_exporter.tar.gz
    dest: /usr/local/bin/
    remote_src: yes
    creates: /usr/local/bin/node_exporter
  when: download_result is succeeded

- name: Create node_exporter systemd service
  copy:
    content: |
      [Unit]
      Description=Node Exporter
      Wants=network-online.target
      After=network-online.target

      [Service]
      User=node_exporter
      Group=node_exporter
      Type=simple
      ExecStart=/usr/local/bin/node_exporter --collector.systemd

      [Install]
      WantedBy=multi-user.target
    dest: /etc/systemd/system/node_exporter.service
    mode: '0644'

- name: Install Fluent Bit for log aggregation
  apt:
    name: fluent-bit
    state: present
  when: ansible_os_family == "Debian"

- name: Configure Fluent Bit
  template:
    src: fluent-bit.conf.j2
    dest: /etc/fluent-bit/fluent-bit.conf
  notify: restart fluent-bit
```

### 6. Security Hardening Role

Create `roles/security/`:

**`roles/security/tasks/main.yml`:**
```yaml
---
- name: Configure firewall (UFW)
  ufw:
    rule: "{{ item.rule }}"
    port: "{{ item.port }}"
    proto: "{{ item.proto | default('tcp') }}"
    state: enabled
  loop: "{{ firewall_rules }}"
  when: ansible_os_family == "Debian"

- name: Configure firewall (firewalld)
  firewalld:
    port: "{{ item.port }}/{{ item.proto | default('tcp') }}"
    permanent: yes
    state: enabled
    immediate: yes
  loop: "{{ firewall_rules }}"
  when: ansible_os_family == "RedHat"

- name: Install and configure fail2ban
  apt:
    name: fail2ban
    state: present
  when: ansible_os_family == "Debian"

- name: Configure fail2ban jail
  template:
    src: fail2ban/jail.local.j2
    dest: /etc/fail2ban/jail.local
  notify: restart fail2ban

- name: Apply kernel security parameters
  sysctl:
    name: "{{ item.key }}"
    value: "{{ item.value }}"
    state: present
    reload: yes
  loop:
    - { key: net.ipv4.ip_forward, value: 0 }
    - { key: net.ipv4.conf.all.send_redirects, value: 0 }
    - { key: net.ipv4.conf.default.send_redirects, value: 0 }
    - { key: net.ipv6.conf.all.disable_ipv6, value: 1 }

- name: Configure automatic security updates
  apt:
    name: unattended-upgrades
    state: present
  when: ansible_os_family == "Debian"
```

### 7. Container Orchestration Tasks

Create `roles/containers/`:

**`roles/containers/tasks/main.yml`:**
```yaml
---
- name: Install Docker
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - docker.io
    - docker-compose
    - python3-docker
  when: ansible_os_family == "Debian"

- name: Create Docker networks
  docker_network:
    name: "{{ item.name }}"
    driver: bridge
    ipam_config:
      - subnet: "{{ item.subnet }}"
    state: present
  loop: "{{ docker_networks }}"

- name: Deploy containers from compose files
  docker_compose:
    project_src: "{{ compose_deploy_path }}"
    state: present
    pull: yes
  when: compose_deploy_path is defined

- name: Configure container registry authentication
  docker_login:
    registry_url: "{{ item.registry }}"
    username: "{{ item.username }}"
    password: "{{ item.password }}"
  loop: "{{ container_registries }}"
  no_log: true
  when: container_registries is defined
```

### 8. Main Playbook

Create `playbooks/deploy.yml`:

```yaml
---
- name: Deploy and configure Linux systems
  hosts: all
  become: yes
  gather_facts: yes

  vars_files:
    - ../group_vars/all.yml

  pre_tasks:
    - name: Display playbook information
      debug:
        msg: "Deploying to {{ inventory_hostname }} in {{ environment }}"

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

    - role: containers
      tags: [containers]
      when: enable_containers | default(false)

  handlers:
    - name: reload systemd
      systemd:
        daemon_reload: yes

    - name: restart fluent-bit
      systemd:
        name: fluent-bit
        state: restarted

    - name: restart fail2ban
      systemd:
        name: fail2ban
        state: restarted

  post_tasks:
    - name: Verify service status
      systemd:
        name: "{{ item }}"
        state: started
      loop: "{{ services | default([]) }}"
      when: enable_services | default(true)

    - name: Display deployment summary
      debug:
        msg:
          - "Deployment complete for {{ inventory_hostname }}"
          - "Services: {{ services | default([]) }}"
          - "Monitoring: {{ enable_monitoring | default(false) }}"
```

### 9. Automation Scripts

Create `scripts/deploy.sh`:

```bash
#!/usr/bin/env bash
# Deployment automation script
# Usage: ./deploy.sh [environment] [tags]

set -euo pipefail

ENVIRONMENT=${1:-production}
TAGS=${2:-all}
INVENTORY="inventory/${ENVIRONMENT}.yml"
PLAYBOOK="playbooks/deploy.yml"
VAULT_FILE="vault/${ENVIRONMENT}.vault"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# Check prerequisites
check_prerequisites() {
    for cmd in ansible ansible-playbook; do
        if ! command -v $cmd &>/dev/null; then
            log_error "$cmd is not installed"
            exit 1
        fi
    done
    
    if [[ ! -f "$INVENTORY" ]]; then
        log_error "Inventory file not found: $INVENTORY"
        exit 1
    fi
}

# Run playbook
run_deployment() {
    local extra_args=""
    
    if [[ "$TAGS" != "all" ]]; then
        extra_args="--tags $TAGS"
    fi
    
    if [[ -f "$VAULT_FILE" ]]; then
        extra_args="$extra_args --vault-password-file <(echo \$ANSIBLE_VAULT_PASSWORD)"
    fi
    
    log_info "Running deployment for environment: $ENVIRONMENT"
    log_info "Playbook: $PLAYBOOK"
    log_info "Inventory: $INVENTORY"
    
    ansible-playbook \
        -i "$INVENTORY" \
        "$PLAYBOOK" \
        $extra_args \
        --check \
        --diff \
        -v
    
    read -p "Proceed with actual deployment? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ansible-playbook \
            -i "$INVENTORY" \
            "$PLAYBOOK" \
            $extra_args \
            -v
    else
        log_warn "Deployment cancelled"
    fi
}

# Verify deployment
verify_deployment() {
    log_info "Verifying deployment..."
    
    ansible all -i "$INVENTORY" -m ping
    
    log_info "All systems reachable"
}

# Main
main() {
    check_prerequisites
    run_deployment
    verify_deployment
    
    log_info "Deployment complete!"
}

main "$@"
```

Make executable:
```bash
chmod +x scripts/deploy.sh
```

### 10. Configuration Templates

Create `templates/systemd-service.j2`:

```ini
[Unit]
Description={{ service_description }}
After=network.target
{% if service_dependencies is defined %}
{% for dep in service_dependencies %}
Requires={{ dep }}
After={{ dep }}
{% endfor %}
{% endif %}

[Service]
Type={{ service_type | default('simple') }}
User={{ service_user | default(app_user) }}
Group={{ service_group | default(app_group) }}
WorkingDirectory={{ service_workdir | default(app_base_dir) }}
ExecStart={{ service_exec_start }}
{% if service_exec_reload is defined %}
ExecReload={{ service_exec_reload }}
{% endif %}
{% if service_exec_stop is defined %}
ExecStop={{ service_exec_stop }}
{% endif %}
Restart={{ service_restart | default('on-failure') }}
RestartSec={{ service_restart_sec | default(5) }}
{% if service_environment is defined %}
{% for key, value in service_environment.items() %}
Environment={{ key }}={{ value }}
{% endfor %}
{% endif %}

# Security hardening
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem={{ protect_system | default('strict') }}
ProtectHome={{ protect_home | default('yes') }}
ReadWritePaths={{ service_rw_paths | default('/tmp') }}

[Install]
WantedBy={{ service_wanted_by | default('multi-user.target') }}
```

### 11. Variables and Defaults

Create `group_vars/all.yml`:

```yaml
---
# System configuration
system_timezone: "UTC"
configure_hostname: true

# Application settings
app_user: appuser
app_group: appgroup
app_base_dir: /opt/application

# Services
services:
  - myapp.service

# Monitoring
enable_monitoring: true
node_exporter_version: "1.6.1"

# Containers
enable_containers: false
docker_networks:
  - name: app_network
    subnet: 172.20.0.0/24

# Firewall rules
firewall_rules:
  - { rule: allow, port: 22, proto: tcp }
  - { rule: allow, port: 80, proto: tcp }
  - { rule: allow, port: 443, proto: tcp }

# Security
enable_fail2ban: true
```

## Verify

### 1. Syntax Check
```bash
# Validate Ansible playbook syntax
ansible-playbook -i inventory/production.yml playbooks/deploy.yml --syntax-check

# Check YAML syntax
yamllint playbooks/*.yml roles/*/tasks/*.yml
```

### 2. Dry Run
```bash
# Run in check mode
ansible-playbook -i inventory/production.yml playbooks/deploy.yml --check --diff
```

### 3. Test Connectivity
```bash
# Ping all hosts
ansible all -i inventory/production.yml -m ping

# Gather facts
ansible all -i inventory/production.yml -m setup
```

### 4. Verify Services
```bash
# Check service status on target hosts
ansible webservers -i inventory/production.yml -m systemd \
  -a "name=myapp state=started"

# Verify firewall rules
ansible all -i inventory/production.yml -m shell \
  -a "ufw status numbered 2>/dev/null || firewall-cmd --list-all"
```

### 5. Monitor Logs
```bash
# Check deployment logs
ansible-playbook -i inventory/production.yml playbooks/deploy.yml -v

# View target system logs
ansible all -i inventory/production.yml -m shell \
  -a "journalctl -u myapp --since '5 minutes ago'"
```

## Rollback

### 1. Rollback via Git
```bash
# Revert to previous version
cd linux-automation-template
git log --oneline -10
git checkout <previous-commit-hash>

# Redeploy previous version
./scripts/deploy.sh production all
```

### 2. Rollback Specific Role
```bash
# Redeploy only base role
ansible-playbook -i inventory/production.yml playbooks/deploy.yml \
  --tags base
```

### 3. Manual Rollback
```bash
# Stop and disable services
ansible all -i inventory/production.yml -m systemd \
  -a "name=myapp state=stopped enabled=no"

# Restore from backup
# (assuming you have backup mechanism)
ansible all -i inventory/production.yml -m shell \
  -a "cp /opt/application/backup/config.yml /opt/application/config.yml"

# Restart services
ansible all -i inventory/production.yml -m systemd \
  -a "name=myapp state=started"
```

### 4. Remove Automation Artifacts
```bash
# Remove deployed services
ansible all -i inventory/production.yml -m systemd \
  -a "name=myapp state=stopped enabled=no"

# Remove configuration files
ansible all -i inventory/production.yml -m file \
  -a "path=/etc/systemd/system/myapp.service state=absent"

# Remove application files
ansible all -i inventory/production.yml -m file \
  -a "path=/opt/application state=absent"

# Reload systemd
ansible all -i inventory/production.yml -m systemd \
  -a "daemon_reload=yes"
```

## Common Errors

### Error: "Failed to connect to the host"
**Cause:** SSH connectivity or authentication issue.
```bash
# Test SSH connection manually
ssh -i ~/.ssh/automation_key ansible@target-host

# Verify inventory configuration
cat inventory/production.yml

# Check ansible_ssh_private_key_file path
```

### Error: "Syntax Error while loading YAML"
**Cause:** Invalid YAML formatting (tabs instead of spaces, etc.)
```bash
# Validate YAML syntax
yamllint roles/*/tasks/*.yml
python3 -c "import yaml; yaml.safe_load(open('playbook.yml'))"

# Common fixes:
# - Replace tabs with spaces
# - Ensure consistent indentation (2 spaces)
# - Quote strings containing special characters
```

### Error: "FAILED! => {\"changed\": false, \"msg\": \"No package matching...\"}"
**Cause:** Package not available in repositories.
```bash
# Update package cache
ansible all -i inventory/production.yml -m apt \
  -a "update_cache=yes cache_valid_time=3600"

# Or manually add repository
ansible all -i inventory/production.yml -m apt_repository \
  -a "repo='ppa:some/repository' state=present"
```

### Error: "Permission denied" for systemd operations
**Cause:** Insufficient privileges.
```bash
# Ensure become: yes is set in playbook
# Verify sudo access for ansible user
ansible all -i inventory/production.yml -m shell \
  -a "sudo whoami"
```

### Error: Template rendering fails
**Cause:** Undefined variable in Jinja2 template.
```bash
# Check variable definitions
grep -r "variable_name" group_vars/ host_vars/

# Provide default values in templates
{{ variable_name | default('default_value') }}
```

### Error: "ERROR! conflicting action statements"
**Cause:** Multiple actions in same task.
```yaml
# Wrong:
- name: Do multiple things
  apt: name=foo
  service: name=bar state=started  # ❌

# Correct:
- name: Install package
  apt: name=foo state=present

- name: Start service
  service: name=bar state=started
```

### Error: Service fails to start
**Cause:** Configuration error or dependency issue.
```bash
# Check service logs on target
ansible target-host -i inventory/production.yml -m shell \
  -a "journalctl -u myapp --no-pager"

# Test service manually
ansible target-host -i inventory/production.yml -m shell \
  -a "/path/to/service binary --test-config"

# Verify template variables
ansible target-host -i inventory/production.yml -m debug \
  -a "var=hostvars[inventory_hostname].services"
```

## References
- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_best_practices.html)
- [Systemd Service Unit Files](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [Prometheus Node Exporter](https://github.com/prometheus/node_exporter)
- [Fluent Bit Documentation](https://docs.fluentbit.io/)
- [Fail2ban Documentation](https://www.fail2ban.org/wiki/index.php/Main_Page)
- [Docker Compose](https://docs.docker.com/compose/)
- [Linux Security Hardening Guide](https://www.cisecurity.org/cis-benchmarks/)