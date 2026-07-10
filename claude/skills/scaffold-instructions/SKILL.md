---
name: scaffold-instructions
description: Scaffolds a constitution-based instruction system for a repo or folder — CONSTITUTION.md (principles), CLAUDE.md (dispatcher), numbered instructions/ (enforceable rules), CONTEXT.md (session memory), plan/, and optional specs/ + AI-policy tiers. Use when the user asks to set up instructions, governance docs, or a constitution for a project.
---

You are scaffolding the instruction system the user runs across their repos
(reference implementations: CashKoh, Marvin, NTBackend). The architecture
separates **principles** from **enforcement** from **dispatch** from **state**:

| File | Job | Never contains |
|---|---|---|
| `CONSTITUTION.md` | Principles as articles; each article links → the instruction files that enforce it | Enforceable detail, build commands |
| `instructions/NN-topic.md` | One enforceable rule domain per file, numbered | Principles, session state |
| `instructions/README.md` | Index of the files, grouped by category, + quick-reference tables | New rules |
| `CLAUDE.md` | Dispatcher: repo intro, session protocol, by-task and by-symptom routing tables | The rules themselves |
| `CONTEXT.md` | Session memory — decisions in flight, up next. ~50-line cap, pruned every session | Durable rules |
| `plan/` | Dated multi-session efforts, `YYYY-MM-DD-short-topic.md` + README index with status | — |
| `specs/` (optional) | Spec-driven design for T1/T2 changes: TEMPLATE.md + dated specs | — |

Core invariants — never violate:

1. **Precedence ladder**, stated in the constitution: constitution >
   instructions/ > CLAUDE.md > session state (CONTEXT.md, plan/). The phrase
   "A doc or plan that contradicts the constitution is the bug" appears
   verbatim.
2. Every constitution article ends with `→` links to its enforcing
   instruction files. Every instruction file is reachable from at least one
   article.
3. Instruction files are numbered `NN-topic.md`; numbers are referenced from
   the constitution, both quick-reference tables, and each other. Numbering is
   stable — never renumber existing files.
4. CLAUDE.md routes, it does not legislate. If you find yourself writing a
   rule in CLAUDE.md, it belongs in an instruction file.
5. Rules are concrete to THIS repo: real paths, real components, real
   incidents. A rule that could be pasted into any repo unchanged is too
   generic — sharpen it with repo specifics or drop it.

## Step 1 — Analyze the target

Two modes, decided by what's on disk:

- **Existing codebase** — the code is the primary source. Analyze deeply,
  infer stack/role/risk/conventions from what's there, and ask only what the
  code cannot tell you (team shape, Claude's role, appetite for tiers/specs).
  Present inferences as confirmations ("I read this as X — correct?"), not
  open questions.
- **New / near-empty repo or plain folder** — nothing to analyze, so the
  interview carries the weight: ask everything in Step 2 plus intended stack,
  project layout, and what the software will do. Generate a leaner set
  (fewer instruction files, generic-but-sharpenable rules) and note in each
  file where repo specifics should replace placeholders once code exists.

Read what exists before asking anything: README, any current CLAUDE.md /
AGENTS.md / .cursorrules, manifests (`go.mod`, `*.sln`/`*.csproj`,
`package.json`, `Cargo.toml`, `pyproject.toml`), directory layout, and
`git log --oneline -30` for recurring fix patterns (a bug fixed twice is an
instruction file waiting to be written — cite the commits in the rule's
preamble). Determine:

- **Stack and layout** — single project or multi-project (multi-project repos
  get per-project CLAUDE.md + CONTEXT.md; the root docs stay the baseline that
  project docs may *add to* but MUST NOT weaken).
- **Risk surface** — auth/tokens? money? PII? public API? UI/a11y only?
  Risk domains become constitution articles.
- **Conventions already in the code** worth codifying instead of inventing.

## Step 2 — Ask

Use AskUserQuestion. Skip anything the analysis already answered; confirm
inferences rather than re-asking.

**When in doubt, ask — never assume.** One question too many beats one wrong
assumption baked into a governance doc that every future session will obey.
Anything unclear, ambiguous, or where two plausible readings exist (whose
responsibility a domain is, whether a convention in the code is intentional
or legacy, how strict a gate should be) becomes a question. This applies at
every step, not just here — if doubt surfaces mid-generation, stop and ask
before writing the rule.

Cover:

1. **Claude's role** — full engineer / restricted slice (e.g. CashKoh:
   markup + CSS only, developer writes all Go) / review-only. A restricted
   slice always gets a scope article at `01` with an explicit refusal rule.
