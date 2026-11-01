---
last_verified: 2026-10-31
tool_version: n/a
sources: []
---
# Read an HTTP exchange and a certificate

You've learned how to branch, merge, and rebase safely in Git. Now you'll look at what happens when your code makes network requests — how to inspect HTTP traffic and examine the TLS certificates that secure those connections. These skills are fundamental for debugging integration issues and verifying trust in any DevSecOps pipeline.

## What you'll learn

- Explain ports, DNS and the request/response cycle
- Annotate the output of `curl -v`
- Read a certificate's subject, issuer and expiry with `openssl`

## Before you start

- [Navigate and script on Linux](02-shell-scripting.md) — you should be comfortable using the command line, running scripts, and checking exit codes

## Walkthrough

1. Use `curl -v` to inspect a sample HTTP request to `https://httpbin.org/get`:

   ```bash
   curl -v https://httpbin.org/get 2>&1 | head -40
   ```

   You should see output starting with `* About to connect`, followed by the request line `GET /get HTTP/1.1`, the `Host` header, and the response status line `HTTP/1.1 200 OK`.

2. Identify the port number in the output (default HTTPS port 443) and understand that DNS resolves `httpbin.org` to an IP address before the TCP connection is established.

3. Extract the TLS certificate information from a secure connection:

   ```bash
   echo | openssl s_client -connect httpbin.org:443 -servername httpbin.org 2>/dev/null | openssl x509 -noout -subject -issuer -dates
   ```

   You should see output similar to:
   ```
   subject=CN = httpbin.org
   issuer=C = US, O = DigiCert Inc, OU = www.digiCert.com
   notBefore = Jan 17 00:00:00 2024 GMT
   notAfter = Jan 16 23:59:59 2025 GMT
   ```

4. Note the `subject` field identifies the hostname the certificate was issued for, and the `issuer` field shows who signed it. The `notBefore` and `notAfter` dates define the validity period — if the current date falls outside this range, the certificate is considered expired.

## Exercise

1. Run `curl -v https://httpbin.org/get 2>&1 | head -30` and identify the HTTP method, path, and status code in the output.
2. Run `echo | openssl s_client -connect httpbin.org:443 -servername httpbin.org 2>/dev/null | openssl x509 -noout -subject -issuer -dates` and write down the `notBefore` and `notAfter` dates shown.
3. Verify that the current date falls within the certificate's validity period.

## Check your work

```bash
curl -v https://httpbin.org/get 2>&1 | head -30 | head -1
```

You should see output containing `GET / HTTP/1.1` or similar request line.

```bash
echo | openssl s_client -connect httpbin.org:443 -servername httpbin.org 2>/dev/null | openssl x509 -noout -subject -issuer
```

You should see `subject=` and `issuer=` fields populated, not empty.

## Common mistakes

- Confusing the `subject` and `issuer` fields — the `subject` is the entity the certificate was issued to (the hostname), while the `issuer` is the CA that signed it
- Forgetting `-servername` when using `openssl s_client` — without it, the tool may not send the SNI extension and could get the wrong certificate or fail entirely
- Reading `notAfter` as a simple date string without noting the timezone (all openssl dates are in GMT)

## Next

[YAML, JSON, jq and regex for security tooling](06-yaml-json-jq-regex.md)