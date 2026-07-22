# last_verified: 2026-07-22 · CodeQL n/a
ARG CODEQL_BUNDLE_URL
FROM ubuntu:22.04

LABEL org.opencontainers.image.title="Custom CodeQL Analysis Image"
LABEL org.opencontainers.image.description="CodeQL CLI with preloaded bundle and custom queries"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sSfL "${CODEQL_BUNDLE_URL}" | tar -xz -C /usr/local && \
    ln -s /usr/local/codeql/codeql /usr/local/bin/codeql

COPY queries/ /codeql/queries/

WORKDIR /repo

ENTRYPOINT ["codeql"]
CMD ["database", "create", "codeql-db", "--language=python", "--command=python3 -m py_compile main.py"]
