# cut-to-the-chase vs brief: pre-registration (written before any generation)

Question: should `cut-to-the-chase` (relevance filter: "write for a reader who
has your answer and nothing else") replace `brief` (length and answer-first
order), sit beside it, or be dropped?

## Arms (generator: sonnet for all; instructions are the shipped SKILL.md bodies)
B = brief (359 words) · C = cut-to-the-chase (353 words) · BC = both
concatenated (712 words, longer by design) · N = no instructions.

## Prompts (9)
Relevance traps, where the failure is extra related material (R1 to R4):
R1 git undo · R2 Flask trailing slash · R3 noisy CI log, one-line answer ·
R4 agent status report with one decision-relevant item buried among noise
(the two un-migrated deploy scripts must survive; the path-bug saga, the typo,
the unused import and the rejected fallback are noise).
Keep cases, where the failure is cutting too much (K1 to K5): K1 JWT caveat ·
K2 rm -rf pg_wal yes/no · K3 Node leak, full detail · K4 GIL question ·
K5 React newcomer (definitions are needed).

## Rubric
R1 to R5 as ratified in 2b (R5 includes the form-honors-the-request wording
from the G4 ruling) plus R6 relevance. See rubric.md.

## Predictions
- Relevance traps: C and BC beat B on R6 by at least 3 of 8 judge-cells.
- Keep cases: C is no worse than B on R4 and R5 (no cutting of needed things).
- N is worst on the traps.

## Decision rule (fixed now)
- REPLACE brief with C iff total(C) >= total(B) AND C does not fail R4 or R5
  on K2, K3 or K5 where B passes.
- KEEP BOTH iff total(BC) exceeds both single arms by at least 4 cells.
- If C and B are within 3 cells in total: no evidence of improvement; the
  owner's preference decides, with brief's prior evaluation as the tiebreaker
  for keeping it.
- If C loses a keep case that B passes: do not replace.

## Judging
Two blind judges (opus and sonnet), 36 shuffled transcripts in 6 batches of 6,
rubric only, no mention of arms or skills. Each score line must quote the first
and last words of its file; quotes verified mechanically; mismatched lines are
voided and regraded. Same-family generators and judges: directional evidence.
