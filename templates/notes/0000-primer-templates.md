---
last_verified: 2026-09-20
tool_version: n/a
sources: []
---

# templates — quick primer

> First-day notes for someone who's never used templates. Personal voice, plain language.

## What is it?

Templates in this kit are project scaffolds — pre-built directory structures and starter files that let you spin up a new DevSecOps project without writing boilerplate from scratch. Think of it like `cookiecutter` or `github templates` but focused on the tools we cover: terraform modules, k8s manifests, docker compose stacks, jenkins pipelines, linux automation scripts, and more. Each template lives in its own subdirectory under `templates/` and contains the minimum viable structure to get started.

## What does it do?

It gives you a starting point. Instead of remembering the exact directory layout for a terraform module (modules/, examples/, tests/, versions.tf, main.tf, variables.tf, outputs.tf) or a kubernetes deployment (base/, overlays/, kustomization.yaml), you copy the template, fill in your specifics, and you're running. The template also encodes opinions — where CI configs go, how secrets are handled, what linter configs to include — so you inherit best practices without researching them.

## Why does it exist?

Before templates, every new project meant Googling "terraform module structure best practices" or copying an old repo and stripping out the irrelevant parts. That's slow and error-prone. Templates capture the "known good" structure once, then let you instantiate it repeatedly. Day-to-day, platform engineers and DevOps folks use these when onboarding a new service, setting up a new environment, or teaching a teammate the project layout.

## Key terminology

- **Template** — a directory under `templates/` containing a complete project scaffold (e.g., `templates/terraform/`).
- **Instantiate** — copying a template to a new location and customizing it for a specific project.
- **Variable substitution** — replacing placeholder values (like `{{PROJECT_NAME}}`) with actual values during instantiation.
- **Hook** — an optional script that runs before/after instantiation to do things like `git init`, `pre-commit install`, or dependency installs.
- **Category** — a grouping of related templates (e.g., all k8s-related templates under a k8s category).

## A tiny example

```bash
# List available templates
ls templates/

# Instantiate the terraform template for a new module
cp -r templates/terraform/ my-new-module/
cd my-new-module
# Edit files to replace placeholders with your project details
```

This copies the terraform module scaffold into a new directory, ready to customize.

## What I'll cover next

I want to build a small template of my own — maybe a minimal github-actions workflow template since that's a common starting point. Then I'll add a config file to define template categories so the CLI can list them by group.