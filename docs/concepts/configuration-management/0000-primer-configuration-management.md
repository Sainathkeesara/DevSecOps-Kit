# Configuration Management — quick primer

> First-day notes on Configuration Management. What it is, why it matters, and the key ideas to know.

## What is it?

Configuration management is the practice of keeping your systems' software, settings, and state consistent and predictable over time. I think of it as making a system behave the way I expect it to, every time, without needing to log in and tweak things by hand.

If provisioning is about creating infrastructure (spinning up a VM, creating a database), configuration management is about what happens after it exists — installing packages, setting environment variables, configuring services, and keeping those settings correct as the system runs. Tools like Ansible, Puppet, Chef, and Salt handle this, each with slightly different philosophies.

## Why does it matter for devops?

Configuration management is what makes "cattle not pets" possible. Instead of treating each server as a unique snowflake that I hand-tune and fear to touch, config management lets me define the desired state of every machine in a file, apply it automatically, and know that all my servers will be identical.

The biggest practical benefit for me is auditability and recovery. If a server gets compromised or drifts out of spec, I can re-apply the configuration and bring it back to the known-good state. The config files themselves live in version control, so I can review changes, roll back bad configs, and trace when a particular setting was introduced. That alone saves hours of "who changed what on that box" detective work.

## Key terminology

- **Desired state** — The configuration I want the system to be in, defined declaratively. Example: "nginx should be installed, running, and listening on port 443."
- **Idempotency** — Running the same configuration multiple times produces the same result. Example: running an Ansible playbook twice doesn't install nginx twice — it checks if nginx is already present and skips if it is.
- **Drift** — When the actual system state differs from the desired state in the config files. Example: someone manually installs a different package version over SSH.
- **Pull model** — Agents on each machine periodically check a central server for the latest config and apply it. Example: Puppet agents poll the Puppet master every 30 minutes.
- **Push model** — A control machine connects to each target and applies the configuration directly. Example: Ansible connects via SSH and runs tasks.
- **Playbook / Recipe / Manifest** — A file (or set of files) describing the desired configuration. Example: an Ansible playbook in YAML that installs packages, copies templates, and restarts services.
- **Inventory** — A list of managed machines and their grouping. Example: an Ansible inventory file listing web servers, database servers, and load balancers.
- **Idempotent resource** — A configuration action that only makes changes when needed. Example: an Ansible `copy` module only overwrites a file if its content differs.

## A concrete example

```yaml
---
- name: Ensure nginx is installed and running
  hosts: webservers
  become: yes
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present

    - name: Copy site config
      copy:
        src: ./site.conf
        dest: /etc/nginx/sites-available/default
      notify: restart nginx

    - name: Ensure nginx is running
      service:
        name: nginx
        state: started
        enabled: yes

  handlers:
    - name: restart nginx
      service:
        name: nginx
        state: restarted
```

This Ansible playbook declares that nginx should be installed, a config file should be in place, and the service should be running. If any task changes the system, the handler restarts nginx. Running it twice does nothing the second time — that's idempotency in action.

## How this connects to what's next

Configuration management slides right next to provisioning (Terraform) and policy enforcement (OPA). Terraform builds the infrastructure, config management sets it up, and OPA keeps it in compliance. Understanding config management concepts makes Ansible and similar tools much easier to pick up.
