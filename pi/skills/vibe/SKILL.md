---
name: vibe
description: Vibe-code an app and keep improving it in a disciplined self-correcting loop. Builds in tiny verified increments anchored to an on-disk plan, runs the app every cycle, critiques the result, and queues the next improvements — repeating until the backlog is clear or the cycle budget runs out. Use to start a new small app from an idea, or to resume and keep improving one you already started. Tuned for local models.
argument-hint: [app idea, or "continue", or "continue N" for N cycles]
allowed-tools: read, bash, grep, edit, write
shell-timeout: 180
---

# Vibe Loop

Build and relentlessly improve: `$ARGUMENTS`

You are running a **local model with limited memory and a tendency to drift**. The defense against that is mechanical, not clever: keep all state on disk in `.vibe/PLAN.md`, do exactly one small thing per cycle, and verify by _running the app_ before moving on. Re-read the plan from disk at the start of every cycle — never trust what you think you remember.

## Cycle budget

Default to **5 cycles** per invocation. If the argument is `continue N` use N. Stop early when the backlog has no `[must]` items left. After stopping, tell me how to resume (`/vibe continue`).

## Bootstrap (only if `.vibe/PLAN.md` is missing)

1. Decide the smallest stack that fits the idea. Prefer one the project already uses; otherwise pick the most boring, well-known option (it's what the model knows best). State the choice in one line — don't ask me unless the idea is truly ambiguous.
2. Scaffold the minimum that _runs and shows something_ — a blank-but-working app beats a feature that doesn't start.
3. Write `.vibe/PLAN.md`:

```md
# <App> — Vibe Plan

## Vision

<1–3 sentences. The core thing this app is for. Rarely changes.>

## Stack & run

- Stack: <...>
- Run: `<exact command to start it>`
- Test: `<exact command, or "none yet">`

## Works now

- <nothing yet>

## Backlog

- [ ] [must] <smallest next slice that makes it more real>
- [ ] [should] <...>

## Log
```

4. Verify the scaffold runs, then go to the loop.

## The loop — repeat each cycle

1. **Re-read** `.vibe/PLAN.md` from disk. This is your source of truth, not your memory.
2. **Pick exactly one item** — the highest `[must]`, else the highest `[should]`. One. Not two.
3. **Implement the smallest change** that completes it. Touch as few files as possible. Concrete over clever — local models break on cleverness.
4. **Verify by running.** Start the app / run the test command from the plan. Look at the actual output.
   - If it's broken, fix it before anything else. If you can't fix it in **2 tries**, `git checkout .` back to the last snapshot, re-queue the item with a note on what failed, and pick a different item.
   - Never end a cycle with a broken build.
5. **Update the plan**: move the finished item into `Works now`, append one `Log` line (`cycle N: <what changed>`).
6. **Critique, then enqueue.** Look at the current real state and ask, in order:
   - Does the core use case actually work end-to-end?
   - Is the main action obvious and fast, or fiddly?
   - What's the most embarrassing rough edge right now?
   - What's the riskiest thing that's never been tested?
     Turn the 1–3 sharpest answers into **concrete** backlog items (a vague item like "improve UX" is banned — say _what_ and _where_). Don't gold-plate: only enqueue what moves the vision.
7. **Snapshot**: `git add -A && git commit -m "vibe: <item>"` (init the repo first if needed). The snapshot is your undo button — it's what makes step 4's revert safe.
8. Repeat until the budget or the `[must]` backlog is empty.

## Rules that keep a local model on the rails

- **One item per cycle.** Batching is how it gets lost. Resist it.
- **The plan file is the memory.** If it's not written down, it didn't happen.
- **Running beats reasoning.** A 10-second run tells you more than re-reading the diff twice.
- **Small diffs.** If a change spans many files, it's too big — split it and re-queue.
- **Don't restart from scratch** when something's wrong — revert to the last green snapshot and try a smaller step.

## When you stop

Print: cycles run, what now works, the top 3 remaining backlog items, and `Resume with: /vibe continue`.
