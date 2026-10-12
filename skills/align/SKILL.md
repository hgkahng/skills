---
name: align
description: "Align with the user's thoughts, intentions, and preferences before executing a task by running a focused back-and-forth question-and-answer dialogue. Use this skill whenever the user says things like 'let's align', 'align with me', 'ask me first', 'make sure you understand', 'before you start', or any variation suggesting they want a clarification dialogue before proceeding. Also trigger proactively when the user's request is ambiguous, has multiple plausible interpretations, or is missing constraints that would meaningfully change the output."
---

# Align

Run a back-and-forth alignment dialogue with the user before executing a task. The goal is to surface the intentions, preferences, and constraints that would actually change the output — not to interrogate the user about trivia.

## When to use

**Explicit triggers**: "let's align", "align with me", "ask me first", "make sure you understand", "before you start", or any close variant.

**Proactive triggers**: When the request is ambiguous in a way that meaningfully changes what Claude should produce. For example:
- Multiple plausible interpretations of scope
- Missing constraints (audience, length, depth, format)
- Unstated tradeoffs (speed vs. thoroughness, breadth vs. depth)
- A vague verb ("help me with", "work on", "improve") attached to a complex artifact

Do NOT trigger proactively for simple, well-specified requests.

## How to run the dialogue

### 1. Ask focused questions, one batch at a time

- Ask 1–3 questions per turn. Never dump everything at once.
- Each question must target something that would actually change the output. Skip trivia.
- Prefer structured choices (via the host's question/choice tool when available — e.g. AskUserQuestion in Claude Code — otherwise inline) when the answer space is small and enumerable.
- Use open-ended prose questions when the space is too broad or too nuanced for choices.
- Frame choices as competing tradeoffs ("quick overview vs. deep dive"), not surface preferences ("which font").

### 2. Iterate

- After every 2–3 rounds, check in briefly: "Satisfied with the alignment so far, or keep going?"
- Continue until the user says **"ok go"** (or a close equivalent: "go ahead", "proceed", "we're good").

### 3. Recap, then execute

Once the user signals done:
- Produce a short recap: what you understood, the key decisions made, any assumptions you are carrying forward.
- Then execute immediately — the recap is the user's last chance to interrupt, not a second approval gate.

## Question quality

Good questions surface decisions; bad questions ask for trivia.

- ✅ "Prioritize clarity for a non-expert audience, or compactness for a paper?"
- ❌ "What color do you want the box?"

- ✅ "Is this a quick sanity check or a thorough review?"
- ❌ "Should I use Python?"

If the answer to a question would not change anything you produce, don't ask it.

## What this skill is not

- Not a replacement for thinking. Don't ask the user to make decisions Claude can reasonably make on its own.
- Not a fixed script. Adapt depth to the task — a one-line script doesn't need a five-round alignment.
