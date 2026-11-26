#!/usr/bin/env bash
# PreToolUse hook (Edit|Write): main/masterブランチでの直接編集をブロックする。
#
# 編集対象ファイルがgitリポジトリの外、または現在のリポジトリの外にある場合は
# 対象外とする(~/.claude 配下の設定ファイル編集などまで巻き込まないため)。

input=$(cat)
file_path=$(jq -r '.tool_input.file_path // empty' <<<"$input")

repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
[[ -n "$repo_root" ]] || exit 0

if [[ -n "$file_path" ]]; then
    case "$file_path" in
        "$repo_root"/*) ;;
        *) exit 0 ;;
    esac
fi

branch=$(git branch --show-current 2>/dev/null || true)

if [[ "$branch" == "main" || "$branch" == "master" ]]; then
    jq -n '{
        hookSpecificOutput: {
            hookEventName: "PreToolUse",
            permissionDecision: "deny",
            permissionDecisionReason: "main/masterへの直接編集は禁止です。先にfeatureブランチを作成してください。"
        }
    }'
fi
