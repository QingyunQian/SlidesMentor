# SlidesMentor Skill Package

This directory is the canonical source for SlidesMentor.

If you only want to use the skill, start from the root [README.md](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/README.md). This package README is mainly for contributors and maintainers.

## Contents

- [skills/slidesmentor/SKILL.md](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/slidesmentor-skill-package/skills/slidesmentor/SKILL.md) - canonical skill source
- [templates/](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/slidesmentor-skill-package/templates) - canonical intermediate and final artifact templates
- [.claude-plugin/](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/slidesmentor-skill-package/.claude-plugin) - Claude adapter files
- [.codex-plugin/](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/slidesmentor-skill-package/.codex-plugin) - Codex adapter files
- [examples/](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/slidesmentor-skill-package/examples) - package fixtures
- [docs/deck-review-rubric.md](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/slidesmentor-skill-package/docs/deck-review-rubric.md) - downstream deck review rubric

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

Keep canonical content here first, then sync local installation targets from this package. Do not introduce a second source of truth.
