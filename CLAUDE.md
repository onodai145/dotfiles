# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A [chezmoi](https://www.chezmoi.io/) source state for the user's Linux dotfiles (Arch/Hyprland desktop). Files here are *source* representations that chezmoi renders/copies into `$HOME`; this repo does not contain the live config files themselves.

## Chezmoi naming conventions (important when adding/renaming files)

Chezmoi encodes target behavior in the source filename:

- `dot_foo` → deploys as `~/.foo`
- `private_` prefix → target file/dir gets `0600`/`0700` perms (used for anything with secrets or sensitive host-specific data, e.g. `dot_config/alacritty/private_alacritty.toml`, `dot_config/private_mpv`, `dot_config/hypr/private_hyprland.conf`)
- `executable_` prefix → target gets the executable bit (used for the hook scripts under `private_dot_claude/hooks/`)
- Nested `dot_config/<tool>/...` mirrors `~/.config/<tool>/...` exactly

When adding a new dotfile, mirror the target's path/permission needs using these prefixes rather than `chmod`-ing after the fact. There are currently no `.tmpl` templates or a `.chezmoi.toml.tmpl` in this repo — everything is applied as static content — so don't introduce templating unless it's actually needed.

## Common commands

```sh
chezmoi diff              # preview what would change in $HOME
chezmoi apply             # apply this source state to $HOME
chezmoi apply -v          # verbose apply (shows each file touched)
chezmoi add <path>        # import an existing ~ file/dir into the source state (adds with correct dot_/private_/executable_ prefix)
chezmoi cd                # open a shell in the source dir (this repo)
chezmoi status            # show pending changes
```

There is no build/lint/test suite — changes are validated by running `chezmoi diff`/`chezmoi apply` and checking the resulting shell/app config behaves as expected.

## Structure

- `dot_config/` — per-application config, one subdirectory per tool (zsh, tmux, hypr, ghostty, alacritty, git, starship, mise, sheldon, rofi, mpv, MangoHud, fontconfig, linux-xanmod, ccstatusline).
- `dot_zshrc` / `dot_zprofile` — shell init; zsh plugins are managed via `sheldon` (`dot_config/sheldon/plugins.toml`), sourced from `.zshrc` with `eval "$(sheldon source)"`.
- `dot_config/git/config` uses `includeIf` to load host-specific git identity/config from `dot_config/git/github.com.config` and `dot_config/git/git.omhnc.net.config` based on the remote URL — keep per-host credentials/identity in those included files, not the main `config`.
- `private_dot_claude/` — the user's global Claude Code config, tracked here so it's synced across machines:
  - `CLAUDE.md` → deploys to `~/.claude/CLAUDE.md` (global instructions for *all* projects — the user is a security engineer/researcher, runs a homelab, prefers official docs over guesses, and wants Japanese for conversation/explanations)
  - `rules/workflow.md` → global git workflow rules (never commit to main/master, branch before editing, never bypass commit signing/hooks, subject-line-only commit messages)
  - `hooks/executable_doc-update-check.sh` — `Stop` hook: blocks ending a turn if source files changed without any accompanying doc change (CLAUDE.md/README/docs/CHANGELOG), once per distinct diff per session
  - `hooks/executable_superpowers-reminder.sh` — `UserPromptSubmit` hook: re-injects the reminder to check for applicable Superpowers skills before responding
  - `settings.json` — model/effort defaults, enabled plugins (superpowers, code-review, frontend-design, voltagent subagent packs, etc.) and notification/status-line setup

Because `private_dot_claude/*` *is* the global Claude Code config, editing it changes Claude Code's own behavior across every other repo the user works in — treat changes here with more care than a typical config tweak, and be aware the instructions you're currently operating under (this session's CLAUDE.md/rules/hooks) live in this same directory.
