#!/usr/bin/env bash
# Install every skill in ./skills into each agent's skills directory as a symlink.
# Because they're symlinks back to this repo, editing a skill here updates it for
# Claude Code, Codex, Cursor, and Hermes at once; `git pull` re-syncs everything.
#
# Usage:
#   bin/sync.sh            # symlink all skills into every target dir
#   bin/sync.sh --list     # show what would be linked, and current state
#   bin/sync.sh --copy     # copy instead of symlink (for agents that don't follow links)

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO/skills"

# Target skills directories per agent. ~/.agents/skills is the shared convention
# read by BOTH Codex and Cursor, so it covers two agents in one link.
TARGETS=(
  "$HOME/.claude/skills"   # Claude Code
  "$HOME/.agents/skills"   # Codex + Cursor (shared)
  "$HOME/.hermes/skills"   # Hermes
)

MODE="link"
[[ "${1:-}" == "--copy" ]] && MODE="copy"
[[ "${1:-}" == "--list" ]] && MODE="list"

count=0
for target in "${TARGETS[@]}"; do
  [[ "$MODE" != "list" ]] && mkdir -p "$target"
  for skill in "$SRC"/*/; do
    [[ -f "$skill/SKILL.md" ]] || continue
    src="${skill%/}"
    name="$(basename "$src")"
    dest="$target/$name"

    if [[ "$MODE" == "list" ]]; then
      state="missing"
      [[ -L "$dest" ]] && state="symlink -> $(readlink "$dest")"
      [[ -e "$dest" && ! -L "$dest" ]] && state="EXISTS (not a symlink)"
      printf '  %-40s %s\n' "$dest" "$state"
      continue
    fi

    if [[ -e "$dest" && ! -L "$dest" ]]; then
      echo "skip: $dest exists and is not a symlink" >&2
      continue
    fi

    if [[ "$MODE" == "copy" ]]; then
      rm -rf "$dest"; cp -R "$src" "$dest"
    else
      ln -sfn "$src" "$dest"
    fi
    count=$((count + 1))
  done
done

[[ "$MODE" == "list" ]] || echo "synced $count skill link(s) across ${#TARGETS[@]} agent dir(s)."
