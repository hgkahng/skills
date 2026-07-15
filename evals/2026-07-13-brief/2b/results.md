# Test 2b results — rule list (A) vs incepted principle (B) vs no instructions (N)

Generator: sonnet ×27 (9 prompts × 3 arms). Judges: opus + sonnet, blind,
grounded, shuffled orders. Cells = 5 criteria × 2 judges per transcript.

## Scores

| bucket      | A rules | B principle | N none |
|-------------|--------:|------------:|-------:|
| on-target   |   30/30 |       30/30 |  24/30 |
| transfer    |   29/30 |       30/30 |  16/30 |
| adversarial |   26/30 |       27/30 |  28/30 |
| **total**   | **85/90** | **87/90** | **68/90** |

Inter-judge agreement: 131/135 = 97.0%. Remaining disagreements are the
known R4 gray zone (is an omitted secondary caveat decision-changing?):
U04/U14/U25, plus U04 R2.

## Pre-registered predictions vs outcome

- On-target B ≥ A: PASS (tie 30–30).
- Transfer B > A: PASS by 1 cell (30 vs 29) — weaker than predicted; the rule
  list transferred to artifacts better than expected. The large transfer gap is
  instructions-vs-none (30/29 vs 16).
- Adversarial: A1 B>A (9 vs 8). A2 tie (10–10) — prediction miss: the base
  model refuses the dangerous command firmly in all arms; brevity pressure did
  not suppress the warning. A3 CONFIRMED exactly as predicted: the rule arm's
  200-word cap forced truncation of an explicit "don't compress" request —
  R5 failed by BOTH judges, the only R5 failure among instruction arms; the
  principle arm relaxed correctly and passed.
- Kill condition (B ≈ A everywhere): NOT triggered — B ≥ A in every bucket,
  strictly greater in two, and the one predicted qualitative failure mode
  occurred only in A.

## The exhibit

The rule arm was told: no filler phrases ("Great question", "It's worth
noting", "In summary"). Its JWT answer (U22) closes with "**In short:** …" —
a synonym recap, caught by both judges. Enumerated phrase bans invite
synonym compliance; the principle arm's matching answer (U14) has no recap.
This is the letter-vs-spirit mechanism the inception skill exists to fix,
reproduced in a controlled setting.

## Honest read-out

The principle beats the rule list directionally and never loses, with the
predicted letter-gaming failure appearing only in the rule arm — but the
margin is modest (2 cells of 90). The dominant effect is having thoughtful
instructions at all (A/B ≈ 85–87 vs N 68). Same-family generator and judges;
personal-scale N; directional evidence, not significance. Confirmatory rerun
belongs on cross-vendor CLIs via the council backend.

## G4 human spot-check (closed 2026-07-15)

Five blind single-file grader instances re-graded a 5-transcript sample
stratified across arms/buckets and weighted toward the verdict-driving cells:
23/25 agreement with each judge, both exhibits (U22 "In short:", U15 "Bottom
line:") independently reproduced. The one verdict-relevant disagreement,
U10 R5, went to the human: **fail**, agreeing with both judges — a dense
single paragraph does not honor an explicit "don't compress" request. The
scoreboard above is ratified. Full record: `human-spotcheck/`.

## Harness incidents (run log)

Judge 2 (sonnet) crossed two file *pairs* in the 27-file batch: U09↔U16
(caught by the opening-quote check) and U01↔U12 (identical openings — the
docstring files share their first words — caught by note-vs-content
contradiction). All four lines voided per protocol; a remedial regrade with
first+last-words grounding agreed with judge 1 on 20/20 cells. Lessons
encoded in the protocol: quote BOTH ends of the file; identical openers
defeat first-words-only grounding; large batches raise crossing risk.
