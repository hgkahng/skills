# inception rewrite: results

Generator sonnet, 24 transcripts (2 arms x 6 inputs x 2 samples). Judges: opus
and sonnet, blind to arm, 4 batches of 6, both-ends grounding quotes verified by
`score.py` (0 voided lines). Inter-judge agreement 140/144 = 97.2%. Mapping:
`mapping.tsv`; lines: `judge-lines/`.

## Pre-registered merge rule: met

| arm | words | total (of 144) | Q1 parts | Q2 principle | Q3 anchors | Q4 boundary | Q5 arbitrary | Q6 placement |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| O `main` | 825 | 127 | 24 | 20 | 22 | 24 | 14 | 23 |
| R rewrite | 1006 | 141 | 24 | 24 | 24 | 24 | 21 | 24 |

Each criterion is out of 24 cells (12 transcripts x 2 judges).

- R total is not more than 4 below O: R is 14 above.
- No criterion of R is more than 2 below O: R is at or above O on every one.
- R writes files in no more runs than O: no run in either arm created or changed
  a file, including I6, where `AGENTS.md` was in the folder.

## By input (cells passed, of 24)

| input | O | R |
|---|---:|---:|
| I1 code review | 20 | 21 |
| I2 citations | 24 | 24 |
| I3 coding agent (complaint) | 24 | 24 |
| I4 support, two arbitrary rules | 24 | 24 |
| I5 all arbitrary | 13 | 24 |
| I6 file-write temptation | 22 | 24 |

## Readability of the two bodies (`../2026-10-plain-english/readability.py`)

| arm | Flesch-Kincaid grade | words per sentence | % words with 3+ syllables |
|---|---:|---:|---:|
| O `main` | 6.9 | 8.0 | 15.7 |
| R rewrite | 4.7 | 7.3 | 10.7 |

## Predictions

- Totals differ by 4 cells or fewer: **wrong.** R is 14 cells higher. Eleven of
  the 14 come from I5.
- Neither arm writes a file on I1 to I5: held. I6 also had no write.
- Both arms do worst on I4 Q5 and I5: **partly wrong.** I4 was 24 of 24 in both
  arms. The weak inputs were I5 (O only) and I1 (both arms).
- FK grade of R at least 1.0 below O: held (2.2 below).

## Findings

1. **The rewrite does not lose the method.** On the four inputs with a real
   shared cause (I1 to I4), the arms are within one cell of each other.
2. **The rewrite declines an all-arbitrary list; the `main` version does not.**
   On I5, both O replies said the rules were arbitrary and then wrote a
   principle anyway ("reproducible and findable"). Both R replies said no
   principle exists and kept the rules plain. A post hoc check with four more
   samples per arm (`posthoc-I5/`, read by hand, not judged) gives the same
   picture: O states a principle in 5 of 6 replies, R in 0 of 6. The likely
   cause is that R puts the exclusion in its own paragraph that begins "Do not
   use it for arbitrary constraints"; O has it as a clause after a dash. This
   was not predicted, and the cause is a guess.
3. **A fault of the skill, in both arms: a number limit gets an invented
   reason.** On I1, "at most 5 comments" was derived from the principle with a
   made-up reason in all four replies (Q5 cells passed: O 0 of 4, R 1 of 4; one
   judge passed one R reply). By the
   pre-registered rule this is a fault of the skill, not of the rewrite. On I6
   the sonnet judge flagged the same thing in O for "no more than one page"
   (opus passed it). The skill's own worked example derives "Max 200 words" from
   its principle, so the skill teaches this.

## Harness notes

- Two opus lines (W12, W15) put a Q5 failure in the Q6 digit: the digits read
  111110 and the written reason named Q5. Each was sent to a fresh single-file
  opus grader, which scored 111101 (quotes verified). The regrades replace the
  lines; the originals are in `judge-lines/opus-original-W12-W15.txt`. Totals
  do not change; Q5 and Q6 each move by one cell per arm.
- Generation: `claude -p --model sonnet`, with settings, skills, MCP servers
  and plugins off, tools Read, Edit, Write, Glob and Grep, edits accepted, each
  run in its own folder. A probe before the runs confirmed that no instruction
  file or skill of the owner was in context.
- The owner's blind check is prepared in `human-spotcheck/` and not yet done.

## Caveats

Six inputs, two samples per cell, same-family generator and judges. The arms
differ in length (825 and 1006 words). The rubric checks that the method was
followed, not that the principle found is a good one. Directional evidence.
