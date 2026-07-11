---
name: inception
description: Turn behavioral rules for AI agents into the higher-level concept they derive from. Rule lists ("do this, don't do that") invite letter-compliance and cover only anticipated cases; this skill finds the principle that makes the desired behavior the natural one, states it overtly and positively with its reasons, and keeps only 2–3 rules as derived anchors. Use when writing or revising any agent instructions (system prompts, AGENTS.md, skills, subagent definitions), when the same correction keeps getting repeated to an agent, when an agent follows the letter of a rule but misses its intent, or on request — "inception this", "distill these rules", "make this instruction stick", "turn these rules into a principle". Outputs text only: proposes where to install, never writes to files unless explicitly told.
---

# Inception

Change an agent's behavior by installing the concept the behavior follows from,
rather than the behaviors themselves. A rule list is a boundary, and boundaries
invite boundary behavior: comply with the letter, drift on the spirit, fail in
every situation the author didn't anticipate. A concept the agent operates *from*
generates correct behavior in situations nobody enumerated — the rules become
outputs, not inputs.

## When to use

- **A correction keeps recurring.** The user has told agents the same thing across
  sessions — the rule isn't taking.
- **A rule list is about to be written.** A new skill, subagent, system prompt, or
  AGENTS.md drafted as "always X, never Y" bullets.
- **Letter-compliance without spirit.** A rule is technically obeyed while its
  intent is violated (told "under 200 words", the agent cuts the caveat that
  mattered).

**Not** for genuinely arbitrary constraints — "use port 8080", "branch names start
with `feat/`" have no deeper concept; forcing one produces fiction. Keep those as
plain rules (see step 4).

## The constitution

Three properties are load-bearing; drop any and the method stops working:

1. **Overt.** State the principle openly. What does the work is the agent having a
   coherent frame to derive from — not the frame being hidden.
2. **True.** The principle must be genuinely sound, with reasons the author
   actually believes. A false or incoherent frame collapses the moment context
   contradicts it, and behavior gets worse than with no instruction at all.
3. **Positive.** Frame as the behavior to produce, not the behavior to suppress —
   prohibitions activate the very concept they negate, and affirmative
   instructions are followed more reliably.

## Method

**1. Capture the intent.** From the user's draft rules, complaint, or gaming
example, write one sentence of *intent*: what should be true of the agent's
behavior, and in which scope. Save it — it is also the evaluation rubric later.

**2. Climb the ladder.** Ask repeatedly: *"what would have to be true for the
desired behavior to be the natural one?"* Each answer is a rung. Stop at the last
rung that still **excludes** something: a concept from which the wanted behaviors
derive but some behaviors demonstrably don't. One rung too high is a platitude
("be helpful" derives everything, therefore nothing); one rung too low is just a
restated rule.

**3. Run the derivation test — both directions.**
- *Forward:* does each rule in the draft fall out of the concept alone, without
  being mentioned? Any rule that doesn't means the concept is wrong or the rule is
  arbitrary (→ step 4).
- *Reverse (over-generalization):* what **unwanted** behaviors also fall out?
  Generalization cuts both ways — a concept generates behaviors nobody enumerated,
  including bad ones. Each finding becomes a Boundary line in the output.

**4. Compose the output** in four parts:

```markdown
**Principle** — one or two sentences, affirmative, concrete enough to derive from.
**Why** — the honest reasons the principle is sound (this is what makes it stick).
**Derived anchors** — the 2–3 load-bearing rules, kept, but phrased as instances
  ("hence: …") so they read as consequences, not arbitrary constraints.
**Boundary** — where the principle stops; the over-generalization findings, plus
  any genuinely arbitrary constraints listed plainly as "hard constraints".
```

**5. Propose placement — never install.** Suggest the right layer (always-on
instructions like AGENTS.md for identity-level concepts; a skill for on-demand
postures; a one-off prompt for session-scoped needs) and stop. The output is
text; the user decides where it goes. Write to a file only when explicitly
instructed with a destination.

## Worked example

Draft rules: *"No preamble. Don't restate the question. Stop early. Don't
self-correct mid-answer. Max 200 words."* — five patches over one cause.

Ladder: why do long answers happen? → the reply narrates the reasoning that
produced it → **"The reply is written fresh from the conclusion; reasoning is
private scratch, not something the reader receives."**

Forward test: all five rules derive (a conclusion-first reply has no preamble, no
visible self-correction, no padding — length falls out). Reverse test: could
derive "omit necessary caveats" → Boundary: *"cut padding, not substance — keep
the caveat that changes the reader's decision."*

Result: one principle + one boundary replaced five rules and covers cases the
rules missed (e.g. rambling code comments — never mentioned, still derived).

## Evaluating whether it took

The intent sentence from step 1 is the rubric. Quick check: correction frequency —
if the user stops re-issuing the same correction across sessions, it worked. For a
rigorous A/B against the original rule list (token-matched arms, on-target /
transfer / adversarial buckets, blind multi-model judging via the model-council
skill, pre-registered kill condition), follow
[`references/evaluation.md`](references/evaluation.md).

## Pitfalls

- **Platitudes**: a principle that nothing fails is decoration. Re-run step 2.
- **Fiction**: inventing a "why" the author doesn't believe violates the
  constitution (True) — the frame will collapse under contradiction.
- **Force-derived arbitrary rules**: "port 8080 because ports embody simplicity"
  is fiction; list it as a hard constraint instead.
- **Concept sprawl**: one behavior cluster, one principle. Several unrelated
  complaints deserve several small inceptions, not one grand unified theory.
- **Silent installs**: producing the principle and immediately writing it into
  AGENTS.md or settings. Placement is the user's call, always.
