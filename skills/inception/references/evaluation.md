# Evaluating an incepted principle

How to know the principle actually beats the rule list it replaced — not by
feel, but by a protocol honest enough to kill the principle if it doesn't.

The claim under test is specific. Not "answers get smarter" (hard to measure,
and structured-scaffold evals routinely come back null — see
[cc-thinking-skills](https://github.com/tjboudreaux/cc-thinking-skills), whose
rigorous pipeline found zero of 39 thinking skills with proven accuracy gains).
The claim is: **behavior conforms to intent more reliably, especially in
situations the rules never anticipated, and resists letter-compliance gaming.**
Conformance is checkable per-case, which makes this claim measurable where
"accuracy" is noise.

## Static checks (free, at authoring time)

Already part of the method, listed here as the first eval gate:

1. **Forward derivation** — every kept behavior falls out of the principle alone.
2. **Reverse derivation** — unwanted derivable behaviors are named in Boundary.
3. **Platitude check** — the principle demonstrably excludes something.

A principle failing any of these is not ready for the A/B.

## Validate the harness before trusting its verdict

An unvalidated eval validates nothing. Before reading the A/B result, the
harness itself must pass four gates:

1. **Control arms.** Alongside A and B, run a known-bad arm (instructions that
   obviously violate the intent) and, when feasible, a known-good hand-written
   one. The harness must separate controls decisively; a judge that can't tell
   sabotage from gold can't tell A from B. Control failure invalidates the run.
2. **Judge agreement.** Use ≥2 blind judges per transcript. Low agreement means
   the rubric is ambiguous — revise the rubric and rerun; never average over
   confusion.
3. **Bias mitigations by construction.** LLM judges favor longer answers, the
   first option shown, and their own model family. Therefore: score each
   transcript independently against the rubric (no side-by-side comparison),
   randomize presentation order, strip arm labels, and prefer cross-vendor
   judges (council `cli`/`openrouter` backends). Same-family judges make the
   result directional, not confirmatory — say so in the read-out.
4. **Human spot-check.** The intent belongs to the user, so the user is ground
   truth: they blind-grade a sample (~5 transcripts) and judge–human agreement
   is the harness's validity score. Report it with the verdict.

## A/B protocol

**Arms.** Same behavioral goal, two instruction sets:
- **A** — the original rule list.
- **B** — the incepted output (Principle + Why + Derived anchors + Boundary).
- **Token-match the arms** (pad A with its own rationale or trim B) so "more
  text" cannot masquerade as "better concept".
- Optional third arm **∅** (no instructions) to confirm the behavior doesn't
  come for free from the base model.

**Intent rubric.** Before generating anything, freeze the one-sentence intent
(method step 1) plus 3–5 observable conformance criteria. Judges get only this.

**Test suite.** 10–15 prompts per bucket, written before running either arm:

| Bucket | Construction | Success bar |
|---|---|---|
| **On-target** | Situations the rules explicitly cover | B ≥ A (principle must not lose ground it inherited) |
| **Transfer** | Situations the rules never mention but the intent covers — vary the surface domain (if rules were about chat answers, probe code comments, commit messages, reports) | **B > A** — this bucket *is* the generalization claim |
| **Adversarial** | (a) letter/spirit traps where obeying a rule literally violates intent; (b) out-of-scope probes where the principle might over-fire (Boundary territory) | B > A on traps; B ≈ ∅ on out-of-scope probes |

**Judging.** Blind, rubric-based, multi-model — run the transcripts through the
`model-council` skill in **judge mode**: identical criteria (the intent rubric)
for every judge, arm labels stripped, neither "inception" nor the arms' existence
mentioned. Score each transcript pass/fail per criterion; aggregate per bucket.
Require **grounding**: each judge must quote the **first and last** words of
every transcript in its score line, and the quotes are verified mechanically
against the files — any mismatch voids that judge's line, and voided lines get
a remedial regrade. (Calibration found even a frontier-model judge silently
crossing files without this; grounding took its sabotage-detection from 58% to
100%. A later run showed first-words-only grounding is insufficient when files
share identical openings — quote both ends. File-crossing risk grows with
batch size; for large sets, grade one file at a time or in small batches.)

**Reading the result.**
- B ≥ A on-target, B > A on transfer and traps, B ≈ ∅ out-of-scope → the
  principle took. Ship it.
- B ≈ A everywhere → the inception added nothing over the rules for this case;
  keep whichever is shorter and say so.
- B < A anywhere, or B ≠ ∅ out-of-scope → the concept is wrong or over-broad;
  return to the ladder with the failing transcripts as evidence.

**Pre-register the bar, publish the verdict.** Decide the success/kill thresholds
before judging, and record the outcome (in the skill's notes or commit message)
even when it's null — especially when it's null. An unevaluated principle is
folklore; a killed principle is information.

## Longitudinal signal (the metric that matters)

The skill exists because corrections kept recurring. So the real-world KPI is
**correction recurrence**: after installing the principle, does the same
complaint stop appearing across sessions? Track loosely — a correction that
comes back within a week is a failed inception regardless of what the A/B said.

## Practicality notes

- Personal-scale N (10–15/bucket) yields directional evidence, not significance.
  That is fine — the question is "keep or kill", not "publish".
- Reuse suites: the transfer and adversarial buckets for a given intent are
  reusable every time the principle's wording is revised.
- First calibration case for this repo: `brief` v1 (rule list) vs `brief` v2
  (conclusion-first principle) — ground truth already exists for what v2 was
  supposed to fix.
