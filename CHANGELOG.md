# Changelog

All notable changes to the DevSecOps-Kit repository will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## 2026-11-10

### Added
- defectdojo-017: `learn/03-shift-left/14-defectdojo-findings.md` — Bring all findings together in DefectDojo: import Gitleaks, Semgrep, Trivy, and ZAP results into one product and engagement, enable deduplication and finding closure, triage findings in the UI (L3 lesson)
- defectdojo-017: `learn/03-shift-left/13-zap-baseline.md` — Updated `## Next` link to point at the new DefectDojo findings lesson

## 2026-11-06

### Added
- syft-027: `learn/03-shift-left/10-syft-sbom.md` — Produce and read an SBOM with Syft: generate SPDX and CycloneDX SBOMs for an image and locate a package+version in each format (L2 lesson)
- syft-027: `learn/03-shift-left/09-trivy-ci-gate.md` — Updated `## Next` link to point at the new Syft SBOM lesson

## 2026-11-05

### Added
- gitleaks-013: `learn/03-shift-left/03-gitleaks-in-ci.md` — Catch secrets before they land with Gitleaks (L2 lesson)
## 2026-11-04

### Added
- trivy-028: `learn/03-shift-left/09-trivy-ci-gate.md` — Gate the image on Trivy findings in CI: add a Trivy image-scan job that fails on HIGH and CRITICAL, and accept a known finding with a dated `.trivyignore` entry (L2 lesson)
- trivy-028: `trivy/configs/trivy-ci-gate.yml` — Trivy config for the CI image-scan gate lesson (severity CRITICAL/HIGH, exit-code 1, ignorefile .trivyignore)

## 2026-11-03

### Added
- github-actions-014: `learn/02-build-and-ship/06-gha-sample-app-ci.md` — CI for the sample app — build, test and push: write a GitHub Actions workflow that builds and tests on every pull request and gates the merge on a green run (L2 lesson)
- github-actions-014: `github-actions/configs/sample-app-ci.yml` — companion CI workflow file for the sample app (L2 lesson)

## 2026-11-02

### Added
- docker-017: `learn/01-foundations/07-lab-setup.md` — Set up the lab and the sample app: install Docker, kind and a local registry, confirm each works, clone the sample app and list its planted security issues (L1 lesson)

## 2026-10-31

### Added
- data-formats-001: `learn/01-foundations/06-yaml-json-jq-regex.md` — YAML, JSON, jq and regex for security tooling: write YAML and JSON that validate, filter scanner JSON output with jq, and write a simple regex that matches a token pattern (L1 lesson)
- linux-040: `learn/01-foundations/02-shell-scripting.md` — Navigate and script on Linux: navigate and inspect files with `pwd`/`cd`/`ls -la`, find files by name and type with `find`, write a shell script that finds large log files with correct quoting and exit codes, then make it pass ShellCheck; companion script `linux/scripts/find-large-logs.sh` (L1 lesson)

## 2026-10-28

### Added
- kubernetes-016: `kubernetes/templates/cluster-bootstrap/` — Cluster bootstrap: CNI, CSI, Ingress, Cert-Manager template: Calico CNI namespace, CSI StorageClass reference, IngressClass plus sample Ingress, and Cert-Manager namespace (L4 template)

## 2026-10-29

### Added
- grype-047: `grype/snippets/2026-10-27-grype-filter-severity-formats.sh` — Grype vulnerability scan: filter by severity and output formats (L2 snippet)
- opa-023: `opa/notes/2026-10-27-opa-install-first-policy.md` — Install OPA and run first Rego policy evaluation (L2 notes)
- snyk-018: `snyk/notes/2026-10-27-snyk-quickstart-tripped.md` — Follow the official Snyk quickstart and write up what tripped me up (L2 notes)
- cosign-020: `cosign/docs/keyless-signing-patterns.md` — Keyless signing with Fulcio and Rekor in production: OIDC federation, digest signing, verification gates, and common error patterns

## 2026-10-27

