# SlidesMentor Skill Package

This directory is the canonical source for SlidesMentor.

If you only want to use the skill, start from the root [README.md](../README.md). This package README is mainly for contributors and maintainers.

## Contents

- [skills/slidesmentor/SKILL.md](skills/slidesmentor/SKILL.md) - canonical skill source
- [templates/](templates) - canonical intermediate and final artifact templates
- [.claude-plugin/](.claude-plugin) - Claude adapter files
- [.codex-plugin/](.codex-plugin) - Codex adapter files
- [examples/](examples) - package fixtures
- [docs/deck-review-rubric.md](docs/deck-review-rubric.md) - downstream deck review rubric

## Adapter install

### Claude Code

```bash
bash slidesmentor-skill-package/.claude-plugin/install.sh
```

### Codex

```bash
bash slidesmentor-skill-package/.codex-plugin/install.sh
```

## Maintainer note

Keep canonical content here first, then sync local installation targets from this package. Adapter install scripts treat target skill directories as generated output and replace target `templates/*.md` files with canonical templates. The root `skills/` directory is a Codex plugin discovery mirror and should be kept in sync with this package.

Verify sync from repository root:

```bash
bash scripts/check-sync.sh
```
