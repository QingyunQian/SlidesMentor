# SlidesMentor

SlidesMentor is an open skill for turning a research paper, with or without code, into teaching-oriented artifacts and a stronger NotebookLM presentation prompt.

It is built for the common failure case where raw papers produce summary-style slides that are hard to teach from.

## What it does

- extracts one teachable story from a paper
- reframes the paper into lecture structure instead of paper section order
- produces a teaching summary, slide outline, lecture script, and NotebookLM-ready prompt
- separates local artifact quality from actual deck quality after NotebookLM generation

## What it does not do

- it does not automate NotebookLM
- it does not generate `.pptx` or `.pdf`
- it does not guarantee that a good prompt will always produce a good final deck

## Install

### Claude Code

```bash
bash .claude-plugin/install.sh
```

### Codex

```bash
bash .codex-plugin/install.sh
```

## Quick start

Ask your coding agent for something like:

```text
Teach this paper for a grad-intro audience and produce a NotebookLM-ready slide prompt.
Paper: <paper path or URL>
Code: <repo path or none>
```

SlidesMentor will write local run artifacts to `output/`.

## Outputs

- `teaching-summary.md`
- `slide-outline.md`
- `notebooklm-prompt.md`
- `lecture-script.md`
- `qc-report.md`

Curated examples live in [examples/](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/examples). Local run output is intentionally not versioned.

## Repository guide

- [slidesmentor-skill-package/](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/slidesmentor-skill-package) - canonical skill package
- [.claude-plugin/](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/.claude-plugin) - root Claude install entry
- [.codex-plugin/](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/.codex-plugin) - root Codex plugin entry
- [slidesmentor-skill-package/skills/slidesmentor/SKILL.md](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/slidesmentor-skill-package/skills/slidesmentor/SKILL.md) - canonical skill definition
- [slidesmentor-skill-package/examples/](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/slidesmentor-skill-package/examples) - contract fixtures and package examples
- [examples/](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/examples) - user-facing sample outputs

## Current status

SlidesMentor is usable now, but still being tuned against real NotebookLM generations.

The current emphasis is:
- improving prompt quality for NotebookLM Custom Presentations
- keeping the skill installable across clients
- validating generated decks with a downstream review loop instead of over-claiming from local checks

## License

[MIT](/Users/qqy/Desktop/**2026Project**/SlidesMentor/SlidesMentor/LICENSE)
