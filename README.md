# SlidesMentor

SlidesMentor is a teaching-oriented paper-to-slides skill package focused on producing better NotebookLM Custom Presentations prompts.

## Why SlidesMentor

Research artifacts are rarely teachable in raw form.
Papers are written for publication. Code is written for execution. Feeding them directly into a slide generator often produces summary-style decks that are dense, weakly structured, and hard to teach from.

SlidesMentor helps extract the actual teaching story, turn it into teaching artifacts, and hand NotebookLM a shorter, higher-signal prompt contract.

## What v2 focuses on

- **Extract** — identify the core teaching story across the paper and codebase
- **Reframe** — convert publication-style exposition into teaching-oriented explanation
- **Prompt** — generate a short NotebookLM prompt with dynamic required coverage and explicit visual style
- **Review** — distinguish local artifact QC from downstream review of the actual generated deck
- **Package** — ship a canonical package layout instead of only a Claude-local skill folder

## Current source of truth

- `docs/superpowers/specs/2026-04-01-slidesmentor-v2-design.md` — v2 design spec
- `docs/superpowers/plans/2026-04-01-slidesmentor-v2.md` — v2 implementation plan
- `slidesmentor-skill-package/` — canonical package source
- `.claude/skills/slidesmentor/SKILL.md` — Claude-oriented adapter copy

The older v1 spec and plan remain in the repo as historical reference.

## Repository layout

- `slidesmentor-skill-package/` — canonical package root
- `slidesmentor-skill-package/skills/slidesmentor/SKILL.md` — canonical skill source
- `slidesmentor-skill-package/templates/` — canonical templates
- `slidesmentor-skill-package/.claude-plugin/` — Claude adapter docs
- `slidesmentor-skill-package/.codex-plugin/` — Codex adapter docs
- `.claude/skills/slidesmentor/` — repo-local Claude-oriented distribution target
- `docs/superpowers/specs/` — design specs
- `docs/superpowers/plans/` — implementation plans

## Validation model

SlidesMentor now separates two kinds of validation:

1. **Artifact QC** — are the local markdown artifacts on contract?
2. **Deck review** — after NotebookLM generates slides, do the actual slides match the teaching goal?

Artifact QC alone does not prove final deck quality.

## How to use

Use SlidesMentor when you want to turn a paper, optionally with its codebase, into teaching-oriented material such as:
- a teaching summary
- a slide outline
- a NotebookLM Custom Presentations prompt
- a lecture script

Typical triggers include:
- "teach this paper"
- "make slides from this paper"
- "prepare a NotebookLM prompt for this paper"

## Roadmap

- validate the v2 prompt contract on real NotebookLM generations
- refine prompt constraints based on observed deck failures
- improve platform adapters and installation story
- explore future automation only after the prompt and review loop are stable
