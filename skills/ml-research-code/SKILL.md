---
name: ml-research-code
description: "Write, review, and fix Python code for ML research: training scripts, data pipelines, utility modules, and experiment infrastructure. Use when the user says 'write code for', 'implement', 'code this up', 'build a pipeline', 'review this code', 'check my training loop', 'fix this code', 'what's wrong with this code', 'debug this', or asks to revise code against review feedback. Covers PyTorch, numpy, pandas, scikit-learn, and common ML tooling. Not for judging experiment design or methodology (use ml-research-critique)."
---

# ML Research Code

**ML research code exists to produce results people will trust and build on.** A silent bug can invalidate an experiment, and every unnecessary line is another place for one to hide. So the code should be as small as the task allows, correct in the ways ML code usually goes wrong, and changed only where the user asked.

## Know the intent first

Writing or reviewing against a guess wastes the whole pass. If the task or the code's purpose is unclear, ask. If several approaches exist and the choice changes the deliverable (output format, a dependency, the experiment design), name them and let the user pick; otherwise pick the simpler one and state the tradeoff in one line. For files over about 300 lines, ask which parts matter most, or say which ones you focused on.

## The smallest code that does the job

<!-- Simplicity lines adapted from multica-ai/andrej-karpathy-skills (MIT),
     which distilled them from Andrej Karpathy's observations on LLM coding failures. -->
- Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked, no abstractions for single-use code, no configurability nobody requested, no error handling for impossible cases.
- If it could be meaningfully shorter, make it shorter before presenting it. In a review, show the shorter version.
- Complete and runnable: no stubs or TODOs unless the user asked for a skeleton.
- Stdlib and well-known libraries (torch, numpy, pandas, sklearn, matplotlib) over niche packages.
- Style: comprehensions over append loops, unpacking over indexing, `pathlib` over `os.path`, f-strings, `with` for resources. If the `python-style` skill is available, it is the full reference.

## Correct where ML code usually fails

- **No leakage:** nothing fit on, tuned on, or selected by test data; augmentation on training data only.
- **Reproducible:** seed random, numpy, torch, and cuda, and DataLoader workers. Note that this is reproducible, not deterministic, unless cuDNN determinism is also set.
- **Resumable:** checkpoint model, optimizer, scheduler, step, and the AMP scaler when using mixed precision.
- **Runs everywhere:** put script entry points under `if __name__ == "__main__":`. With `num_workers > 0`, DataLoader workers re-import the module on macOS and Windows, and unguarded top-level code crashes or runs twice.
- **No silent waste:** log scalars with `.item()`; evaluate under `model.eval()` and `torch.inference_mode()`.

When writing or reviewing anything beyond a small snippet, check against [references/ml-checklist.md](references/ml-checklist.md), using judgment about what the code actually does rather than running every item.

## Change only what was asked

<!-- Surgical-change lines adapted from multica-ai/andrej-karpathy-skills (MIT). -->
When fixing code or revising it against feedback, every changed line should trace to the request. Match the existing style. Don't improve adjacent code, refactor what isn't broken, or remove pre-existing dead code; do remove what your own change made unused. Mention unrelated problems separately instead of fixing them. If pieces of feedback conflict with each other or with correctness, say so rather than silently picking one.

## Be honest about certainty

State a bug as certain only when you traced it concretely or reproduced it; otherwise call it "likely" and say what would confirm it. When an environment exists, check your own code with an import or a one-batch dry run, and run a minimal repro for a critical suspected bug. If you couldn't run anything, say so.

## What to hand back

- **Writing:** for more than about 50 lines, a 2 to 4 line plan first. Then the code, then only what isn't obvious from it: design choices, assumptions that might not hold, settings the user must fill in.
- **Reviewing:** line-referenced comments (`# Line 23: Bug — gradients not zeroed before backward`), then a summary grouped as Bugs (critical first), Overcomplication, Performance, and Style, each item with a concrete rewrite. Say so when the code is good; don't invent issues.
- **Fixing:** what was wrong, what the fix does, and how to verify it.
