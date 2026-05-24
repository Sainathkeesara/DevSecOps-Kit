# Installing Trivy and running my first scan

I installed Trivy on Ubuntu using the official script:

```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh
```

That dropped the binary in `./bin/trivy`. I moved it to `/usr/local/bin` so it's on my PATH.

First scan — tried `trivy image alpine:latest`. It downloaded the vulnerability DB (took about a minute) and then printed a table of findings. Mostly MEDIUM and LOW stuff in musl and busybox. Nothing scary.

Then I tried scanning a Python app image I had locally:

```bash
trivy image my-python-app:latest
```

Got a wall of output — 40+ findings. Half were from the OS layer (Almus packages), the rest from pip dependencies. Filtering helped:

```bash
trivy image --severity CRITICAL,HIGH my-python-app:latest
```

Down to 3 findings. One was in `urllib3` with a fix version available. Good to know.

What I'd try next: integrate this into a GitHub Actions workflow so it runs on every PR. Also want to try `trivy fs .` to scan a local directory without building an image first.
