---
last_verified: 2026-09-21
tool_version: "n/a"
---

# Following the DefectDojo quickstart — what tripped me up

I finally sat down with the official DefectDojo quickstart and ran the Docker Compose path on my laptop. I have used a few scanners before but never stood up DefectDojo itself, so this was all new. Cloning and starting looked easy on paper. Most of it worked, but I lost time in a few places that the guide glosses over. Writing them down so future-me does not repeat them.

## Steps that worked

I cloned the repo linked from the quickstart, moved into the checkout, and started everything detached:

```bash
docker compose up -d
docker compose ps
```

All the services came up, and after a wait the login page loaded in my browser. I signed in with the bootstrap admin account the guide points to, created a product for a test service, and added an engagement under it. So far, exactly like the guide said.

## Got stuck on

**The first startup looks frozen.** After `docker compose up -d`, the initializer service sat there for a few minutes running database setup while the UI returned errors. I almost tore everything down thinking I had broken it. Running `docker compose logs initializer` showed it was still working through setup steps. Lesson: give the first boot several minutes and watch the initializer logs before touching anything.

**The admin password was not where I expected.** The guide mentions a default login, but what actually got me in was the generated admin password printed in the initializer logs. I found it with:

```bash
docker compose logs initializer | grep -i "admin password"
```

Once I used that, I got in and changed it. If the login page rejects what the guide says, check the initializer output first.

**My first scan import showed zero findings.** I created a product and an engagement, uploaded a scanner report, got a success message — and the engagement was empty. Turns out the engagement has to be in the "In Progress" state for imports to land. Mine was still in the initial state. I flipped the engagement status, re-uploaded the same file, and the findings appeared. Nothing in the quickstart called that out, and the success banner made it extra confusing.

**The report format matters.** My first upload was a human-readable table export from my scanner, which the importer rejected. Re-exporting the same scan as JSON and uploading that worked on the first try. So: always export machine-readable JSON for the import step, even if the table output is nicer to read.

**The API token step is easy to miss.** For wiring scans into a pipeline later, there is no token waiting for you — I had to create one under my user settings in the token section of the UI, then pass it as the auth header on API calls. The quickstart shows API examples but I had to go hunting for where the token gets created.

## What I'd try next

Next I want to script the whole loop: run a scan, export JSON, and push it to the scan-import API of my test engagement with a small shell script, so I can re-run it after every change. I also want to re-upload the same report twice on purpose to see how DefectDojo handles duplicates, since that decides whether I can safely run the import on a schedule. If the script works, that becomes the CI hook I use for every later scanner task.
