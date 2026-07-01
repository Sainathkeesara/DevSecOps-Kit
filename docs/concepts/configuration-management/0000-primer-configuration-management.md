# Configuration Management — quick primer

> First-day notes on Configuration Management. What it is, why it matters, and the key ideas to know.

## What is it?

Configuration management is the practice of keeping a system's software, settings, and infrastructure in a known, consistent state — and making sure that state stays that way over time. If you've ever manually SSH'd into a server to tweak a config file, only to find three months later that nobody remembers what got changed or why — that's the problem configuration management solves.

I think of it like a cookbook. Instead of telling a chef "make something tasty" and hoping for the best, a recipe spells out exactly what ingredients go in, in what order, and at what temperature. Configuration management tools are the recipe for your servers. They define the desired state (install nginx 1.24, open port 443, deploy this TLS cert) and then make it happen — and keep making it happen if something drifts.

## Why does it matter for devops?

Without configuration management, every server is a snowflake. One team's staging box might have a slightly different kernel version than another. A load balancer might be routing to instances running different library versions. When something breaks, it's a forensic exercise to figure out what changed.

Configuration management solves this by making server state:
- **Repeatable** — the same config produces the same result every time
- **Version-controlled** — configs live in Git, so you can review changes, roll back, and audit who changed what
- **Automated** — no manual SSH tweaks; changes roll out through code

Every devops engineer encounters this from day one. Even a simple Dockerfile is a primitive form of configuration management — it describes the exact files, packages, and commands needed to produce a container image.

## Key terminology

- **Desired state** — The target configuration you want your system to have. Example: "nginx should be installed at version 1.24, enabled as a systemd service, and listening on port 443."
- **Idempotency** — Running the same configuration multiple times produces the same result. Example: running an Ansible playbook that sets `nginx state: started` will start nginx if it's stopped, but won't fail or restart it if it's already running.
- **Drift** — When a system's actual state differs from its desired state. Example: someone manually edits `/etc/nginx/nginx.conf`, so the running config no longer matches what's in Git.
- **Agent** — A background process running on a managed node that reports state and applies configs. Example: the Puppet agent runs every 30 minutes, checks in with the Puppet master, and applies any policy changes.
- **Pull model** — Nodes periodically fetch their config from a central server. Example: Puppet agents pull catalogs from the Puppet master on their own schedule.
- **Push model** — A central orchestrator pushes configs out to nodes. Example: Ansible connects to target machines over SSH and applies playbooks directly.
- **Declarative** — You describe *what* you want, not *how* to get there. Example: Terraform's `resource "aws_instance" "web" { ami = "ami-..." }` says "I want an EC2 instance with this AMI" — Terraform figures out the API calls.
- **Manifest / Playbook / Policy** — The file that defines your desired state. Each tool has its own name for this (Ansible calls them playbooks, Puppet calls them manifests, Chef calls them recipes).

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

    - name: Ensure nginx is running
      service:
        name: nginx
        state: started
        enabled: yes
```

This Ansible playbook declares that all machines in the `webservers` group should have nginx installed, running, and set to start on boot. If I run this against ten servers, all ten end up in the same state — and I can run it again tomorrow without accidentally restarting anything.

## How this connects to what's next

Configuration management is the foundation for Infrastructure as Code (IaC) and automated deployment pipelines. Tools like Ansible, Puppet, Chef, and Salt all build on these concepts. Once you're comfortable with desired state and idempotency, Terraform, Kubernetes (which is basically configuration management for containers), and CI/CD pipeline automation will feel like natural extensions.
