---
name: handoff
description: Produce a client/team handoff document for the current project or branch — what was done, how to run it, key decisions, and open follow-ups. Use when wrapping up an engagement, delivering work, or onboarding someone onto the codebase.
argument-hint: [scope or audience]
allowed-tools: read, bash, grep
shell-timeout: 20
---

# Project Handoff

Build a handoff document. Scope/audience hint: `$ARGUMENTS` (e.g. "client", "next dev", "this feature branch").

## Process

1. **Survey reality** with `bash`/`read`: `git log --oneline` for recent work, README/package manifests for how it runs, test/build scripts, env/config files (note required vars — never print secret values).
2. Distinguish what _is_ from what's _planned_ — only document what's actually in the code.

## Output (markdown)

- **Summary** — what this delivers, in 2–4 sentences, in client-readable terms.
- **How to run** — install, run, test, build commands. Verified from the repo, not guessed.
- **Configuration** — required env vars / config keys and where they live (names only, not secrets).
- **Key decisions** — notable choices and why, linking any ADRs.
- **Known gaps / follow-ups** — what's incomplete, deferred, or risky, with rough effort.
- **Where to look** — the 3–5 files/dirs that matter most for someone picking this up.

Match the tone to the audience hint. For a client, lead with outcomes; for a dev, lead with how-to-run and the map.
