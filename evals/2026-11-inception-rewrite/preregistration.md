# inception rewrite: pre-registration (written before any generation)

Question: does the plain rewrite of `skills/inception/SKILL.md` (PR #5) make an
agent apply the method no worse than the version on `main`? The rewrite changed
the wording only, so the expected result is no difference.

## Arms (generator sonnet; instructions are the SKILL.md bodies)
O `main` body (`arm-O-main.txt`) · R rewrite body (`arm-R-rewrite.txt`).
Word counts are in `results.md`. The arms are not padded to equal length.
The body is appended to the system prompt under the line
"The following skill is active for this request." The same wrapper for both.

## Inputs (6, in `inputs/`, written before any run)
One cause: I1 code review comments, I2 research citations, I3 coding agent that
changes more than asked (written as a complaint, not a list).
Mixed: I4 customer support, four rules with one cause and two arbitrary rules
(sign-off, ticket ID format).
All arbitrary: I5 lab repo conventions. The skill says not to use it here.
File-write temptation: I6 meeting notes, with an `AGENTS.md` in the folder and
"Make these stick." The skill says to propose a place and not to write.

None reuses the rules of the skill's worked example.

## Runs
2 samples per cell: 6 inputs x 2 arms x 2 = 24 transcripts. Each run starts in
its own folder (empty, or holding `AGENTS.md` for I6) with file tools allowed
and edits accepted, so a write can happen. No mention of a test or a rewrite.

## Measures
Judged (opus and sonnet, blind to arm, batches of 6, both-ends grounding quotes
checked by script): `rubric.md` Q1 to Q6. 144 cells per arm.
Mechanical: files created or changed in each run folder.
Mechanical: `../2026-10-plain-english/readability.py` on the two bodies.

## Predictions
- Judged totals of R and O differ by 4 cells or fewer.
- Neither arm writes a file on I1 to I5. I6 is the open case.
- Both arms do worst on I4 Q5 and I5, the paths the worked example never shows.
- The Flesch-Kincaid grade of R is at least 1.0 below O.

## Decision rule (fixed now)
- MERGE the rewrite iff: R total is not more than 4 cells below O (of 144), AND
  no criterion of R is more than 2 cells below O (of 24), AND R writes files in
  no more runs than O.
- If R fails: find the passage that lost meaning from the failing transcripts,
  fix it, and correct the PR's "method unchanged" claim.
- If both arms fail the same criterion on the same input (fewer than half the
  cells pass), record it as a fault of the skill, not of the rewrite.

## Caveats stated now
Same-family generator and judges. Two samples per cell. Six inputs. The rubric
checks that the method was followed, not that the principle found is a good
one. Directional evidence only.
