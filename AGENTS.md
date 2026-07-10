# AGENTS.md — working in this repo

This repo is a personal, cross-agent **skills library**. Each skill is authored
once in the portable [Agent Skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
format (`SKILL.md`) and loaded into Claude Code, Codex, Cursor, and Hermes via
symlinks — so one edit here updates every agent.

## Layout

```
skills/<name>/SKILL.md      canonical source of truth for each skill
skills/<name>/scripts/      executable helpers the skill runs
skills/<name>/references/   docs loaded on demand (keep SKILL.md short)
templates/SKILL.md          starter for a new skill
bin/sync.sh                 symlinks skills into each agent's skills dir
```

## Authoring rules

- **Portable core only** in `SKILL.md`: `name`, `description`, and plain Markdown.
  Put agent-specific config in sidecar files (e.g. `agents/openai.yaml` for Codex),
  never in the shared frontmatter.
- `name`: lowercase, hyphenated, ≤64 chars, matches the directory name. Avoid the
  words "claude"/"anthropic".
- `description`: the single most important field — it's all an agent sees when
  deciding to load the skill. State **what it does and when to use it**, with
  concrete trigger phrases. ≤1024 chars.
- **Progressive disclosure:** keep `SKILL.md` short; move long details into
  `references/` and deterministic work into `scripts/`.
- Prefer scripts to be POSIX/bash-portable (works on macOS and Linux) and to
  degrade gracefully when an optional dependency is missing.

## Loading skills onto a machine

```bash
bin/sync.sh          # symlink all skills into ~/.claude, ~/.agents, ~/.hermes
bin/sync.sh --list   # preview / check current link state
```

## After changing a skill

Test it by invoking it in the target agent; skills are model-invoked from their
`description`, so verify the description actually triggers on realistic phrasing.

When a change is worth distributing, bump `version` in
`.claude-plugin/plugin.json` (the Claude Code marketplace channel keys updates
off it) and keep the plugin description in `.claude-plugin/marketplace.json` in
sync with the skill list. The `npx skills` and `bin/sync.sh` channels need no
release step.
