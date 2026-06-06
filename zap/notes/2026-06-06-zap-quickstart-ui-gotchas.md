# ZAP quickstart walkthrough — UI gotchas

Installed ZAP from the official download page (the cross-platform package). First thing I noticed: ZAP runs as a Java desktop app, not a CLI tool I'm used to. Starting it gives you a big "persist session" dialog before you even get to a scanner — that threw me off.

## Steps I followed

1. Downloaded the Linux package and ran `zap.sh` from the extracted directory.
2. Clicked through the session persistence prompt (chose "I'll persist later").
3. Used the Quickstart tab — entered a URL and hit Attack.
4. Watched the Sites tree populate as ZAP spidered and passively scanned.
5. Clicked through the Alerts tab to review findings.

The automated scan worked out of the box but I wasn't sure what it was actually doing under the hood. The Status bar showed "Spidering..." then "Active Scan..." but ZAP doesn't explain the difference unless you go read the docs.

## Got stuck on

- **Session persistence popup every startup.** ZAP assumes you want to save sessions but doesn't explain what a session is. Turns out sessions store your scan state, but for a first try I didn't need it.
- **The Sites tree isn't just URLs you entered.** ZAP discovers pages and shows them as a tree. I spent a minute wondering why the URL I entered wasn't showing up — it was nested under a different path.
- **Alerts tab showed nothing at first.** I ran the quickstart scan but had to click the Alerts tab manually. Also, by default ZAP only shows HIGH-level alerts unless you expand the filter.
- **Active Scan is separate from the Automated Scan.** The Quickstart tab's Attack button runs a passive scan + spider, not a full active scan. To run an active scan you right-click a node in Sites and choose Attack > Active Scan. I missed this initially.
- **ZAP ships with its own JRE.** The download includes a bundled JRE so you don't need Java installed. But it means `zap.sh` is the only entrypoint — there's no system-wide `zap` command.

## What I'd try next

Now that I've run a basic scan, I want to try configuring authentication contexts so ZAP can crawl behind a login form. The context configuration seems to be the key to making ZAP useful for real web apps. I also want to try the headless daemon mode for CI pipelines.
