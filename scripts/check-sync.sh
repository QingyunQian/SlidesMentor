#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

CANON_SKILL="$REPO_ROOT/slidesmentor-skill-package/skills/slidesmentor/SKILL.md"
MIRROR_SKILL="$REPO_ROOT/skills/slidesmentor/SKILL.md"
CANON_TEMPLATES="$REPO_ROOT/slidesmentor-skill-package/templates"
MIRROR_TEMPLATES="$REPO_ROOT/skills/slidesmentor/templates"
PLUGIN_JSON="$REPO_ROOT/.codex-plugin/plugin.json"

SHELL_SCRIPTS=(
  "$REPO_ROOT/scripts/check-sync.sh"
  "$REPO_ROOT/.claude-plugin/install.sh"
  "$REPO_ROOT/.codex-plugin/install.sh"
  "$REPO_ROOT/slidesmentor-skill-package/.claude-plugin/install.sh"
  "$REPO_ROOT/slidesmentor-skill-package/.codex-plugin/install.sh"
)

INSTALLERS=(
  "$REPO_ROOT/.claude-plugin/install.sh"
  "$REPO_ROOT/.codex-plugin/install.sh"
  "$REPO_ROOT/slidesmentor-skill-package/.claude-plugin/install.sh"
  "$REPO_ROOT/slidesmentor-skill-package/.codex-plugin/install.sh"
)

failures=0
TMP_DIR=""

cleanup() {
  if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT

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

check_template_dir() {
  local left="$1"
  local right="$2"
  local label="$3"

  if ! diff -qr "$left" "$right" >/dev/null 2>&1; then
    printf 'FAIL %s\n' "$label"
    diff -qr "$left" "$right" || true
    failures=$((failures + 1))
  else
    printf 'OK   %s\n' "$label"
  fi
}

check_command() {
  local label="$1"
  shift

  if "$@" >/dev/null 2>&1; then
    printf 'OK   %s\n' "$label"
  else
    printf 'FAIL %s\n' "$label"
    "$@" || true
    failures=$((failures + 1))
  fi
}

check_installer() {
  local installer="$1"
  local label="$2"
  local target="$TMP_DIR/$label"

  mkdir -p "$target/templates"
  printf 'stale\n' > "$target/templates/stale-template.md"

  if bash "$installer" "$target" >/dev/null; then
    check_same "$CANON_SKILL" "$target/SKILL.md" "$label SKILL.md"
    check_template_dir "$CANON_TEMPLATES" "$target/templates" "$label templates/"
  else
    printf 'FAIL %s install\n' "$label"
    bash "$installer" "$target" || true
    failures=$((failures + 1))
  fi
}

printf 'Checking SlidesMentor canonical/mirror sync...\n'

check_same "$CANON_SKILL" "$MIRROR_SKILL" "SKILL.md"
check_template_dir "$CANON_TEMPLATES" "$MIRROR_TEMPLATES" "templates/"

printf '\nChecking script syntax...\n'
for script in "${SHELL_SCRIPTS[@]}"; do
  check_command "bash -n ${script#$REPO_ROOT/}" bash -n "$script"
done

printf '\nChecking plugin metadata...\n'
check_command ".codex-plugin/plugin.json" python3 -m json.tool "$PLUGIN_JSON"

printf '\nChecking adapter installers...\n'
TMP_DIR="$(mktemp -d)"
installer_index=0
for installer in "${INSTALLERS[@]}"; do
  installer_index=$((installer_index + 1))
  check_installer "$installer" "install-$installer_index"
done

if [ "$failures" -gt 0 ]; then
  printf '\nRepository check failed with %s issue(s).\n' "$failures"
  exit 1
fi

printf '\nRepository check passed.\n'
