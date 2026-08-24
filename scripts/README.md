# Scripts Repository

This directory contains production-ready scripts for DevOps workflows. Scripts are organized by language and include comprehensive documentation, safety features, and error handling.

## Organization

```
scripts/
├── README.md                      # This file
├── bump-version.sh                # Version bumper (root-level)
├── patch-report.sh                # Patch management report generator (root-level)
├── triage-vulnerabilities.sh      # Vulnerability triage helper (root-level)
├── pipeline/                      # Deployment pipeline wrappers
│   ├── deploy.sh
│   └── rollback.sh
└── bash/                          # Shell scripts by tool domain
    ├── ansible_toolkit/
    ├── argo_toolkit/
    ├── azure_toolkit/
    ├── ci_cd_toolkit/
    ├── docker_toolkit/
    ├── flux_toolkit/
    ├── git_toolkit/
    ├── harbor/
    ├── helm_toolkit/
    ├── jenkins_toolkit/
    ├── k8s_toolkit/
    ├── kafka_toolkit/
    ├── linux_toolkit/
    ├── observability_toolkit/
    ├── oci_registry_toolkit/
    ├── terraform_toolkit/
    ├── trivy_toolkit/
    └── vault_toolkit/
```

### Root-level scripts

The root-level scripts (`bump-version.sh`, `patch-report.sh`, `triage-vulnerabilities.sh`, and `pipeline/`) are intentionally kept at the repo root because multiple docs reference them with relative paths like `./scripts/pipeline/deploy.sh`. Moving them into a toolkit subdirectory would break those references. If you reorganize, update the referencing docs at the same time.

## Standards

All scripts in this repository MUST include:

1. **Header documentation**: purpose, usage, requirements, safety notes
2. **Safe defaults**: Conservative defaults that prevent accidental harm
3. **Error handling**: Clear error messages and exit codes
4. **Dry-run mode**: For any operation that modifies state
5. **Logging**: Consistent output format (info/warn/error)
6. **Validation**: Input validation and pre-flight checks

### Bash Standards
```bash
#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
IFS=$'\n\t'        # Proper field splitting
```

### Python Standards
```python
#!/usr/bin/env python3
import argparse
import sys
# Clear error messages, proper exit codes
```

### PowerShell Standards
```powershell
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
```

## Shared Libraries

Common functionality is extracted to `scripts/lib/`:

- **logging.sh** / **logging.py** - Unified logging functions
- **retry.sh** / **retry.py** - Retry logic with backoff
- **config.sh** / **config.py** - Configuration parsing
- **k8s-common.sh** - Kubernetes command wrappers

## Safety Policy

- **No destructive operations without explicit confirmation**
- **Dry-run must be supported for any state-changing operation**
- **Clear preconditions and assumptions documented**
- **Graceful degradation when optional dependencies missing**

## Usage

Make scripts executable:
```bash
chmod +x bash/<tool_name>/*.sh
```

Run with `--help` to see options:
```bash
bash/k8s_toolkit/node/drain-node.sh --help
```
