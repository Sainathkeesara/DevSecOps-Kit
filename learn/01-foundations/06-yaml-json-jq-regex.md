---
last_verified: 2026-10-31
tool_version: n/a
sources: []
---
# YAML, JSON, jq and regex for security tooling

You've inspected HTTP traffic and TLS certificates. Now you'll work with the structured data formats that security tools produce and consume. Scanners like Trivy, Syft, and Grype output JSON; CI pipelines pass YAML configurations; and jq is the standard tool for extracting exactly what you need from that JSON. Regex completes the picture by letting you describe token patterns at the character level.

## What you'll learn

- Write YAML and JSON that validate
- Filter scanner JSON output with jq
- Write a simple regex that matches a token pattern

## Before you start

- [Navigate and script on Linux](02-shell-scripting.md) — you should be comfortable using the command line, running scripts, and checking exit codes

## Walkthrough

1. Write valid YAML and JSON side by side and verify they parse correctly:

   ```bash
   echo '{"key": "value"}' > data.json
   cat > data.yml <<'EOF'
   key: value
   EOF
   python3 -c "import yaml; yaml.safe_load(open('data.yml'))"
   python3 -c "import json; json.load(open('data.json'))"
   ```

   You should see no output from the python commands (meaning both parsed successfully).

2. Examine how a security scanner like Trivy outputs JSON, and use `jq` to extract the severity of each finding:

   ```bash
   trivy fs . --format json --severity HIGH,CRITICAL 2>/dev/null | jq '.vulnerabilities[].severity'
   ```

   You should see a list like: `"HIGH"`, `"CRITICAL"` — one line per vulnerability.

3. Write a regex that matches a typical API token pattern — uppercase letters, lowercase letters, and digits, 32 characters long:

   ```bash
   echo "TOKEN=abc123XYZ789def" | grep -oE '[A-Za-z0-9]{32}'
   ```

   You should see: `abc123XYZ789def` — the 32-character token extracted from the line.

## Exercise

1. Create a file `scan-results.json` with this content:

   ```json
   {"vulnerabilities":[{"id":"CVE-2023-1234","severity":"HIGH","pkg":"openssl"},{"id":"CVE-2023-5678","severity":"CRITICAL","pkg":"curl"}]}
   ```

2. Use `jq` to extract only the severity values and output them as a plain list (one per line).

3. Write a regex pattern using `grep -oE` that matches a string starting with `sec_` followed by exactly 20 alphanumeric characters, and test it against `sec_AbC123dEfGhIjKlMnOp`.

## Check your work

```bash
cat scan-results.json | jq '.vulnerabilities[].severity'
```

You should see output (one per line): `HIGH` then `CRITICAL`.

```bash
echo "sec_AbC123dEfGhIjKlMnOp" | grep -oE '[A-Za-z0-9]{20}'
```

You should see: `AbC123dEfGhIjKlMnOp` (or a 20-character substring matching the pattern).

## Common mistakes

- YAML indentation errors — tabs are not allowed in YAML; use spaces only, and nested keys must be indented consistently
- Off-by-one in regex quantifiers — `grep -oE '.{5}'` matches exactly 5 characters, but `.{1,5}` matches 1 to 5; forgetting the bound leads to matching too much or too little
- Assuming jq filters always produce the same type — `jq '.keys'` returns strings, but `jq '.[]'` on an object returns keys first then values; know your data shape

## Next

[Set up the lab and the sample app](../../00_index/learning-path.md)