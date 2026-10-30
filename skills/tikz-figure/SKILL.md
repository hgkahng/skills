---
name: tikz-figure
description: "Create, iterate on, and compile publication-ready TikZ/LaTeX figures for academic papers and Beamer presentation slides. Use this skill whenever the user wants to draw, design, or refine any figure, diagram, chart, or illustration using TikZ — including neural network architectures, flowcharts, commutative diagrams, geometric figures, plots, DAGs, and more. Also trigger when the user shares existing TikZ code and asks to fix, extend, or improve it. Trigger even for vague requests like 'draw a diagram of X', 'sketch this architecture', 'make a figure for my paper', or 'can you TikZ this?'"
---

# TikZ Figure

**A figure is read in a few seconds by someone who never sees its code.** So every element has to be legible, placed on purpose, and correct, and the only proof that it renders is compiling it. The rules below follow from that.

## Before drawing

- **Paper or slide?** It sets line widths, font sizes, color, and density. Infer it: "slide", "lecture", "Beamer" means slide; "paper", "IEEE", "NeurIPS", "journal" means paper. With no signal, use paper and say so.
- **Default output** is a standalone `.tex` that compiles on its own. If the request is vague, ask one focused question or take a reasonable reading and state it. If the user gave existing code, read it fully before changing anything.
- Prefer packages in base TeX Live; name any niche package you use so the user can install it.

| | Paper | Beamer slide |
|---|---|---|
| Lines | 0.4 to 0.8pt (≈0.4pt matches 11pt Computer Modern strokes) | 1 to 1.5pt |
| Labels | `\footnotesize` or `\small`, matching the text | `\small` to `\normalsize`, never below `\scriptsize` |
| Color | sparing, grayscale-safe; add dashed/dotted styles so B&W print still works | higher contrast; `structure` and `alert` inside Beamer |
| Density | width `\columnwidth` or `0.8\columnwidth`, nothing decorative | less dense, more whitespace |

## The reader decodes by consistency

- **One palette.** Define every box and arrow type once in `\tikzset` at the top, and use named styles on nodes. Hardcoded `draw=…, fill=…` on individual nodes drifts out of sync. If you find yourself writing it, add a style instead.
- **One arrow style** per figure. Deviate only when the difference means something (dashed = optional path).
- **Color carries meaning:** black for normal lines and borders, red or `\alert` for the highlighted part, green for examples or correct outputs, blue for structure, references, and input flow. For colorblind-safe categorical palettes, use ColorBrewer via `\usepgfplotslibrary{colorbrewer}` (a pgfplots library, so `\usetikzlibrary` won't load it), e.g. `cycle list/Set1-5`.

## The reader must not have to untangle anything

- **Labels never sit on a line.** Offset each label above or below nearby curves, and point to the data with an explicit `\draw[->]` arrow rather than anchoring a bare node next to it. In pgfplots, place the label at `(axis cs:x, y+offset)` and arrow to `(axis cs:x, y)`. After placing each label, check whether its box crosses any element; if it does, move it or flip sides.
- **Subordinate labels** ("raw inputs") anchor to their element in a consistent position, smaller and gray, never floating in empty space.
- **Balance the layout.** For four or more sources feeding one processor, stack the sources in one column and center the processor on it: `right=of {$(first.east)!0.5!(last.east)$}`. Each arrow enters the processor at its own source's height, `(src.east) -- (proc.west |- src.east)`, not at one shared point where the arrowheads pile up. A 2×2 grid of sources puts its right column level with the processor, and the arrows collide. A worked example is in [references/pipeline-template.tex](references/pipeline-template.tex).
- **No icon fonts or pasted images inside a diagram.** They clash with the TikZ look and blur in print. Use a short text label, a simple shape, or a math-mode symbol.
- **No hairballs.** For large networks, connect only the outer nodes and mark the rest with `\vdots`. Draw repeated layers with `\foreach`.

## The content must be correct

- **Architecture order.** Write the intended forward-pass order as a comment before placing nodes, and re-check the placed order against it. Transformer blocks are Sublayer → Add&Norm. Residuals run on the right side of the main flow, routed with `|-`, from a sublayer's input to the Add&Norm that closes it.
- **Neural networks.** Keep the index base consistent (no bias node `a_0` if inputs start at 1). Draw inputs `x_1 … x_d` as distinct from computation nodes. If weights are labeled, matrix shapes must match the node counts.

## Compile, then hand over

Compile every figure before presenting it, and fix errors from the `.log` first:

```bash
pdflatex -interaction=nonstopmode figure.tex
```

Deliver the `.tex` and `.pdf`; offer a PNG preview rather than rendering one unasked. If a package is missing (rare in a full TeX Live), install it with `tlmgr install <pkg>`, or on Debian/Ubuntu with `apt-get install texlive-pictures texlive-latex-extra` (`poppler-utils` adds `pdftoppm` for PNGs).

Errors that look like other problems:
- `above=of A` and `right=1cm of A` need the `positioning` library. The old `above of=A` form is deprecated; don't use it.
- `\usetikzlibrary` belongs in the preamble. The `standalone` class with the `tikz` option already loads TikZ.
- `remember picture, overlay` callouts positioned on `current page` need **two** compile passes; after one pass they land in the wrong place.
- Beamer overlay keys on TikZ elements (`visible on=<2->`, `alert on=<3>`) need `\usetikzlibrary{overlay-beamer-styles}`.

## Iterating

Make the change the user asked for and leave the rest: their coordinates, names, and style choices stay unless they conflict with the request. Apply direct feedback ("thicker arrows", "move this left") without asking first, then say briefly what changed.
