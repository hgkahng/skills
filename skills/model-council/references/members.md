# Council members — CLI invocations & notes

Each council member is a locally-installed AI CLI invoked in **non-interactive /
headless mode** so it prints one answer and exits. The roster lives at the top of
[`../scripts/council.sh`](../scripts/council.sh).

## Default roster

| Member   | Binary         | Non-interactive invocation                     | Notes |
|----------|----------------|------------------------------------------------|-------|
| `claude` | `claude`       | `claude -p "PROMPT" --output-format text`      | `-p`/`--print` runs the agent loop once and exits. |
| `codex`  | `codex`        | `codex exec "PROMPT"`                           | `exec` streams progress to stderr, prints the final answer to stdout. |
| `gemini` | `gemini`       | `gemini -p "PROMPT"`                            | `-p`/`--prompt` = headless; add `--yolo` only if you want it to run tools. |
| `cursor` | `cursor-agent` | `cursor-agent -p "PROMPT" --output-format text`| Known bug: `-p` can hang and not exit — the runner force-kills it on timeout. |

## Adding a member

In `scripts/council.sh`:

1. Add its name to `DEFAULT_MEMBERS`.
2. Define `bin_<name>=<executable>` (used for the "is it installed?" check).
3. Define `run_<name>()` — it receives a **prompt-file path as `$1`** and must
   write the model's answer to **stdout**. Read the prompt with `"$(cat "$1")"`
   (argument form) or `< "$1"` (stdin form), whichever the CLI prefers.

Example (OpenCode):

```bash
# in DEFAULT_MEMBERS: (... opencode)
bin_opencode=opencode ; run_opencode() { opencode run "$(cat "$1")"; }
```

## Design notes

- **Isolation:** each member runs in a throwaway `mktemp -d` working directory, so
  a prompt can't accidentally cause edits to your project. Keep prompts to
  *questions*, not agentic tasks.
- **Parallelism & timeouts:** members run concurrently; each is wrapped in
  `timeout -k 10 $COUNCIL_TIMEOUT` (uses `gtimeout` on macOS if present). A member
  that times out shows `[timed out …]` and doesn't block the others.
- **Keep it portable:** invocations should be a single one-shot command. If a CLI
  needs auth/config, set that up once in your shell environment — don't bake keys
  into the script.

## Sources

- Claude Code headless: <https://code.claude.com/docs/en/headless>
- Codex non-interactive (`codex exec`): <https://developers.openai.com/codex/noninteractive>
- Gemini CLI headless: <https://google-gemini.github.io/gemini-cli/docs/cli/headless.html>
- Cursor CLI headless: <https://cursor.com/docs/cli/headless>
