# last_verified: 2026-07-10 · docker n/a
# My first Docker image — tiny alpine with a custom message

FROM alpine:3.19
# I picked alpine because the image is only ~7MB
CMD ["echo", "Hello from my first custom Docker image!"]
