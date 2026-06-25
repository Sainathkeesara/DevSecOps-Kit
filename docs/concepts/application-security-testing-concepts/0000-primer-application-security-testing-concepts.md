# Application Security Testing — quick primer

> First-day notes on Application Security Testing. What it is, why it matters, and the key ideas to know.

## What is it?

Application security testing is the practice of finding and fixing security weaknesses in software before someone else finds them first. I think of it like proofreading, but instead of catching typos, you're looking for ways an attacker could break in.

It's the same idea as testing for bugs in functionality — except the "bug" is a security flaw. A missing input validation check is a bug; that same missing check also becomes a vector for SQL injection. Security testing just frames the same quality work through an attacker's eyes.

## Why does it matter for DevSecOps?

Security can't be a separate phase at the end of a project anymore. By the time a DAST scan runs after deployment, the code has already shipped. In DevSecOps, we weave security testing into the CI/CD pipeline so every commit gets checked automatically.

As someone building pipelines, I need to understand what kinds of testing exist and when to run each one. Choosing between a SAST scan that runs in seconds per commit vs a DAST scan that takes 20 minutes determines where in the pipeline each fits. Knowing the difference also keeps me from recommending the wrong tool for the job.

## Key terminology

- **SAST (Static Application Security Testing)** — Testing source code without running it. Think of it as a spellchecker for security patterns. Example: Semgrep scanning a Python PR for `eval()` calls.
- **DAST (Dynamic Application Security Testing)** — Testing a running application by sending requests and observing responses. Example: OWASP ZAP spidering a staging server for hidden endpoints.
- **SCA (Software Composition Analysis)** — Scanning dependencies for known vulnerabilities. Example: `trivy fs .` checking if my npm packages have CVEs.
- **IAST (Interactive Application Security Testing)** — Instrumenting a running app to observe security behavior from the inside. Combines SAST's code awareness with DAST's runtime context.
- **RASP (Runtime Application Self-Protection)** — Embedded security that blocks attacks inside the running app. Not a testing technique, but a control that testing validates.
- **False positive** — An alert that flags something benign as a vulnerability. The bane of every security engineer's existence.
- **Severity** — How bad a finding is (critical, high, medium, low, info). Determines whether a pipeline should block or just warn.
- **CVE (Common Vulnerabilities and Exposures)** — A standardized identifier for a known vulnerability. Example: CVE-2024-3094 in xz utils.

## A concrete example

Here's a tiny SAST vs DAST comparison on a deliberately vulnerable app:

```python
# vulnerable_app.py — DO NOT USE IN REAL CODE
from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route("/ping")
def ping():
    ip = request.args.get("ip", "8.8.8.8")
    # SAST would flag this: subprocess with user input
    result = subprocess.run(f"ping -c 1 {ip}", shell=True, capture_output=True)
    return f"<pre>{result.stdout.decode()}</pre>"
```

A SAST tool (Semgrep, CodeQL) would flag the `subprocess.run()` with concatenated user input immediately — no runtime needed. A DAST tool (ZAP) would need to hit `/ping?ip=;cat /etc/passwd` and see the response to confirm the injection works. Both find the same class of issue, but at different points in the lifecycle.

## How this connects to what's next

Understanding SAST, DAST, and SCA is the foundation for choosing tools later — Semgrep and CodeQL for SAST, OWASP ZAP for DAST, and Trivy or Snyk for SCA. Each tool makes different tradeoffs in speed, accuracy, and where it fits in a pipeline.
