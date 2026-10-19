---
last_verified: 2026-10-19
tool_version: n/a
sources: []
---

# templates quickstart — what tripped me up

> Following a quickstart approach, this is what worked and where it broke.

## What I wanted to do

I wanted to get my head around the templates in this kit: what they are, how they're organised, and how I'd actually use one. Templates here are project scaffolds — pre-built directory layouts and starter files for tools like terraform, k8s, docker, jenkins, linux-automation and more. I figured I'd start from the primer, then look at a real template and try to see the pattern.

## Steps

1. **Read the primer** — I looked at `templates/notes/0000-primer-templates.md`. It gave me a high-level view: copy the template folder, fill in placeholders, and you're off. The analogy to cookiecutter/github templates made sense.
2. **Checked an existing scaffold** — I looked into `templates/templates/2026-09-20-first-project-template/`. It has `cookiecutter.json` with variable defaults and a `{{cookiecutter.project_slug}}/` folder with files. That showed the template mechanism clearly.
3. **Looked at a real use-case template** — Skimmed `templates/linux-automation/README.md` to see how an actual template is documented. It explains layout and usage in a practical way.
4. **Considered variables/config** — Noticed there's already `templates/configs/2026-09-20-first-template-variables.yaml` with placeholder defaults.

## Got stuck on

- **Terminology vs mechanics** — The primer talks about instantiation, hooks, and categories in general terms, but the actual scaffolds in this repo are mostly copy-paste friendly (some use cookiecutter-style templating with `{{cookiecutter.*}}` placeholders). I assumed "instantiation" meant running a CLI tool, but in practice here I can just `cp -r` a template and edit manually. That's fine, just not explicitly stated.
- **Naming consistency** — I found `templates/templates/` (a subfolder literally called templates) containing the cookiecutter demo scaffold. At first glance I thought it was recursive or a typo, but it's just a demonstration scaffold living under the templates area.
- **Minimal entry point** — With many tool-specific templates, it's not obvious which one is the "hello world". The linux-automation one is concrete and readable.

## What I'd try next

I'd build a tiny custom template (maybe a simple shell script starter) and write a minimal `README` for it, similar to how the existing templates are structured. Also worth exploring how to standardise the variable set so it matches what the kit expects.
