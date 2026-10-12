# plain-english: results

Generator sonnet, 32 transcripts (4 arms x 8 prompts). Judges: opus and sonnet,
blind, 6 batches of 5 or 6, both-ends grounding quotes verified by script
(0 voided lines). Inter-judge agreement 176/192 = 91.7%. Mapping: `mapping.tsv`;
lines: `judge-lines/`. Readability code: `readability.py`.

## Readability (mechanical, explain prompts E1 to E5, mean of 5 replies)

| arm | Flesch-Kincaid grade | words per sentence | % words with 3+ syllables | reply words |
|---|---:|---:|---:|---:|
| none | 7.3 | 12.7 | 11.6 | 464 |
| cut-to-the-chase | 8.3 | 15.7 | 11.1 | 134 |
| plain-english | 5.4 | 12.2 | 6.7 | 229 |
| both | 5.4 | 12.1 | 7.6 | 192 |

## Judged (96 cells per arm; Q1 jargon, Q2 idioms, Q3 accurate, Q4 literals, Q5 complete, Q6 natural)

| arm | total | Q1 | Q2 | Q3 | Q4 | Q5 | Q6 |
|---|---:|---:|---:|---:|---:|---:|---:|
| none | 67 | 2 | 2 | 15 | 16 | 16 | 16 |
| cut-to-the-chase | 79 | 7 | 8 | 16 | 16 | 16 | 16 |
| plain-english | 85 | 11 | 10 | 16 | 16 | 16 | 16 |
| both | 85 | 9 | 12 | 16 | 16 | 16 | 16 |

Out of 16 cells each (8 prompts x 2 judges).

## Pre-registered ship rule: met

FK grade of plain-english is 2.9 below cut-to-the-chase (rule: at least 0.5);
Q3, Q4, Q5 and Q6 are not worse than cut-to-the-chase. Predictions: FK drop of 1.0 vs
none and 0.5 vs C held (1.9 and 2.9). Fewer idioms than C held on the judged
criterion (Q2 10 vs 8 passes). The idiom-regex count was 0 in every arm, so that
measure did not discriminate: the fixed list was too narrow.

## Findings

1. **cut-to-the-chase alone makes text shorter but harder to read.** 71% fewer
   words than no instructions, but a higher grade level (8.3 vs 7.3) and longer
   sentences (15.7 vs 12.7 words): it packs the same ideas into fewer, denser
   sentences. plain-english fixes that (5.4, 12.2 words).
2. **Combining adds nothing measurable over plain-english alone** (85 vs 85, same
   FK), but replies are shorter (192 vs 229 words). Both skills are
   complementary in length, not in score.
3. **Q1 jargon is the weak spot for every arm** (best 11 of 16): judges flagged
   terms like "dropout", "lock", "GPU" that appear in a reply without a
   plain-words explanation, even in plain-english replies.
4. **No cost to accuracy, literals, completeness or tone.** The expert prompt
   (B3) was not talked down to in any arm; the error message and command (B1)
   stayed literal in every arm.

## Harness notes

- One opus line (W28, p-value) was internally contradictory: its digits scored
  accuracy as failed while its written reason described idioms, and the sonnet
  judge disagreed. It was sent to a fresh single-file opus grader, who scored it
  111111 (grounding quotes verified); that regrade replaces the line. As recorded
  originally, plain-english's Q3 would read 15 and the strict ship rule would have
  failed on one cell; the reply itself is accurate.
- The readability library could not run (it downloads a dictionary and the sandbox
  blocks that fetch). `readability.py` implements the standard Flesch-Kincaid
  formula with a vowel-group syllable counter, so absolute grades are approximate;
  comparisons across arms use the same counter.

## Caveats

Eight prompts, one sample per cell, same-family generator and judges. Q3 to Q6
are saturated (near 16/16 everywhere), so they only show the absence of harm.
Directional evidence.
