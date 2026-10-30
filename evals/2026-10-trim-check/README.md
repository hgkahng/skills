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

## Merge check: write-ml-code + review-ml-code -> ml-research-code

Old skill vs merged skill, one blind opus judge per prompt (`ml-research-code/`).

| prompt | winner | margin | note |
|---|---|---|---|
| write a fine-tuning script | old | slight | new lacked an `if __name__ == "__main__"` guard |
| write (rerun after adding the guard rule) | old | slight | different details: `drop_last`, resume claims |
| review a buggy loop | old | slight | new overstated a memory issue |
| fix the same loop | new | slight | |

Old 3, new 1, all slight. The merged skill is roughly even with the old pair on
output while removing 830 words of duplication. Two concrete misses led to
rules: the main guard, and pointing writing (not only review) to the checklist.

## Tidy re-test: cut-to-the-chase and plain-english

Old vs tidied text on 4 prompts each from their original evaluations
(`writing-skills/`).

| skill | new wins | old wins | decision |
|---|---|---|---|
| plain-english | 4 (slight) | 0 | keep tidied text |
| cut-to-the-chase | 1 | 3 (two clear) | revert to tested text |

The tidied cut-to-the-chase kept noise in the agent status report and gave a
newcomer too little, the two failure modes the skill exists to prevent. It
was restored to the text measured in `2026-10-cut-to-the-chase/`.
