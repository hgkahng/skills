# Evaluation records

Each folder is one experiment: pre-registration written before generation,
blind transcripts, verified judge lines, mapping, and a results write-up.

| folder | question | outcome |
|---|---|---|
| `2026-07-13-brief/` | does a principle beat the rule list it replaced? | yes, 87 vs 85 of 90; letter-gaming seen only in the rule arm; G4 human check passed |
| `2026-10-library-smoke/` | do the ported skills route and build? | routing 22/22 and 23/24; Beamer and TikZ templates compile |
| `2026-10-cut-to-the-chase/` | replace brief? | yes, 100 vs 94 of 108, no keep-case regression |
| `2026-10-plain-english/` | does it add readability beyond cut-to-the-chase? | yes, grade 5.4 vs 8.3, no accuracy cost |
| `2026-11-inception-rewrite/` | does the plain rewrite of inception apply the method no worse? | yes, 141 vs 127 of 144; the rewrite declines an all-arbitrary list, `main` does not; owner's blind check pending |

## Open: inception field test

The real test of `inception` is correction recurrence: take a correction the
owner actually repeats to agents, incept it, install the principle, and watch
whether the correction stops coming back. As of 2026-10 no correction was
pending. When one surfaces, run inception on it, record the before/after
sessions here, and note whether the correction returned within a week.
