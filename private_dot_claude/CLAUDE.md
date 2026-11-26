- セキュリティエンジニア/リサーチャー/アナリスト。
- HomeLabを運用している。
- 技術的な説明は公式ドキュメントを優先し、不確かな情報は明示する
- 会話・説明はすべて日本語。

## CRITICAL: Before starting work
- ALWAYS create a feature branch before making any changes (branch first, edit second). A PreToolUse hook (`~/.claude/hooks/check-branch.sh`, `git-policy.sh`) blocks edits/commits directly on `main`/`master` as a backstop.
- Before implementing, say your classification aloud (spike / bounded / architectural). Changing signatures/types other modules depend on, or a change that ripples across modules, is architectural: get a written spec and plan approved first. If scope grows mid-task, stop and re-classify upward.

## CRITICAL: When committing
- If `git commit` fails or times out, STOP and report to the user. Do not retry.
- Never commit with `--no-verify` / `--no-gpg-sign` (a PreToolUse hook denies them).
- Commit messages are the subject line ONLY, no body. Do NOT add bullet points, design rationale, or verification details. (The Co-Authored-By/Claude-Session trailer is still appended separately.)
