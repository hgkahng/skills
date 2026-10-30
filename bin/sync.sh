#!/usr/bin/env bash
# Install every skill in ./skills into each agent's skills directory as a symlink.
# Because they're symlinks back to this repo, editing a skill here updates it for
# Claude Code, Codex, Cursor, and Hermes at once. After a `git pull`, run it again
# to link new skills and remove links to skills that were renamed or deleted.
#
# Usage:
#   bin/sync.sh            # symlink all skills into every target dir, prune broken links
#   bin/sync.sh --list     # show what would be linked or removed, and current state
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

# Remove links left behind by skills that were renamed or deleted here. Only
# links that point into this repo's skills/ and no longer resolve are touched;
# links to anything else are left alone. (--copy installs are real folders, so
# they are never removed automatically.)
pruned=0
for target in "${TARGETS[@]}"; do
  [[ -d "$target" ]] || continue
  for dest in "$target"/*; do
    [[ -L "$dest" && ! -e "$dest" ]] || continue
    [[ "$(readlink "$dest")" == "$SRC/"* ]] || continue
    if [[ "$MODE" == "list" ]]; then
      printf '  %-40s %s\n' "$dest" "broken (would be removed)"
    else
      rm "$dest"; pruned=$((pruned + 1))
    fi
  done
done

[[ "$MODE" == "list" ]] || echo "synced $count skill link(s) across ${#TARGETS[@]} agent dir(s); removed $pruned broken link(s)."
