# last_verified: 2026-08-05 · docker n/a

# Purpose: scaffold a minimal multi-service Docker Compose application
# with a web service and a Redis cache, then build and start it.
# This script is intended as a starting point for learners exploring
# Docker Compose at L3; it demonstrates service definition, build
# context, and basic verification.

set -e

PROJECT_DIR="multi-service-compose"
COMPOSE_FILE="${PROJECT_DIR}/docker-compose.yml"
WEB_DIR="${PROJECT_DIR}/web"

echo "Creating project structure in ${PROJECT_DIR}/"
mkdir -p "${WEB_DIR}"

cat > "${COMPOSE_FILE}" << 'COMPOSE_EOF'
version: "3.8"

services:
  web:
    build: ./web
    ports:
      - "8080:8080"
    depends_on:
      - cache
    environment:
      - REDIS_HOST=cache

  cache:
    image: redis:7-alpine
    ports:
      - "6379:6379"
COMPOSE_EOF

cat > "${WEB_DIR}/Dockerfile" << 'DOCKERFILE_EOF'
FROM python:3.11-alpine
WORKDIR /app
COPY app.py .
RUN pip install --no-cache-dir redis
EXPOSE 8080
CMD ["python", "app.py"]
DOCKERFILE_EOF

cat > "${WEB_DIR}/app.py" << 'APP_EOF'
import os
import time
import redis
from http.server import HTTPServer, BaseHTTPRequestHandler

REDIS_HOST = os.environ.get("REDIS_HOST", "localhost")
r = redis.Redis(host=REDIS_HOST, port=6379, decode_responses=True)

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            r.ping()
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"OK - Redis connected")
        except Exception:
            self.send_response(503)
            self.end_headers()
            self.wfile.write(b"Service Unavailable")

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), Handler)
    server.serve_forever()
APP_EOF

echo "Building and starting services with docker compose..."
docker compose -f "${COMPOSE_FILE}" build
docker compose -f "${COMPOSE_FILE}" up -d

echo "Waiting for services to be ready..."
sleep 5

echo "Verifying services are running..."
docker compose -f "${COMPOSE_FILE}" ps

echo "Testing web endpoint..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ || true)
if [ "${HTTP_STATUS}" = "200" ]; then
    echo "Web service responded with 200 — compose app is healthy."
else
    echo "Web service returned status ${HTTP_STATUS} — check logs with:"
    echo "  docker compose -f ${COMPOSE_FILE} logs web"
fi

echo "Done. To tear down: docker compose -f ${COMPOSE_FILE} down"