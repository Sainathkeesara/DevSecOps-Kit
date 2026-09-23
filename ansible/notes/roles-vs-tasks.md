---
last_verified: 2026-09-22
tool_version: "v2.21.3"
sources:
  - https://docs.ansible.com/projects/ansible-core/devel/playbook_guide/playbooks_reuse_roles.html
  - https://www.ansiblepilot.com/articles/ansible-roles-complete-guide
  - https://github.com/ansible/ansible-examples
  - https://forum.ansible.com/t/new-release-ansible-core-v2-21-3/46155
---

# Roles vs tasks in Ansible — comparing two structural approaches

## Purpose

I compared two ways to organize an Ansible playbook: keeping the work as a linear list of tasks, and moving a repeatable concern into a role. The right choice depends on how often the work is reused and how much context a future reader needs. A short, one-off sequence can stay in `tasks:`. A capability that belongs to a class of hosts, or that needs defaults, variables, files, templates, or handlers, is easier to understand as a role.

This note is written against ansible-core v2.21.3. It uses the role layout and ordering behavior documented for Ansible roles rather than treating roles as a mandatory wrapper around every task.

## Steps

### 1. Start with tasks when the workflow is truly local

For a small playbook, a direct `tasks:` list keeps the sequence visible. There is no extra directory to open, and the order of the work is the order in which it appears. This is a reasonable starting point while I am learning what the hosts need.

The limitation becomes apparent when the same group of tasks appears in more than one play or when the list grows beyond one concern. At that point, the file starts answering several questions at once: what is being changed, which hosts receive the change, and which pieces are reusable.

### 2. Move a reusable concern into a role

A role gives that concern a named home. I keep only the directories the role needs under `tasks/`, `handlers/`, `files/`, `templates/`, `vars/`, `defaults/`, and `meta/`; a role can be valid with just one of those directories. For example, a web-server role might begin with `tasks/main.yml` and add `handlers/main.yml` only when a service needs to be restarted.

A small project can then use a thin `site.yml` entry point with roles such as `common/` and `webservers/`. Ansible can find roles in `roles/` beside the playbook, or through `roles_path`. This makes the entry point describe the intended host groups while the role describes one capability.

### 3. Use tasks for ordering-sensitive glue

One detail changed how I choose between the two structures: entries under a play's `roles:` key run before the play's `tasks:` entries. If a preflight task must happen first, I keep that task in `tasks:` and use `ansible.builtin.include_role` for the role that needs to run at that point. `ansible.builtin.import_role` is the static-reuse alternative described in the role guide.

This is not a rule that roles are bad. It is a reminder that structure and execution order are separate decisions. I first decide which work is reusable, then choose the inclusion mechanism that gives me the order I need.

### 4. Keep repeated roles intentional

Ansible runs each role once per play unless the parameters differ or `allow_duplicates: true` is set in `meta/main.yml`. I treat a repeated role with identical parameters as a signal to check the design before adding an exception. If the role genuinely needs to run twice, I make the difference explicit through parameters or the documented duplicate setting.

For platform-specific work, I split the role into focused files such as `tasks/redhat.yml` and `tasks/debian.yml`, then include the file selected from `ansible_facts['os_family']`. That keeps the main task list readable without hiding the platform branch inside every task.

## Verify

- The entry point still names the host groups clearly, while each role has one understandable responsibility.
- Every role contains only the directories it uses, and its `tasks/main.yml` remains the default task list.
- Ordering-sensitive work is visible in `tasks:` or uses the intended include mechanism.
- A repeated role is either parameterized differently or has an explicit duplicate policy.
- The playbook is exercised against a small inventory after reorganizing it, so the structural change is checked as a workflow rather than only as YAML.

## What I would change next

For a larger project, I would compare a role-per-concern layout with platform-specific task files and keep the entry point deliberately small. If a concern stops being reusable, I would move it back to a focused task list instead of preserving a role only because it already exists.

## References

- Ansible playbook reuse roles guide: role directories, `roles_path`, `roles:` ordering, `include_role`, `import_role`, and duplicate behavior.
- Ansible Pilot role walkthrough: scaffolding a role with `ansible-galaxy role init`.
- Official Ansible examples: `lamp_simple/`, `tomcat-standalone/`, and `wordpress-nginx/` starter layouts.
- ansible-core v2.21.3 release discussion: the version used for this note.
