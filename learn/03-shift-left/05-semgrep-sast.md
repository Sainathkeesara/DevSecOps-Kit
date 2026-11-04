---
last_verified: 2026-11-04
tool_version: n/a
---


# Find the SQL injection with Semgrep

Run Semgrep against the sample app in CI, catch a planted SQL injection, write your own rule, and suppress a false positive with a documented justification.

## What you'll learn
- Run Semgrep in CI and find the planted SQL injection
- Write a custom rule and suppress a false positive with a justification

## Before you start
- [Application security testing — SAST, DAST, SCA and secrets](../../docs/concepts/application-security-testing-concepts/0000-primer-application-security-testing-concepts.md) — what SAST is and where it sits in the pipeline
- [CI for the sample app — build, test and push](../02-build-and-ship/06-gha-sample-app-ci.md) — the workflow Semgrep slots into
- Semgrep installed locally — confirm with `semgrep --version`

## Walkthrough

1. Run the default ruleset against the sample app.
   ```bash
   semgrep --config p/python /work/DevSecOps-Kit/lab/sample-app
   ```
   You should see: at least one finding titled `python.lang.security.audit.sqli` (or similar) pointing at a line where user input reaches a SQL query.

2. Add Semgrep to CI so every push is scanned.
   ```yaml
   - name: Run Semgrep
     uses: semgrep/semgrep-action@v1
     with:
       config: p/python
   ```
   You should see: the job fail on the planted injection, with the finding reported as an annotation on the PR.

3. Write a custom rule that flags the specific unsafe pattern.
   ```yaml
   rules:
     - id: raw-sql-exec
       pattern: cursor.execute($QUERY)
       message: Review raw SQL execution; ensure inputs are parameterised
       languages: [python]
       severity: WARNING
   ```
   You should see: your rule appears in the output alongside the community rules.

4. Suppress a false positive with a justification.
   ```python
   cursor.execute(query)  # nosemgrep: raw-sql-exec  # reviewed: query is a constant string
   ```
   You should see: Semgrep reports the finding as suppressed, with the justification recorded.

## Exercise

Fork the sample app, add a second SQL injection that uses string concatenation, run Semgrep, and confirm it flags both. Then write a custom rule that catches the new pattern and suppress a single false positive with a justification comment.

## Check your work

```bash
semgrep --config p/python /work/DevSecOps-Kit/lab/sample-app 2>&1 | grep -i "sqli\|sql"
```
Expected: at least one SQL-injection finding, and your custom rule name appears in the report.

## Common mistakes
- Running Semgrep only locally and not in CI — findings never block a merge.
- Suppressing findings without a justification — the suppression becomes a permanent blind spot.
- Using a broad ruleset (`p/security-audit`) on day one and drowning in noise before triage habits exist.

## Next
[Follow tainted data with CodeQL](../../00_index/learning-path.md)