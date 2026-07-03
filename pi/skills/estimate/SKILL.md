---
name: estimate
description: Break a feature or task into a defensible effort estimate with assumptions, risks, and a low/likely/high range. Use when the user asks "how long", needs to quote a client, scope a proposal, or size work before committing.
argument-hint: [what to estimate]
allowed-tools: read, bash, grep
shell-timeout: 15
---

# Effort Estimate

Produce a consultant-grade estimate for: `$ARGUMENTS`

If `$ARGUMENTS` is empty, estimate the change currently being discussed or the staged/working diff.

## Process

1. **Ground it in the codebase.** Use `bash` (`rg`, `fd`, `git log`) and `read` to see the real shape of the area touched — existing patterns, test setup, integration points. Don't estimate in a vacuum.
2. **Decompose** into 3–8 concrete work items. Each item is a verifiable chunk, not a vague phase.
3. **Per item**, give a likely effort in hours/days and a one-line reason.
4. **State assumptions** explicitly — every assumption is a lever the client can change. Flag the ones that, if wrong, blow up the estimate.
5. **List risks/unknowns** that widen the range (unclear requirements, external deps, legacy code, missing tests).

## Output

A short markdown table of items with effort, then:

- **Range:** low / likely / high (the spread reflects the unknowns, not padding)
- **Assumptions:** bulleted, each falsifiable
- **Risks:** bulleted, each with rough impact
- **What would shrink this:** 1–3 things the client could decide or provide to cut scope or uncertainty

Be honest about uncertainty. A confident wrong number is worse than an explicit range.
