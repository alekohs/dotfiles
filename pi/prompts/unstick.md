---
description: I'm stuck on a bug — generate ranked hypotheses, cheapest check first
---

I'm stuck. Here's the symptom: $@

Don't jump to a fix. Work it like a diagnosis:

1. Restate what's actually observed vs. what I expected — flag any gap in the evidence I've given.
2. List candidate root causes ranked by likelihood given this codebase. Inspect the relevant files/logs with read and bash (rg, git log) before ranking — don't guess blind.
3. For each candidate, state the single cheapest observation or command that would confirm or kill it.
4. Recommend which check to run first and why.

Only propose a fix once a hypothesis is actually confirmed. If the evidence is too thin to rank, tell me exactly what to capture next.
