---
last_verified: 2026-11-01
tool_version: jq 1.8.2
sources:
  - https://jqlang.github.io/jq/manual/
  - https://jqlang.org/
---
# YAML, JSON, jq and regex for security tooling

You can inspect HTTP traffic and read TLS certificates. Now you'll learn how to read and validate the structured data that security tools produce — YAML configuration, JSON scan output, and the simple patterns used to match tokens and findings. These formats are the lingua franca of DevSecOps tooling, and jq is the primary tool for interrogating them.

## What you'll learn

- Write YAML and JSON that validate
- Filter scanner JSON output with jq
- Write a simple regex that matches a token pattern

## Before you start

- [Navigate and script on Linux](02-shell-scripting.md) — you should be comfortable using the command line, running commands, and checking exit codes
- `jq` must be installed. Confirm it with `jq --version` (latest stable release is 1.8.2).
- `python3` must be installed to validate YAML. Confirm it with `python3 --version`.

## Walkthrough

1. Write a small YAML file and check that it parses. Save it as `scanner-config.yaml`:

   ```yaml
   scanner: trivy
   target: ./app
   severity_threshold: HIGH
   ```

   Validate it with Python:

   ```bash
   python3 -c "import yaml; yaml.safe_load(open('scanner-config.yaml')); print('YAML valid')"
   ```

   You should see: `YAML valid`.

   If the file has bad indentation or an unsupported construct, Python raises a `yaml.YAMLError` instead.

2. Write a small JSON file and confirm it is valid JSON. Save it as `scan-results.json`:

   ```json
   {
     "schema_version": 2,
     "artifacts": [
       {
         "name": "openssl",
         "version": "1.1.1k",
         "vulnerabilities": [
           {"vulnerability_id": "CVE-2021-3711", "severity": "CRITICAL", "title": "Buffer overflow in SM2"},
           {"vulnerability_id": "CVE-2022-0778", "severity": "HIGH", "title": "Infinite loop in BN_mod_sqrt"}
         ]
       },
       {
         "name": "bash",
         "version": "5.0.17",
         "vulnerabilities": [
           {"vulnerability_id": "CVE-2019-9924", "severity": "MEDIUM", "title": "RCE via history expansion"}
         ]
       }
     ]
   }
   ```

   Run `jq '.'`, the identity filter — it pretty-prints valid JSON and raises a parse error on invalid input:

   ```bash
   jq '.' scan-results.json
   ```

   You should see the same JSON, pretty-printed with two-space indentation.

   To confirm invalid input is rejected, run `jq '.'` on broken JSON:

   ```bash
   echo '{not valid' | jq '.'
   ```

   You should see a parse error such as `jq: parse error: Invalid numeric literal at line 1, column 5` and a non-zero exit code.

3. Filter the scanner output with jq. List every artifact name:

   ```bash
   jq -r '.artifacts[].name' scan-results.json
   ```

   You should see:
   ```
   openssl
   bash
   ```

   Pull only the CRITICAL vulnerability IDs:

   ```bash
   jq -r '.artifacts[].vulnerabilities[] | select(.severity == "CRITICAL") | .vulnerability_id' scan-results.json
   ```

   You should see:
   ```
   CVE-2021-3711
   ```

4. Write a regex that matches a CVE token pattern. A CVE ID looks like `CVE-2021-3711`: the literal `CVE-`, a four-digit year, a hyphen, and a sequence of digits. Match it with `grep -E`:

   ```bash
   grep -E 'CVE-[0-9]{4}-[0-9]{4,}' scan-results.json
   ```

   You should see every line containing a CVE ID — the two openssl advisories and the one bash advisory.

   The same pattern works in jq with `test()`:

   ```bash
   jq -r '.artifacts[].vulnerabilities[].vulnerability_id | select(test("CVE-[0-9]{4}-[0-9]{4,}"))' scan-results.json
   ```

   You should see:
   ```
   CVE-2021-3711
   CVE-2022-0778
   CVE-2019-9924
   ```

## Exercise

1. Create a JSON file `my-scan.json` describing two scanned artifacts, each with a `name`, `version`, and a `vulnerabilities` array of objects containing `vulnerability_id`, `severity`, and `title`. Include at least one CRITICAL and one MEDIUM finding.
2. Confirm the file is valid JSON with `jq '.'`.
3. Use jq to print just the vulnerability IDs of every finding whose severity is `CRITICAL`.
4. Use `grep -E` with a regex that matches a CVE pattern to list every line in the file containing a CVE ID.

Do not paste the solution into the lesson file.

## Check your work

```bash
jq '.' my-scan.json
jq -r '.artifacts[].vulnerabilities[] | select(.severity == "CRITICAL") | .vulnerability_id' my-scan.json
grep -E 'CVE-[0-9]{4}-[0-9]{4,}' my-scan.json
```

`jq '.'` prints the pretty-printed file with no parse error; the second command prints only CRITICAL finding IDs; the third lists every line containing a CVE ID.

## Common mistakes

- Forgetting to single-quote the jq program on Unix shells — `jq .foo` runs `jq foo` and `foo` is not defined; always write `jq '.foo'`.
- Assuming `jq '.'` printed output means the file is valid — invalid JSON raises a parse error instead of printing anything useful.
- Writing an unanchored regex — `grep -E 'CVE'` would also match `CVE-EXTRA`; anchor with `CVE-[0-9]{4}-[0-9]{4,}` to match real CVE IDs.

## Next

[Set up the lab and the sample app](../../00_index/learning-path.md)