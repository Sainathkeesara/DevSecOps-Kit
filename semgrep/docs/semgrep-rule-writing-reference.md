# Semgrep Rule Writing Reference: From Pattern to Metavariable

## Purpose

This guide provides a reference for writing Semgrep rules using pattern matching with metavariables. It covers the core syntax for matching code structures, metavariable constraints, and practical patterns for security-focused rule creation.

## When to Use This Reference

Use this when building custom Semgrep rules for security scanning. The reference applies to all languages supported by Semgrep (Python, JavaScript, Java, Go, Ruby, etc.) and targets security engineers, developers, and DevSecOps practitioners writing rules to detect vulnerabilities in codebase reviews.

## Prerequisites

- Semgrep installed (`semgrep --version` should return version 1.x)
- Basic understanding of YAML syntax
- Sample codebase to test rules against

## Pattern Syntax Fundamentals

### Basic Pattern

A pattern matches code structures using `$METAVARIABLE` syntax for wildcards:

```yaml
rules:
  - id: dangerous-subprocess-call
    pattern: subprocess.Popen($CMD, shell=True)
    message: Shell execution with user-controlled input
    languages: [python]
    severity: ERROR
```

The pattern `subprocess.Popen($CMD, shell=True)` matches any call where the first argument could be a variable, literal, or expression.

### Metavariable Constraints

Metavariables can be constrained using `metavariable-pattern` and `metavariable-comparison`:

```yaml
rules:
  - id: hardcoded-password
    patterns:
      - pattern: $VAR = "$SECRET"
      - metavariable-pattern:
          metavariable: $VAR
          patterns:
            - pattern-either:
                - pattern: password
                - pattern: passwd
                - pattern: pwd
                - pattern: secret
                - pattern: api_key
    message: Hardcoded credential in variable assignment
    languages: [python]
    severity: WARNING
```

### Metavariable Comparison

Use `metavariable-comparison` for numeric or string comparisons:

```yaml
rules:
  - id: insecure-cors-wildcard
    patterns:
      - pattern: Access-Control-Allow-Origin: $ORIGIN
      - metavariable-comparison:
          metavariable: $ORIGIN
          comparison: "$ORIGIN = '*'"
    message: CORS wildcard allows any origin
    languages: [generic]
    severity: WARNING
```

## Pattern Matching Rules

### Ellipsis (`...`)

The ellipsis matches zero or more arguments or statement elements:

```yaml
# Matches subprocess.Popen with any arguments
pattern: subprocess.Popen(...)

# Matches function definition with any parameters
pattern-inside: |
  def $FUNC(...):
    ...
```

### Metavariable Syntax Variants

| Syntax | Description | Example |
|--------|-------------|---------|
| `$X` | Matches any expression | `password = $X` |
| `$X.something` | Matches member access | `cursor.execute($X)` |
| `$X(...)` | Matches function/method call | `eval($X)` |
| `$X[...]` | Matches array/map access | `config[$X]` |
| `$X, ...` | Matches multiple items | `foo($X, ...)` |

### Constraint Patterns

Additional constraint types for precise matching:

```yaml
rules:
  - id: sql-injection-concatenation
    patterns:
      - pattern-either:
          - pattern: $CURSOR.execute($QUERY % $VAR)
          - pattern: $CURSOR.execute($QUERY + $VAR)
          - pattern: $CURSOR.execute($QUERY.format($VAR))
          - pattern: $CURSOR.execute(f"$QUERY{$VAR}")
      - pattern-inside: $CURSOR.execute(...)
      - metavariable-regex:
          metavariable: $CURSOR
          regex: cursor|db|conn|connection
    message: SQL injection via string concatenation
    languages: [python]
    severity: ERROR
```

## Steps

### 1. Identify the Target Pattern

Start by finding the code pattern you want to flag. For example, to detect Flask debug mode:

```python
app.run(debug=True)  # What to match
```

### 2. Write the Base Pattern

Create the initial pattern with metavariables for variables:

```yaml
pattern: $APP.run(debug=$VALUE)
```

### 3. Add Constraints

Narrow the match with constraints:

```yaml
rules:
  - id: flask-debug-enabled
    patterns:
      - pattern: $APP.run(debug=True)
      - metavariable-regex:
          metavariable: $APP
          regex: app|application|flask
    message: Flask debug mode should not be enabled
    languages: [python]
    severity: WARNING
```

### 4. Test the Rule

```bash
semgrep --config rule.yaml /path/to/code
```

### 5. Refine with Test Annotations

Create test files using `ruleid` and `ok` annotations:

```python
# ok: flask-debug-enabled
app.run(debug=False)

# ruleid: flask-debug-enabled
app.run(debug=True)
```

Run with: `semgrep --test --config rule.yaml tests/`

## Verify

1. Run the rule against a codebase with known violations
2. Confirm each `ruleid` annotation triggers a finding
3. Confirm each `ok` annotation does not trigger
4. Check the SARIF output structure if using `--sarif`

## Common Errors

### Forgetting Language Specification

Without `languages: [python]`, Semgrep defaults to generic text matching, missing AST-level precision.

### Over-Broad Metavariables

Using `$X` without constraints can match unintended code. Add `metavariable-regex` or `metavariable-pattern` to narrow scope.

### Indentation Sensitivity

`pattern-inside` requires exact indentation matching:

```yaml
# Correct: matches function body
pattern-inside: |
  def handler(...):
    ...

# Incorrect: won't match
pattern-inside: |
  def handler(...):
```

## References

- [Semgrep Rule Schema](https://semgrep.dev/docs/writing-rules/overview)
- [Pattern Combinators](https://semgrep.dev/docs/writing-rules/pattern-combinators)
- [Metavariable Constraints](https://semgrep.dev/docs/writing-rules/metavariable-constraints)