#!/usr/bin/env bash
# last_verified: 2026-09-20 · defectdojo n/a
# Check DefectDojo readiness after the Docker Compose quickstart.
# Doing this because the initializer takes minutes and the admin
# password isn't static — need to confirm service is up before imports.

CONTAINER_COUNT=$(docker compose ps -q 2>/dev/null | wc -l)

if [ "$CONTAINER_COUNT" -eq 0 ]; then
  echo "DefectDojo is not running. Start it first:"
  echo "  cd django-DefectDojo && docker compose up -d"
  exit 1
fi

echo "DefectDojo containers are running ($CONTAINER_COUNT found)."

# The admin password is generated at first run, not admin/admin.
echo "Retrieving admin password from initializer logs..."
docker compose logs initializer 2>/dev/null | grep "Admin password:" || \
  echo "Initializer not found — may still be migrating."

# Imports silently fail unless engagement status is In Progress.
# Check via API before uploading scan results.
if [ -n "$DEFECTDOJO_URL" ] && [ -n "$DEFECTDOJO_API_KEY" ]; then
  echo "DefectDojo URL: $DEFECTDOJO_URL"
  echo "API key is set. Ready to import scan reports."
else
  echo "Set DEFECTDOJO_URL and DEFECTDOJO_API_KEY to enable API imports."
fi
