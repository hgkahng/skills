---
name: python-style
description: "Write or rewrite Python code to match the user's personal coding style preferences. Use this skill whenever the user asks to write, refactor, clean up, or review Python code for style — including requests like 'write this in my style', 'clean this up', 'rewrite this', 'does this match my preferences', or any Python code task where style and idiom matter. Also trigger when the user shares a snippet and asks for feedback on how it could be improved."
---

# Python Style Skill

This skill encodes the user's personal Python style preferences, derived from direct input.
Apply these preferences consistently when writing or rewriting Python code.
When in doubt between two approaches, prefer the one that is more readable at a glance
and requires fewer lines — but never sacrifice clarity for cleverness.

---

## Core Style Preferences

### Iteration
- **Prefer list/dict/set comprehensions** over explicit loops with `.append()`
- Use comprehensions with inline conditions: `[f(x) for x in items if cond(x)]`
- Prefer `[f(x) for x in items]` over `list(map(f, items))` — avoid `map()`/`filter()`
- Exception: use an explicit loop when the body is complex or has side effects

### Unpacking
- Always prefer tuple/iterable unpacking over index access: `a, b = pair` not `pair[0]`
- Use `*rest` unpacking where it clarifies intent

### Control flow
- **Prefer nested `if` over early return** — keep the main logic as the primary branch,
  not tucked after a guard clause
- Use ternary for simple assignments: `x = val if cond else other`
- Avoid ternary when either branch is complex enough to need reading twice

### Dict construction
- Prefer dict comprehensions `{k: v for k, v in ...}` over `dict(zip(...))` for the
  simple single-pass case
- When building a dict across two sequences (nested iteration), use explicit nested
  `for` loops with assignment — a double-`for` comprehension is harder to read

### Imports
- Always use `import module` and qualify names (`np.array`, `nn.Linear`), not `from module import name`
- Standard aliases: `numpy as np`, `torch.nn as nn`, `pandas as pd`, etc. (`import torch` needs no alias)

### Type hints
- Always annotate function signatures: arguments and return type
- Use `Optional[T]` / `T | None` for nullable args; use `list[T]`, `dict[K, V]` (lowercase, Python 3.9+)
- Skip hints for throwaway scripts or one-liners; apply them for any reusable function

### Docstrings
- Short functions: one-line docstring `"""Does X and returns Y."""`
- Longer functions: Google-style docstring with Args / Returns sections if non-obvious
- No redundant docstrings that just restate the function name

### Error handling
- Use `raise ValueError(...)` / `raise TypeError(...)` for invalid inputs in library code
- Use `assert` for internal invariants and debug checks (things that "should never happen")
- Both are context-appropriate — choose based on whether the caller is expected to catch it

### Computed attributes
- Use `@property` for computed attributes that feel like state (no args, cheap to compute)
- Use a regular method (`get_x()`) only when computation is expensive or takes arguments

### Signatures
- Always use explicit, fully typed signatures — avoid `*args`/`**kwargs` except when wrapping another API
- If a function genuinely needs variadic args, type them: `*args: int`, `**kwargs: str`

### Data containers
- Use `@dataclass` for simple data-holding classes
- Use a plain `class` with `__init__` when you need custom logic or inheritance
- Both are acceptable — choose based on complexity

### Classes and functions
- **Prefer methods over standalone functions** — reusable logic belongs inside a class by default
- Only use module-level functions for truly general utilities with no natural class home
- Use `@classmethod` for alternative constructors (`from_file`, `from_dict`, `from_config`, etc.)
- Use `@staticmethod` for pure utilities that relate to the class conceptually but need no instance or class access
- The deciding question: is this creating an instance? → `@classmethod`. Is this a helper that happens to live here? → `@staticmethod`

### File paths
- Use `pathlib.Path` and `/` operator for path construction
- Use `os.path` only when interfacing with legacy APIs that require strings

---

## What "Clean" Means Here

When rewriting or reviewing code, the target is:
- **Short**: remove ceremony, redundant variables, unnecessary intermediate steps
- **Idiomatic**: use the stdlib and Python builtins well; avoid reimplementing what exists
- **Readable**: a competent Python reader should understand each line without a comment
- **No niche dependencies**: if something can be done in a few lines of stdlib, don't add a package

---

## How to Apply This Skill

### Writing new code
1. Follow all preferences above by default
2. If a preference is ambiguous for the situation, choose the more readable option and note it briefly
3. Do not add boilerplate (argparse, logging setup, etc.) unless asked

### Rewriting / refactoring existing code
1. Preserve the logic exactly — only change style, not behavior
2. Note each substantive change made and why (one line per change is enough)
3. Do not introduce new dependencies
4. If the original code has a bug unrelated to style, flag it separately — don't silently fix it

### Reviewing code for style
1. Point out deviations from the preferences above
2. Show the preferred version inline, not just describe it
3. Be specific: "use a comprehension here" + show it, rather than "this could be more Pythonic"
