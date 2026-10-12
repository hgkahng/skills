# Macros from `mymacro.sty`

Reference for the custom commands and environments defined in the user's
`mymacro.sty`. Every example below is copy-paste ready and should be preferred
over generic LaTeX equivalents when applicable.

`mymacro.sty` also loads `tikz`, `tikzsymbols`, `pgfpages`, `pgfplots`
(`compat=1.18`), and the TikZ libraries `positioning` and `fit`. So those are
always available without an extra `\usepackage`.

## Auto-sized brackets

Use these instead of writing `\left( ... \right)` etc. They produce identical
output but are shorter.

```latex
\nbracket{x_1 + x_2}   % ( x_1 + x_2 )      parentheses
\cbracket{y_i}         % { y_i }            curly braces
\rbracket{0, 1}        % [ 0, 1 ]           square brackets
\abracket{u, v}        % < u, v >           angle brackets
```

## Bold sans-serif math

```latex
\boldsf{X}   % bold sans-serif uppercase, e.g. for matrices in mathsf style
```

## Operators

```latex
\tr(A)              % trace
\argmax_{x} f(x)    % argmax with subscript below the operator
```

## Highlighting math expressions

The `\highlight` family wraps math in a rounded, color-tinted box (color!10
fill). The optional color argument defaults to red. All variants accept an
overlay specification (`<2->`, etc.) and fall back to plain math on slides
where the overlay is not active.

### `\highlight[color]{expr}` — the base highlight

```latex
y = \underbrace{\highlight[blue]{\beta_0 + \beta_1 x}}_{=h(x)} + \varepsilon
```

Use `\highlight[white]{...}` as an invisible space-holder when you want a
later overlay to swap in a real highlight without the layout jumping.

### Captioned highlights — five placements

Each adds a small caption near the highlighted expression. Pick by where the
caption should sit:

| Macro                        | Caption placement | Reserves space |
|------------------------------|-------------------|----------------|
| `\highlightcap`              | below             | yes            |
| `\highlightcaphead`          | above             | yes            |
| `\highlightcapright`         | right             | yes            |
| `\highlightcapoverlay`       | below             | no (overlay)   |
| `\highlightcapheadoverlay`   | above             | no (overlay)   |

The `overlay` variants do not push surrounding content; the caption floats
above/below without taking vertical space. Use them for transient annotations
appearing on later overlay slides.

```latex
\highlightcap[red]{\frac{1}{2}\sum_n (t_n - \mathbf{w}^\top\phi(\mathbf{x}_n))^2}{error term}
\highlightcap<2->[blue]{\frac{\alpha}{2}\mathbf{w}^\top\mathbf{w}}{regularizer}
```

## Text-level callout: `\remarkbox`

A rounded gray box (color!30 fill, default gray) for inline remarks or asides
in regular text. Math goes inside `\highlight*`; prose goes inside `\remarkbox`.

```latex
\remarkbox{Note: this approximation breaks down when $n < p$.}
\remarkbox[blue]{Recall: convexity guarantees a unique minimum.}
```

For richer callouts (warnings, takeaways, findings), use the `tcolorbox`
environments documented in `frame-patterns.md` rather than `\remarkbox`.

## `supframe` environment — supplementary frames

A `frame` variant with a green frame-title background. Use for "extra detail",
optional content, or appendix-style frames the user can skip in a time crunch.

```latex
\begin{supframe}{Derivation of the Normal Equation}
    % content
\end{supframe}
```

## Bilingual labels: `\withja{english}{japanese}`

Compact two-line label: English on top, Japanese in `\scriptsize` directly
below, with negative vertical space between them. Designed for slide titles or
short captions when teaching Japanese-speaking audiences.

```latex
\frametitle{\withja{Optimization}{最適化}}
```

For Korean parentheticals the convention is different and does not use a
macro: write `{\footnotesize (한국어)}` inline after the English term.

```latex
\item Simple Linear Regression {\footnotesize (단순선형회귀)}
```

## What is NOT defined here

- No theorem/lemma/proof environments. Use `amsthm` from a preamble if needed.
- No bibliography helpers. Use `biblatex` directly (see `course-ml.tex` / math-dm).
- No tcolorbox callouts. Those live in `course-is.tex`.
