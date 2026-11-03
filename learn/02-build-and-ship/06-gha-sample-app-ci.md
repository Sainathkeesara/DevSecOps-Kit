---
last_verified: 2026-11-03
tool_version: n/a
sources:
  - https://docs.docker.com/engine/release-notes/29/
  - https://docs.docker.com/reference/dockerfile/
---

# CI for the sample app — build, test and push

You can build and run the sample app locally with Docker. The next step is to automate it: every pull request should build the image and run the tests, and a merge to master should only happen when that run is green. This lesson continues from the Docker lesson, where you built the sample app image by hand, and adds a GitHub Actions workflow that does the same work on every change.

## What you'll learn

- Write a workflow that builds and tests the app on every pull request
- Push the image to the registry and gate the merge on a green run

## Before you start

- [GitHub Actions — quick primer](../../github-actions/notes/0000-primer-github-actions.md) — you know what a workflow, job, step, and runner are
- [CI/CD pipeline concepts](../../docs/concepts/ci-cd-pipeline-concepts/0000-primer-ci-cd-pipeline-concepts.md) — you understand stages, gates, and triggers
- [Build the sample app image](03-docker-sample-app-image.md) — you have a Dockerfile for the sample app and know how to build its image
- Confirm `gh` and Docker are available: `gh --version` and `docker --version`

## Walkthrough

1. Create the CI workflow file.

   The workflow lives at `.github/workflows/sample-app-ci.yml`. Write it with two jobs: one that builds and tests on every pull request, and one that pushes the image only on a push to master.

   ```yaml
   name: CI — sample app

   on:
     pull_request:
       branches: [master]
     push:
       branches: [master]

   permissions:
     contents: read

   jobs:
     build-and-test:
       name: Build and test
       runs-on: ubuntu-latest
       steps:
         - name: Checkout the repository
           uses: actions/checkout@v4
         - name: Set up Python
           uses: actions/setup-python@v5
           with:
             python-version: "3.12"
         - name: Install dependencies
           run: |
             python -m pip install --upgrade pip
             pip install -r requirements.txt
             pip install pytest
         - name: Run tests
           run: pytest
         - name: Build the sample app image
           run: docker build -t sample-app:${{ github.sha }} .

     push-to-registry:
       name: Push image to registry
       needs: build-and-test
       if: github.event_name == 'push'
       runs-on: ubuntu-latest
       steps:
         - name: Checkout the repository
           uses: actions/checkout@v4
         - name: Log in to GitHub Container Registry
           uses: docker/login-action@v3
           with:
             registry: ghcr.io
             username: ${{ github.actor }}
             password: ${{ secrets.GITHUB_TOKEN }}
         - name: Build and push the image
           run: |
             docker build -t ghcr.io/${{ github.repository_owner }}/sample-app:${{ github.sha }} .
             docker push ghcr.io/${{ github.repository_owner }}/sample-app:${{ github.sha }}
   ```

   A completed version is checked in at [`../../github-actions/configs/sample-app-ci.yml`](../../github-actions/configs/sample-app-ci.yml).

   You should see a valid workflow file with a `build-and-test` job gating a `push-to-registry` job.

2. Commit and push, then watch the run.

   ```bash
   git add .github/workflows/sample-app-ci.yml
   git commit -m "Add CI workflow for the sample app"
   git push
   gh run list
   ```

   You should see a new run with both jobs, and the `push-to-registry` job only appearing after `build-and-test` passes.

## Exercise

Add a second workflow file `.github/workflows/sample-app-ci-pr.yml` that runs only on pull requests (not on push), reuses the same build-and-test steps, and adds a comment explaining what each step does. Run it against a test branch and confirm the image-push job does not run on a pull request.

## Check your work

- `gh run list` shows a run triggered by your push.
- The run has a `build-and-test` job that completes green.
- On a push to master, a `push-to-registry` job runs only after `build-and-test` succeeds.
- On a pull request, no image-push job runs.

## Common mistakes

- Forgetting `needs: build-and-test` on the push job, which lets the image push start before the build finishes.
- Pushing an unpinned image tag; always tag with `${{ github.sha }}` so each deployable image is traceable to a commit.
- Placing the workflow file at the repo root instead of `.github/workflows/`, where GitHub Actions will not pick it up.

## Next

[Application security testing — SAST, DAST, SCA and secrets](../../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md)