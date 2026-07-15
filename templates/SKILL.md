---
name: skill-name
description: "One or two sentences covering BOTH what this skill does AND when to use it. This text is the only thing the agent sees when deciding whether to load the skill, so lead with the trigger. Include concrete trigger phrases the user might say. Keep the value wrapped in double quotes with single quotes inside — an unquoted ': ' breaks YAML parsers. Max 1024 chars; lowercase-hyphenated name, max 64 chars, no 'claude'/'anthropic'."
---

# Skill Name

One-line statement of what this skill accomplishes.

## When to use

- Situation / phrasing that should trigger this skill.
- Another trigger.
- **Not** for: cases that look similar but this skill should stay out of.

## How to run

1. Step-by-step procedure the agent should follow.
2. Reference bundled files by relative path, e.g. `scripts/do_thing.sh` or
   [`references/details.md`](references/details.md) — they load only when needed.

## Output / result

What the finished result should look like.

## Pitfalls

- Common failure and how to avoid it.

<!--
Bundle supporting files in these subfolders (all optional):
  scripts/     executable helpers the agent runs (deterministic > regenerated code)
  references/  docs the agent reads on demand (keep SKILL.md itself short)
  templates/   starter files to copy
  assets/      images, data, other resources
Keep only the portable core in this file (name, description, plain Markdown) so it
works across Claude Code, Codex, Cursor, and Hermes. Put agent-specific config in
sidecar files (e.g. agents/openai.yaml for Codex) rather than here.
-->
