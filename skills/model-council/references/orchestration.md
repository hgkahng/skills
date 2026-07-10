# Orchestration — backends, presets, and diversity

How to compose a council and why. The four-step flow lives in
[`../SKILL.md`](../SKILL.md); this file is the depth behind Steps 2–4.

## Backends

| Backend | Members are… | Strengths | Costs / limits |
|---|---|---|---|
| `subagents` | Parallel subagents of the **host agent**, with per-agent model overrides | Zero setup; fast; fine-grained control of tier mix (2× opus + 3× sonnet); cheapest way to get N samples | Same provider → correlated priors; weakest for independent second opinions |
| `cli` | Locally installed agent CLIs (`claude`, `codex`, `cursor-agent`, …) | True cross-vendor **agents** as they ship (their system prompts, their defaults) | Only vendors whose CLIs you install & authenticate; slowest members gate wall-clock (mitigated by timeouts) |
| `openrouter` | Any model on OpenRouter, one API + one key | Widest diversity (Grok, DeepSeek, Qwen, Llama…); reproducible model pinning; works with zero CLIs | Raw models, not agent products; per-token cost; needs `OPENROUTER_API_KEY` |

### Subagents backend — how to run it

No scripts. Use the host's parallel-subagent mechanism directly:

- **Claude Code**: launch N agents **in a single message** (so they run
  concurrently) via the Agent/Task tool, each with its model override (`opus`,
  `sonnet`, `haiku`) and its own prompt variant. Each agent's final message is its
  council answer.
- **Other hosts**: use the equivalent parallel task/agent facility; if the host
  can't spawn subagents, fall through to `cli` or `openrouter`.

Give every subagent the same instruction skeleton: *"You are one member of a
council. Answer independently from only what is in this prompt. [variant frame]
[core block]"*. Don't let subagents read the repo unless the question is about the
repo — context isolation is the point.

### OpenRouter backend — how to run it

```bash
export OPENROUTER_API_KEY=sk-or-...
scripts/openrouter.sh --list-models claude        # discover current slugs
scripts/openrouter.sh --models "MODEL_A,MODEL_B,MODEL_C" --file prompt.md
```

No default roster is baked in on purpose — model slugs change too often. Discover
with `--list-models [filter]`, propose a roster in the preset popup, or pin a
personal default via `OPENROUTER_MODELS`.

## Presets — the popup

Present these when the user hasn't specified a composition (host choice-UI if
available, else a numbered list). Requirements gate what's offerable: preset 1
needs ≥2 CLIs installed (`council.sh --list`), preset 4 needs `OPENROUTER_API_KEY`.
Non-interactive runs: first preset whose requirements are met, stated explicitly.

1. **Independent seconds** — `cli`: every installed member. The default for
   decisions and second opinions; vendor diversity breaks shared blind spots.
2. **Tiered deep-dive** — `subagents`: 2× opus with two contrasting frames
   (skeptic / advocate) + 3× sonnet with three more frames. Depth and breadth,
   no setup. Good synthesize-mode default when CLIs are missing.
3. **Best-of-5 builders** — `subagents`: 5× one tier, each with a different
   **approach directive** (see below). Pair with judge mode.
4. **Max diversity** — `openrouter`: 3–5 models across vendors. For exotic
   models, reproducible rosters, or CLI-less machines.

Mixing backends in one council is fine (e.g. preset 1 + one OpenRouter exotic);
just merge the outputs before combining.

## Diversity by paraphrase — the random-forest trick

**Why:** N identical prompts to similar models yield correlated answers — the
ensemble adds little. Random forests fix correlation by giving each tree a
different view of the same problem. The prompt-level analog: each member gets a
different **framing** of one **frozen core**.

**The invariants (guardrails):**

1. **Core block is verbatim everywhere** — question, artifact/code, hard
   constraints, required answer shape. If the core drifts, members answer
   different questions and disagreement becomes noise.
2. **One control member** gets the core with no added frame — your anchor.
3. **Record member → variant.** Disagreement that tracks the variant means the
   answer is *framing-sensitive*: report it and lower confidence. (This is the
   out-of-bag insight — sensitivity analysis for free.)

**Frame library** (pick N−1, one per non-control member):

- *Skeptic*: "Steelman the case against the obvious answer before concluding."
- *Risk-first*: "Lead with what could go wrong; recommend only after."
- *Simplicity-first*: "Prefer the answer with the fewest moving parts."
- *User-first*: "Optimize for the end user's experience over elegance."
- *Long-term*: "Weigh maintainability over the next 2 years above shipping speed."
- *Contrarian*: "Assume the popular answer is wrong; argue the alternative, then
  judge honestly."

**Per-mode variants:**

- **Synthesize** → frames above.
- **Judge / best-of-N** → vary the **approach directive** ("build MVP-first" /
  "correctness-first" / "performance-first"…), but score every artifact with the
  **identical criteria** — otherwise scores aren't comparable.
- **Critique** → assign **distinct lenses** (security, performance,
  maintainability, UX, correctness) instead of free paraphrase; structured
  coverage beats random rewording for reviews.

**Worked example** (synthesize, 3 members):

```text
# core block — verbatim in all three
QUESTION: Should we migrate the job queue from Redis to Postgres?
CONSTRAINTS: 2 engineers, 6-week window, ~50 jobs/sec peak.
ANSWER SHAPE: One recommendation, strongest reason, main risk. ≤200 words.

# member 1 (control): core block only
# member 2 (risk-first): "Lead with what could go wrong…" + core block
# member 3 (simplicity-first): "Prefer the fewest moving parts…" + core block
```

If members 1 and 3 say "migrate" but 2 says "stay", check whether 2's dissent is
the risk frame talking — if its risks are real but generic, the finding is
"migration is defensible but risk-sensitive; de-risk X first", not a 2–1 vote.

**Mechanics:** write variants as files and pass `--variants-dir DIR` —
`council.sh` looks for `<member>.md` (e.g. `claude.md`), `openrouter.sh` for the
sanitized slug (e.g. `anthropic-claude-opus.md`, `/` and `:` → `-`). Members
without a variant file get the shared prompt. For subagents, put each variant
directly in that agent's prompt.
