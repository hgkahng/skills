---
name: beamer-lecture
description: "Create, edit, convert, debug, and visually polish academic Beamer lecture slides for Hyungu Kahng (math-dm / DIGB174; DIGB164 BP; DIGB225 ML; DDM 676 IS). Use when building or revising lecture decks, adding or rewriting frames, fixing Beamer/LaTeX errors, converting notes to slides, or tightening plots, layout, or typography. Always compiles and screenshot-verifies before claiming done."
---

# Beamer Lecture

Build and maintain Beamer lecture slides as `.tex`. Two ideas drive everything here: **slides teach**, so students must be able to follow an idea in the order it is built and read each frame quickly; and **only the rendered page is real**, so TeX that compiles can still overflow, clip, or leave a widow.

Tasks: create a deck, topic, or frame; convert notes into slides (distill, don't transcribe every sentence); edit or polish existing `.tex` (respect its structure); fix LaTeX/Beamer errors.

## Slides teach

- **Background → intuition → formalism.** Open every deck, and every multi-frame topic, with why it matters and a mental-model frame right after `\maketitle`, before any definition. Each slide answers where we are, what the idea is, or what it looks like in practice.
- **Examples and visuals over prose:** every definition or equation gets a concrete instance; prefer a TikZ/pgfplots figure or a table to a paragraph.
- **Close with a conclusion frame:** the 2 to 4 points students should remember, not "thank you" or a slide-by-slide recap.
- **Emphasis is cool blue** (`\textbf{\textcolor{blue}{...}}`, `\highlight[blue]{...}`), at most one or two marks per frame; red `\alert{}` only for real warnings.
- **Wording:** no em dashes (`---`, `—`); use a comma, parentheses, or rewrite. Don't build sentences around a colon; a colon may introduce displayed math, a list, or a title suffix.
- **Named frames.** `allowframebreaks` only for one long worked example that must stay a single unit.

## Only the rendered page is real

**Workflow:** identify the course and use its preamble (shared base plus its option file) → write or edit frames → compile with that course's toolchain → render changed pages (all pages for a full deck) to PNG → inspect the images → fix and repeat until clean. Never report done from TeX alone. Engines, rendering commands, and the inspection checklist are in [compile-and-verify.md](references/compile-and-verify.md).

Layout rules that only the image can confirm:
- **Columns by role:** text with an illustrating figure is asymmetric (e.g. `.575 / .375`); peer panels (definition vs. picture) are equal `0.5 / 0.5`, with no `\hfill` between half-widths.
- **A block between bullets** (`definition`, `theorem`, `example`) aligns its left edge with the bullet *text*, using the `\item[]` + minipage pattern, measured on the PNG; never a guessed large `\hspace*`.
- **Size plots to the companion text panel, once.** Leftover whitespace is not a reason to enlarge. Tick and axis labels no larger than body text; geometry plots at 1:1 aspect; `adjustbox` only when a figure risks overflowing.
- **Labels sit at the tip** of what they label, padded into open space (`above right=3pt`), with `clip=false` near axis edges; re-check them after any resize.
- **Never shrink to fit.** No `\tiny`, and no `\scriptsize` for body text (fine for tick labels and the IS code blocks); split the frame instead.

## Keep each course's look

Don't change the theme, fonts, or `\setbeamertemplate` settings, or add packages beyond the course preamble, unless asked. Course-specific features (the IS callout boxes, for example) stay in their course. Express design in TeX, theme colors, and TikZ, not CSS or slide-software habits.

## References (read when needed)

| File | When |
|---|---|
| [frame-patterns.md](references/frame-patterns.md) | Frame skeletons, itemize spacing, blocks inside lists, code blocks, openers and closers, overflow and widow rules |
| [figure-style.md](references/figure-style.md) | Plot colors, sizes, axis defaults, tip-label details |
| [compile-and-verify.md](references/compile-and-verify.md) | Engines per course, PDF to PNG, inspection checklist |
| [preamble-architecture.md](references/preamble-architecture.md) | How the base preamble and course option files fit together |
| [macros.md](references/macros.md) | `mymacro.sty` commands (bundled as `references/mymacro.sty`) |
