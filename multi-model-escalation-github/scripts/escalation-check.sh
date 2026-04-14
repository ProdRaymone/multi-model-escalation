#!/usr/bin/env bash
set -euo pipefail

read_input() {
  if [[ "${1:-}" != "" ]]; then
    cat "$1"
  else
    cat
  fi
}

normalize_line() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}

hash_text() {
  if command -v sha1sum >/dev/null 2>&1; then
    printf '%s' "$1" | sha1sum | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    printf '%s' "$1" | shasum | awk '{print $1}'
  else
    printf '%s' "$1" | cksum | awk '{print $1}'
  fi
}

INPUT="$(read_input "${1:-}")"
SESSION_KEY="${ESCALATION_SESSION_KEY:-default}"
STATE_DIR="/tmp/openclaw-escalation-state-${SESSION_KEY}"

mkdir -p "$STATE_DIR"

found=0

emit() {
  found=1
  printf '%s\n' "$1"
}

if grep -qiE '(TOOLS\.md|AGENTS\.md|SOUL\.md|\.learnings/)' <<<"$INPUT"; then
  emit "[escalation] long-lived rule or memory file detected"
fi

if grep -qiE "(i'm not sure|i may be wrong|unclear|needs review|not confident|suspicious)" <<<"$INPUT"; then
  emit "[escalation] explicit uncertainty detected"
fi

if grep -qiE '(delete|overwrite|remove|replace).*(TOOLS\.md|AGENTS\.md|SOUL\.md|automation|rule)' <<<"$INPUT"; then
  emit "[escalation] destructive or hard-to-undo rule change detected"
fi

while IFS= read -r raw_line; do
  normalized="$(normalize_line "$raw_line")"
  [[ -z "$normalized" ]] && continue
  hash="$(hash_text "$normalized")"
  count_file="$STATE_DIR/$hash.count"
  count=0
  if [[ -f "$count_file" ]]; then
    count="$(cat "$count_file")"
  fi
  count=$((count + 1))
  printf '%s' "$count" > "$count_file"
  if [[ "$count" -ge 2 ]]; then
    emit "[escalation] repeated error signature detected ($count x): $normalized"
  fi
done < <(printf '%s\n' "$INPUT" | grep -iE '(429|rate limit|failed|error|exception|invalid slug|unauthorized)' || true)

if [[ "$found" -eq 0 ]]; then
  printf '%s\n' "[escalation] no automatic trigger detected"
fi
