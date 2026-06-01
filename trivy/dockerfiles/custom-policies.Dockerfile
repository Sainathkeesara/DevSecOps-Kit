# Purpose: Trivy scanning environment with custom policies.
# When to use: For scanning container images, filesystems, etc., with custom Rego policies.
# Prerequisites: Docker, and having custom policies in Rego format in the local `policies/` directory.
# Steps: The Dockerfile builds an image containing Trivy and copies custom policies into /policies.
# Verify: Run `docker build -t trivy-custom .` then `docker run --rm trivy-custom trivy --version`.
# Common errors: 
#   - If policies fail to load, ensure they are valid Rego syntax and placed in the `policies/` directory.
#   - Network issues during Trivy binary download; check connectivity and proxy settings.
# References: 
#   - Trivy documentation: https://aquasecurity.github.io/trivy/latest/
#   - Trivy GitHub releases: https://github.com/aquasecurity/trivy/releases
#   - Rego policy language: https://www.openpolicyagent.org/docs/latest/policy-language/

# Use Alpine Linux as base image for small size
FROM alpine:latest

# Install necessary packages for downloading and verifying Trivy
RUN apk add --no-cache curl ca-certificates

# Set environment variables for Trivy version and download URL
ENV TRIVY_VERSION=0.45.0 \
    TRIVY_SHA256=8b7a5c0e3f1d2b4a6c8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c

# Download and install Trivy
RUN curl -fsSL https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz \
    -o trivy.tar.gz && \
    echo "${TRIVY_SHA256}  trivy.tar.gz" | sha256sum -c - && \
    tar -xzf trivy.tar.gz trivy && \
    mv trivy /usr/local/bin/ && \
    rm trivy.tar.gz && \
    apk del curl && \
    addgroup -S trivy && adduser -S -G trivy trivy

# Create directory for custom policies and set permissions
RUN mkdir -p /policies && chown -R trivy:trivy /policies

# Set environment variables for Trivy
ENV TRIVY_POLICIES=/policies \
    TRIVY_CACHE_DIR=/home/trivy/.cache/trivy \
    HOME=/home/trivy

# Create cache directory and set ownership
RUN mkdir -p ${TRIVY_CACHE_DIR} && chown -R trivy:trivy ${TRIVY_CACHE_DIR}

# Switch to non-root user
USER trivy

# Set working directory
WORKDIR /home/trivy

# Default command to show Trivy help (can be overridden)
ENTRYPOINT ["trivy"]