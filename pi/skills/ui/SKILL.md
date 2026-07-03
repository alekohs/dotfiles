---
name: ui
description: Opinionated UI/visual-design help for developers who aren't designers. Either critiques an existing screen and returns concrete prioritized fixes, or picks a coherent aesthetic and applies it — making the design calls FOR you instead of asking what you want. Use when something "looks off", a page/component needs to look good, or you don't know what design choices to make. For a full new app where you DO have direction, prefer the frontend-design skill.
argument-hint: [file/component or "make X look better"]
allowed-tools: read, bash, grep, edit, write
shell-timeout: 15
---

# UI Design (for non-designers)

Target: `$ARGUMENTS`. Your job is to make the visual decisions a developer typically gets wrong, with **specific values** — never vague advice like "add some spacing".

First, `read` the relevant files (and any existing CSS/theme/tokens via `rg`/`bash`) to see what's already there.

## Pick the mode

- **Critique mode** — code/UI already exists → audit it and return ranked fixes.
- **Build mode** — little or nothing exists → choose a coherent system and apply it.

If the project already has a design system or token file, **respect it** — don't invent a competing one. Extend what's there.

## The few levers that matter most

Non-designers lose 90% of polish on these. Address them in this order:

1. **Spacing & rhythm** — use one consistent scale (e.g. 4px base: 4/8/12/16/24/32/48). Inconsistent gaps are the #1 amateur tell. Give exact values.
2. **Typography** — a small type scale (e.g. 12/14/16/20/24/32), one or two families max, deliberate weight/line-height. Avoid default Inter + SaaS-blue slop.
3. **Hierarchy** — one clear primary action per view; size, weight, and color should make importance obvious at a glance. Demote secondary elements.
4. **Color restraint** — one accent, a neutral ramp, semantic states. Most things are neutral; color earns attention. Give hex values.
5. **Alignment & grouping** — align to a grid, group related items, use whitespace to separate. Nothing floats arbitrarily.
6. **Contrast / a11y** — body text ≥ 4.5:1, interactive targets ≥ 40px, visible focus states. Flag real failures.

## Output

**Critique mode:** a prioritized list. Each item = what's wrong → the concrete fix (with values) → severity. Lead with the 3 changes that buy the most polish. Offer to apply them with `edit` after I pick.

**Build mode:** state the aesthetic direction in one sentence and why it fits, give a compact token block (spacing scale, type scale, colors, radius/shadow), then apply it. Be decisive — commit to one coherent look rather than hedging between two.

Default to restraint and consistency over cleverness. A plain, consistent, well-spaced UI beats an ambitious inconsistent one every time.
