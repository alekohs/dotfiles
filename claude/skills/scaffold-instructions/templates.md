# Templates

Skeletons for every file in the system. `<angle brackets>` are placeholders;
everything else is canonical wording — keep it unless the repo demands
otherwise. Sections marked *(optional)* are included only when the matching
layer was opted in.

---

## CONSTITUTION.md

```markdown
# <Repo> Constitution

## Preamble

<Two–four sentences: who depends on this software, what breaks if the rules
aren't followed, and what split of responsibility the rules protect. State
the stakes, not the mechanics.>

This document states the **principles**. Enforcement lives in
[/instructions/](instructions/).

---

## Articles

### Article I — <Principle name>

<Three–five declarative sentences stating the principle. No procedure — that
lives in the linked files.>

→ [NN-topic.md](instructions/NN-topic.md)
→ [NN-topic.md](instructions/NN-topic.md)

<Repeat for each article. 4–6 articles total. Typical set: scope-of-
assistance or security posture, truthfulness, deny-by-default or
tokens-are-the-design-system, consistency or quality bar, governance of
assistance (optional), amendments (optional).>

### Article <N> — Amendments *(optional — repos with tiers/review gates)*

This constitution changes by pull request, not by drive-by edit. The PR must
state:
1. The motivation (what went wrong, or what we're learning).
2. The new or revised rule in full.
3. How it interacts with existing articles — does it extend, narrow, or
   supersede?

Amendments are **Tier 1**.

---

## Precedence

When two documents disagree, the higher wins:

1. **This constitution** — the principles.
2. **[/instructions/](instructions/)** — the enforceable rules.
3. **`CLAUDE.md`** — repo dispatcher: structure, quick references.
   <Multi-project repos: "Project `CLAUDE.md` files may **add**; must not
   **weaken**.">
4. **Session state** — `CONTEXT.md` and active efforts in
   [/plan/](plan/). Never overrides rules.

A doc or plan that contradicts this constitution is the bug.

---

## How to read this repo

1. **This file** — the principles.
2. **[CLAUDE.md](CLAUDE.md)** — the dispatcher.
3. **`CONTEXT.md`** — what the last session did, what's next.
4. **[/instructions/](instructions/)** — drill in by task or symptom.
5. **[/plan/](plan/)** — active multi-session efforts, if any.

---

## Cross-tool portability *(optional)*

If you use another agent or IDE (Cursor, Copilot, etc.) against this repo,
its instruction file (`AGENTS.md`, `.cursorrules`,
`.github/copilot-instructions.md`) should either **be** this file or **point
to** it. One source of truth.
```

---

## CLAUDE.md (dispatcher)

```markdown
# <Repo>

<One short paragraph: what the software is and who it serves.>

## Stack  <or "## Projects" table for multi-project repos>

- <bullet per major technology, with its role>

## Role *(only for restricted-slice repos)*

<Exactly what Claude writes and what it must refuse. Name the human's
responsibilities too.>

## Rules of the road

Start with the **[Constitution](CONSTITUTION.md)** — <N> articles stating
the principles. Enforceable rules derived from those articles live in
[/instructions/](instructions/).

1. **Principles** — [/CONSTITUTION.md](CONSTITUTION.md).
2. **Enforceable rules** — [/instructions/](instructions/).
3. **Session memory** — `CONTEXT.md`.
4. **Multi-session efforts** — [/plan/](plan/).

## Start of every session

1. Read this file.
2. Read `CONTEXT.md` to pick up where we left off.
<If tiers:> 3. Determine the **tier** for the planned work — see
   [NN-ai-assistant-policy.md](instructions/NN-ai-assistant-policy.md).
   For Tier 1 work, state the plan and wait for approval before editing.
4. Confirm focus with the <developer/user>.

## Quick reference — by task

| Task | Start with |
| --- | --- |
| <concrete task the repo actually sees> | [NN](instructions/NN-topic.md), [NN](instructions/NN-topic.md) |

## Quick reference — by symptom

| Symptom | Start with |
| --- | --- |
| <greppable symptom: an error, a banned pattern in a PR, a smell> | [NN](instructions/NN-topic.md) |

## Session end

Update `CONTEXT.md` per
[NN-session-protocol.md](instructions/NN-session-protocol.md). Prune
aggressively — `CONTEXT.md` is memory, not archive.

## Git discipline

`git push`, `git commit`, `git rebase`, `git reset`, destructive
`git checkout`, force-push, and merge / tag operations are gated on explicit
approval. Ask before pushing anything that could publish or overwrite.
```

