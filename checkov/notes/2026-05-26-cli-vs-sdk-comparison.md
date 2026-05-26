# 2026-05-26: CLI vs SDK scanning with Checkov

I tried both approaches for scanning a Terraform directory.

CLI is dead simple:
```bash
checkov -d terraform/
```
One command, rich output with colors, summary table at the end. Great for interactive use and quick CI integration. But filtering the output programmatically means piping through jq with `--output json`.

SDK approach:
```python
from checkov.main import Checkov
runner = Checkov()
report = runner.run(directory="terraform/")
# now I can iterate over findings, filter by severity, etc.
```
More code upfront but way more flexible — I can filter records, group by check_id, or fail the build only for specific policies without parsing CLI output.

What tripped me up: the SDK's `Checkov()` class isn't well documented outside the source. I had to read `checkov/main.py` to figure out the method signature. CLI docs are everywhere, SDK docs are sparse.

For quick ad-hoc scans, CLI wins. For automated pipelines where I need to enforce custom logic, SDK is worth the extra setup.
