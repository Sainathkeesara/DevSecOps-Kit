#!/usr/bin/env bash
# Start DefectDojo locally with Docker Compose

git clone https://github.com/DefectDojo/django-DefectDojo.git
cd django-DefectDojo && docker compose up -d

echo "Open http://localhost:8080 — admin / admin"
echo "Upload a scan report via the web UI or DefectDojo API"
# TODO: try the REST API import with curl instead of the UI
