# Preamble architecture

Do **not** maintain four full preamble copies. Use a shared spine plus thin
course option files.

## Layout

```tex
% main.tex
\input{path/to/preamble-base.tex}
\input{path/to/course-math-dm.tex}  % or course-ml / course-bp / course-is
% then \title ... \begin{document}
```

## What goes where

**`preamble-base.tex`** — Boadilla 16:9 14pt, ams\*, booktabs, hyperref, mymacro,
xcolor, minted (footnotesize python), theme/innertheme, professionalfonts,
nav symbols off, caption numbered, `\sectionslide`, footline breathing room,
author/institute skeleton.

**`course-math-dm.tex` / `course-ml.tex`** — kotex (+ fonts as needed), bm,
nicematrix, footmisc symbols, biblatex, systeme/pgfplots if needed, math helpers.

**`course-bp.tex`** — almost empty (optional tweaks only).

**`course-is.tex`** — tcolorbox callouts, cool palette, TikZ box/arrow styles,
denser minted.
