#!/usr/bin/env bash
# PreToolUse hook (Bash): git commit関連のポリシーを強制する。
#   - main/masterへの直接コミット禁止
#   - 署名・検証のbypassフラグでのcommit禁止(--no-verify / --no-gpg-sign / -n、
#     および -c commit.gpgsign=false / -c core.hooksPath=... / GIT_CONFIG_* の設定経由、
#     git config commit.gpgsign false も含む)

set -euo pipefail

input=$(cat)
command=$(jq -r '.tool_input.command // ""' <<<"$input")

# git commit が実行される形だけを対象にする。grep/echoなど別コマンドの引数に
# 文字列が現れただけの場合は対象外。
#   - コマンド区切り(; & | ( ` { 改行)の直後。env/sudo等や VAR=val の前置きは許容
#   - bash -c / sh -c / eval / xargs 配下はコマンドが文字列に包まれるため、
#     位置を問わず対象にする(取りこぼし防止を優先)
nl=$'\n'
head_re="(^|[;&|(\`{${nl}])[[:space:]]*((env|command|sudo|time|nohup|exec|builtin)[[:space:]]+|[A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*[[:space:]]+)*"
wrap_re="(^|[[:space:];&|(])(bash|sh|zsh|dash|eval|xargs)[[:space:]].*"
in_segment="[^;&|${nl}]*"
# git のグローバルオプション(-C dir / -c k=v / --no-pager など)が git と commit の間に
# 挟まる形も対象にする。値は引用符付きでもよい。
opt_val="([^[:space:]\"']|\"[^\"]*\"|'[^']*')+"
git_opts="([[:space:]]+(-[Cc][[:space:]]+${opt_val}|--(git-dir|work-tree|namespace|exec-path)[[:space:]]+${opt_val}|--[a-z][a-z-]*(=${opt_val})?|-[a-zA-Z]))*"
# "commit" の直後の境界。空白・区切り記号・引用符・行末のみ。commit-tree / commit-graph
# など別サブコマンドや、設定キー(commit.gpgsign)の一部は含めない。
end_re="([[:space:];&|)\"'\`]|\$)"

# $1: 判定対象の文字列 $2: "git commit" に続くパターン
has_commit() {
    local re1="${head_re}git${git_opts}[[:space:]]+commit$2"
    local re2="${wrap_re}git${git_opts}[[:space:]]+commit$2"
    [[ "$1" =~ $re1 ]] || [[ "$1" =~ $re2 ]]
}

# 設定経由の bypass: git -c commit.gpgsign=false / -c core.hooksPath=... commit
# (git config のキー・bool値は大文字小文字を区別しないため、小文字化して判定する)
cfg_re="-c[[:space:]]+[\"']?(commit\.gpgsign=(false|no|off|0)|core\.hookspath=)[^[:space:]]*"
has_cfg_bypass() {
    local lc="${1,,}"
    local re1="${head_re}git${git_opts}[[:space:]]+${cfg_re}${git_opts}[[:space:]]+commit${end_re}"
    local re2="${wrap_re}git${git_opts}[[:space:]]+${cfg_re}${git_opts}[[:space:]]+commit${end_re}"
    [[ "$lc" =~ $re1 ]] || [[ "$lc" =~ $re2 ]]
}

deny_bypass() {
    jq -n '{
        hookSpecificOutput: {
            hookEventName: "PreToolUse",
            permissionDecision: "deny",
            permissionDecisionReason: "署名・検証のbypassフラグを使ったcommitは禁止です。"
        }
    }'
    exit 0
}

# git config で署名を無効化するコマンド自体を拒否する。署名が通らない時の回避策として
# 使われやすく、git commit と別のコマンドで実行されるため、下の git commit 判定より先に見る。
# core.hooksPath は正当な用途(.githooks の指定など)があるので、ここでは対象にしない。
gpg_off_re="config${in_segment}commit\.gpgsign[[:space:]=]+[\"']?(false|no|off|0)"
has_config_gpg_off() {
    local lc="${1,,}"
    local re1="${head_re}git${git_opts}[[:space:]]+${gpg_off_re}"
    local re2="${wrap_re}git${git_opts}[[:space:]]+${gpg_off_re}"
    [[ "$lc" =~ $re1 ]] || [[ "$lc" =~ $re2 ]]
}
if has_config_gpg_off "$command"; then
    deny_bypass
fi

# 環境変数経由の設定: GIT_CONFIG_COUNT/KEY_n/PARAMETERS で署名・hooksPath を上書きする形。
# git commit と同じコマンド文字列内にある場合のみ対象(別コマンドで export した場合は検出できない)。
env_cfg_re="git_config_(parameters|key_[0-9]+)=${in_segment}(commit\.gpgsign|core\.hookspath)"
has_env_cfg_bypass() {
    local lc="${1,,}"
    [[ "$lc" =~ $env_cfg_re ]]
}

# git commit 以外は対象外
has_commit "$command" "$end_re" || exit 0

# 署名・verificationのbypassを禁止(ブランチ問わず)
# フラグは git commit と同じコマンド区切り内にある場合のみ対象。
# 短縮形 -n(--no-verify と同義)は、-m "..." のメッセージ内の文字列を誤検知しないよう
# クォート内を除いた文字列で判定する。ただしフラグ単体をクォートした形('-n')は別途拾う。
unquoted=$(printf '%s' "$command" | sed -Ez "s/\"[^\"]*\"//g; s/'[^']*'//g")
short_n="-[a-zA-Z]*n[a-zA-Z]*"
if has_commit "$command" "${in_segment}--no-(verify|gpg-sign)" ||
    has_commit "$unquoted" "${in_segment}[[:space:]]${short_n}([[:space:]]|\$)" ||
    has_commit "$command" "${in_segment}[[:space:]][\"']${short_n}[\"']([[:space:]]|\$)" ||
    has_cfg_bypass "$command" ||
    has_env_cfg_bypass "$command"; then
    deny_bypass
fi

# main/master への commit を禁止
# git -C <dir> commit の場合は cwd ではなく <dir> のブランチを見る。-C が複数ある場合は
# git と同じく順に適用する(相対パスは直前の -C からの相対)。~ のみ展開し、変数など
# 展開できない指定はブランチを取得できず、許可側に倒れる(eval はしない)。
repo_dirs=()
c_re="git${git_opts}[[:space:]]+-C[[:space:]]+${opt_val}${git_opts}[[:space:]]+commit"
val_re="-C[[:space:]]+(\"([^\"]*)\"|'([^']*)'|([^[:space:]]+))"
if [[ "$command" =~ $c_re ]]; then
    rest="${BASH_REMATCH[0]}"
    while [[ "$rest" =~ $val_re ]]; do
        dir="${BASH_REMATCH[2]}${BASH_REMATCH[3]}${BASH_REMATCH[4]}"
        repo_dirs+=("${dir/#\~/$HOME}")
        rest="${rest#*"${BASH_REMATCH[0]}"}"
    done
fi
branch=$(
    for dir in "${repo_dirs[@]}"; do
        cd "$dir" 2>/dev/null || exit 0
    done
    git branch --show-current 2>/dev/null || true
)

if [[ "$branch" == "main" || "$branch" == "master" ]]; then
    jq -n \
        --arg reason "main/masterへの直接コミットは禁止です。featureブランチを作成してください。" \
        '{
            hookSpecificOutput: {
                hookEventName: "PreToolUse",
                permissionDecision: "deny",
                permissionDecisionReason: $reason
            }
        }'
fi
