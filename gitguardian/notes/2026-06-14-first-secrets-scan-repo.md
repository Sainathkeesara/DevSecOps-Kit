# Run my first secrets scan on a repo

I already had ggshield installed from the primer, so I jumped straight into scanning a real repo. I picked a small personal project to test — didn't want to trigger alerts on someone else's codebase.

## Scanning a local repo

I ran `ggshield scan path` on my project root:

```bash
ggshield scan path ~/projects/my-test-app
```

The output was... a lot. Turns out a small app can have dozens of false positives from test fixtures, mock data, and API documentation examples. The scan flagged things like:

- Fake API keys in test files
- Example credentials in README examples
- A `.env.example` file with placeholder secrets

## Got stuck on: filtering noise

The first scan was noisy. I couldn't tell what was a real secret vs. test data. I spent a while reading the ggshield docs on configuration.

I created a `.ggshield.yaml` to suppress known patterns:

```yaml
version: 2
paths-ignore:
  - "**/test*/**"
  - "**/fixtures/**"
  - "**/*.md"
```

That cut the output by about 80%. But I worried I might be ignoring too much — a real secret could hide in a test file.

## Got stuck on: commit range scanning

My real goal was scanning new commits before they hit GitHub, not the whole repo. I tried:

```bash
ggshield scan commit-range HEAD~3..HEAD
```

This worked well — only checks the diff in the last 3 commits. Way less noise. I could see exactly which new lines introduced potential secrets.

## What I'd try next

- Set up ggshield as a pre-commit hook so scanning happens automatically before every commit
- Compare ggshield output with `trufflehog filesystem` on the same repo to see which catches more real secrets
- Try `ggshield scan ci` in a GitHub Actions workflow for the PR gate pattern
