---
name: audit-instructions
description: Read-only drift check of a repo's instruction system (docs-first or constitution shape) against the code — dead names and paths in rules, broken doc links, orphaned or unreachable rule files, stale exceptions, oversized session files. Use when the user asks to audit, check or verify instructions, CLAUDE.md, the constitution or rules against the code.
---

You are checking that a repo's instructions still tell the truth about its
code. Read-only: never edit, create or delete anything. Every finding cites
`file:line`.

## Step 1 — Identify the shape

- **Docs-first** — CLAUDE.md has `## Rules that can't be broken`, `docs/` is
  stated as the source of truth.
- **Constitution** — `CONSTITUTION.md` + `instructions/NN-topic.md`.
- Neither — say so, list what instruction files exist, and suggest
  `/scaffold-instructions`. Stop.

## Step 2 — Check

Both shapes:

1. **Dead names.** Every code identifier, path, config key, error code,
   table and project named in a rule — grep the code for it. Missing or
   renamed → finding. This is the main check; do it for every name, not a
   sample.
2. **Broken links.** Every relative link and every `<doc> §N` / anchor
   reference resolves to an existing file and section heading.
3. **Contradictions.** A rule and the doc it points at, or two rules, say
   different things.
4. **Rule violated by the code.** For mechanical rules (banned patterns,
   "only X may write Y", "all Z lives in module M"), grep for violations.
   Report hits; don't judge non-mechanical rules.
5. **Dependencies.** Packages in the manifests that are not on the approved
   list, and approved packages no longer used.
6. **Too generic.** Rules that name nothing in this repo and could be pasted
   anywhere.

Docs-first:

7. **Exceptions.** Each `One exception (YYYY-MM-DD)`: the named code site
   still exists, it is still the only one (grep for other callers/writers),
   and the guard or test that holds it in shape still exists.
8. **Authority.** CLAUDE.md and `research/README.md` still state that
   `docs/` wins. Decisions that live only in `research/` (not carried into
   `docs/`) → finding.
9. **Doc registers.** Registers in docs (tables, events, endpoints) that
   have no test checking them against code → note as a candidate, not a
   finding.
10. **Status lines.** Docs missing `**Status:**` or an open-questions
    section; "Draft" docs whose content is fully built.

Constitution:

7. **Reachability.** Every instruction file is linked from at least one
   article; every article links at least one file; numbers in both
   quick-reference tables match real files.
8. **Rules in CLAUDE.md.** CLAUDE.md that legislates instead of routing.
9. **CONTEXT.md** over ~50 lines, or holding entries the code or a rule
   file now answers; `plan/` entries marked Active with no recent commits.

## Step 3 — Report

Group by severity:

- **Wrong** — the instruction would mislead an agent today (dead name,
  contradiction, broken exception fence, code violating a mechanical rule).
- **Stale** — true-ish but out of date (broken link, unused approved
  dependency, oversized CONTEXT.md, Draft status on built work).
- **Weak** — generic rules, registers without tests.

Per finding: `file:line`, one sentence on what's wrong, one on the fix at
concept level. End with counts per group. Don't propose new rules beyond
what a finding needs; point at `/amend-rule` for fixes.
