---
name: tikz-figure
description: "Create, iterate on, and compile publication-ready TikZ/LaTeX figures for academic papers and Beamer presentation slides. Use this skill whenever the user wants to draw, design, or refine any figure, diagram, chart, or illustration using TikZ — including neural network architectures, flowcharts, commutative diagrams, geometric figures, plots, DAGs, and more. Also trigger when the user shares existing TikZ code and asks to fix, extend, or improve it. Trigger even for vague requests like 'draw a diagram of X', 'sketch this architecture', 'make a figure for my paper', or 'can you TikZ this?'"
---

# TikZ Figure Skill

You are an expert in TikZ and LaTeX figure creation. Your goal is to produce clean,
publication-quality figures — code that compiles without errors, looks professional,
and can be dropped into an academic paper or Beamer slide deck with minimal adjustment.

---

## Step 1: Understand the Request

Before writing any code, clarify:

1. **Target context** — is this for a paper (IEEE, NeurIPS, ICML, etc.) or a Beamer slide?
   - If ambiguous, infer from context (e.g. mentions of "slide" vs "figure in the paper").
   - This affects font sizes, line widths, colors, and overall density.
2. **What to draw** — if the description is vague, ask one focused clarifying question rather
   than multiple. Prefer to take a reasonable interpretation and note your assumptions.
3. **Output format** — unless the user specifies, default to a **standalone `.tex` file**
   that compiles on its own. Also offer to compile to PDF if they want it.

If the user provides existing TikZ code, read it carefully before suggesting any changes.

---

## Step 2: Choose Libraries and Approach

Pick libraries appropriate to the figure type. Do not load unnecessary packages.

| Figure type | Preferred libraries |
|---|---|
| General shapes, arrows, layouts | `tikz` + `arrows.meta`, `shapes.geometric`, `positioning`, `calc` |
| Flowcharts, DAGs, trees | `positioning`, `graphs` |
| Neural networks / ML architectures | `tikz` with manual node layout (avoid niche packages that may not be installed) |
| Commutative diagrams | `tikz-cd` |
| Function plots, data curves | `pgfplots` |
| Geometric / math figures | `tkz-euclide` or plain TikZ |
| Circuit diagrams | `circuitikz` |

**Prefer widely available packages** (part of TeX Live / MiKTeX base distributions).
If you use a niche package, note it explicitly so the user knows to install it.

---

## Step 3: Apply Context-Aware Styling

