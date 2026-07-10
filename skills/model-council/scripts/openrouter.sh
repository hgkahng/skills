#!/usr/bin/env bash
# model-council (openrouter backend) — fan one prompt out to any set of models on
# OpenRouter, in parallel, and collect their answers. The CALLING agent
# synthesizes them (see SKILL.md).
#
# Usage:
#   openrouter.sh --models "vendor/model-a,vendor/model-b" "your question"
#   openrouter.sh --models "…" --file prompt.md
#   echo "your question" | openrouter.sh --models "…"
#   openrouter.sh --list-models [filter]     # discover current model slugs
#
# Options:
#   --models a,b,c       Model slugs to consult (or env OPENROUTER_MODELS)
#   --timeout SECS       Per-model timeout (default: $COUNCIL_TIMEOUT or 180)
#   --variants-dir DIR   Per-model prompt variants: DIR/<slug-sanitized>.md
#                        ('/' and ':' become '-', e.g. vendor-model-a.md)
#   --list-models [f]    List available model slugs, optionally filtered
#   -h, --help           Show this help
#
# Env: OPENROUTER_API_KEY (required), OPENROUTER_MODELS (default roster),
#      OPENROUTER_BASE_URL (default https://openrouter.ai/api/v1),
#      COUNCIL_TIMEOUT (seconds), COUNCIL_OUT (dir to save a transcript)

set -uo pipefail

API="${OPENROUTER_BASE_URL:-https://openrouter.ai/api/v1}"
TIMEOUT="${COUNCIL_TIMEOUT:-180}"
SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

# JSON tool: jq preferred, python3 fallback (both build the payload safely —
# never string-interpolate the prompt into JSON by hand).
if   command -v jq      >/dev/null 2>&1; then JSON_TOOL=jq
elif command -v python3 >/dev/null 2>&1; then JSON_TOOL=python3
else echo "openrouter: needs jq or python3 for JSON handling" >&2; exit 4; fi

build_payload() { # $1=model  $2=prompt file  → JSON on stdout
  if [[ "$JSON_TOOL" == jq ]]; then
    jq -n --arg m "$1" --arg p "$(cat "$2")" '{model:$m, messages:[{role:"user", content:$p}]}'
  else
    python3 - "$1" "$2" <<'PY'
import json, sys
print(json.dumps({"model": sys.argv[1],
                  "messages": [{"role": "user", "content": open(sys.argv[2]).read()}]}))
PY
  fi
}

extract_content() { # $1=response JSON file → answer text or "[api error] …"
  if [[ "$JSON_TOOL" == jq ]]; then
    jq -r 'if (.choices[0].message.content // null) != null
           then .choices[0].message.content
           else "[api error] " + ((.error.message // .error // "unrecognized response") | tostring)
           end' "$1" 2>/dev/null || echo "[api error] unparseable response"
  else
    python3 - "$1" <<'PY'
import json, sys
try:
    d = json.load(open(sys.argv[1]))
except Exception as e:
    print(f"[api error] unparseable response: {e}"); raise SystemExit
c = (d.get("choices") or [{}])[0].get("message", {}).get("content")
if c is None:
    err = d.get("error")
    msg = err.get("message") if isinstance(err, dict) else err
    print(f"[api error] {msg or 'unrecognized response'}")
else:
    print(c)
PY
  fi
}

list_models() { # $1=optional filter
  local auth=()
  [[ -n "${OPENROUTER_API_KEY:-}" ]] && auth=(-H "Authorization: Bearer $OPENROUTER_API_KEY")
  local raw
  raw="$(curl -sS --max-time 30 "${auth[@]}" "$API/models")" || { echo "openrouter: model list fetch failed" >&2; exit 5; }
  local ids
  if [[ "$JSON_TOOL" == jq ]]; then ids="$(printf '%s' "$raw" | jq -r '.data[].id')"
  else ids="$(printf '%s' "$raw" | python3 -c 'import json,sys; [print(m["id"]) for m in json.load(sys.stdin)["data"]]')"
  fi
  if [[ -n "${1:-}" ]]; then printf '%s\n' "$ids" | grep -i -- "$1" || true
  else printf '%s\n' "$ids"; fi | sort
}

sanitize() { printf '%s' "$1" | tr '/:' '--'; }

# ------------------------------------------------------------------ parse ---
MODELS_CSV="${OPENROUTER_MODELS:-}"
PROMPT=""
PROMPT_FILE=""
VARIANTS_DIR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --models)       MODELS_CSV="$2"; shift 2 ;;
    --timeout)      TIMEOUT="$2"; shift 2 ;;
    --file)         PROMPT_FILE="$2"; shift 2 ;;
    --variants-dir) VARIANTS_DIR="$2"; shift 2 ;;
    --list-models)  list_models "${2:-}"; exit $? ;;
    -h|--help)      sed -n '/^# Usage:/,/^#      COUNCIL_TIMEOUT/p' "$SELF" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)              PROMPT="${PROMPT:+$PROMPT }$1"; shift ;;
  esac
