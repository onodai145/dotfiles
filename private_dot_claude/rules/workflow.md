## CRITICAL: Before starting work
- Check the current branch: `git branch --show-current`
- NEVER commit directly to `main` or `master`, NO EXCEPTIONS
- ALWAYS create a feature branch before making any changes
- Order matters: run `git checkout -b` BEFORE editing any file. NEVER edit first and branch off afterward (never leave uncommitted changes sitting on `main`). Branch creation must complete before the first tool call that touches a working file.

## CRITICAL: When committing
- NEVER use `--no-gpg-sign` or `--no-verify`
- NEVER bypass signing for any reason, including timeouts or errors
- If `git commit` fails or times out, STOP and report to the user. Do NOT retry with signing disabled.
- Commit messages are the subject line ONLY, no body. Do NOT add bullet points, design rationale, or verification details. (The Co-Authored-By/Claude-Session trailer is still appended separately.)
