---
name: amend-rule
description: Adds, changes, narrows or removes a rule — or adds a dated exception — in a repo's instruction system (docs-first or constitution shape), keeping rule, doc section and code in step. Use when the user wants to change a rule, add an exception, approve a dependency, or record a decision in CLAUDE.md, the constitution or instructions/.
---

You are amending a repo's instruction system. Rules are obeyed by every
future session, so a sloppy amendment costs more than a sloppy line of code.

## Step 1 — Load

Read CLAUDE.md, the constitution and instructions/ (if constitution shape),
and the doc sections the change touches. Identify the shape: docs-first
(`## Rules that can't be broken` in CLAUDE.md) or constitution.

## Step 2 — Classify and confirm

Restate the change in one sentence and classify it:

- **New rule** — a new invariant.
- **Exception** — one named code site allowed to do what a rule forbids.
- **Change** — extends, narrows or supersedes an existing rule.
- **Removal** — the rule no longer applies.
- **Approval** — a dependency or decision gets approved.

Push back before writing when:

- An "exception" would cover more than one code site or an open-ended
  category — that is a rule change; say so.
- A new rule duplicates or contradicts an existing one — name it.
- The rule is generic (names nothing in this repo).
- A test could enforce it instead — suggest the test, keep the rule short.

Show the user the exact new wording and where it goes. Wait for approval
before editing. Constitution-shape repos with tiers: amendments are Tier 1.

## Step 3 — Write

Docs-first:

- **Doc first.** Write or update the `docs/` section that holds the detail
  and rationale. The rule may not point at a section that doesn't exist.
- **Rule:** bold declarative lead sentence, sub-bullets only where the
  boundary needs them, the doc reference (`docs/<doc>.md` §N), real
  identifiers so it is greppable.
- **Exception:** nested under the rule it excepts:
  `**One exception (YYYY-MM-DD): <name>** (<doc> §N, "<section>")`. Name the
  one code site, its exact conditions, what holds it in shape (guard, test),
  and end with "Don't widen this to <...>." Don't loosen the parent rule's
  wording.
- **Approval:** add to the approved list with what it's for and the date;
  update the full list in the docs.
- **Removal:** delete the rule and any exceptions under it; mark the doc
  section as superseded or remove it.
- Use today's date, absolute.

Constitution:

- Rule goes in the matching `instructions/NN-topic.md` (never in
  CLAUDE.md). A new file takes the next free number — never renumber.
- Link it from the article it enforces and add it to both quick-reference
  tables and `instructions/README.md`.
- A new principle is an article amendment: state motivation, the rule in
  full, and whether it extends, narrows or supersedes existing articles.

Both: if the change comes with code, the rule, the doc and the code belong
in the same PR. If the user wants a test that enforces the rule, write it in
the same change.

## Step 4 — Finish

- Grep every identifier the new wording names — each must exist (or be
  created in this change).
- Check every link you added resolves.
- Do not commit. List what changed, file by file.