done

[[ -z "${OPENROUTER_API_KEY:-}" ]] && { echo "openrouter: OPENROUTER_API_KEY not set" >&2; exit 2; }
[[ -z "$MODELS_CSV" ]] && { echo "openrouter: no models — pass --models a,b,c (discover with --list-models). No default roster is baked in; slugs change too often." >&2; exit 2; }
IFS=',' read -r -a MODELS <<< "$MODELS_CSV"

# temp files + single cleanup trap
tmp_prompt=""; workroot=""
cleanup() { [[ -n "$tmp_prompt" ]] && rm -f "$tmp_prompt"; [[ -n "$workroot" ]] && rm -rf "$workroot"; }
trap cleanup EXIT

tmp_prompt="$(mktemp)"
if   [[ -n "$PROMPT_FILE" ]]; then cat "$PROMPT_FILE" > "$tmp_prompt"
elif [[ -n "$PROMPT" ]];      then printf '%s\n' "$PROMPT" > "$tmp_prompt"
elif [[ ! -t 0 ]];            then cat > "$tmp_prompt"
else echo "openrouter: no prompt (pass an arg, --file PATH, or pipe via stdin)" >&2; exit 2
fi

# per-model prompt: variants-dir/<sanitized>.md if present, else shared prompt
prompt_for() {
  local f="$VARIANTS_DIR/$(sanitize "$1").md"
  if [[ -n "$VARIANTS_DIR" && -f "$f" ]]; then printf '%s' "$f"; else printf '%s' "$tmp_prompt"; fi
}

# --------------------------------------------------------------- fan out -----
workroot="$(mktemp -d)"
echo "openrouter: consulting ${MODELS[*]} (timeout ${TIMEOUT}s each)…" >&2
for model in "${MODELS[@]}"; do
  safe="$(sanitize "$model")"
  pf="$(prompt_for "$model")"
  [[ "$pf" != "$tmp_prompt" ]] && echo "openrouter: $model gets variant $pf" >&2
  build_payload "$model" "$pf" > "$workroot/$safe.payload"
  (
    curl -sS --max-time "$TIMEOUT" \
      -H "Authorization: Bearer $OPENROUTER_API_KEY" \
      -H "Content-Type: application/json" \
      -H "X-Title: model-council" \
      -d @"$workroot/$safe.payload" \
      "$API/chat/completions" > "$workroot/$safe.resp" 2> "$workroot/$safe.err"
    echo $? > "$workroot/$safe.rc"
  ) &
done
wait

# --------------------------------------------------------------- collect -----
transcript=""
for model in "${MODELS[@]}"; do
  safe="$(sanitize "$model")"
  rc="$(cat "$workroot/$safe.rc" 2>/dev/null || echo 1)"
  if [[ "$rc" == 28 ]]; then body="[timed out after ${TIMEOUT}s]"
  elif [[ "$rc" != 0 && ! -s "$workroot/$safe.resp" ]]; then
    body="[error rc=$rc] $(tail -n 3 "$workroot/$safe.err" 2>/dev/null)"
  else
    body="$(extract_content "$workroot/$safe.resp")"
    [[ -z "$body" ]] && body="[empty response]"
  fi
  transcript+=$'\n===== '"$model"$' =====\n'"$body"$'\n'
done
printf '%s\n' "$transcript"

# --------------------------------------------------------------- save --------
if [[ -n "${COUNCIL_OUT:-}" ]]; then
  mkdir -p "$COUNCIL_OUT"
  ts="$(date +%Y%m%d-%H%M%S)"
  { echo "# council (openrouter) $ts"; echo; echo "## prompt"; echo; cat "$tmp_prompt"; echo
    if [[ -n "$VARIANTS_DIR" ]]; then
      echo "## variants"; echo
      for model in "${MODELS[@]}"; do
        pf="$(prompt_for "$model")"
        [[ "$pf" == "$tmp_prompt" ]] && pf="(shared prompt)"
        echo "- $model: $pf"
      done; echo
    fi
    echo "## responses"; printf '%s\n' "$transcript"; } > "$COUNCIL_OUT/council-$ts.md"
  echo "openrouter: saved $COUNCIL_OUT/council-$ts.md" >&2
fi
