# Cargo needs a Kache executable on PATH to use it as a runner.
builtin whence -pa kache >/dev/null || return 0

# Cargo test runner
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUNNER="${CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUNNER:-kache test-runner}"

# Compiler shims
typeset -U path
path=("$HOME/.local/lib/kache/shims" $path)

# Shell completions
if [[ -o interactive && -r "$HOME/.local/share/kache/completions/kache.zsh" ]]; then
    if (( ! $+functions[compdef] )); then
        autoload -Uz compinit
        compinit
    fi
    source "$HOME/.local/share/kache/completions/kache.zsh"
fi
