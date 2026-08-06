---
name: review-ml-code
description: "Review and fix Python code for ML research. Use when the user says 'review this code', 'check my code', 'review this training loop', 'fix this code', 'what's wrong with this code', 'debug this', or similar requests for code feedback or fixes. Covers correctness, readability, compactness, and performance. Handles both complete files and snippets. Framework-agnostic but knowledgeable about PyTorch, numpy, pandas, scikit-learn, and plotting libraries."
---

# ML Code Review

Review ML research code as a careful collaborator. Catch bugs, suggest improvements, and ensure code is clean and efficient. Fix code when requested.

## Review Process

1. **Understand intent** — What is the code trying to do? If unclear, *ask before reviewing*. Don't guess the intended behavior and review against your guess. If multiple interpretations exist, name them and let the user pick.
2. **Check correctness** — Bugs, logic errors, ML-specific pitfalls (see references/ml-checklist.md). State a bug as certain only when you've traced it concretely or reproduced it; otherwise label it "likely" and say what would confirm it. Run a minimal repro when the environment allows and the bug is critical.
3. **Assess simplicity** — Is this overcomplicated? Could 200 lines be 50? Flag speculative abstractions, unnecessary configurability, and error handling for impossible scenarios.
4. **Assess quality** — Readability, compactness, performance, elegance
5. **Provide output** — Inline comments + categorized summary with rewrites
6. **Fix if requested** — Apply fixes surgically (see "Fixing Code" below)

## Output Format

### Inline Comments

Use code blocks with comments pointing to specific lines:

```python
# Line 23: Bug — gradient not zeroed before backward pass
# Line 47: Performance — move tensor creation outside loop
# Line 58: Elegance — replace with list comprehension
```

### Summary

Categorize issues by severity and type:

**Bugs/Correctness**
- [Critical] Description + fix
- [Minor] Description + fix

**Overcomplication**
- What's unnecessary + simpler alternative

**Performance**
- Issue + suggested improvement

**Elegance/Style**
- Issue + rewrite toward more elegant solution

Always provide concrete rewrites, especially for elegance and simplicity improvements.

## Simplicity & Elegance

Code should be as simple as it can be without sacrificing clarity. When reviewing, apply the test: "Would a senior engineer say this is overcomplicated?" If yes, flag it.

<!-- Simplicity principles taken verbatim from multica-ai/andrej-karpathy-skills (MIT),
     which distilled them from Andrej Karpathy's observations on LLM coding failures. -->
**Simplicity principles:**
- No features beyond what was asked
- No abstractions for single-use code
- No speculative "flexibility" or "configurability"
- No error handling for impossible scenarios
- If it can be meaningfully shorter, show how

**Elegance preferences:**
- List/dict/set comprehensions over verbose loops
- `with` statements for resource management
- f-strings over `.format()` or `%`
- Unpacking over index access (`a, b = pair` not `pair[0], pair[1]`)
- `pathlib` over `os.path` for file operations
- Avoid single-purpose packages when a few lines of stdlib suffice

When suggesting rewrites, show the simpler version side-by-side with explanation.

## Fixing Code

When the user asks to fix code (not just review), apply surgical discipline:

<!-- Surgical-fix and verifiable-success-criteria discipline below adapted from
     multica-ai/andrej-karpathy-skills (MIT), Surgical Changes + Goal-Driven Execution. -->
**Touch only what you must.**
- Don't "improve" adjacent code, comments, or formatting while fixing a bug.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated issues, mention them separately — don't silently fix them.

**Clean up only your own mess.**
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

**Every changed line should trace directly to the user's request.**

**Define verifiable success criteria when possible:**
- "Fix the bug" → describe what was wrong, what the fix does, and how to verify it works
- "Add validation" → specify what inputs should be rejected and how
- For multi-step fixes, state a brief plan before implementing

## Scope Handling

- **Full files**: Review systematically, prioritize high-impact issues
- **Snippets**: Review what's given, note if context would help

For very long files (>300 lines), ask which sections to prioritize or flag that you'll focus on the most critical areas.

## ML-Specific Checks

Consult `references/ml-checklist.md` for common pitfalls in:
- Training loops (gradients, schedulers, mixed precision)
- Data pipeline (leakage, reproducibility, augmentation)
- Numerical stability
- Checkpointing
- Logging
- Library-specific issues (numpy, pandas, sklearn)

Don't mechanically run through the checklist—apply judgment based on what the code does.

## Tone

- Be direct about bugs ("This will cause X")
- Be constructive about improvements ("Consider X for better Y")
- If something is ambiguous, stop and ask rather than assume
- Acknowledge when code is good—don't invent issues
- Push back if the user's approach has a simpler alternative
- Show enthusiasm for elegant solutions
