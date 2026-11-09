---
last_verified: 2026-11-04
tool_version: v0.76.1
sources:
  - https://trivy.dev/docs/latest/configuration/filtering/
  - https://github.com/aquasecurity/trivy/releases
---

# Gate the image on Trivy findings in CI

You can build and push the sample app image on every merge to master. The missing piece is a gate: a broken build should stop a vulnerable image from shipping. This lesson continues from the sample-app CI lesson, where you built and pushed the image, and adds a Trivy scan job that fails the run on HIGH and CRITICAL findings — then shows how to accept a known finding with a dated justification instead of ignoring it forever.

## What you'll learn

- Scan the built image in CI and fail on HIGH and CRITICAL
- Ignore an accepted finding with a dated justification

## Before you start

- [First win: find a secret and a vulnerable package](../01-foundations/08-first-scan.md) — you've run Trivy against files and read a vulnerable-package finding
- [CI for the sample app — build, test and push](../02-build-and-ship/06-gha-sample-app-ci.md) — you have a GitHub Actions workflow that builds the sample app image on push
- `trivy` installed. Confirm with `trivy --version`.
- `jq` installed. Confirm with `jq --version`.

## Walkthrough

1. Add a Trivy scan job to the CI workflow.

   Add a `trivy-scan` job that runs after `build-and-test`, scans the image just pushed, and fails the run when Trivy finds HIGH or CRITICAL vulnerabilities. Trivy exits non-zero when findings match the severity filter, so a failing scan fails the job.

   ```yaml
   trivy-scan:
     name: Trivy image scan
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
       - name: Pull and scan the image
         run: |
           trivy image --severity HIGH,CRITICAL \
             --ignore-unfixed \
             ghcr.io/${{ github.repository_owner }}/sample-app:${{ github.sha }}
   ```

   The severity filter is uppercase (`HIGH,CRITICAL`); lowercase matches everything and returns unfiltered results. The complete workflow is checked in at [`../../trivy/configs/trivy-ci-gate.yml`](../../trivy/configs/trivy-ci-gate.yml).

   You should see a valid workflow with a `trivy-scan` job that needs `build-and-test` and only runs on pushes to master.

2. Commit and push, then watch the run fail on a vulnerable image.

   ```bash
   git add .github/workflows/sample-app-ci.yml
   git commit -m "Add Trivy image scan gate to CI"
   git push
   gh run list
   gh run view <run-id>
   ```

   You should see the `trivy-scan` job start after `build-and-test` passes, Trivy download its vulnerability database on the first run, and the job fail when HIGH or CRITICAL findings are present. The first run can take several minutes while the database downloads (hundreds of MB); pre-fetch it locally with `trivy image --download-db-only` if you iterate on the workflow.

   If the image is clean, the job passes — that's the gate working as intended. To see the failure path, scan an image you know carries a HIGH or CRITICAL package.

3. Accept a known finding with a dated justification.

   Instead of disabling the gate, record an accepted risk in `.trivyignore` with an expiration date and a reason. Create `.trivyignore` at the repository root:

   ```text
   # Accepted risk — CVE-2019-14697 is mitigated by a network policy;
   # revisit before this expires.
   CVE-2019-14697 exp:2027-01-01
   ```

   `.trivyignore` accepts dated entries such as `CVE-2019-14697 exp:2023-01-01`. Re-run the scan: the accepted finding no longer fails the job, and the date forces a review before it silently expires. For richer suppression (statements, paths, pURLs), use `.trivyignore.yaml` or VEX via `--ignorefile`.

   You should see the finding count drop by one and the job pass.

## Exercise

On your own, extend the CI workflow so the Trivy job:

- Runs on every pull request as well as on push to master (so a vulnerable image never reaches a reviewable branch).
- Writes a SARIF report to `trivy-results.sarif` and uploads it as a workflow artifact so reviewers can inspect findings without re-running the scan.

Do not change the severity gate — keep `HIGH,CRITICAL` failing. Test it on a branch, confirm a vulnerable image fails the PR run, then add a dated `.trivyignore` entry for one finding and confirm the run passes again.

## Check your work

- `.github/workflows/sample-app-ci.yml` has a `trivy-scan` job that runs `trivy image --severity HIGH,CRITICAL` and fails non-zero on findings.
- `gh run list` shows a run triggered by your push or pull request.
- The `trivy-scan` job fails when the image carries HIGH or CRITICAL findings, and passes after you add a dated `.trivyignore` entry for an accepted finding.
- `trivy --version` reports Trivy v0.76.1 (or later) and `jq --version` reports jq.

## Common mistakes

- Using lowercase `--severity high,critical`, which matches everything and returns unfiltered results — the filter must be uppercase.
- Forgetting `needs: build-and-test`, which lets the scan start before the image is built.
- Treating `.trivyignore` as permanent: without an `exp:` date, an accepted finding is never re-reviewed. Always date it.
- Running the scan on the first push without the vulnerability database downloaded — the job appears to hang; pre-fetch with `trivy image --download-db-only`.

## Next

[Produce and read an SBOM with Syft](./10-syft-sbom.md)