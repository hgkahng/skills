---
name: model-council
description: Consult several independent AI models (a "council") on the same question in parallel, then combine their answers. Supports three modes you choose from — poll-and-synthesize (merge answers, surface consensus and dissent), best-of-N judge panel (each model drafts a full solution, then score and pick/merge the winner), and critique panel (collect diverse critiques of your draft, no rewrite). Use when the user wants a second opinion, cross-model agreement, the strongest possible draft, or blind-spot review before committing. Triggers include "ask the council", "model council", "best of N", "get critiques", "what do other models think", "second opinion".
---

# Model Council

Fan a single, self-contained prompt out to several AI CLIs **in parallel**, then
combine their independent answers. Choose the **mode** that fits the intent.

## When to use

- The user says "ask the council", "model council", wants "other models' opinions",
  a "second opinion", "best of N", or a "critique".
- The work is high-stakes, ambiguous, or a classic single-model blind spot:
  architecture, security, risky refactors, close tradeoffs, "is this any good".

**Not** for: quick factual lookups, or tasks needing the members to actually edit
files or run tools — the council only returns written opinions.

## Modes — pick one

Infer the mode from the user's intent (or ask in one line if unclear):

**1. Synthesize** *(default — "decide / second opinion")*
- **Prompt each member:** the question, self-contained, ending with *"Recommend one
  option; give your single strongest reason and the main risk. ≤200 words."*
- **Process results:** produce **Recommendation → Consensus → Disagreements (who
  said what) → Confidence & tie-breaker**.

**2. Judge panel / best-of-N** *("give me the strongest artifact")*
- **Prompt each member:** the task **plus explicit quality criteria**, asking for a
  complete solution.
- **Process results:** score each solution against the criteria, name the winner,
  then **merge the best parts** into one answer and note why it wins.

**3. Critique panel** *("review mine before I ship")*
- **Prompt each member:** your draft/code/plan + *"What's wrong, risky, or missing?
  Be specific. Do not rewrite it."*
- **Process results:** dedupe into a **ranked issue list** (severity), attribute
  each to the model that raised it, and drop the noise.

## How to run

1. **Build the mode-appropriate prompt.** Members share **none** of this session's
   context — inline everything: question/artifact, constraints, and the answer shape.
2. **Fan out:**
   ```bash
   scripts/council.sh "YOUR SELF-CONTAINED PROMPT"     # or --file prompt.md
   ```
   Auto-detects installed members, runs them concurrently with a per-member timeout,
   and prints each answer under a `===== <model> =====` header.
   Flags: `--members claude,codex` · `--exclude cursor` · `--timeout 240` · `--list`.
3. **Read every block in full, then process per the chosen mode.** Never just paste
   the raw responses back.

## General principles (all modes)

- Weigh arguments on **merit, not vote count** — say so explicitly if the majority
  looks wrong.
- **Attribute** notable claims to the model that made them.
- Lead with the bottom line; keep it tight.

## Configuration

- **Default roster:** `claude`, `codex`, `cursor` (whichever are installed).
  `gemini` ships in the script but is **off by default** — add it to
  `DEFAULT_MEMBERS`. Edit the roster / invocations in `scripts/council.sh`; see
  [`references/members.md`](references/members.md).
- **Env:** `COUNCIL_TIMEOUT` (per-member seconds, default 180), `COUNCIL_OUT`
  (directory to save a timestamped transcript).

## Pitfalls

- Members can't see your files or this chat — **inline all context** in the prompt.
- Keep prompts to **questions/artifacts**, not agentic tasks. Each member runs in a
  throwaway temp dir so it can't touch your project.
- `cursor-agent -p` has a known bug where it doesn't exit; the script force-kills it
  on timeout. `--exclude cursor` if it's flaky for you.
- Running the council *from* one of the members (e.g. Claude Code invoking
  `claude -p`) is fine. `--exclude` it if you want only the *other* models' views.
