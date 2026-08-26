# last_verified: 2026-08-25 · cosign n/a

FROM gcr.io/distroless/static-debian12:latest AS base

FROM golang:1.24-alpine AS builder

WORKDIR /src

RUN apk add --no-cache git make

ARG COSIGN_VERSION=v2.4.1

RUN git clone --depth 1 --branch ${COSIGN_VERSION} https://github.com/sigstore/cosign.git . \
    && CGO_ENABLED=0 go build -ldflags="-s -w" -o /cosign ./cmd/cosign

FROM base

COPY --from=builder /cosign /cosign

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]