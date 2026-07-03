---
name: adr
description: Write an Architecture Decision Record capturing a design decision — context, options considered, the decision, and consequences. Use when the user makes a non-trivial technical choice, asks to "document this decision", or weighs architectural trade-offs worth recording.
argument-hint: [decision topic]
allowed-tools: read, bash, grep, write
shell-timeout: 10
---

# Architecture Decision Record

Capture the decision about: `$ARGUMENTS`

## Process

1. If the decision was discussed in-session, use that. Otherwise inspect the code/diff with `read` and `bash` to understand what's actually being decided.
2. Identify the real alternatives — at least two, ideally three. A one-option ADR is just a note.
3. Be concrete about consequences, including the bad ones we're accepting.

## Output

Write a file `docs/adr/NNNN-<kebab-title>.md` (next free number; create the dir if missing). Use this structure:

```md
# NNNN. <Title>

- Status: proposed
- Date: <ask or leave as TODO — do not invent a date>

## Context

What forces are at play? Constraints, requirements, the problem being solved.

## Options considered

1. <Option> — pros / cons
2. <Option> — pros / cons

## Decision

What we chose and the core reason.

## Consequences

- Positive: ...
- Negative / accepted trade-offs: ...
- Follow-ups: ...
```

Keep it tight — an ADR is a record, not an essay. Confirm the file path with the user before writing if the repo has no existing `docs/adr/` convention.
