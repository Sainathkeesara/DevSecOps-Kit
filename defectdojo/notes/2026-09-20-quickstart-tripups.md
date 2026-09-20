---
last_verified: 2026-09-20
tool_version: 2.16.0
sources:
  - https://github.com/DefectDojo/django-DefectDojo/blob/main/readme-docs/quick_start.md
  - https://github.com/DefectDojo/django-DefectDojo
---

# Following the official DefectDojo quickstart — what tripped me up

I worked through the DefectDojo 2.16.0 quickstart (the Docker Compose path) and hit several things the happy path doesn't mention. Here's what the guide glosses over.

## The steps that "just worked"

Cloning and starting was straightforward:

```bash
git clone https://github.com/DefectDojo/django-DefectDojo.git
cd django-DefectDojo && docker compose up -d
```

The containers came up, and I could reach the UI at `http://localhost:8080`.

## Where I tripped

- **The default credentials aren't `admin/admin` anymore.** The initializer generates a random admin password on first run. You have to check the initializer logs:

  ```bash
  docker compose logs initializer | grep "Admin password:"
  ```

  The quickstart still says `admin/admin` in a few places, but that hasn't been true since the initializer was added.

- **Imports silently fail unless engagement status is "In Progress".** I created a product and engagement, uploaded a Trivy JSON report, and got a green success banner — but zero findings appeared. The engagement was still "Not Started". Changing it to "In Progress" and re-importing made the findings show up. This isn't called out in the quickstart.

- **The API token isn't created by default.** For CI integration you need an API v2 token. You generate it in the UI under **Settings → API v2 Tokens**, then use it as `Authorization: Token <token>`. The quickstart shows CLI examples but doesn't mention the token step.

- **Docker Compose data persists in named volumes, but the database migrations can take minutes.** The first `docker compose up` sits at "initializer" for 2–3 minutes while migrations run. If you `ctrl-c` too early, the DB ends up in a partial state and you need `docker compose down -v` to reset.

- **Scanner format matters.** I first exported Trivy output as table format (`trivy image --format table`), but DefectDojo only accepts JSON (`--format json`) or SARIF. The quickstart says "upload a scan report" but doesn't specify the format.

## What I'd try next

I want to automate the import via the REST API in a GitHub Actions workflow — trigger a Trivy scan, convert to JSON, POST to `/api/v2/import-scan/`, and link it to an engagement that's already set to "In Progress". Also need to figure out deduplication rules so re-scans don't create duplicate findings.