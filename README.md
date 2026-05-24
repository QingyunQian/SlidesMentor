<p align="center">
  <img src="logo.png" alt="SlidesMentor logo" width="300" />
</p>

<h1 align="center">SlidesMentor</h1>

<p align="center">
  <strong>Turn research papers into teachable slide artifacts and stronger NotebookLM prompts.</strong>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-16a34a" alt="MIT License"></a>
  <img src="https://img.shields.io/badge/status-experimental-f59e0b" alt="Experimental Status">
  <img src="https://img.shields.io/badge/platform-Claude_Code-111827" alt="Claude Code">
  <img src="https://img.shields.io/badge/platform-Codex-2563eb" alt="Codex">
  <img src="https://img.shields.io/badge/output-NotebookLM_Prompt-0f766e" alt="NotebookLM Prompt">
</p>

<p align="center">
  SlidesMentor helps an agent turn a paper and optional codebase into a teaching summary, slide outline, lecture script, and a NotebookLM-ready prompt.
</p>

SlidesMentor is an open skill for a specific workflow: take a paper, find the one story worth teaching, and turn it into artifacts that are actually useful for lecture prep.

The main target is not generic summarization. The main target is better handoff into slide-making workflows, especially NotebookLM Custom Presentations.

## Why this exists

Raw papers are optimized for publication, not teaching. If you paste a paper directly into a slide generator, the result is often predictable:

- too close to the paper section order
- too much abstract-summary language
- weak intuition
- poor slide-level structure

SlidesMentor tries to fix that before the slides are generated.

## What you get

- a `teaching-summary.md` with the core takeaway and explicit teach/skip decisions
- a `slide-outline.md` with one pedagogical purpose per slide
- a `lecture-script.md` written in presentation order instead of paper order
- a `notebooklm-prompt.md` that is short, specific, and slide-oriented
- a `qc-report.md` that checks local artifact quality without over-claiming final deck quality

## Install

Both install scripts sync the canonical package from `slidesmentor-skill-package/` into a platform-specific skill directory.

### Claude Code

```bash
bash .claude-plugin/install.sh
```

Default target: `.claude/skills/slidesmentor/` inside this repository.

This keeps the skill local to the project by default. To install elsewhere:

```bash
bash .claude-plugin/install.sh /path/to/.claude/skills/slidesmentor
```

### Codex

```bash
bash .codex-plugin/install.sh
```

Default target: `${CODEX_HOME:-$HOME/.codex}/skills/slidesmentor/` in your user home directory.

To install elsewhere:

```bash
bash .codex-plugin/install.sh /custom/codex/skills/slidesmentor
```

### Maintainer sync check

If you edit canonical content under `slidesmentor-skill-package/`, keep the root `skills/` mirror in sync:

```bash
bash scripts/check-sync.sh
```

## Quick start

Ask your agent for a task like:

```text
Teach this paper for a grad-intro audience and produce a NotebookLM-ready slide prompt.
Paper: <paper path or URL>
Code: <repo path or none>
```

SlidesMentor writes local run artifacts to `output/`.

## Inputs

SlidesMentor expects a paper plus a small set of session parameters.

Required:

- `Paper`: PDF path, paper URL, or pasted text

Common optional inputs:

- `Code`: repo path, repo URL, or `none`
- `Audience`: `undergrad`, `grad-intro`, `grad-advanced`, or `seminar-mixed`
- `Scenario`: `course lecture`, `group meeting`, `conference tutorial`, or `self-study`
- `Duration`: for example `20 min`
- `Code preference`: `yes-central`, `yes-supporting`, `no`, or `auto-decide`
- `Slide count`: only if you want to override the default duration-based estimate

If you omit most of these, SlidesMentor can still run with defaults. The only true must-have is the paper source.

## How to ask

You do not need a command-line interface or a special form. Just ask your agent in plain language and include the inputs inline.

Minimal example:

```text
Use SlidesMentor for this paper.

Paper: /path/to/paper.pdf
```

Recommended example:

```text
Use SlidesMentor for this paper.

Paper: /path/to/paper.pdf
Code: none
Audience: grad-intro
Scenario: group meeting
Duration: 20 min
Code preference: auto-decide

Please produce:
- teaching summary
- slide outline
- notebooklm prompt
- lecture script
- qc report
```

Example with code:

```text
Use SlidesMentor for this paper.

Paper: https://arxiv.org/abs/xxxx.xxxxx
Code: /path/to/repo
Audience: seminar-mixed
Scenario: course lecture
Duration: 30 min
Code preference: yes-supporting
```

## Workflow

SlidesMentor produces both intermediate artifacts and final outputs.

Intermediate artifacts:

- `output/session-config.md`
- `output/paper-analysis-brief.md`
- `output/code-relevance-map.md` when code is available and relevant
- `output/teaching-reframe.md`

Final outputs:

- `output/teaching-summary.md`
- `output/slide-outline.md`
- `output/notebooklm-prompt.md`
- `output/lecture-script.md`
- `output/qc-report.md`

The intermediate files exist so you can inspect how the teaching story was derived before relying on the final prompt or outline.

## What `qc-report.md` means

`qc-report.md` checks the quality of the local artifacts generated by SlidesMentor. It does not directly score the final slides produced by NotebookLM.

It is meant to answer questions like:

- Is the teaching summary actually a teaching summary, or just a rewritten abstract?
- Does each slide have one clear pedagogical purpose?
- Is the NotebookLM prompt short, specific, and paper-aware?
- Does the lecture script follow the teaching story instead of the paper section order?

It is not meant to answer:

- Are the final NotebookLM slides visually strong?
- Did NotebookLM drift into abstract-summary slides anyway?
- Is the final deck actually good enough to present?

For that second layer, use the downstream rubric in [slidesmentor-skill-package/docs/deck-review-rubric.md](slidesmentor-skill-package/docs/deck-review-rubric.md) after NotebookLM generates a deck.

## Example outputs

Public sample artifacts are in [examples/](examples):

- [notebooklm-prompt.example.md](examples/notebooklm-prompt.example.md)
- [qc-report.example.md](examples/qc-report.example.md)

## Repository layout

- [.claude-plugin/](.claude-plugin) - Claude install entry
- [.codex-plugin/](.codex-plugin) - Codex install entry
- [skills/](skills) - Codex plugin discovery surface
- [slidesmentor-skill-package/](slidesmentor-skill-package) - canonical package source
- [slidesmentor-skill-package/skills/slidesmentor/SKILL.md](slidesmentor-skill-package/skills/slidesmentor/SKILL.md) - canonical skill definition
- [slidesmentor-skill-package/docs/deck-review-rubric.md](slidesmentor-skill-package/docs/deck-review-rubric.md) - downstream deck review rubric

## Scope

SlidesMentor does:

- extract a teaching story from a paper and optional codebase
- reorganize content for teaching rather than publication
- generate markdown artifacts for lecture prep and NotebookLM prompting
- separate artifact QC from downstream review of generated slides

SlidesMentor does not:

- automate NotebookLM
- generate `.pptx` or `.pdf`
- guarantee that a good prompt always yields a good deck

## Project status

SlidesMentor is usable now, but still being tuned against real NotebookLM generations. The current focus is prompt quality, clearer installation, and stronger review of downstream slide quality.

## License

[MIT](LICENSE)
