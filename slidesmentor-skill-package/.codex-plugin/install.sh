#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
CANON_SKILL="$PKG_DIR/skills/slidesmentor/SKILL.md"
CANON_TEMPLATES_DIR="$PKG_DIR/templates"
TARGET_DIR="${1:-${CODEX_HOME:-$HOME/.codex}/skills/slidesmentor}"

mkdir -p "$TARGET_DIR/templates"
cp "$CANON_SKILL" "$TARGET_DIR/SKILL.md"

shopt -s nullglob
for template in "$CANON_TEMPLATES_DIR"/*.md; do
  cp "$template" "$TARGET_DIR/templates/$(basename "$template")"
done

printf 'Synced SlidesMentor canonical package to: %s\n' "$TARGET_DIR"
