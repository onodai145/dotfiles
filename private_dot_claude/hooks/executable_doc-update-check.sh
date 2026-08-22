#!/usr/bin/env bash
# Stop hook: when source code changed but no doc files (CLAUDE.md, docs/, README, ...)
# changed alongside it, block ending the turn and ask Claude to confirm whether docs
# need updating. Avoids infinite loops by only blocking once per distinct diff state
# per session (tracked via a hash file keyed on session_id).
set -euo pipefail

input=$(cat)
session_id=$(printf '%s' "$input" | jq -r '.session_id // "unknown"' 2>/dev/null || echo "unknown")

# Only act inside a git repo.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

changed=$(git status --porcelain | awk '{print $2}')
if [ -z "$changed" ]; then
  exit 0
fi

doc_pattern='(^|/)(CLAUDE\.md|AGENTS\.md|GEMINI\.md|README(\.[A-Za-z]+)?|CHANGELOG\.md)$|(^|/)docs/'
code_pattern='\.(rs|ts|tsx|js|jsx|svelte|py|go|java|kt|swift|c|cpp|h|hpp|rb|cs)$'
ignore_pattern='(^|/)(target|node_modules|dist|build|\.git|Cargo\.lock|pnpm-lock\.yaml|package-lock\.json|yarn\.lock|frontend/src/bindings/tauri\.gen\.ts)(/|$)'

has_code_change=false
has_doc_change=false
while IFS= read -r f; do
  [ -z "$f" ] && continue
  if echo "$f" | grep -qE "$ignore_pattern"; then
    continue
  fi
  if echo "$f" | grep -qE "$doc_pattern"; then
    has_doc_change=true
  elif echo "$f" | grep -qE "$code_pattern"; then
    has_code_change=true
  fi
done <<< "$changed"

if [ "$has_code_change" != true ] || [ "$has_doc_change" = true ]; then
  exit 0
fi

state_dir="${TMPDIR:-/tmp}/claude-doc-check"
mkdir -p "$state_dir"
state_file="$state_dir/${session_id}.hash"
current_hash=$(printf '%s\n' "$changed" | sort | sha256sum | cut -d' ' -f1)

if [ -f "$state_file" ] && [ "$(cat "$state_file")" = "$current_hash" ]; then
  exit 0
fi
printf '%s' "$current_hash" > "$state_file"

cat <<'EOF'
{"decision":"block","reason":"Source files changed but no documentation (CLAUDE.md / docs/ / README) changed alongside them. Before finishing, check whether these docs need updating for this change, and update them if so. If the update is a CLAUDE.md learning/convention, consider invoking the claude-md-management:revise-claude-md skill (or claude-md-management:claude-md-improver for a broader CLAUDE.md quality pass) rather than editing ad hoc. For docs/ design or guide content, edit directly. If no update is needed, say so briefly and then stop."}
EOF
