---
name: interview-me
description: "Interview the user about their taste and preferences, then write the answers to ME.md in the project so every future agent session builds things the way they like. Routes to a domain: code, writing, UI design, or docs. Use when the user says 'interview me', 'learn my taste', 'learn my preferences', 'set up my ME.md', 'ask me how I like things done', 'make the agent match my style', or when they keep correcting the same stylistic choices across sessions. Re-run to update an existing ME.md. NOT for clarifying a single task before starting it (ask directly) or for writing generic project docs."
---

# Interview me

Learn how the user likes things built, and save it to `ME.md` so future agents
start already aligned. Taste is hard to describe but easy to react to — so ask
concrete questions, not "what's your style?".

## Route to a domain

Read only the reference you need.

| Domain | Pick when the user mentions… | Read |
|---|---|---|
| Code | code, repo, architecture, tests, commits, a language | [`references/code.md`](references/code.md) |
| Writing | prose, emails, posts, tone, voice, essays | [`references/writing.md`](references/writing.md) |
| UI design | UI, look and feel, layout, colors, components, a frontend | [`references/ui-design.md`](references/ui-design.md) |
| Docs | README, guides, specs, API docs, internal docs | [`references/docs.md`](references/docs.md) |

Domain unclear → ask which one (one question). Several → do them one at a time,
each finishing with its own save. Nothing fits → run the protocol below with
your own questions.

## How to interview

1. **Read first, ask second.** Open the project (README, config, existing code or
   docs) and any existing `ME.md`. Never ask what you can see; never re-ask what
   `ME.md` already answers. Open with one line on what you found.
2. **One question at a time**, in plain language. Wait for the answer.
3. **Make it concrete.** Prefer "A or B?" with two short real examples, or "what
   did an agent do last time that annoyed you?" over open-ended questions. Offer
   your best guess as a default so a plain "yes" is enough.
4. **Ask why** after any strong opinion — the reason lets the agent handle
   cases the answer didn't cover.
5. **Allow "skip" and "depends".** Record "depends" with the condition.
6. **Stop when more answers wouldn't change what you'd build** — usually 8–12
   questions per domain. Don't exhaust the question bank.
7. **Read back, then save.** Show the draft section; write it only after the
   user confirms or edits.

## Save to `ME.md`

- **Location:** `ME.md` at the project root (default). User asks for "global" or
  "all projects" → confirm a path (e.g. `~/.claude/ME.md`) before writing.
- **One section per domain** (`## Code`, `## Writing`, `## UI design`, `## Docs`).
  Re-running replaces that section; never touch the others.
- **Each entry = preference + reason**, one line, concrete enough to act on:
  `- **Early returns over nesting** — why: flat code is faster for me to scan.`
  Skip anything generic ("write clean code") — if it wouldn't change output, leave it out.
- Keep each section ≤ 15 lines. `ME.md` is read every session; length costs.
- Start a new file from this skeleton:

```markdown
# ME.md — how I like things built

Personal taste for agents working in this project. Edit freely; re-run
`interview-me` to refresh a section.
```

## Wire it in

Agents only read `ME.md` if something points to it. After saving, propose adding
`@ME.md` to the project's `CLAUDE.md` (Claude Code import) or, for agents
without imports, the line `Read ME.md for the user's preferences.` in
`AGENTS.md`. Show the edit and apply it only after a yes.

`ME.md` is personal taste, and a project-level file gets committed with the
project. Also propose adding `ME.md` to `.gitignore` (create the file if
needed) and apply it only after a yes.

## Pitfalls

- **Interrogation fatigue**: long question lists, several questions per turn.
- **Generic output**: "clean, minimal, readable" changes nothing — push for an
  example or a reason, or drop it.
- **Guessing**: infer nothing the user didn't say; ask or leave it out.
- **Stale or contradictory entries**: when updating, show the old line next to
  the new one and ask which wins.
- **Sensitive details**: record work taste only — nothing private or secret.
