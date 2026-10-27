---
last_verified: 2026-10-27
tool_version: n/a
sources: []
---

# Syft: install and generate my first SBOM from a container image

I installed Syft with the official install script — one curl piped to sh that dropped the `syft` binary into `/usr/local/bin`. `syft --version` confirmed it was on the PATH.

Instead of pulling an image from a registry, I saved one locally first:

```bash
docker save my-app:latest -o my-app.tar
```

Then pointed Syft at the tarball:

```bash
syft my-app.tar
```

It printed a package table — name, version, type — for everything inside the image layers. I also tried the JSON output:

```bash
syft my-app.tar -o json
```

which dumps a top-level `artifacts` array, each entry carrying `name`, `version`, `type`, `locations`, and `licenses`.

## What tripped me up

- `syft my-app.tar` works on the archive directly — I did not need to `docker load` the image first, which surprised me.
- The default table output is fine for a quick look, but I could not tell how many packages were found at a glance; `-o json` is easier to script against.
- I have not tried CycloneDX or SPDX yet — the `-o cyclonedx-json` and `-o spdx-json` spellings are next on my list.

## What I'll cover next

Pipe Syft's SBOM into Grype for vulnerability scanning, and try scanning a running image rather than an archive.
