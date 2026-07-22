# last_verified: 2026-07-22 · HashiCorp Vault n/a
# Purpose: Custom Vault Docker image with pre-configured TLS and plugins.
#          Plugins are bundled into the image so a single container can start
#          with all required secrets engines enabled.
# Usage:
#   docker build --build-arg VAULT_BASE_IMAGE=hashicorp/vault:1.15.0 \
#     -t custom-vault:latest -f custom-vault-image-with-plugins-tls.Dockerfile .
#   docker run --cap-add IPC_LOCK -e VAULT_DEV_ROOT_TOKEN_ID=root custom-vault:latest

ARG VAULT_BASE_IMAGE
FROM ${VAULT_BASE_IMAGE}

LABEL org.opencontainers.image.title="Custom Vault"
LABEL org.opencontainers.image.description="Vault with bundled plugins and TLS configuration"

RUN mkdir -p /etc/vault/plugins /etc/vault/config && \
    chown -R vault:vault /etc/vault

COPY --chown=vault:vault config/vault.hcl /etc/vault/config/vault.hcl
COPY --chown=vault:vault plugins/ /etc/vault/plugins/

ENV VAULT_ADDR=https://127.0.0.1:8200

EXPOSE 8200

ENTRYPOINT ["vault", "server", "-config=/etc/vault/config/vault.hcl"]
