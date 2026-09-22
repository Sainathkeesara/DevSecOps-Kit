---
last_verified: 2026-09-22
tool_version: "v2.21.3"
sources:
  - https://docs.ansible.com/projects/ansible-core/devel/playbook_guide/playbooks_reuse_roles.html
  - https://www.ansiblepilot.com/articles/ansible-roles-complete-guide
  - https://github.com/ansible/ansible-examples
  - https://forum.ansible.com/t/new-release-ansible-core-v2-21-3/46155
---

# How I wired Ansible into my infrastructure workflow

## Purpose

This is one way to wire Ansible into a small infrastructure workflow: one entry-point playbook plus a `roles/` layout, instead of a single growing playbook. The docs also describe larger layouts, but for a handful of hosts this shape was enough to stay readable. Written against ansible-core v2.21.3.

## Steps

### 1. Split the giant playbook into `site.yml` + `roles/`

I started with everything in one playbook and it got hard to scan, so I split it following the small-project recipe: a `site.yml` entry point plus a `roles/` directory with one role per concern (`common/`, `webservers/`), each role carrying only the directories it needs under `tasks/`, `handlers/`, `files/`, `templates/`, `vars/`, `defaults/`, `meta/`. A role is valid with just one of those directories, so I did not scaffold empty ones.

```yaml
# site.yml — this is one way to do it; the docs also show larger layouts
- name: Base setup for all hosts
  hosts: all
  roles:
    - common
- name: Web tier
  hosts: webservers
  roles:
    - webservers
```

Ansible finds roles in `roles/` next to the playbook, or via `roles_path`, so I kept `site.yml` and `roles/` side by side and it just worked.

### 2. Scaffold the role instead of hand-making directories

I scaffolded the second role rather than creating the directories by hand:

```bash
ansible-galaxy role init roles/webservers
```

That created the standard `tasks/`, `handlers/`, `files/`, `templates/`, `vars/`, `defaults/`, `meta/` skeleton. I deleted the directories I did not need and kept `tasks/main.yml` plus `handlers/main.yml`. When I wanted a starter example to compare against, I looked at the `lamp_simple/`, `tomcat-standalone/`, and `wordpress-nginx/` examples in the official examples collection.

### 3. Split platform-specific tasks instead of branching inline

My `webservers` role needed different package steps per family, so I split platform-specific tasks into `tasks/redhat.yml` vs `tasks/debian.yml` and included the right one from `tasks/main.yml` on `ansible_facts['os_family']`:

```yaml
# roles/webservers/tasks/main.yml
- name: Include OS-family tasks
  ansible.builtin.include_tasks: "{{ ansible_facts['os_family'] | lower }}.yml"
```

This replaced a tangle of `when:` conditions on every task. I tripped here first by naming a file `RedHat.yml` with capital letters while the include asked for `redhat.yml` — the include failed, and renaming to lowercase fixed it.

### 4. Fix the ordering surprise: `roles:` runs before `tasks:`

I hit the classic ordering surprise: `roles:` entries run before all `tasks:`, so a debug task I placed in `tasks:` expecting it to run first actually ran after the roles. The docs describe `ansible.builtin.include_role` for dynamic in-order reuse vs `ansible.builtin.import_role` for static reuse, so I moved the ordering-sensitive piece into `tasks:` with an explicit include:

```yaml
tasks:
  - name: Preflight check before roles
    ansible.builtin.debug:
      msg: "running before webservers role"
  - name: Apply webservers role in order
    ansible.builtin.include_role:
      name: webservers
```

I also learned Ansible runs each role once per play unless parameters differ or `allow_duplicates: true` is set in `meta/main.yml` — my second listing of `common` with identical parameters was silently skipped until I passed it a different parameter. And where I had previously called subsets of one role with heavy tag-splitting at different times, I split it into two smaller roles instead.

## Verify

- `site.yml` parses and the role list resolves: the playbook references `common` and `webservers`, and both directories exist under `roles/` next to `site.yml`.
- The platform include resolves: `roles/webservers/tasks/` contains `main.yml` plus the per-family files, and the include key matches `ansible_facts['os_family']` values.
- Ordering behaves as written: the preflight debug task runs before the `include_role` step, and a repeated role with identical parameters is expected to run once (set `allow_duplicates: true` in `meta/main.yml` or pass differing parameters if a repeat is intended).

## Common errors

- **Repeated role silently skipped.** I listed `common` twice with the same parameters and the second run never happened. Fixed by passing differing parameters; `allow_duplicates: true` in `meta/main.yml` is the other option the docs describe.
- **Wrong-case include filename.** `include_tasks` failed because I created `RedHat.yml` instead of `redhat.yml`. Matched the filename to the lowercased fact value.

## References

- Ansible reuse-roles guide (`site.yml` + `roles/` layout, `tasks/` / `handlers/` / `files/` / `templates/` / `vars/` / `defaults/` / `meta/`, `roles_path`, `include_role` vs `import_role`, `allow_duplicates`, per-family includes on `ansible_facts['os_family']`)
- Ansible Pilot roles walkthrough (scaffolding with `ansible-galaxy role init`)
- Official Ansible examples collection (`lamp_simple/`, `tomcat-standalone/`, `wordpress-nginx/`)
- ansible-core v2.21.3 release note (version verified against)