2. **Risk domains deserving articles** (multiselect) — security/auth, data
   integrity, docs truthfulness, accessibility/design system, quality bar
   (warnings/tests/gates), governance of AI assistance.
3. **Optional layers** (multiselect) — AI-policy tiers (T1–T4 by blast
   radius), `specs/` (spec-driven design for T1/T2), `plan/` (default yes).
4. **Team shape** — solo or team. Solo repos express review gates as
   *process gates* (AI-critic pass in a fresh session, cooldowns) instead of
   reviewer headcount; team repos name required reviewers.

Rule of thumb for how much to scaffold: low-risk / consultant-slice repo →
constitution with ~4 articles, 6–8 instruction files, no tiers or specs
(CashKoh shape). Production backend with auth/PII → 6 articles including
Amendments, 12–19 files, tiers + specs (NTBackend shape).

## Step 3 — Derive the rule set

Draft the instruction file list (number + name + one-liner each) and show it
to the user for sign-off **before writing the files**. Candidates:

- **Universal** (appear in every reference repo): scope or security at `01`,
  session-protocol, docs-truthfulness, testing, review-gates,
  error-handling, dependencies, logging.
- **Stack-specific** — derive from the actual codebase, e.g.: datetime-and-
  culture, async-and-cancellation, httpclient-and-di, nullability (- .NET);
  tokens, markup, consistency, ui-character, htmx (design/frontend);
  data-layer, background-services, observability (backend).
- **Process** — ai-assistant-policy last, if tiers were opted in.

## Step 4 — Write the files

Skeletons live in [templates.md](templates.md). Write in this order so links
resolve as you go: `instructions/*.md` → `instructions/README.md` →
`CONSTITUTION.md` → `CLAUDE.md` → `CONTEXT.md` → `plan/README.md` →
`specs/README.md` + `specs/TEMPLATE.md` (if opted in).

Two instruction-file shapes — pick per repo, don't mix:

- **Rule / Why / How to apply** — design-system and consultant-slice repos.
  The Why earns the rule; How to apply gives the concrete procedure and
  enumerates real repo artifacts (existing tokens, components).
- **Domain sections + Banned patterns + Review tier** — engineering repos.
  End with a `## Banned patterns (review-blocking)` list of mechanical,
  greppable patterns a reviewer can check without judgment
  (`DateTime.Now` in non-test code, `new HttpClient()`, `.Result`).
  Open with the incident that motivated the file when git history has one.

Writing rules:

- **By-symptom table entries are concrete and greppable** — "Timezone off by
  N hours", "`new HttpClient()` in a PR" — not "date issues".
- Terse, declarative, no filler. These docs are read at session start; every
  line costs attention.
- CONTEXT.md is seeded short: app scope, layout, "Up next", "Decisions worth
  honoring" — and nothing that belongs in a rule file.

## Step 5 — Finish

- If the repo already had a CLAUDE.md, fold its still-true content into the
  new structure (build commands stay in CLAUDE.md; rules move to
  instructions/) — don't silently drop anything, list what you dropped.
- Cross-tool portability: if the repo has `AGENTS.md` / `.cursorrules` /
  `.github/copilot-instructions.md`, make them point at the constitution —
  one source of truth.
- Do not commit; leave the files for the user to review.
- Close by listing generated files and flagging every rule you inferred
  rather than confirmed, so the user can correct before first use.
