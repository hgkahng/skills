#!/usr/bin/env bash
# model-council — fan one prompt out to several AI CLIs in parallel and collect
# their independent answers. The CALLING agent synthesizes them (see SKILL.md).
#
# Usage:
#   council.sh "your question"
#   council.sh --file prompt.md
#   echo "your question" | council.sh
#
# Options:
#   --members a,b,c   Only use these members (default: all detected)
#   --exclude a,b     Skip these members
#   --timeout SECS    Per-member timeout (default: $COUNCIL_TIMEOUT or 180)
#   --list            List configured members and whether each is installed
#   -h, --help        Show this header
#
# Env: COUNCIL_TIMEOUT (seconds), COUNCIL_OUT (dir to save a transcript)

set -uo pipefail

# ----------------------------------------------------------------- roster ---
# To add a member: append its name to DEFAULT_MEMBERS, then define bin_<name>
# (the executable, used for the installed-check) and run_<name>() (takes a
# prompt-file path as $1 and writes the model's answer to stdout).
# See references/members.md.
DEFAULT_MEMBERS=(claude codex cursor)

bin_claude=claude        ; run_claude() { claude -p "$(cat "$1")" --output-format text; }
bin_codex=codex          ; run_codex()  { codex exec "$(cat "$1")"; }
bin_cursor=cursor-agent  ; run_cursor() { cursor-agent -p "$(cat "$1")" --output-format text; }

# Available but OFF by default — add its name to DEFAULT_MEMBERS above to enable:
bin_gemini=gemini        ; run_gemini() { gemini -p "$(cat "$1")"; }
# ----------------------------------------------------------------------------

TIMEOUT="${COUNCIL_TIMEOUT:-180}"

binary_for() { local v="bin_$1"; printf '%s' "${!v:-}"; }
available()  { command -v "$(binary_for "$1")" >/dev/null 2>&1; }

# Internal re-entry: run ONE member in an isolated temp dir. Invoked via timeout
# so a hung/slow CLI can be killed as a real process (functions can't be timed
# out directly).
if [[ "${1:-}" == "__run" ]]; then
  member="$2"; promptfile="$3"
  workdir="$(mktemp -d)"; trap 'rm -rf "$workdir"' EXIT
  cd "$workdir" || exit 1
  "run_$member" "$promptfile"
  exit $?
fi

# Absolute path to this script, for the self re-invocation above.
SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

# Pick a timeout binary (GNU coreutils on Linux, gtimeout via brew on macOS).
TIMEOUT_BIN=""
if command -v timeout  >/dev/null 2>&1; then TIMEOUT_BIN="timeout"
elif command -v gtimeout >/dev/null 2>&1; then TIMEOUT_BIN="gtimeout"; fi

# ------------------------------------------------------------------ parse ---
MEMBERS=("${DEFAULT_MEMBERS[@]}")
EXCLUDE=()
PROMPT=""
PROMPT_FILE=""
LIST=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --members) IFS=',' read -r -a MEMBERS <<< "$2"; shift 2 ;;
    --exclude) IFS=',' read -r -a EXCLUDE <<< "$2"; shift 2 ;;
    --timeout) TIMEOUT="$2"; shift 2 ;;
    --file)    PROMPT_FILE="$2"; shift 2 ;;
    --list)    LIST=1; shift ;;
    -h|--help) sed -n '2,20p' "$SELF"; exit 0 ;;
    *)         PROMPT="${PROMPT:+$PROMPT }$1"; shift ;;
  esac
done

if [[ "$LIST" == 1 ]]; then
  for m in "${MEMBERS[@]}"; do
    if available "$m"; then echo "✓ $m ($(binary_for "$m"))"
    else echo "✗ $m ($(binary_for "$m")) — not installed"; fi
  done
  exit 0
fi

# temp files + single cleanup trap
tmp_prompt=""; workroot=""
cleanup() { [[ -n "$tmp_prompt" ]] && rm -f "$tmp_prompt"; [[ -n "$workroot" ]] && rm -rf "$workroot"; }
trap cleanup EXIT

# ------------------------------------------------------------------ prompt ---
tmp_prompt="$(mktemp)"
if   [[ -n "$PROMPT_FILE" ]]; then cat "$PROMPT_FILE" > "$tmp_prompt"
elif [[ -n "$PROMPT" ]];      then printf '%s\n' "$PROMPT" > "$tmp_prompt"
elif [[ ! -t 0 ]];            then cat > "$tmp_prompt"
else echo "council.sh: no prompt (pass an arg, --file PATH, or pipe via stdin)" >&2; exit 2
fi

# filter roster to available, non-excluded members
roster=()
for m in "${MEMBERS[@]}"; do
  skip=0
  for x in "${EXCLUDE[@]:-}"; do [[ "$m" == "$x" ]] && skip=1; done
  [[ "$skip" == 1 ]] && continue
  if available "$m"; then roster+=("$m"); else echo "council: skipping $m (not installed)" >&2; fi
done
[[ ${#roster[@]} -eq 0 ]] && { echo "council: no available members" >&2; exit 3; }
[[ -z "$TIMEOUT_BIN" ]] && echo "council: no 'timeout' binary found — running without per-member timeouts" >&2

# --------------------------------------------------------------- fan out -----
workroot="$(mktemp -d)"
echo "council: consulting ${roster[*]} (timeout ${TIMEOUT}s each)…" >&2
for m in "${roster[@]}"; do
  (
    if [[ -n "$TIMEOUT_BIN" ]]; then
      "$TIMEOUT_BIN" -k 10 "$TIMEOUT" "$SELF" __run "$m" "$tmp_prompt" >"$workroot/$m.out" 2>"$workroot/$m.err"
    else
      "$SELF" __run "$m" "$tmp_prompt" >"$workroot/$m.out" 2>"$workroot/$m.err"
    fi
    echo $? > "$workroot/$m.rc"
  ) &
done
wait

# --------------------------------------------------------------- collect -----
transcript=""
for m in "${roster[@]}"; do
  rc="$(cat "$workroot/$m.rc" 2>/dev/null || echo 1)"
  body="$(cat "$workroot/$m.out" 2>/dev/null)"
  if   [[ "$rc" == 124 ]]; then body="[timed out after ${TIMEOUT}s]"
  elif [[ -z "$body" && "$rc" != 0 ]]; then body="[error rc=$rc] $(tail -n 3 "$workroot/$m.err" 2>/dev/null)"; fi
  transcript+=$'\n===== '"$m"$' =====\n'"$body"$'\n'
done
printf '%s\n' "$transcript"

# --------------------------------------------------------------- save --------
if [[ -n "${COUNCIL_OUT:-}" ]]; then
  mkdir -p "$COUNCIL_OUT"
  ts="$(date +%Y%m%d-%H%M%S)"
  { echo "# council $ts"; echo; echo "## prompt"; echo; cat "$tmp_prompt"; echo;
    echo "## responses"; printf '%s\n' "$transcript"; } > "$COUNCIL_OUT/council-$ts.md"
  echo "council: saved $COUNCIL_OUT/council-$ts.md" >&2
fi
