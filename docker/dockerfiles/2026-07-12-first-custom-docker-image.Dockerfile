# last_verified: 2026-07-12 · Docker n/a
FROM alpine:latest
RUN apk add --no-cache curl
CMD ["curl", "-s", "https://httpbin.org/get"]
