# Trim check: tikz-figure and critique-ml-research (2026-10)

Question: did cutting general knowledge make the output worse?
tikz-figure 2,553 -> 818 words; critique-ml-research 1,107 -> 500 words.

Six prompts, one reply each from the old and new skill (sonnet). One blind opus
judge per prompt saw both replies as A/B in random order (`order.json`, mapping
in `key.json`) plus the rendered figures; all six TikZ replies compiled.

| prompt | winner | margin |
|---|---|---|
| T1 transformer encoder figure | new | clear |
| T2 RAG pipeline slide | old | slight |
| T3 loss curves with annotation | new | slight |
| C1 LoRA result, one seed | new | slight |
| C2 contrastive pretraining design | old | slight |
| C3 best-of-20 vs default AdamW | new | slight |

New 4, old 2; no clear loss. T2's loss traced to a dropped detail: arrows from
a source column should enter the processor at matching heights, not one point.
That rule was restored in one line. One sample per cell, one judge: a smoke
check, not proof.
