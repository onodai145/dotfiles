#!/usr/bin/env bash
# UserPromptSubmit hook: re-inject a strong reminder to check for and use
# relevant superpowers skills before responding to this turn's prompt.
# Keeps the "you MUST use a skill if 1% relevant" rule fresh even in long
# conversations where the SessionStart injection has scrolled out of focus.
cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"REMINDER (superpowers): before responding to this prompt, check whether any available skill applies (superpowers:brainstorming for new features/design, superpowers:systematic-debugging for bugs, superpowers:test-driven-development before writing implementation code, etc.). If there is even a 1% chance a skill applies, invoke it via the Skill tool BEFORE doing anything else - including clarifying questions or exploration. Do not skip this because the task 'seems simple' or you 'remember the skill already'."}}
EOF
