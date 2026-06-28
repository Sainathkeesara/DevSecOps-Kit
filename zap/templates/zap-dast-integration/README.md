# ZAP DAST Integration Scaffold

This template provides a GitHub Actions workflow that runs OWASP ZAP DAST scans using the Automation Framework.

## Prerequisites

- A target URL to scan (set as `TARGET_URL` repository variable or workflow input)
- GitHub repository with Actions enabled

## Files

- `.github/workflows/zap-dast.yml` — CI workflow definition
- `zap-automation-plan.yaml` — ZAP Automation Framework scan plan

## Usage

1. Copy `.github/workflows/zap-dast.yml` into your repository.
2. Copy `zap-automation-plan.yaml` into your repository root.
3. Set `TARGET_URL` in **Settings > Variables and secrets > Actions > Variables**.
4. Push to `main` or open a pull request to trigger the scan.

## Customization

Edit `zap-automation-plan.yaml` to adjust:
- Scan depth and duration (`maxDuration`, `maxDepth`)
- Alert thresholds (`alertThreshold`, `risk` levels in tests)
- Excluded content types (`excludePaths`)
- Active scan policy rules (`policyDefinition.rules`)

The workflow uploads the ZAP JSON report as an artifact and converts alerts to SARIF for GitHub Code Scanning.
