---
name: scaffold-instructions
description: Scaffolds an instruction system for a repo or folder. Default shape is docs-first (CLAUDE.md "rules that can't be broken" linking into an authoritative docs/, numbered principles in the design README, research/ and provenance/); the alternative is constitution (CONSTITUTION.md principles, CLAUDE.md dispatcher, numbered instructions/, CONTEXT.md, plan/, optional specs/ + AI-policy tiers). Use when the user asks to set up instructions, governance docs, or a constitution for a project.
---

You are scaffolding the instruction system the user runs across their repos.
There are two shapes. **Docs-first is the default**; use constitution only
when the analysis clearly points to it or the user asks. Pick one per repo;
never mix them.

## Docs-first (default)

The design docs are the law; CLAUDE.md is the short list of invariants an
agent must never break, each one pointing at the doc section that holds the
detail and rationale.

| File                        | Job                                                                                                                                              | Never contains                                               |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------ |
| `CLAUDE.md`                 | Repo intro, pointer to the key doc, `## Rules that can't be broken`                                                                              | Rationale, procedures, long examples — those live in `docs/` |
| `docs/`                     | **The source of truth.** What has been decided and what gets built. Each doc has a `**Status:**` line and an open-questions section              | Speculation not yet decided                                  |
| `docs/design/README.md`     | Index table of design docs with status, plain-language "What kind of system this is", numbered **Core principles**, each stated once with a link | Enforcement detail                                           |
| `docs/design/milestones.md` | Goal, scope, exit criteria and outside decisions per milestone (replaces `plan/`)                                                                | —                                                            |
| `research/`                 | Spikes (`spikes/YYYY-MM-DD-topic.md`) and design input. Non-authoritative                                                                        | Decisions — those are carried into `docs/`                   |
| `provenance/` (optional)    | Where code comes from: clean-room subsystems with sources and last-audited date; derived code with file mapping                                  | —                                                            |

Core invariants — never violate:

1. **Authority is stated in CLAUDE.md, verbatim shape:** "**`docs/` is the
   source of truth.** `research/` holds spikes and <design> input only. When
   they disagree, `docs/` wins. Record decisions in `docs/`, not in
   `research/`." `research/README.md` repeats it, and says a spike's
   conclusions only count once written into `docs/`.
2. **Each rule is a bold declarative lead sentence**, followed by sub-bullets
   only when the boundary needs them, and a reference to the governing doc
   section (`docs/<doc>.md` §N). The rule names the repo's real types, config
   keys, error codes, tables and projects so it is checkable by grep.
3. **Exceptions are dated, singular and fenced:** `**One exception
(YYYY-MM-DD): <name>** (<doc> §N)`, nested under the rule they except. It
   names the one code site allowed, what holds it to that shape (a guard,
   a test), and ends "Don't widen this to …". An exception never loosens the
   parent rule for anything else.
4. **Rules change in the same PR as the code and docs that motivate them.**
   No drive-by edits; the PR adds the rule/exception, the doc section, and
   the code together.
5. **Approvals carry dates.** Approved dependencies are listed in CLAUDE.md
   with approval dates where they were added later; the full list with
   licences lives in the docs. Decided items in docs get "(decided
   YYYY-MM-DD)".
6. **Docs are checked by tests where they can be.** A register in the docs
   gets a test that fails when code and doc disagree. Prefer this over a
   prose rule.
7. **No session-state files.** Open items live in each doc's "Open
   questions" / "Still open" section and in `milestones.md`, not in
   `CONTEXT.md`. Built mockups and finished spikes are deleted — history is
   in git.
8. **Rules are concrete to THIS repo:** real paths, real components, real
   incidents. A rule that could be pasted into any repo unchanged is too
   generic — sharpen it with repo specifics or drop it.

## Constitution (alternative)

Separates **principles** from **enforcement** from **dispatch** from
**state**:

| File                       | Job                                                                                 | Never contains                     |
| -------------------------- | ----------------------------------------------------------------------------------- | ---------------------------------- |
| `CONSTITUTION.md`          | Principles as articles; each article links → the instruction files that enforce it  | Enforceable detail, build commands |
| `instructions/NN-topic.md` | One enforceable rule domain per file, numbered                                      | Principles, session state          |
| `instructions/README.md`   | Index of the files, grouped by category, + quick-reference tables                   | New rules                          |
| `CLAUDE.md`                | Dispatcher: repo intro, session protocol, by-task and by-symptom routing tables     | The rules themselves               |
| `CONTEXT.md`               | Session memory — decisions in flight, up next. ~50-line cap, pruned every session   | Durable rules                      |
| `plan/`                    | Dated multi-session efforts, `YYYY-MM-DD-short-topic.md` + README index with status | —                                  |
| `specs/` (optional)        | Spec-driven design for T1/T2 changes: TEMPLATE.md + dated specs                     | —                                  |

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
5. Same as docs-first: rules are concrete to THIS repo.

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
  (fewer rules / instruction files, generic-but-sharpenable) and note in each
  file where repo specifics should replace placeholders once code exists.

Read what exists before asking anything: README, any current CLAUDE.md /
AGENTS.md / .cursorrules, `docs/`, manifests (`go.mod`, `*.sln`/`*.csproj`,
`package.json`, `Cargo.toml`, `pyproject.toml`), directory layout, and
`git log --oneline -30` for recurring fix patterns (a bug fixed twice is a
rule waiting to be written — cite the commits). Determine:

- **Stack and layout** — single project or multi-project (constitution:
  multi-project repos get per-project CLAUDE.md + CONTEXT.md; the root docs
  stay the baseline that project docs may _add to_ but MUST NOT weaken).
