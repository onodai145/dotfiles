#!/usr/bin/env bash
# UserPromptSubmit hook: re-inject a strong reminder to check for and use
# relevant superpowers skills before responding to this turn's prompt.
# Keeps the "you MUST use a skill if 1% relevant" rule fresh even in long
# conversations where the SessionStart injection has scrolled out of focus.
cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"REMINDER (superpowers): before responding to this prompt, check whether any available skill applies (superpowers:brainstorming for new features/design, superpowers:systematic-debugging for bugs, superpowers:test-driven-development before writing implementation code, etc.). If there is even a 1% chance a skill applies, invoke it via the Skill tool BEFORE doing anything else - including clarifying questions or exploration. Do not skip this because the task 'seems simple' or you 'remember the skill already'. BEFORE ANY EDIT, apply this checklist: (1) State your classification aloud: spike / bounded / architectural. (2) It is ARCHITECTURAL if it changes function signatures, types or traits that other modules use, ripples across two or more modules, or adds a subsystem; when in doubt, take the heavier path. (3) ARCHITECTURAL requires a written spec (docs/superpowers/specs/) the user has approved, then a written plan (docs/superpowers/plans/), BEFORE any implementation; a chat-only design is not enough. (4) If scope grows mid-task (e.g. a change starts touching other modules), STOP, say so, and re-classify upward; never keep implementing because you are 'almost done'."}}
EOF
