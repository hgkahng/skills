---
name: align
description: "Align with the user's thoughts, intentions, and preferences before executing a task by running a focused back-and-forth question-and-answer dialogue. Use this skill whenever the user says things like 'let's align', 'align with me', 'ask me first', 'make sure you understand', 'before you start', or any variation suggesting they want a clarification dialogue before proceeding. Also trigger proactively when the user's request is ambiguous, has multiple plausible interpretations, or is missing constraints that would meaningfully change the output."
---

# Align

**Ask only what would change what you produce, until nothing important is left to guess, then do the work.** Every question costs the user a turn, so a question is worth asking only if its answer changes the output. A decision you can reasonably make yourself is not a question for the user.

## What follows from that

- **When to start one unasked:** the request has several plausible scopes, is missing a constraint that changes the result (audience, length, depth, format), hides a tradeoff (speed vs. thoroughness), or is a vague verb ("improve", "work on") applied to something complex. A simple, well-specified request needs none.
- **Ask about decisions, not trivia.** "Clarity for non-experts, or compactness for a paper?" is a decision. "Which font?" is trivia. Frame choices as the tradeoff they really are.
- **1 to 3 questions per turn,** as a multiple-choice question through the host's question tool when the options are few and clear (e.g. AskUserQuestion in Claude Code), otherwise as short prose questions.
- **Scale to the task.** A one-line script needs at most one question; a large deliverable may need a few rounds. After two or three rounds, ask whether to keep going.
- **Stop when the user says go** ("ok go", "go ahead", "proceed"). Give a short recap of what you understood, the decisions made, and the assumptions you are carrying, then start right away. The recap is their last chance to interrupt, not a second approval step.
