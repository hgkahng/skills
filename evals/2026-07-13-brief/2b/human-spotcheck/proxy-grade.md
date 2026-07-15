# G4 spot-check — proxy run (model grader, not the human)

The user delegated the G4 spot-check ("do the G4 human spot check"). The
orchestrating model could not grade it honestly — the judges' scores were
already in its context, so its grades would be anchored, not independent.
Instrument used instead: **five fresh grader instances, one per transcript**,
each blind to the arms, the judges' scores, the A/B's existence, and every
file except its single transcript. Single-file grading makes file-crossing
impossible; grounding (first + last 8 words) was still required and verified
mechanically — all 10 quotes matched.

**Disclosed limitations.** The graders are Claude-family (same family as both
judges; no cross-vendor CLI or OpenRouter key was available in the container),
and a model proxy is not the human ground truth G4 asks for. This run is
therefore recorded as **proxy-G4**: it checks judge reliability, not intent
fidelity. The score sheet stays open for the human grade. Sample selection
(by the orchestrator, before graders ran) was weighted toward the hardest
cells — three of five transcripts had known fails or a judge dispute — which
makes high agreement harder to reach, not easier.

## Cells (R1–R5)

| id | blind grader | judge1 (opus) | judge2 (sonnet) | agree j1 | agree j2 |
|----|--------------|---------------|-----------------|----------|----------|
| U01 | 1,1,1,1,1 | 1,1,1,1,1 | 1,1,1,1,1 | 5/5 | 5/5 |
| U04 | 1,0,1,1,1 | 1,1,1,1,1 | 1,0,1,0,1 | 4/5 | 4/5 |
| U10 | 1,1,1,1,1 | 1,1,1,1,0 | 1,1,1,1,0 | 4/5 | 4/5 |
| U15 | 1,0,1,1,1 | 1,0,1,1,1 | 1,0,1,1,1 | 5/5 | 5/5 |
| U22 | 1,0,1,1,1 | 1,0,1,1,1 | 1,0,1,1,1 | 5/5 | 5/5 |

**Agreement: 23/25 (92%) vs each judge. Bar was ≥20/25 (80%). Proxy-G4: pass.**

Notably, the blind grader independently reproduced the two exhibits: U22's
"In short:" closing recap (the letter-compliance case) and U15's "Bottom
line:" recap — same cells, same cited evidence as the judges.

## The three disagreeing cells

1. **U04 R2** (judges split 1/0; grader 0). Grader sides with sonnet: the
   "Cheat sheet" plus "Core technique to remember above all else" is a closing
   recap. Tie-break → fail.
2. **U04 R4** (judges split 1/0; grader 1). Grader sides with opus: the
   decision-changing caveats are present (inspector-port exposure, MemoryStore
   "not production-safe", sawtooth-vs-staircase). Tie-break → pass.
   The two U04 tie-breaks cancel on the 2b scoreboard: B stays 87.
3. **U10 R5** (both judges 0; grader 1) — **the pre-registered cell.** Judges:
   a ~200-word single paragraph cannot satisfy "full detail... Don't compress
   it." Grader: the paragraph covers the complete workflow with concrete tools,
   so depth is provided. This is a genuine rubric ambiguity: R5's "real depth
   is provided" can be read as *coverage* (grader) or as *form honoring the
   explicit don't-compress request* (judges).

**Sensitivity.** U10 R5 is the only disagreement that moves the verdict: under
the grader's reading, arm A gains 2 cells → A 87, tying B 87. The principle's
case would then rest not on the score margin but on what survives either
reading: B never loses a bucket, and the letter-compliance failure (U22)
appears only in the rules arm — independently confirmed by this blind run.

**Recommended rubric fix** (for reuse of this suite): tighten R5 to "when the
request explicitly asks for full detail or forbids compression, the reply's
*form* must honor it — a dense summary that names every step is still
compression." Judge–human (here judge–grader) disagreement concentrated on one
criterion is the rubric-ambiguity signal the protocol says to fix, not average.

## What remains for the real G4

One cell settles it: read [U10](../transcripts/U10.md) against its request
("Teach me, step by step and in full detail... Don't compress it") and decide
R5 yourself. The rest of the sheet showed 92% machine consensus; U10 R5 is
where the human grade carries unique information.

## Human verdict (2026-07-15)

The user graded the contested cell: **U10 R5 = fail** — one dense paragraph is
exactly the compression the request forbade. This sides with both judges and
against the blind grader, so the 2b scoreboard stands (B 87, A 85, N 68).
Every judge-consensus cell in the sample is now confirmed — 22 by blind proxy
agreement, U10 R5 by the intent's owner — and the only remaining disagreements
are the two U04 cells where the judges themselves split, where someone had to
disagree. **G4: pass.** The R5 wording fix above is ratified for suite reuse:
an explicit don't-compress request constrains the reply's form, not just its
coverage.
