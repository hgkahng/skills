---
name: inception
description: "Turn behavioral rules for AI agents into the higher-level concept they derive from. Rule lists ('do this, don't do that') invite letter-compliance and cover only anticipated cases; this skill finds the principle that makes the desired behavior the natural one, states it overtly and positively with its reasons, and keeps only 2–3 rules as derived anchors. Use when writing or revising any agent instructions (system prompts, AGENTS.md, skills, subagent definitions), when the same correction keeps getting repeated to an agent, when an agent follows the letter of a rule but misses its intent, or on request — 'inception this', 'distill these rules', 'make this instruction stick', 'turn these rules into a principle'. Outputs text only: proposes where to install, never writes to files unless explicitly told."
---

# Inception

A rule draws a line. An agent that is given lines learns to stand just inside
them: it obeys the words and misses the purpose. A list of lines also ends where
its author's foresight ended.

A principle works differently. An agent that holds the idea behind the rules does
not need them listed. It can work out the right behavior in a case nobody wrote
down. The rules become what the agent produces, not what it is given.

This skill finds that principle. It states the principle openly, with its
reasons, and keeps a few rules only as examples of it. Whether a principle holds
better than the rules is a claim to test, not to assume: see
[`references/evaluation.md`](references/evaluation.md).

## When to use

- **A correction keeps coming back.** The user has told agents the same thing in
  several sessions. The rule is not holding.
- **A rule list is about to be written.** Someone is drafting a new skill,
  subagent, system prompt, or AGENTS.md as "always X, never Y" bullets.
- **A rule is obeyed and its purpose is missed.** Told "under 200 words", the
  agent cuts the one caveat that mattered.

Do **not** use it for arbitrary constraints. "Use port 8080" and "branch names
start with `feat/`" have no deeper idea behind them. A principle invented for
them would be fiction. Keep them as plain rules (see step 4).

## The constitution

The method depends on three properties. Without any one of them it stops working.

1. **Overt.** State the principle openly. The agent behaves well because it has a
   coherent idea to reason from. Hiding the idea adds nothing.
2. **True.** The principle must be sound, and the author must believe its reasons.
   A false principle fails as soon as the context contradicts it. The agent then
   behaves worse than it would with no instruction at all.
3. **Positive.** Name the behavior to produce, not the behavior to avoid. A
   prohibition brings to mind the thing it forbids. Agents also follow "do this"
   more reliably than "don't do that".

## Method

**1. Capture the intent.** Read the user's draft rules, their complaint, or their
example of a rule being gamed. Write the *intent* in one sentence: what should be
true of the agent's behavior, and in which scope. Keep the sentence. It is also
the test in the evaluation later.

**2. Climb the ladder.** Ask: *"What would have to be true for the wanted behavior
to be the natural one?"* Then ask it again of the answer. Each answer is one step
more general than the last. Stop at the highest step that still **excludes**
something. At that step the wanted behaviors follow from the principle, and some
other behaviors clearly do not. One step higher is a platitude: "be helpful"
permits everything, so it guides nothing. One step lower is only the rule again
in other words.

**3. Test the principle in both directions.**
- *Forward.* Does each draft rule follow from the principle alone, without being
  mentioned? If a rule does not, either the principle is wrong or the rule is
  arbitrary (see step 4).
- *Reverse.* Which **unwanted** behaviors also follow from it? A principle
  produces behaviors nobody listed, and some of them are bad. Each one you find
  becomes a line under Boundary in the output.

**4. Write the output** in four parts:

```markdown
**Principle** — one or two sentences that say what to do, concrete enough to reason from.
**Why** — the honest reasons the principle is sound. The reasons are what make it hold.
**Derived anchors** — the 2–3 rules that matter most, kept and phrased as cases of
  the principle ("hence: …"), so they read as consequences.
**Boundary** — where the principle stops: the findings of the reverse test, then
  any arbitrary constraints, listed plainly as "hard constraints".
```

**5. Propose a place. Do not install.** Suggest where the text belongs, then stop.
A principle about who the agent is belongs in always-on instructions such as
AGENTS.md. A stance needed only for some tasks belongs in a skill. A need that
lasts one session belongs in a one-off prompt. The output is text, and the user
decides where it goes. Write to a file only when the user tells you to and names
the file.

## Worked example

Draft rules: *"No preamble. Don't restate the question. Stop early. Don't
self-correct mid-answer. Max 200 words."* These are five patches over one cause.

**Ladder.** Why do long answers happen? The reply narrates the reasoning that
produced it. The principle follows: **"The reply is written fresh from the
conclusion. The reasoning is private working, not something the reader
receives."**

**Forward test.** All five rules follow. A reply that starts from the conclusion
has no preamble, no visible self-correction, and no padding. It is short without
a word limit.

**Reverse test.** "Leave out necessary caveats" could also follow. That gives the
Boundary: *"Cut padding, not substance. Keep the caveat that changes the reader's
decision."*

**Result.** One principle and one boundary replace five rules. They also cover
cases the rules missed. Rambling code comments were never mentioned, and the
principle still rules them out.

## Checking whether it holds

The intent sentence from step 1 is the test. The quick check is how often the
correction returns. If the user stops repeating the same correction across
sessions, the principle is holding.

For a rigorous comparison with the original rule list, follow
[`references/evaluation.md`](references/evaluation.md). It covers arms matched for
length, three groups of test prompts (on-target, transfer, adversarial), blind
judging by several models through the model-council skill, and a pass or fail bar
that is set before the run.

## Pitfalls

- **Platitudes.** A principle that nothing can fail is decoration. Go back to
  step 2.
- **Fiction.** A "why" the author does not believe breaks the second property,
  True. The principle will fail when the context contradicts it.
- **Sprawl.** One group of related behaviors gets one principle. Several unrelated
  complaints need several small inceptions, not one grand theory.