High-risk repos may add a "From a vague issue to a plan" section (restate the
change in one sentence; if it contains *and*/*or* it's two issues; classify
tier; spec if required; consult the tables) and a `Last reviewed: <date> —
<what changed>` footer line appended on each doc revision.

---

## instructions/NN-topic.md — shape A: Rule / Why / How to apply

For design-system and consultant-slice repos.

```markdown
# NN — <Topic>

## Rule

<The rule, declaratively. Use "Forbidden:" / "Allowed:" lists where the
boundary needs to be mechanical.>

## Why

<What breaks without the rule. Cite the incident/commit if one exists.>

## How to apply

<The procedure, numbered. Then enumerate the real repo artifacts the rule
operates on — existing tokens, components, endpoints — so the reader never
has to guess what already exists.>
```

## instructions/NN-topic.md — shape B: domain sections + banned patterns

For engineering repos.

```markdown
# NN — <Topic>

<If git history motivated this file, open with it: "The bug this file
prevents has already shipped: commit `<sha>` … Two incidents in four months
is the definition of a policy gap.">

## <Domain section>

- <concrete rules with real APIs, real paths, code snippets where wording
  is ambiguous>

<More sections as the domain needs.>

## Banned patterns (review-blocking)

- <mechanical, greppable pattern a reviewer checks without judgment>

## Review tier *(if tiers)*

<Tier N for routine; Tier M when <escalating condition>.>
```

---

## instructions/README.md

```markdown
# Repo-wide instructions

The enforceable rules derived from the <N> articles of the
**[Constitution](../CONSTITUTION.md)**. <Multi-project: "Project-specific
CLAUDE.md files may **add** to these rules but MUST NOT weaken them. When
they conflict, the project doc is the bug.">

Entry points: [/CONSTITUTION.md](../CONSTITUTION.md) for the principles,
[/CLAUDE.md](../CLAUDE.md) for the session dispatcher.

## Files

### <Category>
- [NN-topic.md](NN-topic.md) — <one-liner>

<Group by category, e.g. Security & platform / Delivery / <Stack> / Process.>

## Quick reference — by task

| Task | Read first |
| --- | --- |
| <task> | NN, NN |

## Quick reference — by symptom

| Symptom | Read first |
| --- | --- |
| <symptom> | NN |
```

---

## CONTEXT.md (seed)

```markdown
# <Repo> — Context

## App scope
- <two–four bullets on what the app does>

## Up next
- <the first planned effort>

## Decisions worth honoring
- <only decisions not yet visible in code; empty is fine>
```

Cap ~50 lines forever. Entries move out when the code, the constitution, or
an instruction file can answer them.

---

## plan/README.md

```markdown
# Plan

Active, dated plans for remediation and multi-PR initiatives. One file per
initiative. Kill files that are complete or abandoned — history lives in git.

## Naming

`YYYY-MM-DD-short-topic.md`.

## Structure (template)

- **Status:** Active / Paused / Completed / Abandoned
- **Scope** — one paragraph
- **Method** — how findings were produced (manual review, audit, incident)
- **Findings** — by severity for audits; by task for initiatives
- **Suggested execution order** — PR groupings with rationale
- **Open decisions** — what still needs deciding

## Active

*(empty)*

## Completed

*(empty — mark entries with a one-line closure note and a link to the final
PR when a plan ships)*
```

---

## instructions/NN-session-protocol.md (always generated)

Shape A file. Rule: `CONTEXT.md` is read at session start, updated at session
end; it is *memory, not archive*. End-of-session update captures decisions
made / up next / research needed, then prunes: done items removed, decisions
now visible in code removed ("the code is authoritative"), rambling collapsed
to one-liners, >~50 lines means not pruned enough. A `CONTEXT.md` entry that
contradicts the constitution or an instruction is the bug — fix `CONTEXT.md`,
not the rule.

---

## instructions/NN-ai-assistant-policy.md *(optional)*

Tiers classify every session/PR at the **highest** tier any touched file
reaches. Scope items are cited by **responsibility, not path**; a rename must
update the list in the same commit.

- **Tier 1 — critical/irreversible**: constitution + instructions amendments,
  auth wiring, secrets, shared-schema migrations, tenant scope. Max model,
  max effort, written plan before code, AI-critic pass, cooldown before
  merge, approval gate before any write.
- **Tier 2 — significant**: new service/endpoint, cross-service refactor, new
  dependency, shared-library changes. Max model, plan + critic pass, no
  cooldown.
- **Tier 3 — routine**: single-file fix, tests, local refactor. Standard
  model, plan in PR description.
- **Tier 4 — trivial**: typos, comments, regenerated files. Any model.

Solo repos: define the **AI-critic pass** — a separate fresh-context session
loaded with the constitution, all instructions, the diff, and the author's
plan, prompted to review adversarially against the banned-pattern lists; a
flagged banned pattern blocks merge. The critic is not the author — a single
session that plans + implements + self-reviews does not satisfy the gate.

---

## specs/ *(optional)*

`specs/README.md` defines: when a spec is required (new service or
cross-service protocol; auth/authz/tenant/public-contract changes;
shared-schema migrations; new background workers; anything whose *why* would
have to be re-explained in the PR) and not required (single-file fixes,
tests, internal refactors, doc-only edits — those use the amendment process).
Flow: copy TEMPLATE.md to `YYYY-MM-DD-short-topic.md`, fill every section
("Open" beats deleted headings), spec-only PR, iterate to **Approved**,
implement referencing the spec, mark **Shipped** on ship. Solo Tier-3
accommodation: spec may live in the PR description — never for auth/tenant/
new-service changes.

`specs/TEMPLATE.md` frontmatter: title, status (Draft | Review | Approved |
Shipped | Abandoned), authors, reviewers, opened, tier. Sections: Problem
(user-facing symptom) / Goals / Non-goals / Constraints / Proposal (shape,
data model, API surface, auth, failure modes, observability) / Alternatives
considered / Rollout / Rollback ("we can't" is a constraint, state it) /
Open (every entry has a named owner) / Decision log table / Implementing PRs.
