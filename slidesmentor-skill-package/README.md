# SlidesMentor Skill Package

SlidesMentor is a teaching-oriented paper-to-slides skill package focused on producing stronger NotebookLM Custom Presentations prompts.

## What this package contains

- `skills/slidesmentor/SKILL.md` — canonical SlidesMentor skill source
- `templates/` — canonical markdown templates
- `.claude-plugin/` — Claude-oriented adapter files
- `.codex-plugin/` — Codex-oriented adapter files
- `docs/` — supporting docs, including downstream deck review guidance
- `examples/` — example prompt artifacts and contract fixtures

## Design goals

SlidesMentor v2 focuses on:
- extracting a teaching story from a paper,
- generating a short, high-signal NotebookLM prompt,
- preserving explicit visual-style constraints,
- and separating local artifact QC from actual NotebookLM deck review.

## Source of truth

This package is the canonical source for SlidesMentor v2.

Repo-local layouts such as `.claude/skills/slidesmentor/` are distribution targets or adapters, not the conceptual source of truth.

## Platform adapters

### Claude Code
Use the files in `.claude-plugin/` to mirror or install the canonical skill into a Claude-compatible layout.

### Codex
Use the files in `.codex-plugin/` to mirror or install the canonical skill into a Codex-compatible layout.

## Validation model

SlidesMentor validates two different things:
1. **Artifact QC** — are the local markdown outputs coherent and on-contract?
2. **Deck review** — after NotebookLM generates slides, do the actual slides match the teaching goal?

Artifact QC alone does not prove deck quality.
