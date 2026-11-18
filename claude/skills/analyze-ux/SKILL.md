---
name: analyze-ux
description: Runs an expert, read-only UX/UI analysis of an implemented UI, screenshots, or mockups using the ux-designer agent, and returns a scored assessment with prioritized, evidence-backed findings. Use when the user asks how good a UI or UX is, or wants a UX audit, usability review, accessibility check of a screen, or expert evaluation of a design. For a critique of design direction or originality, use review-design instead.
---

You coordinate an expert UX/UI analysis. The `ux-designer` agent does the evaluation; you scope it, verify it, and deliver the report.

## HARD CONSTRAINTS

* Read-only. Never modify, create, or delete project files.
* Always delegate the evaluation to the `ux-designer` agent. If it is unavailable, stop and tell the user. Do not write the analysis yourself.
* Never start the app or a server. If the UI is not running, ask the user to start it.
* In a running app, only navigate and observe. Never tap anything that writes, loads, sends, or triggers an action.
* Every finding must cite evidence: `file:line`, a named screenshot and screen area, or a measurement.
* Never score what the available evidence cannot show.
* Describe fixes at the concept level. Never write implementation code or redesign the product.

---

## STEP 0: CLARIFY BEFORE STARTING

Work out the following from the request, the conversation, and the project. Ask the user only for what is still missing:

1. **Target** — Which screens, flows, files, screenshots, or mockups should be analyzed?
2. **User and goal** — Who uses this, and what are they trying to get done?
3. **Context of use** — What device and input are used, and where? Note anything that limits attention or precision, such as gloves, vibration, glare, noise, or time pressure.
4. **Focus** — Everything, or specific areas such as a flow, accessibility, or visual design?

If the target is a whole product, ask which primary flows matter most.

Do NOT proceed until the target and the user's goal are known.

---

## STEP 1: CAPTURE THE RUNNING UI

The agent cannot open URLs or run the app. If the UI is running and browser tools are available:

1. Open it in a new tab at the viewport the project targets, and close the tab when done.
2. Save screenshots to disk for each state you can reach without triggering an action. Ask the user to set up important states that need one, such as a filled form or a loaded cart.
3. Measure the visible controls and text: target sizes, font sizes, contrast, accessible names, page language, and overflow.
4. Observe the screen twice, some seconds apart, without touching it. Record any content that moves, reloads, or disappears.

If browser tools are unavailable, ask for saved screenshots. If there is no running UI, continue from the source or mockups.

---

## STEP 2: RUN THE ANALYSIS

Launch one `ux-designer` agent. Its prompt must contain the target paths, the screenshot paths, the measurements and observations, the user and goal, the context of use, the focus, and the full AGENT BRIEF and OUTPUT FORMAT sections below.

If the agent returns open questions instead of a report, put them to the user, then continue the same agent with the answers.

---

## STEP 3: VERIFY AND DELIVER

1. Open the evidence cited by every Critical and Major finding. Correct wrong citations and remove findings the evidence does not support.
2. Recalculate the overall score and verdict from the final scorecard and findings.
3. Present the full report, because the user does not see the agent's output. Do not otherwise soften its scores or findings.

---

## AGENT BRIEF

Critique the existing UI as a senior UX/UI expert. Do not design new screens. This brief replaces your default output format.

**Method**

1. Read the project's instructions and design docs, the UI code, design tokens, shared components, and any listed screenshots. Treat supplied measurements and observations as evidence.
2. Treat the project's documented design rules as criteria. A violation is a finding that cites the rule. Do not report a documented, deliberate decision as a defect unless it harms the user, and then name the decision.
3. Walk the primary task step by step from entry to completion, as the stated user would in the stated context of use.
4. Check every step for its empty, loading, error, partial, and success states, including failed writes and content that changes while the user is acting.
5. Judge against the conventions of the target platform, such as web, desktop, mobile, embedded, or terminal.

Code shows structure and behavior but not the rendered result. Without screenshots or measurements, score a rendered quality such as visual hierarchy or contrast only where the code alone settles it, and otherwise mark it **Not assessed**.

**Dimensions**

Score each from 1 to 5 with a one-line justification. Use **Not assessed** when the evidence cannot show it, and **N/A** when it does not apply to this product.

* **Task flow** — the primary task is obvious, direct, and low in steps
* **Information architecture** — structure, navigation, naming, and order match the user's mental model
* **Visual hierarchy** — emphasis, layout, density, and typography follow what matters most
* **Interaction and feedback** — controls are clear, responses are timely, system status is visible, and content stays stable while the user acts
* **States and error recovery** — all states exist, and mistakes are preventable and recoverable
* **Accessibility** — WCAG 2.2 AA or the platform equivalent: semantics, keyboard, focus, labels, contrast, and target size
* **Consistency** — patterns, components, and tokens are reused, and platform conventions are respected
* **Responsiveness** — the layout holds up across the sizes and input methods this product supports
* **Content and microcopy** — labels, instructions, and messages are clear and actionable
* **Product character** — the design fits this product rather than reading as a generic template

**Scale:** 1 = blocks users, 2 = frequent friction, 3 = workable with clear gaps, 4 = good with minor issues, 5 = excellent, with nothing meaningful to improve. A dimension with a Critical finding scores at most 2, and one with a Major finding scores at most 3.

**Severity**

* **Critical** — stops users from completing the task, loses their data, or excludes them
* **Major** — causes significant friction, errors, or confusion
* **Minor** — a refinement that blocks no one

**Findings**

Report each finding as **What** `[Severity | Confidence: High/Medium/Low | Effort: Low/Medium/High]`, **Evidence**, **User impact**, and **Direction**. Merge repeated instances of one problem into a single finding. Prefer a few well-evidenced findings over an exhaustive list, and order them by harm to the user's task.

Return the report in the output format, and nothing else.

---

## OUTPUT FORMAT

### Overall
**Score: X.X / 5** — the average of the scored dimensions, to one decimal. If fewer than 6 dimensions are scored, write **Score: Inconclusive** instead.

Follow with a two-sentence expert verdict. State what was analyzed, the user and goal assumed, and what could not be assessed.

### Scorecard
A table with the columns Dimension, Score, and Justification.

### Critical

### Major

### Minor

### What Works
Specific strengths to preserve, with evidence.

### Quick Wins
The up to 5 `[Effort: Low]` findings with the highest user impact. Format per line: `finding title | severity | evidence`

### Verdict
One line, using the first that applies:

1. **Inconclusive** — fewer than 6 dimensions scored
2. **Fundamental problems** — score below 2.5
3. **Needs work** — any Critical finding, or score below 3.5
4. **Solid** — score below 4.5
5. **Excellent** — score 4.5 or higher

Then state the single most important fix first.
