---
name: beamer-lecture
description: "Create, edit, convert, debug, and visually polish academic Beamer lecture slides for Hyungu Kahng (math-dm / DIGB174; DIGB164 BP; DIGB225 ML; DDM 676 IS). Use when building or revising lecture decks, adding or rewriting frames, fixing Beamer/LaTeX errors, converting notes to slides, or tightening plots, layout, or typography. Always compiles and screenshot-verifies before claiming done."
---

# Beamer Lecture

Help build and maintain Beamer lecture slides. Output is `.tex`; verification is
**compile → PNG → inspect images** (hard requirement).

Keep the course Beamer theme unless asked to change it. Express design in TeX,
theme tokens, and TikZ/pgfplots — not CSS or PPTX metaphors.

Preamble **architecture** (shared base plus thin per-course option files) is in
[preamble-architecture.md](references/preamble-architecture.md). Also read
[macros.md](references/macros.md) for `mymacro.sty` commands.

## Tasks

1. **Create** — full deck, multi-frame topic, or single frame (see pedagogy below)
2. **Convert** notes/outlines → slides (distill; do not dump every sentence)
3. **Edit / polish** existing `.tex` (respect structure unless asked)
4. **Fix** LaTeX/Beamer errors (snippet + recompile + verify)

## Pedagogy (core)

1. **Background → intuition → formalization** — start with why/context, then the
   conceptual picture, then definitions/mechanics/examples. Do not open a topic
   with bare formalism.
2. **Story-driven** — each slide answers where we are, what the idea is, or what it looks like in practice
3. **Example-driven** — definitions and equations get concrete instances
4. **Visuals over prose** — prefer TikZ/pgfplots/table over paragraphs ([figure-style.md](references/figure-style.md))
5. **Open with background + intuition** for full deck / multi-frame topics (mental-model frame after `\maketitle`; see [frame-patterns.md](references/frame-patterns.md))
6. **Conclusion-summary closer** — 2–4 takeaways, not “thank you”
7. **Cool blue emphasis** — `\textbf{\textcolor{blue}{...}}` / `\highlight[blue]{...}`; reserve red `\alert{}` for real warnings
8. **No em dashes.** Use a comma, parentheses, or rewrite. Do not use a colon when forming a sentence. A colon is fine to introduce displayed math, a list, or a title suffix.
9. Prefer **named frames**; use `allowframebreaks` only for a long worked example that must stay one conceptual unit

## Layout

- **Text + illustrating figure:** asymmetric columns (e.g. `.575 / .375`)
- **Peer panels** (definition vs picture, equation vs matching plot): equal `0.5 / 0.5` (adjacent minipages or `columns` + `onlytextwidth`; avoid `\hfill` between half-widths)
- **Blocks in lists:** `definition` / `theorem` / `example` between bullets → left edge aligns with **bullet text** (not the dots). Use the `\item[]` + minipage pattern in [frame-patterns.md](references/frame-patterns.md); verify on PNG
- Size plots to **match the companion text panel**; do not fill leftover whitespace; one calibrated size then stop
- Tick / axis labels ≤ body text (`\small` / `\scriptsize`)
- Geometry plots: **1:1 data aspect**
- `adjustbox` only when a figure risks overflowing the frame/column ([figure-style.md](references/figure-style.md))

## TikZ / pgfplots labels

1. Node **at the tip** (endpoint), not a guessed nearby `axis cs`
2. Pad into **open space** (`above right=3pt`, etc.) — off the ray, not toward axes/other arrows
3. `clip=false` when labels sit near the axis edge (default clip cuts characters)
4. Re-check labels on a screenshot after any resize

## Workflow

1. Identify the course → use that course's preamble (base + option file)
2. Edit / write frames ([frame-patterns.md](references/frame-patterns.md))
3. Compile per course toolchain
4. Render changed pages (or all, for full decks) to PNG
5. **Inspect the images** (overflow, widows, clipping, incomplete labels, plot scale, wrong emphasis)
6. Fix → recompile → recheck until clean

Details: [compile-and-verify.md](references/compile-and-verify.md).

## References (read when needed)

| File | When |
|---|---|
| [frame-patterns.md](references/frame-patterns.md) | Frame structure, itemize + definition-box alignment, code spacing, openers/closers, overflow/widows |
| [figure-style.md](references/figure-style.md) | Plots, colors, tip labels, columns with figures |
| [compile-and-verify.md](references/compile-and-verify.md) | Engines, PNG render, inspection checklist |
| [preamble-architecture.md](references/preamble-architecture.md) | Base + course option files |
| [macros.md](references/macros.md) | `mymacro.sty` commands |

## Do not

- Skip compile + screenshot verification
- Change theme / fonts / beamertemplate unless asked
- Enlarge plots because “there is whitespace”
- Hand-tune bare tip offsets like `(axis cs:2.35,0.85)` instead of tip + pad
- Mix course-only features (IS callouts, etc.) into another course unless asked
- Use `\tiny`, or `\scriptsize` for body text, to fit content; split the frame
  (`\scriptsize` is fine for tick labels and the IS minted block)
- Treat image-caption “still has whitespace” as a reason to enlarge again
- Guess large `\hspace*` to shove definition boxes into lists; use the itemize `\item[]` pattern and measure on PNG
- Use em dashes (`---` / `—`) in slide text; use a comma, parentheses, or rewrite. Do not form sentences with a colon.
