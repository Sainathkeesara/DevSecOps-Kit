# last_verified: 2026-09-23 · docker n/a
# Static front end: serves index.html with the standard library only.
FROM python
WORKDIR /srv
COPY index.html ./index.html
EXPOSE 8080
CMD ["python", "-m", "http.server", "8080", "--directory", "/srv"]
