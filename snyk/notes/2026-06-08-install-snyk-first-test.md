# Snyk notes — installing the CLI and running my first project test

I set up Snyk CLI today. I just wanted to see what it flagged in a small project so I could compare it to Checkov and Grype later.

## Install

I went with the official install script:

```bash
curl -sSfL https://download.snyk.io/install.sh | bash
```

It dropped `snyk` into `~/.local/bin`. I added that to PATH and ran `snyk --version` to confirm it worked. Nothing weird there.

I already had an auth token from signing up on snyk.io, so I ran:

```bash
snyk auth <token>
```

It printed a success message and I was good.

## First project test

I cloned a tiny Python demo app I had lying around:

```bash
git clone https://github.com/snyk-labs/python-goof.git
cd python-goof
```

Then I just ran:

```bash
snyk test
```

It downloaded the vulnerability DB, scanned the `requirements.txt`, and dumped a table of findings. I saw a mix of high and low severity issues, mostly around old Django and Flask pins. The output was readable by default, no flags needed.

I also tried:

```bash
snyk test --json > snyk-report.json
```

That gave me structured JSON I can pipe into other tools later.

## What I'd try next

I want to see how `snyk monitor` differs from `snyk test` for a long-lived project, and I should compare an IaC scan against the same Terraform dir I used with Checkov.
