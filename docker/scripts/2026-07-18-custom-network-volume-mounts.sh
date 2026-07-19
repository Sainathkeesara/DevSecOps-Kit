#!/usr/bin/env bash
# last_verified: 2026-07-18 · Docker n/a

# Create a custom bridge network so containers can talk by name
docker network create dev-net

# Run an nginx container with a named volume and the custom network
docker run -d \
  --name web \
  --network dev-net \
  -v my-vol:/usr/share/nginx/html \
  nginx:alpine

# Inspect the network to see attached containers
docker network inspect dev-net