### Added
- codeql-023: `codeql/notes/2026-10-27-install-codeql-first-query.md` — CodeQL CLI install and first query on a sample Java repo: database creation, built-in security query, SARIF output, and first-contact trip-ups (L1 notes)
- codeql-024: `codeql/snippets/2026-10-27-hardcoded-secrets.ql` — Small CodeQL query flagging string literals that look like database connection strings with embedded credentials (L1 snippet)
- syft-024: `syft/notes/2026-10-27-first-image-sbom.md` — Syft install and first SBOM from a container image archive: table and JSON output, trip-ups, and what's next (L1 notes)
- argocd-045: `argocd/templates/app-of-apps-multienv/` — ArgoCD App of Apps scaffold: root Application watching per-environment child Applications (development, staging, production), Helm-based frontend service with per-env values overrides, and a bootstrap apply script (L4 template)

## 2026-10-26

### Added
- gitleaks-012: `gitleaks/configs/gitleaks-config.toml` — Gitleaks TOML config with CLI-flag equivalents annotated per block (source, reporting format/path) plus rule and allowlist samples (L3 config)
- grafana-010: `grafana/docs/grafana-alerting-routing-templates.md` — Grafana alerting: alert rules, notification policy routing, and Go notification templates (L3 docs)
- grafana-011: `grafana/manifests/grafana-datasource-dashboard.yaml` — Grafana on Kubernetes: Prometheus datasource, dashboard provider and dashboards ConfigMaps, Deployment, and Service (L3 manifest)

## 2026-10-25

### Added
- environments-013: `environments/manifests/kubernetes-namespaces.yaml` — Kubernetes namespaces for dev, staging, prod with resource quotas and limit ranges per environment (L3 manifest)
- lab-005: `lab/notes/2026-10-25-lab-quickstart-trips.md` — Followed the lab quickstart and wrote up what tripped me up: config doesn't run itself, port mapping in compose vs config, shared network not automatic, postgres init order, README/config separation (L2 notes)
- lab-006: `lab/snippets/2026-10-25-minimal-lab-env.py` — Minimal lab environment setup with Python: reads lab YAML config, generates Dockerfile, builds image, optionally runs container with port mapping (L2 snippet)
- lab-007: `lab/configs/2026-10-25-multi-node-demo.yaml` — Lab configuration for multi-node demo: three-node practice cluster (load balancer, app, database) with depends_on, network, and rebuild notes (L2 config)
- prometheus-044: `prometheus/notes/2026-10-25-followed-quickstart.md` — Followed the official Prometheus quickstart and wrote up what tripped me up: scrape config indentation, node_exporter separate binary, relabeling syntax, no default auth, retention defaults (L2 notes)
- prometheus-045: `prometheus/snippets/2026-10-25-minimal-scrape-config.yaml` — Minimal Prometheus scrape config for a demo app: global scrape interval, self-scrape, demo app target, node_exporter target with component labels (L2 snippet)
- prometheus-046: `prometheus/scripts/2026-10-25-query-api-python.py` — Run Prometheus query API from Python: instant/range queries, metadata, series matching, stdlib-only HTTP client (L2 script)

### Passed
- Passed ([x]) environments-011 — Build environment promotion workflow from scratch · Level: L3 · 2026-10-25
- Passed ([x]) environments-012 — Managing dev/staging/prod with environments tool · Level: L3 · 2026-10-25

## 2026-10-24

### Added
- kustomize-010: `kustomize/docs/how-i-wired-kustomize-into-my-manifest-workflow.md` — How Kustomize is wired into a multi-environment manifest workflow: base/overlay layout, ConfigMap/Secret generators with replace behavior, CI render/validate with kubeconform, image promotion via kustomize edit, component reuse, and common error resolutions (L3 docs)
- con-167: `docs/concepts/application-security-testing-concepts/snippets/2026-10-24-appsec-common-patterns.sh` — Application Security Testing common patterns: SAST/DAST/SCA pipeline snippets, tool matrix, Semgrep/CodeQL/Trivy/Syft/ZAP usage patterns (L2 snippet)
- con-170: `docs/concepts/container-runtime-security/scripts/2026-10-24-applying-runtime-controls.sh` — Container Runtime Security practice: drop capabilities, readonly rootfs, non-root user, seccomp profiles, no-new-privileges, Kubernetes PodSecurityContext, Falco rule triggers (L2 script)
- docs-029: `README.md` — Corrected "What's in here" claims to reflect 1187 files across 43 top-level folders (37 tool folders + 6 cross-cutting) (L1 docs)
- opa-021: `opa/notes/2026-10-24-install-opa-first-policy-eval.md` — First install of OPA and my first policy evaluation: wrote a tiny Rego allow rule, fed it a sample input, and read the allow/deny result back (L1 notes)