- **Risk surface** — auth/tokens? money? PII? public API? outbound side
  effects? UI/a11y only? Risk domains become rules (docs-first) or articles
  (constitution).
- **Conventions already in the code** worth codifying instead of inventing.
- **Which shape fits** — docs-first unless something points away from it.
  Recommend constitution only when Claude's role is a restricted slice, or
  the repo has no design docs and the rules are working habits spread
  across many unrelated areas rather than invariants of one architecture.

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

1. **Shape** — ask this first, since it decides the rest. Before the
   question, explain the difference to the user in plain words — short, no
   jargon, no file lists beyond the essentials:

   > **Docs-first** (default) — your design docs are the law. CLAUDE.md is
   > one short list of rules that must never break, each pointing at the
   > doc that explains it. Good when the docs decide the architecture.
   >
   > **Constitution** — principles in one file, the rules split into
   > numbered topic files, plus a session-memory file. Good when the rules
   > are working habits across many areas, or Claude only does part of the
   > work.
   >
   > I recommend **<shape>** because <one sentence from the analysis>.

   Put the same one-line summaries in the AskUserQuestion option
   descriptions, with the recommended shape first (docs-first unless the
   analysis says otherwise).

2. **Claude's role** — full engineer / restricted slice / review-only.
   A restricted slice always gets a first rule (docs-first) or a scope
   article at `01` (constitution) with an explicit refusal rule.
3. **Risk domains** (multiselect) — security/auth, data integrity, personal
   data/erasure, outbound side effects, docs truthfulness, accessibility/
   design system, quality bar (warnings/tests/gates), governance of AI
   assistance.
4. **Optional layers** (multiselect) — docs-first: `provenance/`,
   `research/` (default yes), doc-checking tests. Constitution: AI-policy
   tiers (T1–T4 by blast radius), `specs/`, `plan/` (default yes).
5. **Team shape** — solo or team. Solo repos express review gates as
   _process gates_ (AI-critic pass in a fresh session, cooldowns) instead of
   reviewer headcount; team repos name required reviewers.

Rule of thumb for how much to scaffold. Docs-first: typically 15–30 rules,
as many as the architecture has invariants and no more. Constitution:
low-risk / consultant-slice repo → ~4 articles, 6–8 instruction files, no
tiers or specs; production backend with auth/PII → 6 articles including
Amendments, 12–19 files, tiers + specs. When showing the draft list, help
the user land on the right size: flag candidates that could merge, are too
generic to keep, or are better enforced by a test, and say where the count
sits against that range.

## Step 3 — Derive the rule set

Draft the list and show it to the user for sign-off **before writing the
files**.

Docs-first — rules (bold lead sentence + the doc section it points to) and
the numbered core principles for `docs/design/README.md`, grouped by theme.
Candidates: one rule per invariant the architecture depends on, plus where
code lives, dependency approval (with the approved list), secrets, handling
of untrusted input, side effects, and UI/API conventions.

Constitution — instruction files (number + name + one-liner each).
Candidates:

- **Universal**: scope or security at `01`, session-protocol,
  docs-truthfulness, testing, review-gates, error-handling, dependencies,
  logging.
- **Stack-specific** — derive from the actual codebase: one file per
  language/framework pitfall area, design-system area, or backend concern
  the code shows.
- **Process** — ai-assistant-policy last, if tiers were opted in.

## Step 4 — Write the files

Skeletons live in [templates.md](templates.md).

Docs-first order: `docs/` sections the rules will point at (create or
extend them first — a rule may not point at a section that doesn't exist) →
`docs/design/README.md` → `research/README.md` → `provenance/README.md` (if
opted in) → `CLAUDE.md` last.

Constitution order, so links resolve as you go: `instructions/*.md` →
`instructions/README.md` → `CONSTITUTION.md` → `CLAUDE.md` → `CONTEXT.md` →
`plan/README.md` → `specs/README.md` + `specs/TEMPLATE.md` (if opted in).
Two instruction-file shapes — pick per repo, don't mix:

- **Rule / Why / How to apply** — design-system and consultant-slice repos.
  The Why earns the rule; How to apply gives the concrete procedure and
  enumerates the repo's real artifacts.
- **Domain sections + Banned patterns + Review tier** — engineering repos.
  End with a `## Banned patterns (review-blocking)` list of mechanical,
  greppable patterns a reviewer can check without judgment.
  Open with the incident that motivated the file when git history has one.

Writing rules (both shapes):

- **By-symptom table entries are concrete and greppable** — an exact error,
  a banned pattern seen in a PR — not a vague category.
- Terse, declarative, no filler. These docs are read at session start; every
  line costs attention.
- Constitution: CONTEXT.md is seeded short: app scope, layout, "Up next",
  "Decisions worth honoring" — and nothing that belongs in a rule file.

## Step 5 — Finish

- If the repo already had a CLAUDE.md, fold its still-true content into the
  new structure (docs-first: rationale moves to `docs/`, the invariant
  stays; constitution: build commands stay in CLAUDE.md, rules move to
  instructions/) — don't silently drop anything, list what you dropped.
- Cross-tool portability: if the repo has `AGENTS.md` / `.cursorrules` /
  `.github/copilot-instructions.md`, make them point at CLAUDE.md
  (docs-first) or the constitution — one source of truth.
- Do not commit; leave the files for the user to review.
- Close by listing generated files and flagging every rule you inferred
  rather than confirmed, so the user can correct before first use. Mention
  `/audit-instructions` for drift checks and `/amend-rule` for changing a
  rule later.
