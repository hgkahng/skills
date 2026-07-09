---
name: model-council
description: Consult several independent AI models (a "council") on one question in parallel, then synthesize their answers into a single recommendation that surfaces consensus and disagreement. Use when the user wants a second opinion, cross-model agreement, or diverse perspectives before committing to an important or ambiguous answer — a hard decision, an architecture or design choice, a tricky bug, a risky plan, or a close tradeoff. Triggers include "ask the council", "model council", "what do other models think", "get a second opinion", or any request to reduce single-model blind spots.
---

# Model Council

Fan a single, self-contained question out to several AI CLIs **in parallel**, then
synthesize their independent answers into one recommendation that shows where they
agree and where they diverge.

## When to use

- The user says "ask the council", "model council", wants "other models' opinions",
  or a "second opinion".
- The decision is high-stakes, ambiguous, or a classic single-model blind spot:
  security, architecture, risky refactors, close tradeoffs, "is this a good idea".
- You want to sanity-check a plan or answer *before* committing to it.

**Not** for: quick factual lookups, or tasks that require the members to actually
edit files or run tools — the council only returns written opinions.

## How to run

1. **Write a self-contained prompt.** The members share **none** of this session's
   context. Inline everything they need: the question, the relevant code/text,
   the constraints, and the exact answer shape you want (e.g. *"Recommend one
   option. Give your single strongest reason and the main risk. ≤200 words."*).
   Keep it a **question**, not an agentic task.

2. **Fan out** with the bundled script:
   ```bash
   scripts/council.sh "YOUR SELF-CONTAINED PROMPT"
   # long prompt? put it in a file:
   scripts/council.sh --file /path/to/prompt.md
   ```
   It auto-detects which member CLIs are installed, runs them concurrently with a
   per-member timeout, and prints each answer under a `===== <model> =====` header.

   Useful flags: `--members claude,codex` · `--exclude cursor` · `--timeout 240` ·
   `--list` (show configured members and whether each is installed).

3. **Read every member's block in full, then synthesize** (below). Never just
   paste the raw responses back to the user.

## Synthesizing the verdict

Produce, in this order:

1. **Recommendation** — the single best answer/decision, stated plainly up front.
2. **Consensus** — the points two or more members agree on.
3. **Disagreements** — where they diverge, *who* said what, and why it matters.
4. **Confidence & tie-breaker** — how confident you are, and the one fact or check
   that would settle any remaining disagreement.

Weigh arguments on **merit, not vote count** — call it out explicitly if the
majority looks wrong. Attribute notable claims to the model that made them.

## Configuration

- **Default roster:** `claude`, `codex`, `gemini`, `cursor` — whichever are
  installed. Edit the roster / invocation in `scripts/council.sh`; details and
  per-CLI notes are in [`references/members.md`](references/members.md).
- **Env vars:** `COUNCIL_TIMEOUT` (per-member seconds, default 180),
  `COUNCIL_OUT` (directory to save a timestamped transcript).

## Pitfalls

- Members can't see your files or this chat — **inline all context** in the prompt.
- Keep prompts to **questions**; the council returns text, not actions. Each member
  runs in a throwaday temp directory so it can't touch your project.
- `cursor-agent -p` has a known bug where it doesn't exit; the script force-kills it
  on timeout. Drop it from the roster with `--exclude cursor` if it's flaky for you.
- Running the council *from* one of the members (e.g. Claude Code invoking
  `claude -p`) is fine. Use `--exclude` if you specifically want the *other* models'
  independent views.
