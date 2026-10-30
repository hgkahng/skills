# plain-english: pre-registration (written before any generation)

Question: does `plain-english` make replies easier to read beyond what
`cut-to-the-chase` already does, without costing accuracy?

## Arms (generator sonnet; instructions are the shipped SKILL.md bodies)
N none · C cut-to-the-chase (353 words) · P plain-english (338 words) ·
PC both concatenated (691 words).

## Prompts (8)
Explain-a-concept, jargon-prone (E1 to E5): race condition, overfitting
symptom, idempotent (term the user asked about), database index, process vs
thread. Boundaries: B1 error message and command must stay literal, B2 p-value
(easy to simplify wrongly), B3 PhD student asking in expert terms (must not be
dumbed down).

## Measures
Mechanical, on E1 to E5 (no judging needed): Flesch-Kincaid grade, mean
sentence length in words, share of words with 3+ syllables, count of idioms
from a fixed list written now (see idioms.txt). Judged (opus and sonnet, blind,
grounded, batches of 5 or 6): rubric.md Q1 to Q6, all 8 prompts.

## Predictions
- P and PC lower the FK grade by at least 1.0 vs N and by at least 0.5 vs C.
- P and PC have shorter mean sentences and fewer idioms than C.
- Q3 (accuracy), Q4 (literals) and Q5 (complete): P no worse than C.
- Q6 on B3: P not worse than C (no talking down to the expert).

## Decision rule (fixed now)
- SHIP plain-english iff: FK grade of P is at least 0.5 below C on E1 to E5,
  AND P is not worse than C on Q3, Q4, Q5 (cells), AND P is not worse than C on Q6.
- If P is within 0.5 FK grade of C: it adds nothing measurable beyond
  cut-to-the-chase; do not ship as a separate skill.
- If P is worse than C on Q3 or Q4: do not ship as written.
- PC vs P tells whether to recommend installing both.

## Caveats stated now
Same-family generator and judges; one sample per cell; FK grade is a crude
proxy. Directional evidence only.
