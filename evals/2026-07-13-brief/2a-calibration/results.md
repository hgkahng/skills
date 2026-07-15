# Test 2a results (harness calibration run 1)

G3 inter-judge agreement: 71/80 = 88.8%  PASS (bar 80%)
G1a sabotage-arm fail-rate (R1-R3, pooled): 19/24 = 79.2%  FAIL (bar 80%)
  - judge2 (sonnet): 12/12 = 100% correct rejection
  - judge1 (opus): 7/12 — misgraded T16 (notes describe a different file; T16
    opens "Restating your question:" yet was scored R1=R2=R3=1) and partially
    misgraded T06 (R1/R3). Root cause: judge file-crossing, not rubric ambiguity.
G1b candidate arms pass R1-R3 on P1-P3: A 94.4% PASS, B 100% PASS
G2 depth probe: PASS — thorough answers rewarded on R5 (T11, T15); the only R5
  penalty was judge2 flagging A-P4 as too thin for a "full picture" request
  (penalizing truncation, which is the check working as intended).

Pooled R1-R3 pass-rates: A 96%, B 100%, N 75%, X 21% — ordering as designed
(controls separate), but G1a's pre-registered bar was missed by one cell.

Verdict: harness NOT yet certified. Fix identified: require judges to quote the
first sentence of each transcript before scoring it (grounding check against
file-crossing). Rerun = run 2.
