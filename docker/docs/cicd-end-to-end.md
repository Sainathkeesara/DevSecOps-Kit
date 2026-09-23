---
last_verified: 2026-09-23
tool_version: n/a
---

# Docker integration: CI/CD end-to-end

## Purpose

This guide wires Docker image builds into a CI/CD pipeline end to end: build once in CI, verify the image, then push it to a registry so a later deploy step can pull that exact image. The docs also suggest running lint or unit tests before the build; this is one way to order those stages so a broken commit never produces an image tag.

## When to use

Use this flow when a service already ships as a container and every merge to the main branch should produce a deployable image. It fits a single-service repo with a Dockerfile at the repo root and a registry the CI runner can push to.

## Prerequisites

- A Dockerfile that builds successfully locally.
- A CI runner with Docker engine access and registry credentials configured.
- Familiarity with `docker build`, `docker run`, and `docker push`.

## Steps

### 1. Build the image once with a unique tag

Tag each CI build with something unique to the commit, such as the commit SHA, so the deploy step can reference exactly what was tested. The pipeline equivalent is a single build command run right after checkout.

```bash
docker build -t myapp:ci-test .
docker images myapp
```

If the build fails here, the pipeline stops and nothing is pushed — that is the point. A locally passing but CI-failing build usually means the Dockerfile depends on something only present on the workstation, like a local cache or an uncommitted file.

### 2. Smoke-test the image before pushing

Run the freshly built image with a quick health check rather than trusting that "it built, so it runs". A minimal check is starting the container and hitting its health endpoint or expected startup log line.

```bash
docker run --rm myapp:ci-test python main.py --check
```

I keep this check deliberately small — one command that exits non-zero on failure. A longer integration suite can run here too, but the fast smoke test catches the common case (missing dependency, wrong start command) in seconds.

### 3. Push the verified image, then deploy by tag

Only builds that pass the smoke test get pushed. The deploy step then pulls the same tag that was tested, so what runs in the target environment is byte-identical to what passed CI.

```bash
docker push myapp:ci-test
```

One pattern that works well is retagging the verified image as the environment candidate after the push, so the deploy job references a stable name while the unique tag preserves the audit trail.

## Verify

After a pipeline run, confirm the registry holds the tested tag and that a fresh pull runs cleanly:

```bash
docker pull myapp:ci-test
docker run --rm myapp:ci-test python main.py --check
```

If the pull succeeds and the check exits zero, the loop is closed: commit → build → test → push → pull → run.

## Common errors

- **Push rejected with an auth error.** The build and test steps passed but the push failed, which I hit when the registry credentials were scoped to pull-only. Fix by granting the CI identity push access and re-running just the push step.
- **Stale base layers making builds slow.** When every build re-downloads the base image, pipeline times creep up. Caching the base layers on the runner (or keeping a warm builder) brought build times back down without changing the Dockerfile.
