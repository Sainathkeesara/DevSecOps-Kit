---
last_verified: 2026-10-23
tool_version: "n/a"
sources: []
---
# DefectDojo Scan Ingestion Starter

## Purpose
This scaffold provides a minimal, runnable DefectDojo deployment with pre-configured scripts for product/engagement setup and scan report ingestion. It is designed for teams that want to integrate scanner output (Trivy, Grype, Semgrep, ZAP, SARIF) into DefectDojo via CI pipelines without building the integration from scratch.

## When to use
- Evaluating DefectDojo for vulnerability management
- Building a CI pipeline that imports scan results on every commit
- Needing a local DefectDojo instance for development and testing
- Wanting a reference implementation of the reimport-scan pattern for deduplication

## Prerequisites
- Docker and Docker Compose v2+
- Python 3.8+ with `requests` library (`pip install requests`)
- 4 GB available RAM for the DefectDojo stack
- Ports 8080 (DefectDojo UI) and 5432 (PostgreSQL) free on the host

## Directory structure
```
defectdojo-scan-ingestion-starter/
├── docker-compose.yaml          # DefectDojo + PostgreSQL stack
├── .env.example                 # Environment variable template
├── configs/
│   └── scanner-configs.yaml     # Supported scanner types and mappings
└── scripts/
    ├── setup-product-engagement.py  # Create/retrieve product and engagement
    └── import-scan.py               # Import scan report via reimport-scan
```

## Quick start

### 1. Start the stack
```bash
cp .env.example .env
# Edit .env to set a secure database password
docker compose up -d
```

Wait for the health check to pass (approximately 2-3 minutes on first start). The UI will be available at `http://localhost:8080` with default credentials `admin` / `admin`.

### 2. Create an API token
1. Log in to the DefectDojo UI
2. Navigate to **User Settings** → **API Token** → **Add API Token**
3. Copy the token (it will not be shown again)

### 3. Configure environment
```bash
export DEFECTDOJO_TOKEN="<your-api-token>"
export DEFECTDOJO_URL="http://localhost:8080"
export PRODUCT_NAME="my-application"
export ENGAGEMENT_NAME="ci-scan"
```

### 4. Create product and engagement
```bash
pip install requests
python3 scripts/setup-product-engagement.py
```

The script outputs `product_id` and `engagement_id`. Re-running with the same names is idempotent.

### 5. Generate a scan report
Run your scanner and produce JSON or SARIF output. Examples:

| Scanner | Command | DefectDojo scan_type |
|---------|---------|----------------------|
| Trivy | `trivy image --format json --output report.json myapp:latest` | `Trivy Scan` |
| Grype | `grype myapp:latest -o json > report.json` | `Grype Scan` |
| Semgrep | `semgrep scan --json=report.json` | `Semgrep JSON Report` |
| ZAP | `zap-api-scan.py -t <target> -r report.json` | `ZAP Scan` |
| Generic SARIF | Any tool producing SARIF 2.1.0 | `SARIF` |

### 6. Import the report
```bash
python3 scripts/import-scan.py report.json "Trivy Scan"
```

The script uses the `reimport-scan` endpoint, which updates the existing Test and closes findings no longer present in the new report — preventing duplicate Test accumulation in CI.

## Configuration

### Environment variables (.env)
| Variable | Description | Default |
|----------|-------------|---------|
| `DD_DATABASE_PASSWORD` | PostgreSQL password for DefectDojo | **Required** - change from example |
| `DD_SECRET_KEY` | Django secret key | **Required** - generate with `openssl rand -base64 32` |
| `DD_ADMIN_PASSWORD` | Initial admin user password | `admin` (change in production) |
| `DD_TIME_ZONE` | Container timezone | `UTC` |

### Scanner configs (configs/scanner-configs.yaml)
Maps scanner command output to DefectDojo scan_type strings. Extend this file when adding new scanners.

## Verify
- DefectDojo UI loads at `http://localhost:8080`
- Product and engagement appear under **Products** → `<PRODUCT_NAME>` → **Engagements**
- Imported scan appears as a **Test** under the engagement
- Findings are listed with severity, file path, and line number
- Re-running the import with an updated report updates the same Test (deduplication)

## Common errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `docker compose up` fails with port conflict | Port 8080 or 5432 already in use | Stop the conflicting service or change ports in `docker-compose.yaml` |
| `HTTP 403` on script execution | API token lacks write permissions | Ensure token belongs to a user with Product/Engagement/Test write roles |
| `HTTP 404` on `/api/v2/reimport-scan/` | API v2 not enabled or wrong URL | Verify `DEFECTDOJO_URL` includes the base path (no trailing `/api/v2`) |
| Findings not appearing | Wrong `scan_type` (case-sensitive) | Match exactly: `Trivy Scan`, `Semgrep JSON Report`, `SARIF`, etc. |
| Duplicate Tests on each CI run | Using `import-scan` instead of `reimport-scan` | The provided `import-scan.py` uses `reimport-scan` |
| Product type not found | Default product_type ID 1 missing | Create a Product Type in UI first, or specify `--product-type` |
| Database connection refused | PostgreSQL not ready | Wait for health check; increase `start_period` in compose if needed |

## Customization

### Adding a new scanner
1. Add the scanner's `scan_type` to `configs/scanner-configs.yaml`
2. Verify the scan_type matches a DefectDojo parser (check `/api/v2/doc/` on your instance)
3. Update CI pipeline to run the scanner and call `import-scan.py` with the new type

### Using an external database
Replace the `db` service in `docker-compose.yaml` with environment variables pointing to your managed PostgreSQL instance:
```yaml
environment:
  DATABASE_URL: postgres://user:pass@host:5432/defectdojo
```

### Production hardening
- Generate a strong `DD_SECRET_KEY` and `DD_DATABASE_PASSWORD`
- Set `DD_DEBUG=false` in the environment
- Configure TLS termination at a reverse proxy (nginx, Traefik)
- Enable PostgreSQL backups and DefectDojo media volume snapshots
- Use a dedicated service account for CI tokens with minimal permissions

## References
- DefectDojo documentation: `https://defectdojo.github.io/`
- DefectDojo API v2 docs: `/api/v2/doc/` on your running instance
- Kit integration docs: `defectdojo/docs/defectdojo-scan-tool-ingestion-end-to-end.md`
- Kit triage workflow: `defectdojo/docs/how-i-wired-defectdojo-into-my-triage-workflow.md`
- Source scripts (adapted for this scaffold): `defectdojo/scripts/product-engagement-setup.py`, `defectdojo/scripts/product-scan-import.py`