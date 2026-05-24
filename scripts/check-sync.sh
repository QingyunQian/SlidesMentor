#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

CANON_SKILL="$REPO_ROOT/slidesmentor-skill-package/skills/slidesmentor/SKILL.md"
MIRROR_SKILL="$REPO_ROOT/skills/slidesmentor/SKILL.md"
CANON_TEMPLATES="$REPO_ROOT/slidesmentor-skill-package/templates"
MIRROR_TEMPLATES="$REPO_ROOT/skills/slidesmentor/templates"

failures=0

check_same() {
  local left="$1"
  local right="$2"
  local label="$3"

  if diff -q "$left" "$right" >/dev/null 2>&1; then
    printf 'OK   %s\n' "$label"
  else
    printf 'FAIL %s\n' "$label"
    diff -u "$left" "$right" || true
    failures=$((failures + 1))
  fi
}

printf 'Checking SlidesMentor canonical/mirror sync...\n'

check_same "$CANON_SKILL" "$MIRROR_SKILL" "SKILL.md"

if ! diff -qr "$CANON_TEMPLATES" "$MIRROR_TEMPLATES" >/dev/null 2>&1; then
  printf 'FAIL templates/\n'
  diff -qr "$CANON_TEMPLATES" "$MIRROR_TEMPLATES" || true
  failures=$((failures + 1))
else
  printf 'OK   templates/\n'
fi

if [ "$failures" -gt 0 ]; then
  printf '\nSync check failed with %s issue(s).\n' "$failures"
  exit 1
fi

printf '\nSync check passed.\n'