### Paper figures
- Use thin, precise lines (`line width=0.4pt` to `0.8pt` for most elements; the PGF
  manual recommends matching the font's stroke width — ≈0.4pt for 11pt Computer Modern)
- Font sizes: match the surrounding text (`\footnotesize` or `\small` for labels)
- Colors: use sparingly; prefer grayscale-safe palettes plus dashed/dotted line styles so
  the figure stays readable when printed in B&W
- No unnecessary decorative elements
- Figure width: typically `\columnwidth` or `0.8\columnwidth`

### Beamer slide figures
- Thicker lines (`line width=1pt` to `1.5pt`)
- Larger fonts (`\small` to `\normalsize` for labels; never smaller than `\scriptsize`)
- Higher contrast colors (slides are viewed from a distance)
- Less dense layouts — more whitespace
- Use Beamer-friendly colors if inside a Beamer document (e.g. `structure`, `alert`)

**Auto-detection heuristics:**
- User mentions "slide", "presentation", "lecture", "Beamer" → use slide styling
- User mentions "paper", "figure", "IEEE", "NeurIPS", "journal" → use paper styling
- No context → use paper styling (safer default), but mention the assumption

---

## Step 4: Write the TikZ Code

### Code quality standards
- Code must compile without errors with `pdflatex`
- Add brief comments for non-obvious sections
- Use `\tikzset` to define reusable styles at the top — avoid repetition
- Align coordinates logically; use `calc` library for relative positioning when helpful
- Keep the code readable: one node/path per line for complex figures

### ⚠️ Annotation placement — apply every time, no exceptions
Text labels placed near curves or elements frequently overlap them. This is one of the
most common quality failures and must be checked proactively, not after user feedback.
- **Never** place a label at the same y-level as a nearby curve — always offset above or below
- **Always** use an explicit pointer arrow (`\draw[->] (label coord) -- (data coord)`) rather
  than a bare `\node` anchored next to a data coordinate; bare anchors drift onto lines
- In pgfplots: write annotations at `(axis cs:x, y+offset)` with `\draw[->]` pointing to the
  actual data point — never place the node at `(axis cs:x, y)` directly
- After writing each annotation, mentally trace: does the label bounding box intersect any
  curve or element? If yes, increase the offset or flip it to the opposite side

### ⚠️ Architecture / block diagrams — verify order before drawing
Incorrect block ordering is the most common error in architecture figures.
This must be checked before writing any nodes, not after.
1. Write the intended forward-pass order as a comment at the top of the code
2. Transformer-style blocks: correct order is **Sublayer → Add&Norm**, not the reverse
3. Residuals go on the **right side** of the main flow, routed with `|-`; each originates
   at the input of a sublayer and terminates at the Add&Norm that closes that sublayer
4. After placing all nodes, re-read their order and confirm it matches the comment from step 1

### ⚠️ Flow/block diagram quality — apply before writing any node

Flow diagrams (input sources → processing → output, pipelines, system architectures)
are among the most commonly produced but also most commonly **low-quality** TikZ figures.
The failure modes are predictable and must be checked before writing a single node:

**1. Define a unified style palette first — no exceptions.**
Every box type must come from a `\tikzset` palette defined at the top. Never hardcode
`draw=blue!40, fill=blue!5, rounded corners` inline on individual nodes. If a figure has
three visual levels, define three named styles (the reference template at the end of
this section shows a complete palette in context).

If you catch yourself writing `draw=...` on an individual node, stop and add a named
style instead.

**2. Never use icon fonts or `\includegraphics` for concept icons inside a diagram.**
Pasted-in icons (Font Awesome, Unicode emoji, raster clip-art) clash with the TikZ
aesthetic, become blurry at print resolution, and create alignment headaches. Instead:
- Use a short text label (e.g. `Docs`, `Mem`, `Tools`) inside the box.
- Or use a simple TikZ shape as a visual indicator:
  ```latex
  % A plain labeled box — no icon needed
  \node[primary] (docs) {Documents};
  ```
- Or add a superscript/subscript symbol in math mode: `\node {$\mathsf{M}$}`.

**3. Check spatial balance before placing nodes.**
Sketch the rough layout mentally: are inputs stacked vertically on one side while the
other side is mostly empty? That's a sign the diagram needs restructuring. For
pipelines with 4+ input sources feeding one processor:
- Use a **simple vertical column** for the sources; place the processor to the right,
  vertically centred using `right=of {$(first.east)!0.5!(last.east)$}`.
- ⚠️ **Do NOT use a 2×2 grid** for sources feeding a single processor — the right
  column ends up at the same x-position as the processor and arrows collide with nodes.
- Or use a single "Inputs" aggregation box if individual labels add no information.

**4. Annotate with visual anchoring, not floating text.**
Subordinate labels ("raw inputs", "relevant, compact") must be anchored to the element
they describe (`\node[annot, below=2mm of inputs] {raw inputs};`), visually subordinate
(smaller font, gray), and never left floating in empty space. The full rule — offsets,
pointer arrows, the bounding-box check — is **Annotation placement** above.

**5. Unify arrow style.**
All arrows in a figure should use one style (weight, color, head shape). Define it once:
```latex
\tikzset{flow/.style={-latex, line width=0.7pt, gray!70}}
\draw[flow] (A) -- (B);
```
Only deviate if a specific arrow needs semantic distinction (e.g. dashed = optional path).

**Reference template for a sources → processor → output pipeline:**
```latex
\documentclass[tikz,border=8pt]{standalone}
\usetikzlibrary{arrows.meta, positioning, calc}

\tikzset{
  srcbox/.style={draw=gray!55, fill=gray!7, rounded corners=3pt,
                 minimum width=2.4cm, minimum height=0.85cm,
                 font=\small, align=center},
  procbox/.style={draw=blue!45, fill=blue!5, rounded corners=3pt,
                  minimum width=1.6cm, minimum height=4.6cm,
                  font=\small\bfseries, align=center},
  outbox/.style={draw=gray!70, fill=white, rounded corners=4pt,
                 minimum width=2.2cm, minimum height=1.1cm,
                 font=\small\bfseries, align=center},
  annot/.style={font=\scriptsize\itshape, text=gray!65, align=center},
  arr/.style={-latex, line width=0.55pt, color=gray!65},
}

\begin{document}
\begin{tikzpicture}[node distance=0.6cm and 2.6cm]

% --- 4 source nodes, vertical column ---
\node[srcbox]                 (docs)  {Documents};
\node[srcbox, below=of docs]  (mem)   {Memory};
\node[srcbox, below=of mem]   (tools) {Tool outputs};
\node[srcbox, below=of tools] (hist)  {History};
\node[annot,  below=2mm of hist] {raw inputs};

% --- Processor, vertically centred on the column ---
\node[procbox, right=of {$(docs.east)!0.5!(hist.east)$}] (proc)
    {Filter\\[4pt]\&\\[4pt]Rank};

% --- Output nodes ---
\node[outbox, right=2.4cm of proc] (ctx) {Curated\\Context};
\node[annot,  below=1.5mm of ctx]  {relevant, compact};
\node[outbox, right=1.6cm of ctx]  (llm) {LLM};

% --- Arrows: sources → proc (enter proc.west at matching heights) ---
\draw[arr] (docs.east)  -- (proc.west |- docs.east);
\draw[arr] (mem.east)   -- (proc.west |- mem.east);
\draw[arr] (tools.east) -- (proc.west |- tools.east);
\draw[arr] (hist.east)  -- (proc.west |- hist.east);

% --- Arrows: proc → outputs ---
\draw[arr] (proc.east) -- (ctx.west);
\draw[arr] (ctx.east)  -- (llm.west);

\end{tikzpicture}
\end{document}
```

### Standalone file template
```latex
\documentclass[tikz, border=4pt]{standalone}
\usetikzlibrary{arrows.meta, positioning, shapes.geometric, calc}
% Add other libraries as needed

\begin{document}
\begin{tikzpicture}[
  % Define global styles here
  node distance=1.5cm,
  every node/.style={font=\small},
]

% --- Figure content ---

\end{tikzpicture}
\end{document}
```

### Snippet template (for embedding in existing document)
```latex
\begin{figure}[t]
  \centering
  \begin{tikzpicture}[...]
    % content
  \end{tikzpicture}
  \caption{...}
  \label{fig:...}
\end{figure}
```

---

## Step 5: Compile (Always) and Preview (if requested)

**Always compile every figure** using the bash environment to catch errors proactively.
Never deliver TikZ code that hasn't been compiled. If compilation fails, fix the error
before presenting anything to the user.

```bash
pdflatex -interaction=nonstopmode figure.tex
# If exit code != 0, read the .log file, diagnose, fix, and recompile
```

If a package is missing (rare — `tikz`, `pgfplots`, and every library used here ship with
a full TeX Live / MiKTeX), install it with the TeX package manager (`tlmgr install <pkg>`)
or, on Debian/Ubuntu, `apt-get install texlive-pictures texlive-latex-extra poppler-utils`
(the last one provides `pdftoppm` for PNG previews). Don't assume a particular OS package
manager exists.

**On preview**: after successful compilation, provide the `.tex` and `.pdf` files.
Offer to also render a PNG preview inline — but do not auto-render unless the user asks.
If compilation fails, read the `.log`, diagnose the error, fix the source, and recompile silently before presenting anything to the user.

---

## Step 6: Iterate

When iterating on existing code:
- Make surgical edits; do not rewrite the whole figure unless necessary
- Explain what you changed and why (briefly)
- Preserve the user's coordinate system, naming conventions, and style choices unless
  they conflict with the requested change

When the user gives feedback like "make the arrows thicker" or "shift this node left":
apply it directly without asking for confirmation — just do it.

---

## Color and palette guidance

### Color semantics (from the PGF manual)
Vector graphics should follow consistent color logic so readers can decode figures
without a legend:
- **Black** — normal lines, borders, neutral elements
- **Red / `\alert` color** — highlighted or important part
- **Green** — examples, correct outputs, positive results
- **Blue** — structural elements, references, input flow

Bitmap photos may use arbitrary color; vector diagrams should follow the above.

### Accessible palettes (ColorBrewer)
Load with `\usepackage{pgfplots}` + `\usepgfplotslibrary{colorbrewer}`. These schemes are
colorblind-safe and print well in grayscale:

| Use case | Scheme | Example |
|---|---|---|
| Qualitative (unordered categories) | `Set1`, `Dark2` | method A vs B vs C |
| Sequential (low → high) | `Blues-5`, `Greens-5` | activation intensity |
| Diverging (around a midpoint) | `RdBu-7` | weight sign, loss diff |

```latex
\usepgfplotslibrary{colorbrewer}
% Use as cycle list in pgfplots:
\pgfplotsset{cycle list/Set1-5}

% Use as named colors:
\tikz \fill[color=Set1-A] (0,0) rectangle (1em,1ex);  % red
\tikz \fill[color=Set1-B] (0,0) rectangle (1em,1ex);  % blue
```

Paper-vs-slide color contrast and line-width presets live in **Step 3**.

---

## Neural network diagrams

These are among the most common ML figures. They are also frequently drawn wrong.
Follow the patterns below.

### Core patterns
Use `\foreach` loops to draw layers — never repeat node definitions manually:

```latex
\documentclass[tikz,border=4pt]{standalone}
\usetikzlibrary{arrows.meta,positioning,calc}

\begin{document}
\begin{tikzpicture}[
  node/.style={circle, draw=blue!60, fill=blue!10, minimum size=8mm, thick},
  >=latex,
]
% Input layer: 3 nodes
\foreach \i in {1,2,3} {
    \node[node] (I\i) at (0, {-(\i-2)*1.2}) {};
}
% Hidden layer: 4 nodes
\foreach \j in {1,2,3,4} {
    \node[node] (H\j) at (2.5, {-(\j-2.5)*1.2}) {};
}
% Output layer: 2 nodes
\foreach \k in {1,2} {
    \node[node] (O\k) at (5, {-(\k-1.5)*1.2}) {};
}
% Connections
\foreach \i in {1,2,3}
    \foreach \j in {1,2,3,4}
        \draw[gray!50] (I\i) -- (H\j);
\foreach \j in {1,2,3,4}
    \foreach \k in {1,2}
        \draw[gray!50] (H\j) -- (O\k);
% Labels
\node[above=4mm of I1] {\small Input};
\node[above=4mm of H1] {\small Hidden};
\node[above=4mm of O1] {\small Output};
\end{tikzpicture}
\end{document}
```

### Indicating omitted layers
```latex
% Draw two visible nodes, then "..." between them:
\node[node] (H1) at (2.5, 0.8) {};
\node[node] (H2) at (2.5, -0.8) {};
\node at (2.5, 0) {$\vdots$};
```

### ⚠️ Common neural network diagram errors
1. **Wrong index base** — bias node `a_0^{(0)}` does not exist if you index inputs
   starting at 1. Be consistent: either include bias nodes explicitly or omit them.
2. **Input nodes vs. data nodes** — inputs `x_1, …, x_d` are separate from
   computation nodes. Draw them as distinct shapes or as unlabeled entry points.
3. **Incorrect weight matrix dimensions** — if you show weight labels, verify that
   matrix shape matches the number of source and target nodes.
4. **Dense connections for illustration** — for large networks, draw connections only
   between the outermost nodes (top/bottom) and indicate the rest with `\vdots` or
   fading edges. Fully connected arrows for large layers produce unreadable hairballs.

### Block diagram style (for transformer / ResNet architectures)
See **Architecture / block diagrams** in Step 4 — ordering, right-side residuals, and
`|-` routing all apply directly.

---

## Beamer-specific TikZ patterns

### `remember picture, overlay` — for cross-slide annotations
Useful for highlighting parts of a figure or adding callouts in Beamer:
```latex
\begin{tikzpicture}[remember picture, overlay]
    \node[fill=yellow!40, draw=orange, rounded corners,
          text width=3cm, align=center]
        at (current page.center)
        {Key insight here};
\end{tikzpicture}
```
The `current page` coordinate is available when `remember picture` is active.
**Compile twice** — these positions resolve through the `.aux` file, so the callout lands
in the wrong place on a single pass.

### Beamer overlay specs on TikZ nodes
TikZ nodes inside Beamer frames can use overlay specs:
```latex
\begin{tikzpicture}
    \node (A) {Start};
    \node[right=1.5cm of A] (B) {End};
    \draw[-latex, visible on=<2->] (A) -- (B);  % arrow appears on slide 2+
    \node[above=2mm of B, alert on=<3>] {\small Result};  % red on slide 3
\end{tikzpicture}
```
Requires `\usetikzlibrary{overlay-beamer-styles}`.

---

## Common Pitfalls to Avoid

- `\usetikzlibrary` must be called in the preamble, not inside `tikzpicture`
- `positioning` library required for the `above=of A` / `right=1cm of A` syntax (the
  older `above of=A` form works without it but is deprecated — don't use it)
- `calc` library required for `$(A)!0.5!(B)$` midpoint syntax
- `arrows.meta` replaces the old `arrows` library — prefer it for arrowhead styles
- `pgfplots` and TikZ coordinate systems don't mix without `axis cs:` prefix
- Standalone class with `tikz` option auto-loads TikZ; don't `\usepackage{tikz}` again
  (though it's harmless, it's redundant)
- For Beamer: use `\only`, `\uncover`, `\visible` for animation — TikZ `overlay` specs
  work inside Beamer frames

---

## Output Checklist

Before presenting code to the user, verify every item:
- [ ] All used libraries are imported
- [ ] Figure compiles successfully (bash compile is mandatory — see Step 5)
- [ ] Styling matches target context (paper vs. slide)
- [ ] No hardcoded absolute sizes that break at different scales
- [ ] Reusable styles defined with `\tikzset`, not repeated inline
- [ ] Caption and label included if snippet format was requested
- [ ] **Annotations**: every label has a pointer arrow and is offset away from all curves/elements
- [ ] **Architecture**: forward-pass order confirmed correct before arrows were drawn; residuals route correctly on the right side
- [ ] **Colors**: palette is colorblind-safe or grayscale-compatible; color semantics are consistent
- [ ] **Neural networks**: index base is consistent; weight matrix dimensions match node counts; no hairball connections for large layers
- [ ] **Flow/block diagrams**: single `\tikzset` palette used; no inline icon images; spatial balance checked; annotations anchored to their referent; single arrow style throughout
