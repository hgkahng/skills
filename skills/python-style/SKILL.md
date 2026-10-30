---
name: python-style
description: "Write or rewrite Python code to match the user's personal coding style preferences. Use this skill whenever the user asks to write, refactor, clean up, or review Python code for style — including requests like 'write this in my style', 'clean this up', 'rewrite this', 'does this match my preferences', or any Python code task where style and idiom matter. Also trigger when the user shares a snippet and asks for feedback on how it could be improved."
---

# Python Style

The user's own Python preferences. The aim is code a competent reader understands line by line without comments, in as few lines as clarity allows. Never trade clarity for cleverness. When a preference doesn't settle a case, choose the more readable option and say so briefly.

## Readable at a glance

- **Comprehensions** (list, dict, set, with inline `if`) over `.append()` loops, and over `map()`/`filter()`. Use an explicit loop when the body is complex or has side effects.
- **Dicts:** a comprehension for a simple single pass, preferred over `dict(zip(...))`. When building across two sequences, use explicit nested `for` loops with assignment rather than a double-`for` comprehension.
- **Unpacking** over indexing: `a, b = pair`, not `pair[0]`; `*rest` where it clarifies intent.
- **Nested `if` over early return:** keep the main logic as the primary branch, not after a guard clause.
- **Ternary** only for simple assignments; if either branch needs a second read, use a full `if`.
- **Paths:** `pathlib.Path` with `/`; `os.path` only for legacy APIs that need strings.
- **Short and idiomatic:** no ceremony or needless intermediate variables; use builtins and the stdlib rather than reimplementing them or adding a niche package for a few lines.

## Where every name and type comes from is visible

- **Imports:** `import module` and qualified names (`np.array`, `nn.Linear`), never `from module import name`. Aliases: `numpy as np`, `torch.nn as nn`, `pandas as pd`; plain `import torch`.
- **Signatures:** annotate every argument and return type of any reusable function, with `T | None` (or `Optional[T]`) and lowercase generics (`list[T]`, `dict[K, V]`). Avoid `*args`/`**kwargs` except when wrapping another API, and type them if needed (`*args: int`). Throwaway scripts and one-liners can skip hints.
- **Docstrings:** one line for short functions (`"""Does X and returns Y."""`); Google style with Args/Returns for longer ones when something is non-obvious; none that only restate the name.

## Logic lives with its data

- **Methods over standalone functions** by default. Module-level functions only for truly general utilities with no natural class home.
- **`@classmethod`** for alternative constructors (`from_file`, `from_dict`, `from_config`); **`@staticmethod`** for helpers that belong to the class conceptually but need neither instance nor class. Deciding question: is it creating an instance?
- **`@property`** for cheap, argument-free values that feel like state; a regular method when the computation is expensive or takes arguments.
- **`@dataclass`** for simple data holders; a plain class with `__init__` when it needs custom logic or inheritance.
- **Errors:** `raise ValueError`/`TypeError` for invalid input in library code the caller may catch; `assert` for internal invariants that should never fail.

## Applying it

- **Writing:** follow all of the above; add no boilerplate (argparse, logging setup) unless asked.
- **Rewriting:** change style only and keep behavior exactly; add no dependencies; list each substantive change in one line. Flag an unrelated bug separately instead of fixing it.
- **Reviewing:** name each deviation and show the preferred version inline ("use a comprehension here" plus the code), not "this could be more Pythonic".
