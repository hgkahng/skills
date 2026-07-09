# skills

A personal, **cross-agent** library of the skills I use every day — authored once,
used in Claude Code, Codex, Cursor, and Hermes.

Each skill follows the portable [Agent Skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
standard: a folder with a `SKILL.md` (YAML frontmatter + Markdown instructions),
plus optional `scripts/` and `references/`. All four agents read this format, so a
skill is written once here and **symlinked** into each agent's skills directory —
one edit updates them everywhere, and `git` versions and syncs it across machines.

## Layout

```
skills/<name>/SKILL.md    canonical source of truth for each skill
          /scripts/       executable helpers
          /references/    docs loaded on demand
templates/SKILL.md        starter for new skills
bin/sync.sh               symlink skills into each agent
AGENTS.md                 authoring conventions for this repo
```

## Install onto a machine

```bash
bin/sync.sh          # symlink all skills into ~/.claude/skills, ~/.agents/skills, ~/.hermes/skills
bin/sync.sh --list   # preview / check link state
```

`~/.agents/skills` is the shared convention read by both Codex and Cursor, so the
three target dirs cover all four agents.

## Skills

| Skill | What it does |
|-------|--------------|
| [`model-council`](skills/model-council/) | Ask several AI models the same question in parallel, then synthesize their answers with consensus + dissent. |

## Add a new skill

1. `cp -r templates <skills/my-skill>` (or copy `templates/SKILL.md` into
   `skills/my-skill/`), then edit the frontmatter and body.
2. `bin/sync.sh` to link it into your agents.
3. See [`AGENTS.md`](AGENTS.md) for authoring rules.
