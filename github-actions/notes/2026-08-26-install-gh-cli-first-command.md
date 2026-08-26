---
last_verified: 2026-08-26
tool_version: n/a
sources: []
---

# Install GitHub CLI and run my first `gh` command — what tripped me up

> First-day notes on getting `gh` installed and authenticated.

I installed the GitHub CLI with `brew install gh` and ran `gh auth login` to connect it to my account. The command walked me through a web-based authentication flow: it opened a browser window, asked me to paste a one-time code back into the terminal, and then confirmed the login.

The part that tripped me up was that the browser didn't open automatically on my machine. I had to manually copy the short code from the terminal, open the GitHub device activation page myself, and paste it in. Once I did that, `gh auth status` showed a valid token and everything worked.

I tested it with `gh issue list --repo owner/repo` and saw my open issues. That confirmed the CLI was talking to GitHub correctly.
