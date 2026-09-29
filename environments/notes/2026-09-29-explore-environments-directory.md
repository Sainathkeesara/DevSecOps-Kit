---
last_verified: 2026-09-29
tool_version: n/a
sources: []
---

# Explore the environments directory — what's there

I poked around the `environments/` directory today to see what's in it. The structure is:

```
environments/
├── notes/
│   ├── 0000-primer-environments.md
│   └── 2026-09-19-first-environment-comparison.md
└── configs/
    └── environment-config.yaml
```

The primer (`0000-primer-environments.md`) explains what environments are in this kit — basically a way to manage dev/staging/prod configurations with separate variable files and deployment targets. It compares it to Terraform workspaces but for the whole kit.

The comparison note (`2026-09-19-first-environment-comparison.md`) walks through a three-environment setup (dev, staging, prod) showing how network settings, AZs, NAT gateways, and tags differ across them. It references some shared files I haven't found yet (`../assets/architecture-overview.png` and similar).

The config file (`environment-config.yaml`) has a minimal structure with `environments:` mapping to dev/staging/prod blocks, each with `region`, `cidr`, `azs`, and `tags`. There's also a `defaults:` section at the top.

I ran `ls -la environments/` and `cat environments/configs/environment-config.yaml` to see the raw content. The config looks like valid YAML — I validated it with `yamllint` and it passed.

What I'll cover next: I want to try the quickstart (environments-005) to see how the config gets applied, and then write a minimal config for a test project (environments-006).