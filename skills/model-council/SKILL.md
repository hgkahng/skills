---
name: model-council
description: Consult a council of AI models on the same question in parallel, then combine their answers. Three combine modes — synthesize (consensus + dissent), best-of-N judge, critique panel — and three backends: parallel subagents of the host agent (e.g. 2× Opus + 3× Sonnet), local agent CLIs (claude/codex/cursor), or any model via the OpenRouter API. Presents recommended council presets for the user to pick from, and boosts diversity random-forest-style by giving members paraphrased framings of one frozen core question. Use for second opinions, cross-model agreement, strongest-draft generation, or blind-spot review before committing. Triggers: "ask the council", "model council", "second opinion", "best of N", "what do other models think", "get critiques".
---

# Model Council

Fan one self-contained prompt out to several AI models **in parallel**, then
combine their independent answers. Convening a council = four decisions, in order:
**mode → composition → prompts → combine**.

## When to use

- "Ask the council", "second opinion", "best of N", "what do other models think".
- High-stakes or ambiguous work: architecture, security, risky refactors, close
  tradeoffs, "is this any good".

**Not** for quick factual lookups, or tasks needing members to edit files or run
tools — members only return written opinions.

## Step 1 — Mode (how answers are combined)

Infer from intent; ask in one line if unclear.

1. **Synthesize** *(default — decide / second opinion)*: each member recommends one
   option + strongest reason + main risk, ≤200 words. → Report **Recommendation →
   Consensus → Disagreements (who said what) → Confidence & tie-breaker**.
2. **Judge / best-of-N** *(strongest artifact)*: each member produces a complete
   solution against explicit criteria. → Score all with the **same criteria**, name
   the winner, merge the best parts.
3. **Critique panel** *(review before shipping)*: each member lists what's wrong,
   risky, or missing — no rewrites. → Dedupe into a severity-ranked issue list with
   attribution.

## Step 2 — Composition (the popup rule)

If the user already specified members/backend, use exactly that. **Otherwise,
present the recommended presets and let the user choose** — via the host's
question/choice UI if it has one, else as a numbered list. In non-interactive runs
don't block: take the first preset whose requirements are met and say so.

| # | Preset | Backend | Composition | Pick when |
|---|--------|---------|-------------|-----------|
| 1 | **Independent seconds** | `cli` | claude + codex + cursor (installed subset) | You want truly independent, cross-vendor agent opinions. |
| 2 | **Tiered deep-dive** | `subagents` | 2× opus + 3× sonnet, paraphrased frames | Zero setup; depth + breadth from one provider. |
| 3 | **Best-of-5 builders** | `subagents` | 5× one tier, each a different approach directive | Judge mode; you want the strongest artifact. |
| 4 | **Max diversity** | `openrouter` | 3–5 cross-vendor models (discover via `--list-models`) | Exotic/raw models; needs `OPENROUTER_API_KEY`. |

Caveat to apply when choosing: same-provider subagents share priors — great for
best-of-N and self-consistency, weaker for "independent second opinion", where
cross-vendor (presets 1/4) is what breaks the correlation.

## Step 3 — Prompts (random-forest diversity)

Members share **none** of this session's context; inline everything. Then
decorrelate the council like a random forest — details and a worked example in
[`references/orchestration.md`](references/orchestration.md):

- **Vary the frame, freeze the core.** Write one **core block** — the question,
  artifact/code, hard constraints, and required answer shape — kept **verbatim**
  in every variant. Vary only the framing lens around it (risk-first,
  simplicity-first, user-first, skeptic…).
- **Keep one control member** on the plain, unparaphrased prompt.
- **Log the member → variant mapping**; you'll need it in Step 4.
- Judge mode: vary the *approach directive*, never the scoring criteria.
  Critique mode: assign each critic a distinct lens (security, perf,
  maintainability, UX) instead of free paraphrase.

## Step 4 — Fan out & combine

Fan out by backend:

- **`subagents`** — spawn parallel subagents via the host's mechanism (e.g. Claude
  Code's Agent/Task tool with per-agent model overrides like `opus`/`sonnet`), one
  prompt variant each, collect final messages. No scripts needed.
- **`cli`** — `scripts/council.sh "PROMPT"` (or `--file f.md`); per-member variants
  via `--variants-dir DIR` containing `<member>.md`. Flags: `--members a,b` ·
  `--exclude x` · `--timeout 240` · `--list`.
- **`openrouter`** — `scripts/openrouter.sh --models a,b,c "PROMPT"`; variants via
  `--variants-dir DIR` containing `<model-slug-sanitized>.md`. Discover models with
  `--list-models [filter]`. Needs `OPENROUTER_API_KEY`.

Then combine per the mode. Read every answer in full; **never paste raw responses
back**. Weigh arguments on merit, not vote count. Attribute claims. And check
dissent against the variant mapping: **if disagreement tracks the paraphrase, the
answer is framing-sensitive — report that explicitly and lower confidence.**

## Configuration

- CLI roster & invocations: top of `scripts/council.sh`; see
  [`references/members.md`](references/members.md). Default `claude, codex,
  cursor`; `gemini` defined but opt-in.
- Env: `COUNCIL_TIMEOUT` (per-member seconds, default 180), `COUNCIL_OUT` (save
  timestamped transcripts), `OPENROUTER_API_KEY` / `OPENROUTER_MODELS`.

## Pitfalls

- Prompts must be self-contained **questions/artifacts**, not agentic tasks; CLI
  members run in throwaway temp dirs so they can't touch your project.
- `cursor-agent -p` may hang (known bug); the runner force-kills on timeout.
- Paraphrasing must never touch the core block — if variants drift semantically,
  disagreement is noise, not signal.
- Running the council *from* a member (Claude Code invoking `claude -p`) is fine;
  `--exclude` it if you want only the other models' views.
