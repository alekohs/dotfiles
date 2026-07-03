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
