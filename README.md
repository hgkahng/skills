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

## Install

Three channels — pick by how you consume the skills:

| Channel | Command | Nature |
|---|---|---|
| **Develop / daily driver** (this repo is yours) | `git clone … && bin/sync.sh` | **Symlinks** — edit the repo and every agent updates instantly; `git pull` syncs machines. |
| **Quick install, any agent** (70+ agents) | `npx skills add hgkahng/skills` | **Copies** — no clone needed; update with `npx skills update`. Single skill: `npx skills add hgkahng/skills --skill model-council`. |
| **Claude Code plugin** | `/plugin marketplace add hgkahng/skills` then `/plugin install everyday-skills@hgkahng-skills` | **Copies**, versioned via `.claude-plugin/`. Claude Code only. |

The distinction that matters: `sync.sh` is dev mode (live links, single source of
truth), the other two are distribution (snapshots at install time).

### sync.sh details

```bash
bin/sync.sh          # symlink all skills into ~/.claude/skills, ~/.agents/skills, ~/.hermes/skills
bin/sync.sh --list   # preview / check link state
```

`~/.agents/skills` is the shared convention read by both Codex and Cursor, so the
three target dirs cover all four agents.

## Skills

| Skill | What it does |
|-------|--------------|
| [`model-council`](skills/model-council/) | Ask a council of AI models one question in parallel — via host subagents, local CLIs, or OpenRouter — with recommended presets, random-forest prompt diversity, and three combine modes (synthesize / judge / critique). |
| [`brief`](skills/brief/) | Enforce short, answer-first replies: commit, cut padding, offer depth on request. |

## Add a new skill

1. `cp -r templates <skills/my-skill>` (or copy `templates/SKILL.md` into
   `skills/my-skill/`), then edit the frontmatter and body.
2. `bin/sync.sh` to link it into your agents.
3. See [`AGENTS.md`](AGENTS.md) for authoring rules.
