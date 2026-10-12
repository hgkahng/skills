# Library smoke tests (2026-10)

**Skill routing: 22/22.** One blind sonnet run picked a skill (or none) for 22
prompts from the ten descriptions alone, including the write-vs-review,
align-vs-critique, and no-match cases. `got.tsv` vs `key.tsv`.
Caveat: one run, one model, prompts written by the skill author. A smoke test,
not proof. Re-run after any description edit.

**beamer-lecture templates (compile-verified, Debian TeX Live 2023):**
base+BP and base+IS (pdflatex); base+ML (xelatex, Korean, biber, nicematrix,
footnote symbols); base+math-dm (xelatex, `zxjafont[haranoaji]`); every
`mymacro.sty` command; `supframe`. The shipped `[hiragino-pron]` option fails
off macOS, as noted in `course-math-dm.tex`.

**`bin/sync.sh`:** 30 links across 3 agent dirs, none broken; rerun is safe;
`--copy` produces real copies.

## After replacing brief with cut-to-the-chase

Routing re-run on the new ten-skill catalog with two added brevity phrasings
("tl;dr", "you're rambling, get to the point"): **23/24**. All four brevity
prompts route to cut-to-the-chase. The miss is P21 ("write a Python function
that flattens a nested list"), which went to python-style in the first run and
to none in this one. It is a borderline prompt (python-style only fires when
style matters), so treat it as run-to-run variation. Files:
`*-after-replacing-brief.*`.

cut-to-the-chase's description was widened with brief's everyday phrases
('keep it short', 'just the answer', 'tl;dr', 'no preamble') so replacing brief
did not leave them unrouted. The body is unchanged: it is the evaluated text.
