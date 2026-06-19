FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /app/server .

FROM alpine:3.20 AS sbom-stage
COPY --from=anchore/syft:v1.6.0 /syft /usr/local/bin/syft
COPY --from=builder /app /app
RUN syft dir:/app -o cyclonedx-json > /sbom.cdx.json
RUN syft dir:/app -o spdx-json > /sbom.spdx.json

FROM alpine:3.20
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/server /server
COPY --from=sbom-stage /sbom*.json /sboms/
EXPOSE 8080
CMD ["/server"]
