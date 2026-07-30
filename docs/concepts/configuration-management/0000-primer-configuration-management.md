---
last_verified: 2026-07-30
tool_version: n/a
---

# Configuration Management — quick primer

> First-day notes on Configuration Management. What it is, why it matters, and the key ideas to know.

## What is it?

Configuration management is the practice of keeping a system's software, settings, and dependencies in a known, consistent state — and making sure that state is reproducible across different machines. Instead of logging into a server and tweaking things by hand, you define the desired configuration in code and let a tool enforce it.

I think of it like a recipe. If I write down exactly what ingredients and steps go into a dish, anyone can produce the same result. Without the recipe, I'm relying on memory and muscle memory, and every batch comes out slightly different. Configuration management tools are that recipe for servers — they encode the "how" so every machine ends up looking the same, and they keep it that way even when things drift.

## Why does it matter for devops?

Configuration management is one of the first real automation layers a devops practitioner hits. Without it, each server is a snowflake — you install packages manually, edit config files by hand, and pray you don't forget that one `sysctl` parameter that makes the app work. When you have five servers, that's painful. When you have fifty, it's impossible.

CM tools also give you a safety net. If a server crashes and you need to rebuild, you don't reconstruct from tribal knowledge — the configuration definition is your source of truth. And because the config is code, it goes through version control, code review, and testing just like application code. That's a huge leap over the org-wide bash script in a shared drive.

## Key terminology

- **Idempotency** — Running the same configuration multiple times produces the same result. Example: running an Ansible playbook that ensures `nginx` is installed — the first run installs it, subsequent runs confirm it's already there and move on.
- **Desired state** — The target configuration you declare (e.g. "nginx version 1.24 should be running on port 80"). The tool works to converge the actual system to this state.
- **Drift** — When the actual system state differs from the desired state. Example: someone manually edits `/etc/nginx/nginx.conf` on a server managed by Ansible.
- **Push model** — A central server pushes configuration to nodes. Example: Ansible connects via SSH and runs playbooks on target hosts.
- **Pull model** — Nodes fetch their configuration from a central source on a schedule. Example: a Chef or Puppet agent runs every 30 minutes and pulls the latest policy from the server.
- **Manifest / Playbook / Policy** — The file that defines configuration. Different tools call them different things: Ansible calls them playbooks, Puppet calls them manifests, Chef calls them recipes.
- **Inventory** — The list of nodes a CM tool manages, often grouped by role or environment. Example: `[webservers]`, `[databases]`, `[staging]`.

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
        update_cache: yes

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

This Ansible playbook declares that every server in the `webservers` group should have nginx installed, a specific config file in place, and the service running. If any of those conditions aren't met, Ansible fixes them.

## How this connects to what's next

Configuration management is the bridge between provisioning infrastructure (creating servers) and running applications on them. It's the layer that turns a bare VM into a useful machine. From here, I'll move into tools like Ansible for server config, Helm for Kubernetes app config, and policy engines like OPA that apply the same desired-state thinking to security rules instead of system settings.
