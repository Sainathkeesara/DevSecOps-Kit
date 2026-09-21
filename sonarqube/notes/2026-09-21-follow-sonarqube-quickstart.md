---
last_verified: 2026-09-21
tool_version: n/a
sources: []
---

# Follow the SonarQube quickstart — what tripped me up

I followed the SonarQube getting-started guide to set up a local instance and run my first analysis. Here's what worked, what didn't, and what I'd try next.

## Steps I followed

I started a SonarQube container with the default image and waited for it to come up. The web UI loaded at the expected port, and I logged in with the default credentials. I created a project and generated a token, which I copied carefully — tokens don't show again.

Then I installed the SonarScanner and ran my first scan against a small Python project. The scanner picked up the project key, source paths, and host URL from the command-line arguments it received. The dashboard updated with the results: a handful of code smells and one minor bug flagged.

## Got stuck on

The scan kept failing with an authentication error even though I was sure the token was correct. It turned out I had copied an extra trailing space from the token display — trimming it fixed the issue. I also hit a confusing error when the scanner couldn't find the project key setting; I had to pass it explicitly with `-Dsonar.projectKey=` rather than relying on a config file.

The server startup also took longer than I expected. I assumed it was ready when the container was running, but the UI wasn't responsive for another minute or two. I should have waited for the health check endpoint instead.

## What I'd try next

I want to set up a custom Quality Gate that blocks merges when coverage drops below a threshold. I'd also like to run the scanner through a CI pipeline so every PR gets checked automatically, and explore Quality Profiles to tighten the rules for my team's codebase.
