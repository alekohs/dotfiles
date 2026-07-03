---
description: Turn recent git activity into a client-ready status update
---

Summarize recent work into a short status update suitable for a client or stakeholder.

Use bash to gather facts: `git log --oneline -n 20`, `git diff --stat`, and the current branch/uncommitted state. Base the update only on what's actually in the history and working tree — do not invent progress.

Output three tight sections:

- **Done** — what's completed and what it means in plain terms (outcomes, not commit hashes).
- **In progress** — what's underway and roughly where it stands.
- **Next / needs input** — what's coming up and any decision or info you need from me.

Keep it skimmable and jargon-light. Optional focus or timeframe: $@
