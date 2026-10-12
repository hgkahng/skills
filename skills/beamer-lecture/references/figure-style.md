# Figure Style

Minimalism: gray data, one accent for the message, restrained labels.

## 1. Color budget

- **Gray** (`gray!50`, `gray!30`, `gray!25`) for grid, secondary data
- **One accent** (`blue`, `blue!75`, or `red!75`) for the message curve/arrow
- **Black** for axes and primary labels
- Multi-class: small low-saturation set (`blue!75`, `red!75`, `orange!75`), not rainbow
- IS decks: prefer palette colors from `course-is.tex` (`acc`, `hilite`, …)

Teaching vector diagrams may use blue/red/black for distinct objects; keep the
set small and consistent with equations.

## 2. Plot scale (hard lessons)

- Size to **match the companion text panel**, not to fill whitespace
- One calibrated size, then stop — do not escalate across iterations
- Tick / axis labels ≤ body text (`\small` / `\scriptsize`)
- Geometry: **1:1 data aspect** (`unit vector ratio=1 1` or equal TikZ `x`/`y`)

## 3. adjustbox (when needed)

Use `adjustbox` with `max totalsize` when a figure risks overflowing the frame
or column. Not required on every small vector diagram with intentional sizing.

```latex
\begin{adjustbox}{max totalsize={\textwidth}{.8\textheight},center}
\begin{tikzpicture}
\begin{axis}[ ... ]
\end{axis}
\end{tikzpicture}
\end{adjustbox}
```

Inside a column/minipage, use that box’s `\textwidth`.

## 4. Tip labels (TikZ / pgfplots)

1. Place the node **at the tip** (endpoint)
2. Pad into **open space** (`above right=3pt`, …) — off the ray, not toward axes
3. Set `clip=false` when labels sit near the axis edge
4. Re-screenshot after any resize (fonts and data units do not scale together)

Do not hand-tune bare offsets like `(axis cs:2.35,0.85)` as a substitute.

## 5. Canonical axis defaults

```latex
\begin{axis}[
    xlabel={$x$},
    ylabel={$y$},
    grid=both,
    grid style=dashed,
    scale only axis,
    major grid style={gray!50},
    minor grid style={gray!25},
    tick label style={font=\scriptsize},
    label style={font=\small},
]
```

## 6. `\includegraphics`

Prefer inline TikZ/pgfplots for algorithmic figures. Use `\includegraphics`
for photos, complex external diagrams, or prebuilt PDFs. Constrain with
`width=...` (not bare `height`).

## 7. What not to do

- Neon / rainbow palettes
- Legend that repeats axis labels
- Plot title that duplicates the frame title
- Stacking 3+ subfigures on one frame
