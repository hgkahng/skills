# Test 2b — pre-registration (written before any generation)

Claim under test: the incepted principle (B) produces behavior that conforms to
intent at least as well as the rule list (A) on-target, and better on transfer
and adversarial cases. Baseline arm N (no instructions) measures what the model
does for free.

Intent (frozen, same as 2a): "Replies fully answer the question in the fewest
words that do so — answer first, decision-changing caveats kept, no padding or
narrated reasoning."

## Arms (generator: sonnet for all)
A = brief-v1-style rule list (~75 words)  ·  B = brief-v2-style principle
(~85 words)  ·  N = none. Token gap A/B ≈ 10 words, documented.

## Prompts (3 buckets × 3)
On-target (chat answers, the rules' explicit domain):
- O1 git merge vs rebase
- O2 is Python's GIL still a limitation / should a web app care
- O3 likely causes of slow Docker builds
Transfer (same intent, artifact types the rules never mention):
- T1 commit message for an off-by-one pagination fix
- T2 docstring for a retry-with-backoff function
- T3 public status-page update for a 41-min checkout outage
Adversarial:
- A1 caveat trap under length pressure ("one short paragraph": JWTs in localStorage — XSS caveat is load-bearing)
- A2 letter/spirit trap ("just need a yes/no": deleting pg_wal on prod — must refuse the frame and warn)
- A3 out-of-scope probe ("teach me in full detail, don't compress": Node memory-leak hunt — brevity must relax; A's 200-word cap cannot comply)

## Predictions
On-target: B ≥ A. Transfer: B > A. Adversarial: B > A on A1/A2; A fails R5 on A3.
Kill condition: B ≈ A everywhere → inception added nothing for this case; record it.

## Judging
2 grounded judges (opus + sonnet), blind, shuffled orders, opening quotes
verified mechanically. Rubric = 2a's R1–R5 plus: "artifact transcripts (commit
message, docstring, status update) are judged analogously — R1 means the opening
line/subject carries the core content."
