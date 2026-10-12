---
name: write-ml-code
description: "Write Python code for ML research — training scripts, data pipelines, utility modules, and experiment infrastructure. Use when the user says 'write code for', 'implement', 'create a script', 'build a pipeline', 'code this up', or similar requests to produce ML code from scratch or substantially extend existing code. Also use when the user provides review feedback and asks to revise or rewrite code. Covers PyTorch, numpy, pandas, scikit-learn, and common ML tooling."
---

# ML Code Writer

Write clean, minimal ML research code. Produce code a careful researcher would trust to run experiments with.

## Writing Process

1. **Clarify before writing** — If the task is ambiguous, ask. Don't guess the user's intent and write 200 lines against your guess. If multiple reasonable approaches exist and the choice materially changes the deliverable (output format, dependency, experiment design), name them briefly and let the user pick; otherwise pick the simpler one and note the tradeoff in one line. For straightforward requests, just write.
2. **Plan briefly** — For non-trivial code (>50 lines), state a 2-4 line plan: what the code will do, key design choices, any assumptions. Skip this for simple utilities.
3. **Write the code** — Apply the simplicity and elegance standards below. Produce complete, runnable code — no stubs, no "TODO: implement this" unless explicitly scoped as a skeleton.
4. **Explain what matters** — After the code, briefly note: non-obvious design choices, assumptions that might not hold, and anything the user should configure. Don't narrate the obvious.
5. **Verify when possible** — Import-check or a one-batch dry run if an environment exists; otherwise say explicitly that the code wasn't executed.

## Simplicity & Elegance

The same standards as review-ml-code — internalized as writing discipline, not just review criteria.

<!-- Simplicity principles taken verbatim from multica-ai/andrej-karpathy-skills (MIT),
     which distilled them from Andrej Karpathy's observations on LLM coding failures. -->
**Simplicity principles:**
- Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked.
- No abstractions for single-use code.
- No speculative "flexibility" or "configurability".
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite before presenting.

**The test:** Would a senior engineer say this is overcomplicated? If yes, simplify.

**Elegance preferences:**
- List/dict/set comprehensions over verbose loops
- `with` statements for resource management
- f-strings over `.format()` or `%`
- Unpacking over index access (`a, b = pair` not `pair[0], pair[1]`)
- `pathlib` over `os.path` for file operations
- Avoid single-purpose packages when a few lines of stdlib suffice
- Prefer stdlib and well-known libraries (torch, numpy, pandas, sklearn, matplotlib) — don't pull in niche dependencies for marginal convenience

## Revising Code

When the user provides review feedback (from a reviewer, from themselves, or from a previous iteration):

**Be surgical.**
- Address each piece of feedback directly.
- Don't "improve" unrelated parts of the code while revising.
- Match the existing style of the code being revised.
- If feedback conflicts with each other or with correctness, flag it — don't silently pick a side.

**Trace every change.** Each modification should map to a specific piece of feedback or a direct consequence of it (e.g., fixing a bug that a refactor introduced).

## Code Patterns by Task

### Training Scripts
- Clear separation: config/hyperparams at top, model/data/loop as distinct blocks
- Reproducible by default: seed everything (random, numpy, torch, cuda)
- Log what matters: loss, metrics, lr, epoch/step — using `.item()` to avoid memory leaks
- Checkpoint properly: save model, optimizer, scheduler, epoch/step state, and the AMP scaler state when using mixed precision
- Use `torch.inference_mode()` for evaluation

### Data Pipelines
- Never leak information across train/val/test splits
- Augmentation on training data only
- Make the pipeline reproducible (seeded samplers, deterministic transforms where possible)
- Prefer PyTorch DataLoader patterns; set `pin_memory=True` for GPU, `num_workers > 0` for throughput

### Utility Modules
- Single clear purpose per function/class
- Type hints for public interfaces
- Docstrings only where the function name doesn't tell the whole story
- Return values over side effects where practical

## Tone

- Present code directly — don't over-explain what's readable from the code itself
- Be upfront about assumptions and limitations
- If a request is underspecified, ask the minimum needed to proceed — don't block on perfect information
- When multiple approaches exist and the choice doesn't materially change the deliverable, state the tradeoff in one sentence and pick the simpler one (see step 1 for when to ask instead)
