---
last_verified: 2026-07-05
tool_version: n/a
---

# ZAP Automation Framework plan structure

## Purpose

The ZAP Automation Framework uses a YAML plan file to define what ZAP does during a scan. A plan replaces ad-hoc API calls with a declarative recipe: contexts, requests, scan jobs, and reports are all described in a single file that ZAP reads at startup. This reference explains the top-level plan layout, how contexts constrain scope, how requests define individual HTTP interactions, and how passive scan settings are tuned without sending attack payloads.

## When to use

- Headless DAST runs in CI where you need repeatable, version-controlled scan logic
- Multi-step scan sequences that combine spidering, active scanning, and reporting
- Scoping scans to a subset of URLs or authenticated areas using contexts
- Tuning passive checks without increasing scan duration or payload volume

## Prerequisites

- ZAP installed or running in Docker (the plan file format is the same regardless of how ZAP is launched)
- Familiarity with basic YAML syntax
- A target application reachable from the ZAP runtime

## Plan structure

A plan is a YAML file with three top-level keys:

- **env** — environment variables and context definitions available to all jobs
- **vars** — user-defined variables substituted into other fields at runtime
- **jobs** — ordered list of scan tasks ZAP executes sequentially

```yaml
env:
  contexts:
    - name: default
      urls:
        - "https://target.example.com"
vars:
  reportDir: "reports"
jobs:
  - type: spider
    parameters:
      context: default
```

## Contexts

A context groups URLs, include/exclude rules, and technology sets into a named scope. Every job that touches URLs (spider, active scan) references a context by name.

```yaml
env:
  contexts:
    - name: webapp
      urls:
        - "https://staging.example.com"
      includes:
        - "https://staging.example.com/.*"
      excludes:
        - "https://staging.example.com/static/.*"
        - "https://staging.example.com/logout"
      technology:
        - "JavaScript"
        - "Node.js"
```

`includes` are regex patterns limiting discovery to segments of the application. `excludes` filter out endpoints that should never receive scan traffic, such as logout pages or static assets. Contexts support user and session definitions for authenticated scans, but those belong to the auth configuration inside the context rather than the top-level structure.

## Requests

Request nodes define explicit HTTP interactions outside the spider flow. Use them when you need to seed a session, set cookies, or send API calls that the spider will not discover on its own.

```yaml
jobs:
  - type: request
    parameters:
      context: webapp
      url: "https://staging.example.com/api/setup"
      method: "POST"
      headers:
        - name: "Content-Type"
          value: "application/json"
      body: "{}"
```

Request jobs run before spider or active scan jobs in the sequence. They are useful for logging in, accepting terms, or hydrating test data. Unlike spider jobs, requests do not crawl; they send one explicit call and capture the response.

## Passive scan configuration

Passive scan jobs inspect HTTP requests and responses as they pass through ZAP without sending attacks. Configuring them happens at two levels: global passive scan rules and the `passiveScan-config` job block.

```yaml
jobs:
  - type: passiveScan-config
    parameters:
      maxAlertsPerRule: 10
      scanOnlyInScope: true
```

- **maxAlertsPerRule** caps duplicate alerts from one rule so the report does not grow unbounded
- **scanOnlyInScope** respects the context include/exclude filters instead of passive-scanning every traversed URL

Passive checks run automatically during spider and active scan jobs when enabled. Explicitly including a `passiveScan-config` job before those jobs ensures the configuration is applied before traffic starts flowing.

## Verify

1. Run the plan against a staging environment with `docker run ghcr.io/zaproxy/zaproxy:stable zap.sh -cmd -autorun /path/to/plan.yaml`.
2. Confirm the spider discovers the expected number of URLs with the context filters applied.
3. Verify the report contains passive findings relevant to the target stack (missing security headers, cookie flags, information disclosure).
4. Check that excluded paths do not appear in the report URLs.

## Common errors

- **Context name missing** — Spider and active scan jobs reference `context:` by name. A typo in the context name causes the job to silently skip or fail.
- **Exclude patterns too broad** — Using `.*` in an exclude rule can block the spider from discovering legitimate paths. Test regex patterns independently before adding them to the plan.
- **Passive scan not firing** — Passive scan config must be declared before spider or active scan jobs. If placed after them, the default settings apply for the entire run.
- **Variable substitution mismatch** — Environment variables and `vars` are substituted literally. Extra spaces or wrong case (e.g. `{{Target_URL}}` vs `{{TARGET_URL}}`) result in literal strings instead of resolved values.

## References

- OWASP ZAP Automation Framework documentation
