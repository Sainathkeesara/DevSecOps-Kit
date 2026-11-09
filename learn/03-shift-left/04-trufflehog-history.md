---
last_verified: 2026-11-06
tool_version: "n/a"
sources: []
---
# Search the whole history and verify secrets with TruffleHog

Gitleaks can block secrets in pull requests, but a credential that was committed and removed months ago may still live in git history. In this lesson you use TruffleHog to scan the full history of the sample app, interpret verified versus unverified findings, and decide when to add TruffleHog alongside Gitleaks.

## What you'll learn
- Scan the full Git history and tell verified from unverified findings
- Explain when TruffleHog adds value over Gitleaks

## Before you start
- [Catch secrets before they land with Gitleaks](03-gitleaks-in-ci.md) — the PR-time secret gate you will complement with a history scan
- [TruffleHog — quick primer](../../trufflehog/notes/0000-primer-trufflehog.md) — key terms: detector, verification, entropy
- TruffleHog installed locally so you can scan: `trufflehog --version`
- A git repository to scan (your sample app clone works). Run commands from the repository root so the history is available.

## Walkthrough

1. Scan the repository's full git history.
   ```bash
   trufflehog git file://.
   ```
   You should see: TruffleHog walks commit history (not just the current files) and prints any findings it detects. If the history is clean, it exits without reporting secrets. Scanning history matters because a secret can be removed from the latest commit but still exist in older commits.

   For a first pass when you want fewer API calls, you can disable verification:
   ```bash
   trufflehog filesystem . --no-verification
   ```
   You should see: results based on detector/entropy matches only. This is useful for a quick local look, but it does not tell you whether a credential still works.

2. Compare verified and unverified results.
   ```bash
   trufflehog git file://. --results=verified
   ```
   You should see: only findings that TruffleHog could confirm as live (for example, by checking the credential against the service in a safe, detector-specific way). An **unverified** finding matched a secret pattern or looked risky, but TruffleHog could not confirm it is active. A **verified** finding is higher confidence and usually needs urgent action: rotate the credential, then clean up exposure.

   Treat unverified findings seriously too. Verification can fail because of network access, permissions, or detector limits, so "unverified" does not mean "safe."

3. Capture machine-readable output for review.
   ```bash
   trufflehog git file://. --json > trufflehog-history.json
   ```
   You should see: a `trufflehog-history.json` file with JSON records you can inspect or feed into another tool. A simple check is to look for verified findings:
   ```bash
   python3 -c "import json; rows=[json.loads(l) for l in open('trufflehog-history.json') if l.strip()]; print(sum(1 for r in rows if r.get('Verified')) , 'verified findings')"
   ```
   You should see: a count like `0 verified findings` for a clean history. For deeper output handling, see [`../../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md`](../../trufflehog/docs/trufflehog-output-formats-json-sarif-csv.md).

4. Decide when TruffleHog adds value over Gitleaks.
   - **Gitleaks in CI (from the previous lesson)** is a fast gate on pull requests. It helps stop new secrets before they land.
   - **TruffleHog history scans** add value when you need to audit everything that was ever committed, review detector/verification results, or scan non-git sources in later workflows (filesystem artifacts, cloud storage) using the same tool family.

   You do not have to replace Gitleaks. A practical pattern is: keep Gitleaks as the PR gate, and run TruffleHog on a schedule or during incident response to search history and validate whether findings are still live.

   For scan-mode tradeoffs, read [`../../trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md`](../../trufflehog/docs/comparing-scan-modes-git-filesystem-s3.md).

## Exercise

1. Run a full-history TruffleHog scan against your sample app repository and save JSON output to a file.
2. Run the scan again with `--results=verified` and compare what changes.
3. Write two sentences in your own notes: one explaining the difference between verified and unverified findings, and one explaining when you would run TruffleHog in addition to the Gitleaks PR check.
4. If your repo has no findings, create a throwaway local branch with a fake test token committed to a file, run the history scan, observe the result, then delete the branch and remove the test file. Never use a real credential.

## Check your work

From the repository root, run:

```bash
trufflehog git file://. --json > /tmp/trufflehog-check.json
python3 -c "import json,sys; rows=[json.loads(l) for l in open('/tmp/trufflehog-check.json') if l.strip()]; verified=sum(1 for r in rows if r.get('Verified')); print('records:', len(rows)); print('verified:', verified)"
```

Expected result: the command completes and prints the number of records and verified findings (for example, `records: 0` and `verified: 0` on a clean history). You can also explain, in your own words, why a history scan can find secrets that a PR-only check would miss.

## Common mistakes
- Scanning only the working tree and assuming history is clean — `filesystem` scans current files, while `git` scans commit history.
- Treating "unverified" as harmless — verification can be inconclusive; review the detector and context before ignoring it.
- Confusing TruffleHog's PR/history role with Gitleaks's PR gate — use the right scan for the question: "did this PR add a secret?" versus "has this repo ever contained a live secret?"
- Committing real credentials during practice — use fake test values in throwaway branches and remove them immediately.

## Next
[Find the SQL injection with Semgrep](05-semgrep-sast.md)