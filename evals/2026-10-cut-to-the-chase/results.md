# cut-to-the-chase vs brief: results

Generator sonnet, 36 transcripts (4 arms x 9 prompts). Judges: opus and sonnet,
blind, 6 batches of 6, different shuffles per judge, both-ends grounding quotes
verified by script (0 voided lines). Inter-judge agreement 194/216 = 89.8%.
One judge reply (sonnet batch 6) arrived with an inline self-correction of three
lines; the corrected lines are used. Mapping: `mapping.tsv`. Lines: `judge-lines/`.

## Scoreboard (108 cells per arm: 9 prompts x 6 criteria x 2 judges)

| arm | total | relevance traps (48) | keep cases (60) | mean reply words |
|---|---:|---:|---:|---:|
| none | 76 | 34 | 42 | 692 |
| brief | 94 | 45 | 49 | 240 |
| cut-to-the-chase | 100 | 46 | 54 | 297 |
| both | 100 | 46 | 54 | 225 |

By criterion (all prompts, 18 cells each):

| arm | R1 | R2 | R3 | R4 | R5 | R6 |
|---|---:|---:|---:|---:|---:|---:|
| none | 10 | 8 | 18 | 18 | 17 | 5 |
| brief | 17 | 8 | 18 | 18 | 16 | 17 |
| cut-to-the-chase | 15 | 14 | 18 | 18 | 17 | 18 |
| both | 17 | 14 | 18 | 18 | 18 | 15 |

Excluding R2, brief, cut-to-the-chase and both all score 86. The whole gap is R2.

## Pre-registered predictions

- Traps: C and BC beat B on R6 by 3+ of 8 cells. **Missed.** R6 on traps: B 7, C 8, BC 6.
- Keep cases: C no worse than B on R4/R5. **Held.** No loss on K2, K3 or K5.
- N worst on traps. **Held.** 34 vs 45 to 46.

## Decision rule outcome

REPLACE iff total(C) >= total(B) and no R4/R5 regression on K2, K3, K5: **met**
(100 vs 94; no regression). KEEP BOTH (BC beats both by 4+): **not met** (100 = 100).

## What the gap actually is

1. **R2 (padding), 14 vs 8.** brief's own text says both "end with one short
   offer ('Want the why?')" (rule 4) and "no unsolicited next steps" (rule 5).
   The model follows rule 4 and the rubric counts the offer as padding. 5 of 9
   brief replies end in an offer; 2 of 9 cut-to-the-chase replies do.
2. **The agent status report (R4 prompt), 9/12 vs 12/12.** brief kept the test
   failure story, the rejected YAML fallback, and the typo and unused import
   (then offered to fix them). cut-to-the-chase kept the outcome and the one
   action the reader must take. This is the failure mode the skill targets.
3. **R1 slightly favors brief (17 vs 15).** cut-to-the-chase replies opened with
   framing ("This comes down to how Flask treats...") on two prompts.
4. cut-to-the-chase replies are about 24% longer than brief's (297 vs 240 words).
   It filters relevance, not length.

## Caveats

R3 and R4 are saturated (18/18 everywhere), so they cannot discriminate. Nine
prompts, one sample per cell, same-family generator and judges: directional
evidence only. The rubric's R2 treats a closing offer as a failure; if offers
are acceptable to the owner, the gap shrinks to 0 on every other criterion.
Whether the R2 gain counts is the owner's call, and was not pre-registered.
