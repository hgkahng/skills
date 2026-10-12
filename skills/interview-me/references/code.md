# Interview: code

Goal: learn the choices that make the user say "yes, that's how I'd write it" or
"ugh, not like that". If the project already has linters, formatters, or a
language-style skill, point to them in `ME.md` instead of re-recording rules.

## Look first
Language/stack, dependency count, test setup, comment density, file and function
sizes, recent commit messages. Ask only about what the code doesn't settle.

## Topics (pick what matters; don't ask all)

- **Past annoyances** — "What did an agent do in code that you had to undo?" Best single question; start here.
- **Dependencies** — add a library, or write the few lines yourself? Any favorites/bans?
- **Abstraction** — duplicate until it repeats 3 times, or abstract early? Show a small example of each.
- **Structure** — two examples: early returns vs nested ifs; one longer function vs several tiny ones. Which?
- **Naming** — short and local (`n`, `res`) vs long and explicit (`retry_count`)?
- **Comments** — none, why-only, or thorough docstrings? Show one function each way.
- **Errors** — fail fast and loud, or handle defensively? Where must it never crash?
- **Types & tests** — how strict? What level of tests (unit, integration), tests first or after? Mock or real?
- **Scope of change** — fixing a bug, may the agent also tidy nearby code, or only the minimum diff?
- **Autonomy** — decide and tell me, or ask before choosing? For which kinds of decisions?
- **Git** — commit size, message style, branch and PR habits.

## Good entries look like
- **Minimal diffs; no drive-by refactors** — why: I review every line.
- **Stdlib before new dependencies** — why: fewer things to keep updated.
