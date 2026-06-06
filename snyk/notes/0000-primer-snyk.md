# Snyk — quick primer

I just learned about Snyk at work — it's a developer-first security tool that finds vulnerabilities in your code, dependencies, containers, and infrastructure as code.

Snyk scans your projects and tells you what's vulnerable, how bad it is, and how to fix it. It integrates into IDEs, CI/CD pipelines, and Git repositories. The free tier covers open-source projects and has a CLI for running scans locally.

Before Snyk, I'd have manually checked CVE databases or used tools like npm audit or Trivy separately for each language. Snyk covers them all in one tool with remediation advice — upgrade this package, use this patch, switch to this base image.

Key terms I hit in the first hour:
- **Vulnerability** — A known issue (CVE) in a dependency or container image. Snyk shows severity and fix advice.
- **Fix** — The remediation Snyk suggests: a version upgrade, a configuration change, or a manual patch.
- **Test** — What Snyk calls a scan. `snyk test` checks your project for issues.
- **Monitor** — Sends results to the Snyk web dashboard so you can track them over time.
- **Priority Score** — Snyk's risk score combining CVSS with exploit maturity, popularity, and fixability.

Smallest example:
```
npm install -g snyk
snyk test
```
Install the CLI, run on any Node.js project, and it'll list vulnerable packages with a suggested `npm install` command.

Next I want to try Snyk on a container image and see how its recommendations compare to Trivy.