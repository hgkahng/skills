# Compile and Verify

**Hard requirement:** compile and visually inspect before handing slides back.

| Scope | Verify |
|---|---|
| Full deck / multi-frame create | Compile; render and inspect **all** new/changed pages (full deck: all pages) |
| Single-frame edit | Target frame + one neighbor each side |

## 1. Course-dependent compile

| Course | Engine / command |
|---|---|
| math-dm / ML / Korean (`kotex`, CJK fonts) | `xelatex -shell-escape` (or `latexmk -pdfxe -shell-escape`) |
| BP / IS (no kotex) | `pdflatex -shell-escape` unless the course notes say otherwise |
| Bibliography | `biber` when biblatex is loaded |

Always `-interaction=nonstopmode` (or latexmk equivalent). `minted` needs `-shell-escape`.

Run from the deck directory so `images/`, data paths, and `reference.bib` resolve.

## 2. PDF → PNG

Prefer whatever is installed:

```bash
# pdftocairo (if available)
pdftocairo -png -r 150 -f N -l N main.pdf page

# Ghostscript fallback
gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -r160 \
  -dFirstPage=N -dLastPage=N \
  -sOutputFile=page-%02d.png main.pdf
```

### Slow builds

With many TikZ/pgfplots figures, cache each as a PDF so only changed figures
recompile. Add `\usetikzlibrary{external}` and `\tikzexternalize[prefix=figures-ext/]`
to the preamble, create the `figures-ext/` folder, and compile with `-shell-escape`
(already required for `minted`). If a package breaks externalization (e.g. `pdfpages`):
`\tikzexternalize[prefix=figures-ext/, optimize command away=\includepdf]`.

## 3. Inspection checklist

On each PNG, check:

1. Vertical overflow / content under the footer
2. Widow words (1–3 words alone on a line) — rewrite
3. Code overflow (minted)
4. Figure clipping; incomplete tip labels (missing `)`) → often need `clip=false`
5. Labels overlapping arrowheads or axes
6. Plot dominating sparse text (or starved text column)
7. Wrong emphasis color (red `\alert{}` used as default)
8. Math errors (`??`, broken delimiters)
9. Definition/theorem boxes between bullets: left edge flush with **bullet text**, not dots or frame margin (see `frame-patterns.md`)

**Inspect the image yourself.** Do not claim done from TeX alone. Whitespace alone is not a defect.

## 4. On failure

Fix source → recompile → re-screenshot → re-inspect. Iterate until clean.

## 5. What not to do

- Skip compile because “the LaTeX looks right”
- Compile without rendering pages
- Delegate verification to the user
