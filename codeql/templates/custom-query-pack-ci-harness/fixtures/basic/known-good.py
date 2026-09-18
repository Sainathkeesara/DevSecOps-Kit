# last_verified: 2026-09-18 · codeql n/a
# Known-good fixture: no hardcoded secrets
import os

db_password = os.environ.get("DB_PASSWORD", "")
api_token = os.environ.get("API_TOKEN", "")
