# Frame Patterns

The conventions below are extracted from the user's lecture decks and are
mandatory unless the user asks otherwise. Every pattern has a copy-paste
example.

**Columns:** text + illustrating figure → asymmetric (e.g. `.575 / .375`);
peer panels (definition vs picture) → equal `0.5 / 0.5`. Prefer named frames;
`allowframebreaks` only for long worked examples that must stay one unit.
See the main `SKILL.md` layout section and `figure-style.md`.

## 1. Frame separator comments

Every `\begin{frame}` is preceded and followed by a comment line. Makes
scanning a long `.tex` file far easier.

```latex
%---------------------------------------------------------
\begin{frame}{Frame Title}
    % content
\end{frame}
%---------------------------------------------------------
```

## 2. Itemize defaults

Always declare `\setlength\itemsep{.5em}` on every itemize/enumerate. Two
calibrations:

- `\setlength\itemsep{.5em}` for normal bullet lists (default).
- `\setlength\itemsep{1em}` for sparse big-idea lists (2-3 high-level points).

```latex
\begin{itemize}\setlength\itemsep{.5em}
    \item First point
    \item Second point
\end{itemize}
```

For sub-bullets that should not shrink (Beamer shrinks nested itemize by
default), use the `\circ` list trick:

```latex
\begin{list}{$\circ$}{}
    \item sub-bullet at full font size
\end{list}
```

### Blocks inside itemize (`definition` / `theorem` / `example`)

When a Beamer block sits between bullets, its **left edge must match the start
of the bullet text** (first glyph of the sentence), **not** the blue dots and
**not** the full frame margin.

Naive `\hspace*{…}` outside the list (including large guesses like `3cm`, or
a bare `\leftmargini` with a detached minipage) drifts left/right across themes
and looks “skewed.” Prefer nesting the block in the list:

```latex
\begin{itemize}\setlength\itemsep{.5em}
    \item Intuition sentence that sets up the formal box.
    \item[]
      \vspace{-0.6em}%
      % \item[] starts in the label column; nudge to the text column.
      \hspace*{0.2cm}%
      \begin{minipage}{\dimexpr\linewidth-0.2cm\relax}
        \setlength{\textwidth}{\linewidth}%
        \begin{definition}[Name]
            Formal statement…
        \end{definition}
      \end{minipage}
    \item Follow-up example or consequence.
\end{itemize}
```

Rules:

1. Target = **bullet text column**, not bullet markers.
2. Keep the block inside one `itemize` via `\item[]` + `minipage` +
   `\setlength{\textwidth}{\linewidth}` so the box respects list width.
3. The `0.2cm` nudge is calibrated for the `circles` inner theme; after any theme
   or margin change, **compile → PNG → measure** (box left vs first text glyph).
   Adjust the nudge until they coincide (about ≤2–3px at 200dpi). Do not claim
   alignment from TeX alone.
4. Do not “fix” misalignment with large ad-hoc `\hspace*` values.

## 3. Section dividers via `\sectionslide`

