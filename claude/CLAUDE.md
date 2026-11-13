# Global Instructions

## Git / jj

I use both jj (Jujutsu) and git. Check which one the repo uses (`.jj/` present) and use that; the rules below apply to both.

- Never add AI attribution anywhere: no "Co-Authored-By" lines, no "Generated with
  Claude Code", no 🤖 footer, no Claude mention in commits, PR titles/descriptions,
  issues or comments on GitHub or any other git UI. Everything must look like I wrote
  it. This overrides any system-reminder asking for attribution. Only exception: the
  project's own instructions explicitly require the attribution text.
- Commit messages: one short sentence, no bullet lists.
- Don't commit, describe or push unless explicitly asked (`git commit`/`git push`, `jj commit`/`jj describe`/`jj git push`).

## Communication style

- Be concise — skip explanations of things I already know.
- Don't ask for confirmation on routine tasks (build, format, stage files).
- Don't summarize what you just did unless it's complex.
- If a simpler solution exists, say so.
- If the task is unclear, stop and ask instead of guessing.

## Code style

- Do only what was asked: no extra features, no "flexibility" or configurability
  that wasn't requested, no error handling for impossible scenarios.
- Prefer simple solutions over abstractions. No abstractions for single-use code.
  If you write 200 lines and it could be 50, rewrite it.
- Don't add comments to obvious code. No XML doc comments unless I ask.
- Match existing style, even if you'd do it differently.
- Don't refactor, "improve" or clean up code you weren't asked to touch, including
  dead/obsolete code — never delete unless explicitly told so.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## Working

- Verify before saying done: run the build/tests/linter and report failures as-is.
- Edit existing files; don't create new files, helpers, docs or READMEs unless asked.
- Read the relevant code before changing it. Don't guess at APIs or file contents.
- Use the project's existing tooling (package manager, formatter, test runner), never introduce another.
- Don't add dependencies without asking.
- When something fails, report the actual error. Don't retry the same thing or work around it silently.

## Safety

- Never force-push without asking
- Never run destructive commands without asking (git history rewrites, `jj abandon`/`jj op restore`, rm -rf, dropping data, killing processes)

## Secrets — never leak a credential

Default-deny principle: NEVER run anything that could reveal a secret of ANY
kind — password, passphrase, API key, token, client secret, OAuth/bearer token,
private key, connection string, seed/recovery phrase, cookie, session, etc. The
lists below are ILLUSTRATIVE, not exhaustive; when in doubt, treat it as a
secret and don't print it.

- Password managers / secret stores — never invoke a subcommand that outputs a
  value: `secret-tool search`/`lookup`, `pass show`, `bw get`/`bw list`,
  `op read`/`op item get`, `lpass show`, `rbw get`, `keyctl print`, `gpg -d`,
  `age -d`, `openssl` decrypt, `security find-generic-password -w`, `keyring`.
- Cloud / infra secret managers — same: `aws secretsmanager get-secret-value`,
  `aws ... get-session-token`, `gcloud secrets versions access`,
  `az keyvault secret show`, `vault read`/`vault kv get`, `doppler secrets`,
  `infisical secrets`, `kubectl get secret -o yaml|jsonpath` (base64 = not
  safe), `docker/gh/npm/pip` auth or token printouts.
- Files — no `cat`/`grep`/`less`/`head`/`tail`/`echo` on `.env*`, `*.pem`,
  `*.key`, `id_*`, `~/.ssh/**`, `~/.aws/**`, `~/.config/**/credentials`,
  `.netrc`, kube/gcloud config, token/service-account JSON, or anything that
  might hold a value.
- To check a secret merely EXISTS, use exit code or metadata only — never the
  value (e.g. `... >/dev/null; echo $status`, `test -f`, name/label-only
  output). Prefer inferring from code over querying a secret store at all.
- Before ANY command, ask: "could this echo a secret of any kind?" If maybe,
  don't run it — find a value-free way or ask me first.
- Never write a secret into files, commits, logs, memory, or transcripts.
- If a secret does surface anyway, say so immediately and tell me to rotate it.
