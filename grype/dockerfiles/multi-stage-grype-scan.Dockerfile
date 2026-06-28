# syntax=docker/dockerfile:1
# Multi-stage Dockerfile with Grype vulnerability scanning stage.
#
# Stages:
#   builder   — compile a Go binary
#   grype-scan — run Grype against the binary for vulnerability detection
#   runtime   — minimal image with only the compiled binary
#
# Usage:
#   docker build --target runtime -t my-app:latest .
#   docker build --target grype-scan --output type=local,dest=./reports .

# --- Stage 1: Build ---
FROM golang:1.22-alpine AS builder

WORKDIR /src
RUN go mod init example.com/app 2>/dev/null || true
COPY <<EOF main.go
package main

import (
    "fmt"
    "net/http"
    "os"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintln(w, "hello")
    })
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }
    http.ListenAndServe(":"+port, nil)
}
EOF
RUN CGO_ENABLED=0 go build -o /app/server .

# --- Stage 2: Vulnerability scan ---
FROM alpine:3.20 AS grype-scan

RUN apk add --no-cache curl ca-certificates

ARG GRYPE_VERSION=0.77.1
RUN curl -sSfL "https://raw.githubusercontent.com/anchore/grype/main/install.sh" \
    | sh -s -- -b /usr/local/bin v${GRYPE_VERSION}

COPY --from=builder /app /scan-target
RUN grype dir:/scan-target --only-fixed -o json > /tmp/grype-report.json; \
    grype dir:/scan-target --only-fixed -o sarif > /tmp/grype-report.sarif; \
    echo "Grype scan complete — reports in /tmp/"

# --- Stage 3: Runtime ---
FROM alpine:3.20 AS runtime

RUN apk add --no-cache ca-certificates
COPY --from=builder /app/server /usr/local/bin/server
EXPOSE 8080
CMD ["server"]
