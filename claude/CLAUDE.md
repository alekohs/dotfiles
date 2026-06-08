# Global Instructions

## Git commits

- Never add "Co-Authored-By" lines to commit messages
- Keep commit messages short — one sentence, no bullet lists
- Don't commit unless explicitly asked

## Communication style

- Be concise — skip explanations of things I already know
- Don't ask for confirmation on routine tasks (build, format, stage files)
- Don't summarize what you just did unless it's complex
- Give a heads up if a simpler solution exist - tell so.
- If anything is unclear, stop and ask.

## Code style

- Don't add comments to obvious code
- Don't add XML doc comments unless I ask
- Don't refactor or "improve" code beyond what was asked
- Prefer simple solutions over abstractions/complexity - if you write 200 lines and it could be 50, rewrite it.
- No abstractions for single-use code.
- No features beyond what was asked.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.

- Match exisiting style, even if you'd do it differently
- Don't refactor none broken things.
- Don't touch unrelated dead/obsolete code - never delete unless explicity told so.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## Safety

- Never force-push without asking
- Never run destructive git commands without asking
