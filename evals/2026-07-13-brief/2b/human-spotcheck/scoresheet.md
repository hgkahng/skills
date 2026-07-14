# G4 human spot-check — score sheet

You are the ground truth for this eval: the intent being judged is yours. Grade
the 5 transcripts below against the rubric, then compare with the machine
judges. Judge–human agreement is the harness's validity number.

**Before you start:** don't reopen `../results.md`, `../judge-scores.tsv`, or
`../mapping.tsv` until you've filled in the grid. (You may have skimmed
`results.md` already — that makes this a partially-blind check; still worth
doing, just noted for honesty.)

## Rubric (identical to what the judges saw)

Intent: Replies fully answer the question in the fewest words that do so —
answer first, decision-changing caveats kept, no padding or narrated reasoning.

- **R1**: The first sentence contains the answer/decision (no preamble, no
  restating the question). For artifact transcripts (commit message, docstring,
  status update): the opening line/subject carries the core content.
- **R2**: No padding — no filler phrases, no closing recap, no unsolicited next
  steps.
- **R3**: No narrated deliberation or visible self-correction (no "let me
  think", "actually, wait", weighing of alternatives as a story).
- **R4**: Any caveat that would change the reader's decision is present (if the
  question warrants none, R4 passes by default).
- **R5**: The answer is complete enough to act on; when the question explicitly
  requests depth/detail, real depth is provided.

Length is NOT a criterion. Score each cell 1 (pass) or 0 (fail).

## Transcripts

Grade one at a time, in this order.

1. **[U01](../transcripts/U01.md)** — Write the docstring for
   `fetch_with_retry(url, max_attempts=3, backoff=2.0)` (retries
   `requests.get`, exponential backoff, re-raises final failure).
2. **[U04](../transcripts/U04.md)** — Teach me, step by step and in full
   detail, how to hunt down a memory leak in a Node.js service. Don't compress
   it.
3. **[U10](../transcripts/U10.md)** — Same memory-leak question as above
   (different arm; grade it independently).
4. **[U15](../transcripts/U15.md)** — Is Python's GIL still a limitation these
   days? Should I care for a typical web app?
5. **[U22](../transcripts/U22.md)** — In one short paragraph: is it OK to store
   JWTs in localStorage?

## Score grid

| id | R1 | R2 | R3 | R4 | R5 |
|----|----|----|----|----|----|
| U01 |  |  |  |  |  |
| U04 |  |  |  |  |  |
| U10 |  |  |  |  |  |
| U15 |  |  |  |  |  |
| U22 |  |  |  |  |  |

## After grading

Compare your 25 cells against the `judge1_opus` and `judge2_sonnet` columns in
`../judge-scores.tsv` for these five ids.

- **Agreement** = matching cells / 25, computed against each judge separately.
- **G4 passes** at ≥80% (20/25) with each judge. One transcript has a known
  2-cell judge disagreement, so 25/25 with both is impossible — that's expected.
- If you land below the bar, the disagreeing cells tell you what to fix: either
  the rubric wording (ambiguous criterion → revise and re-run judging) or the
  judges themselves (they missed something a human sees → the 2b verdict is
  suspect on those cells).

Record the two agreement numbers at the bottom of this file and commit.

## Result (fill in when done)

- Agreement vs judge1 (opus): __ / 25
- Agreement vs judge2 (sonnet): __ / 25
- G4 verdict: pass / fail

> A **proxy run** (blind model graders, not the human) is recorded in
> [proxy-grade.md](proxy-grade.md): 23/25 vs each judge, one verdict-relevant
> disagreement on U10 R5. The grid above remains open for the human grade —
> U10 R5 is the one cell where it carries unique information.