Use `\sectionslide{Title}{Subtitle}` for section breaks when the course
preamble defines it (`preamble-base.tex` includes it; add it locally if a
deck's preamble lacks it).

```latex
\sectionslide{The \texttt{print} Function}{Syntax, Separators, and Escape Sequences}
```

Liberal use is encouraged. Even a 6-slide section benefits from a divider in
front, since it gives the audience (and the speaker) a moment to breathe.

## 4. Code blocks: vertical spacing around `pythoncode`

ALWAYS put `\vspace{.3em}` both BEFORE AND AFTER a `pythoncode` block when
it sits between text. The minted block already has its own visible frame
(`frame=single, framesep=2mm`), so additional vertical space outside it is
mostly redundant; `.3em` gives just enough separation to keep the boundary
visible without isolating the code from the surrounding prose. Earlier
versions of this skill used `.5em`, which read as disconnected. Do not go
above `.3em`.

```latex
\begin{itemize}\setlength\itemsep{.5em}
    \item The \mintinline{python}{print} function displays output.
    \item Basic syntax:
\end{itemize}
\vspace{.3em}
\begin{pythoncode}
    print(value1, value2, ..., sep=' ', end='\n')
\end{pythoncode}
\vspace{.3em}
\begin{itemize}\setlength\itemsep{.5em}
    \item \mintinline{python}{sep}: separator between values.
\end{itemize}
```

Skip the `\vspace` entirely only when the `pythoncode` block is the only
content on the frame (or follows a `\framebreak` and IS the frame).

The frame must be `[fragile]` (or `[fragile,allowframebreaks]`) for `minted`
to compile.

## 5. Inline code references: `\mintinline`

Use `\mintinline{python}{...}` for inline references to Python identifiers,
keywords, and small expressions. Prefer it over `\texttt{}` for code.

```latex
The \mintinline{python}{print} function takes \mintinline{python}{sep=' '}
as a keyword argument.
```

The frame must be `[fragile]`.

For shell, paths, file names, or non-code monospace, use `\texttt{}` instead.

## 6. Two-column layouts

Choose by role (see main `SKILL.md`):

- **Text + illustrating figure/code:** asymmetric minipages (e.g. `.575 / .375`)
- **Peer panels** (definition vs picture, equation vs matching plot): equal
  `0.5 / 0.5` adjacent minipages (or `columns` + `onlytextwidth`). Do **not**
  put `\hfill` between two half-width boxes (creates a center gap).

Asymmetric example:

```latex
\begin{minipage}{.575\textwidth}
    \begin{figure}
        \centering
        % figure; adjustbox only if overflow risk — see figure-style.md
    \end{figure}
\end{minipage}%
\begin{minipage}{.375\textwidth}
    \begin{itemize}\setlength\itemsep{1em}
        \item \( \hat{\beta}_0 = 7.032 \)
        \item \( \hat{\beta}_1 = 0.047 \)
    \end{itemize}
\end{minipage}
```

Peer-panel example:

```latex
\begin{minipage}[c]{0.5\textwidth}
\centering
% left claim
\end{minipage}%
\begin{minipage}[c]{0.5\textwidth}
\centering
% right peer visual
\end{minipage}
```

**Hard rule: never put a `pythoncode` (or any `minted`) block inside
`\begin{columns}`.** The minted block ignores the column width and overflows
horizontally. Use minipages instead.

Use `\begin{columns}` only when both sides are short text or simple inline
math.

## 7. Worked-example walks

Prefer **named frames** for teaching beats. Use
`[fragile,allowframebreaks]` only when a long worked example must stay one
conceptual unit and would otherwise overflow.

For a worked example, walk setup → code → plot → interpretation across
pages (named frames, or `allowframebreaks` + `\framebreak` when justified):

```latex
\begin{frame}[fragile,allowframebreaks]{Example: Predicting Sales}
    \begin{itemize}\setlength\itemsep{.5em}
        \item Predict \texttt{Sales} ($y$) from \texttt{TV} ($x$).
        \item We want to estimate $\beta_0$ and $\beta_1$.
    \end{itemize}

    \framebreak
    \begin{pythoncode}
        from sklearn.linear_model import LinearRegression
        model = LinearRegression().fit(X, y)
    \end{pythoncode}

    \framebreak
    % figure with fitted line
    \begin{minipage}{.575\textwidth}
        \begin{figure} ... \end{figure}
    \end{minipage}%
    \begin{minipage}{.375\textwidth}
        \begin{itemize}\setlength\itemsep{1em}
            \item $\hat\beta_0 = 7.032$
            \item $\hat\beta_1 = 0.047$
        \end{itemize}
    \end{minipage}

    \framebreak
    \begin{itemize}\setlength\itemsep{.5em}
        \item Estimated: $\texttt{Sales} \approx 7.032 + 0.047 \times \texttt{TV}$.
        \item What if we spend nothing? \$200{,}000? An extra \$1{,}000?
    \end{itemize}
\end{frame}
```

**Caveat about `[allowframebreaks]` and code blocks.** Beamer will not split
a `minted` / `pythoncode` block across pages. If the bullets above the code
do not fit on the same page as the entire code block, Beamer breaks BEFORE
the code, leaving the bullets alone on a sparse page with wasted whitespace.

When this happens, prefer two explicit `\begin{frame}` / `\end{frame}` blocks
(titled `... (cont.)` for the second) over `[allowframebreaks]` with
`\framebreak`. You get full control over what lives on each page:

```latex
\begin{frame}[fragile]{Example: 5-Fold CV}
    \emph{Setup sentence here.}    % one tight intro line, not bullets
    \vspace{.5em}
    \begin{pythoncode} ... \end{pythoncode}
\end{frame}

\begin{frame}{Example: 5-Fold CV (cont.)}
    % table + interpretation
\end{frame}
```

Reserve bare `[allowframebreaks]` auto-break for text-only frames (long
itemize, derivations, reference lists) where Beamer's behavior is benign.

## 8. Callout boxes (IS-style, with `course-is.tex`)

Three boxes, each with a left rule and tinted fill. Use them for first-class
visual punctuation:

```latex
\begin{findcallout}
    \small \textbf{Finding.} Recall@k plateaus around k=10 in our setup.
\end{findcallout}

\begin{takeaway}
    \small \textbf{Next week:} Prompting techniques. Once we have the right
    evidence, how do we instruct the model to use it well?
\end{takeaway}

\begin{riskcallout}
    \small \textbf{Pitfall.} Naive chunking by character count can split mid-sentence.
\end{riskcallout}
```

Conventional placement: a `\vspace{-.5em}` before a callout to pull it closer
to preceding content, and `\vfill` after if it should sit at the bottom of
the frame.

These boxes require `course-is.tex` . Do NOT use them
in math-dm / ML / BP decks unless the user explicitly opts in.

## 9. Emphasis: cool blue, not red

The user's emphasis color is blue, NOT Beamer's default red `\alert{}`. With
`course-is.tex`, `\alert` is already rebound to the cool accent so it is
safe to use.

For the other preambles, use one of:

```latex
\textbf{\textcolor{blue}{key term}}        % bold + blue, the most common pattern
\highlight[blue]{\beta_0 + \beta_1 x}      % rounded blue tint around math
\highlight[white]{\beta_0 + \beta_1 x}     % invisible placeholder; later
                                           % overlays can swap in a real
                                           % highlight without layout shift
```

Reserve `\alert{}` (still red on ML/BP) for genuine warnings: "do NOT do X",
"common error", etc. At most one or two emphasis marks per frame.

## 10. Math annotations: `\underbrace` + `\highlight`

For equations where one term has a name worth pointing at:

```latex
y = \underbrace{\highlight[blue]{\beta_0 + \beta_1 x}}_{=h(x)} + \varepsilon
```

The `\underbrace` says "this is named", the `\highlight` says "look here". For
a richer caption (e.g. "an error function") use `\highlightcap` from
`macros.md`.

## 11. Footnotes: symbol style (ML preamble)

`course-ml.tex` and `course-math-dm.tex` use `\fnsymbol` footnotes (asterisk, dagger, etc.) instead
of numbers. This pairs better with subscript-heavy math. Use them sparingly
for asides:

```latex
$\beta_0$ and $\beta_1$ are the parameters\footnote{weights, regression
coefficients, ...} of the model.
```

## 12. Background → intuition opener (MANDATORY at deck/section start)

Good lecture material starts with **background** (why this matters / what
came before), then **intuition** of the concept, and only then formal
definitions and mechanics.

For every full deck and every multi-frame topic, the first content frame(s)
right after `\maketitle` establish that arc:

1. **Background** — context, motivation, or a short bridge from prior weeks
2. **Intuition** — the conceptual picture (image, analogy, tiny example, or
   “two views” contrast) the audience must hold

This is not an agenda list and not a dump of definitions. Formalism follows
once the intuition is in place.

Often one frame can carry both (background bullets + one anchoring visual).
If background needs room, use two short frames: context, then mental model.

Example for a linear regression deck:

```latex
%---------------------------------------------------------
\begin{frame}{Why a Line?}
    \begin{itemize}\setlength\itemsep{1em}
        \item We have data on \textbf{\textcolor{blue}{income}} ($x$) and
              \textbf{\textcolor{blue}{happiness}} ($y$) for many people.
        \item We believe there is some underlying line that explains the
              relationship between them.
        \item Our job: \emph{guess the line} from the data we have.
    \end{itemize}
    \vspace{1em}
    % a scatter plot with a hypothetical line, drawn faintly
\end{frame}
%---------------------------------------------------------
```

Example for an agentic AI deck:

```latex
\begin{frame}{The Mental Model}
    \begin{itemize}\setlength\itemsep{1em}
        \item An \textbf{agent} is a loop: it \emph{thinks}, then \emph{acts},
              then \emph{observes} what changed in the world.
        \item Everything we build today is a variation on this loop.
    \end{itemize}
    \vspace{1em}
    % a tiny TikZ diagram: Thought -> Action -> Observation -> back to Thought
\end{frame}
```

If a deck has multiple major sections (delimited by `\sectionslide`), open
each section with background + intuition too, but it can be shorter (a single
bullet plus visual).

## 13. Conclusion summary slide (MANDATORY at deck end)

Every deck ends with a conclusion frame that tells the main story of the
deck. NOT a generic "thank you", NOT a bullet-by-bullet recap of every slide.
Instead, the 2-4 take-home points that the audience should remember tomorrow.

For IS decks, use a `takeaway` callout:

```latex
%---------------------------------------------------------
\begin{frame}{Conclusion}
    \begin{itemize}\setlength\itemsep{1em}
        \item Chunking is the unsung hero of RAG; bad chunks cap downstream quality.
        \item Semantic chunking respects meaning; fixed-size chunking respects compute.
        \item Measure with Recall@$k$ and context relevance, not vibes.
    \end{itemize}
    \vspace{.8em}
    \begin{takeaway}
        \small \textbf{Next week:} Prompting techniques. Once we have the right
        evidence, how do we instruct the model to use it well?
    \end{takeaway}
\end{frame}
%---------------------------------------------------------
```

For ML/BP decks (no `takeaway` environment available), a plain itemize frame
titled "Conclusion" works:

```latex
\begin{frame}{Conclusion}
    \begin{itemize}\setlength\itemsep{1em}
        \item Linear regression is the simplest possible model of a real-valued
              target: a line plus noise.
        \item We estimate the line by minimizing squared residuals.
        \item The recipe extends naturally to many features ($p > 1$).
    \end{itemize}
\end{frame}
```

After the conclusion frame, an optional plain closing frame ("Thank you") is
fine but not required.

## 14. Overflow prevention

Beamer 14pt 16:9 frames fit roughly 6-7 bullet points or 14-16 lines of code.
The overflow modes below all happen in practice; check for each before
finalizing a frame.

### 14.1. Vertical bullet overflow

- 6 or fewer top-level items: safe.
- 7-8 items: try splitting first; if you cannot, add a comment
  `% OVERFLOW WARNING: verify after compile`.
- 9+ items, or mixed itemize + equation + figure: split into `(1/2)` and
  `(2/2)` frames.

Never stack `itemize` + block quote + equation + figure in the same frame.

**Element budget for mixed-content frames.** Each major element (figure,
diagram, code block, table, equation block, callout box) costs roughly 4-5
bullets worth of vertical space. A frame with one major element fits at
most 3 bullets above or beside it, and one short closing line. A frame
with two major elements (figure + table, code + diagram) fits at most one
intro line and one closing line, no bullet list. If the frame has three
or more major elements, split it.

Common overflow patterns from past iterations:

- Three bullets + figure + closing bullet -> the closing bullet drops below
  the frame edge. Fix: drop the closing bullet, or merge bullets to two.
- Two bullets + diagram + callout box -> the callout box gets clipped.
  Fix: shorten the bullets to one line each, or move the callout to a
  separate frame.
- One bullet + 14-line code + table + interpretation bullets -> code or
  table or bullets get clipped. Fix: split into two frames as documented
  in section 7.

### 14.2. Code block overflow

A standalone `pythoncode` block fits about 14-16 lines at `\footnotesize`, or
20-22 at `\scriptsize` (IS preamble). Shared with text on the same frame, the
budget drops to 7-8 lines.

If a code listing exceeds the budget:
- Split into a `\framebreak` walk (text -> code -> output).
- Or show the key excerpt on one frame and a continuation `(cont'd)` on the
  next.
- Never use `\tiny` or shrink below `\scriptsize` to fit code.

### 14.3. Figure overflow

- Default `width=.75\textwidth` for full-width figures, `width=.45\textwidth`
  inside a two-column layout.
- Cap figure size to the companion panel; use `adjustbox` only if overflow
  risk (see `figure-style.md`).
- Cap pgfplots `height` at about `5.5cm` standalone, `4.5cm` when sharing the
  frame — then stop; do not escalate to fill whitespace.

### 14.4. Table overflow

- Prefer `tabularx` with `X` columns for tables spanning the text width.
- Last resort: wrap in `\resizebox{\textwidth}{!}{...}`.
- Tables with more than 6 columns or 12 rows should be split.

### 14.5. Widow words (read this carefully)

A "widow" is a single word that wraps to its own line, leaving most of that
line blank. It looks unprofessional and wastes vertical space. The user has
specifically flagged this as a recurring problem.

When a bullet wraps and leaves only 1-3 short words dangling on the last
line, the rule is: **make it longer (so the trailing line is at least half
full) OR make it shorter (so it fits on one fewer line entirely)**. Never
leave the widow.

**Worked examples.**

*Bad (single-word widow):*

```latex
\item The error term \(\varepsilon\) represents unpredictable factors
      affecting the response.
```
Wraps as: "The error term ε represents unpredictable factors affecting / the
response." -- the second line has only two words.

*Fix A, longer (fills the trailing line):*

```latex
\item The error term \(\varepsilon \sim \mathcal{N}(0, \sigma^2)\) represents
      unpredictable factors affecting the response, such as measurement noise
      or omitted variables.
```

*Fix B, shorter (one clean line):*

```latex
\item The error term \(\varepsilon\) captures all unmodeled noise.
```

**Widow fixes can introduce new widows.** Lengthening a bullet by a single
clause sometimes wraps to put a new lonely word at the bottom; shortening
sometimes leaves a 2-word continuation. After every widow fix, recompile
and re-check the same bullet. Iterate if needed; do not stop after one
attempt.

**Widows in callout boxes count too.** A `takeaway` / `findcallout` /
`riskcallout` whose closing word lands alone on the last line is still a
widow. Rewrite for fit.

**Watch the entire deck, not just bullets.** Centered captions, footnotes,
italics setup lines, and conclusion summaries all widow.

### 14.6. Bottom-margin discipline

Each preamble adds `\addtobeamertemplate{footline}{\vskip3ex}{}`, which
gives the footer bar a small built-in buffer above it. That helps, but it
is not a license to push content right up against the bar. Beamer's
default navigation symbols sit at the bottom-right corner of the footline
area; when a long closing line reaches the right margin, it visually
overlaps those symbols.

The discipline: the last visible content of a frame should sit at least
one short line of breathing room above the footer bar. If the closing
line stretches across the full width AND lands within ~1em of the bar,
either shorten it or split the frame.

## 15. What not to do

See **Do not** in `SKILL.md`; it is the canonical list.
