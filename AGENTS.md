# SlidesMentor Project Notes

This repository now tracks SlidesMentor v2.

The current source of truth is:
- `docs/superpowers/specs/2026-04-01-slidesmentor-v2-design.md` — v2 design specification
- `docs/superpowers/plans/2026-04-01-slidesmentor-v2.md` — v2 implementation plan
- `slidesmentor-skill-package/` — canonical package source
- `.claude/skills/slidesmentor/SKILL.md` — Claude-oriented adapter copy

Important project notes:
- The canonical product is no longer just a `.claude/skills` artifact.
- NotebookLM prompt quality is the main focus of v2.
- Local artifact QC is not the same thing as validating the actual NotebookLM-generated deck.
- If package files and adapter copies differ, prefer the v2 spec and canonical package source.
