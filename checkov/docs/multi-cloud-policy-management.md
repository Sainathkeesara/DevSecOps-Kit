---
last_verified: 2026-07-20
tool_version: 3.3.8
sources:
  - https://pypi.org/project/checkov
  - https://safeguard.sh/resources/blog/checkov-3-2-2026-iac-scanning-review
  - https://github.com/bridgecrewio/checkov/releases
---

# Checkov multi-cloud IaC policy management: AWS, Azure, and GCP drift detection patterns

## Purpose

Checkov scans infrastructure-as-code across AWS, Azure, and GCP from a single policy engine. This guide covers how to run one scan across a multi-cloud estate, how Checkov's graph-based analysis catches cross-resource misconfigurations, and the patterns teams use to surface and manage configuration drift between the IaC you declared and the cloud you actually have.

## When to use

- You manage Terraform (or OpenTofu, CloudFormation, ARM, Bicep) that provisions resources in more than one cloud.
- You want built-in CIS/PCI/HIPAA/SOC2 mappings applied uniformly instead of maintaining three separate scanners.
- You need to detect drift: resources changed out-of-band in the console that your IaC no longer describes.

## Prerequisites

- Checkov 3.x installed. The current release is **3.3.8** (released 2026-07-09; the prior 3.3.7 shipped 2026-07-07) [source: https://github.com/bridgecrewio/checkov/releases] [source: https://pypi.org/project/checkov].
- Your IaC directories for each provider present on disk (e.g. `aws/`, `azure/`, `gcp/`).
- For drift detection, cloud credentials with read access to the relevant accounts so Checkov can compare live state against the plan.
- A `.checkov.yaml` to pin behaviour across the team (see Configuration-as-code below).

## Steps

### 1. Scan each provider from one engine

Checkov discovers the provider from the IaC framework. Run the same command per directory:

```bash
# AWS (Terraform)
checkov -d aws/ --output cli --output sarif --report --output-file-path out/aws

# Azure (ARM / Bicep)
checkov -d azure/ --output cli

# GCP (Terraform)
checkov -d gcp/ --output cli
```

Checkov ships roughly 1,400 built-in policies across AWS/Azure/GCP with CIS/PCI/HIPAA/SOC2 mappings, so the same run surfaces provider-specific misconfigurations without per-cloud rule files [source: https://safeguard.sh/resources/blog/checkov-3-2-2026-iac-scanning-review].

### 2. Rely on graph-based, cross-resource analysis

Checkov builds an in-memory graph of resource relationships rather than scanning single attributes in isolation. This is what lets it flag an S3 bucket as public when the exposure comes from a bucket policy or a `PublicAccessBlock` declared on a *different* resource [source: https://safeguard.sh/resources/blog/checkov-3-2-2026-iac-scanning-review]. The same pattern applies across clouds — an Azure Storage account flagged via its network rules, or a GCP bucket flagged via its IAM bindings.

### 3. Pin behaviour with config-as-code

Persist flags to a `.checkov.yaml` so every developer and the CI runner scan identically:

```yaml
# .checkov.yaml
soft-fail: false
framework:
  - terraform
  - bicep
  - arm
output:
  - cli
  - sarif
output-file-path: out/
```

Resolution order is run-dir → CWD → home, and you can inspect what actually loaded with `--show-config`. Create it once with `--create-config` [source: https://pypi.org/project/checkov].

### 4. Detect drift between IaC and live cloud

Checkov can compare a Terraform plan or live state against declared IaC:

```bash
# Enrich a plan scan with repo context
terraform show -json tf.plan > tf.json
checkov -f tf.json --repo-root-for-plan-enrichment .
```

For live drift on supported providers, Checkov's drift detection compares the IaC you declared with the cloud state and reports resources that diverged. Note that the richest drift-detection features (e.g. continuous cloud drift) are tied to the paid Bridgecrew platform; open-source Checkov covers plan/file-level scanning and local drift comparisons [source: https://safeguard.sh/resources/blog/checkov-3-2-2026-iac-scanning-review].

### 5. Suppress known false positives surgically

Prefer inline suppressions over global skips so the rule keeps protecting everything else:

```hcl
resource "aws_s3_bucket" "logs" {
  #checkov:skip=CKV_AWS_20:intentional public-read for anonymous log ingest
}
```

On Kubernetes, an `checkov.io/skip#:` annotation works the same way. Global `--skip-check` should be reserved for org-wide exceptions you have reviewed [source: https://pypi.org/project/checkov].

## Verify

1. Run the scan per provider and confirm the SARIF file lands in `out/` for GitHub code scanning.
2. Deliberately introduce a public-bucket misconfig split across two resources (bucket + `PublicAccessBlock`) and confirm graph analysis flags it — a single-attribute scanner would miss it.
3. Run `checkov --show-config` and confirm the resolved config matches `.checkov.yaml`.
4. For drift, introduce a console change the IaC does not describe and confirm Checkov reports the divergence.

## Common errors

| Error / symptom | Cause | Fix |
|-----------------|-------|-----|
| One cloud's resources not scanned | Wrong `framework` in `.checkov.yaml` | Add the framework (e.g. `bicep`, `arm`) to the list |
| Cross-resource finding missing | Single-attribute mental model | Trust the graph; the blocker may be on a sibling resource |
| Drift features unavailable | Assuming they are all open-source | Use plan/file-level drift; cloud drift needs paid tier |
| Noisy repeated skips | Global `--skip-check` used for one-off cases | Move to inline `#checkov:skip=` |

## References

- [Checkov on PyPI (version 3.3.8)](https://pypi.org/project/checkov)
- [Checkov releases](https://github.com/bridgecrewio/checkov/releases)
- [Checkov 3.2 (2026) IaC scanning field review](https://safeguard.sh/resources/blog/checkov-3-2-2026-iac-scanning-review)
