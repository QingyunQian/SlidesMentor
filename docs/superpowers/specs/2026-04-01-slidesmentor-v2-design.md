# SlidesMentor v2 Design Spec

## Meta

This document defines the v2 redesign of SlidesMentor.

v1 proved that the upstream pedagogy workflow is useful: paper analysis, teaching reframe, slide outline, and lecture script are all stronger than raw paper summarization. The main weakness is the final handoff to NotebookLM. The current prompt artifact is still too scaffold-like, so NotebookLM can collapse back into abstract-summary slides. The project also currently feels Claude Code-specific because the repository only ships a `.claude/skills` layout rather than a canonical cross-platform package.

v2 therefore has two goals:
1. improve the NotebookLM prompt contract;
2. package SlidesMentor as a reusable skill package with platform adapters.

---

## Product definition

SlidesMentor is a teaching-oriented paper-to-slides skill package.

Its value is not just “a Claude skill that runs.” Its value is:
- extracting the teaching story from a paper,
- turning that story into strong teaching artifacts,
- producing a NotebookLM Custom Presentations prompt that better steers deck generation,
- and making the package installable beyond one client-specific layout.

SlidesMentor still does **not**:
- automate NotebookLM itself,
- generate final `.pptx` or `.pdf` files,
- guarantee that local artifact quality automatically implies final deck quality.

---

## What changes from v1

### Keep from v1
Preserve these strengths from the existing workflow:
- Stage 1 paper understanding
- Stage 3 teaching reframe
- slide-by-slide outline generation
- lecture script generation
- explicit teaching-priority rules

### Change for v2
The major redesign is at the NotebookLM handoff and packaging layers:
- the NotebookLM prompt becomes shorter and more command-style;
- audience and duration remain optional short steering constraints rather than mandatory boilerplate;
- `Required coverage:` becomes the core structural control surface;
- slide coverage items are generated dynamically from the paper;
- visual style becomes an explicit hard requirement;
- a very short negative-constraint block remains, because removing it completely makes summary-like slides more likely;
- QC is split into local artifact QC and downstream deck review;
- the repo gains a canonical `slidesmentor-skill-package/` distribution root.

---

## NotebookLM prompt contract

### Principles
The v2 NotebookLM prompt should be:
- short;
- direct;
- easy to paste into NotebookLM Custom Presentations;
- focused on deck shape and slide behavior, not workflow exposition.

### Required structure
The prompt should follow this shape:

```md
Create a teaching-oriented slide deck for this paper.

Audience: [optional short line]
Duration: [optional short line]

Build the deck around this teaching story:
[3-5 sentence narrative]

Required coverage:
1. [paper-specific topic]
2. [paper-specific topic]
...

Visual style:
- white background
- black text
- colorful figures and diagrams where helpful
- clean academic presentation style
- one key idea per slide

Do NOT include:
- [2-4 short guardrails]
```

### Audience and duration handling
NotebookLM already exposes language and presentation-length controls in its UI, so the skill should not treat those as the primary contract surface.

However, short audience and duration lines may still be included when they provide useful steering. They should stay concise and optional.

### Required coverage behavior
`Required coverage:` is the main structural lever in v2.

Rules:
- coverage items must be specific to the paper;
- they must not be generic placeholders like “method” or “results” without context;
- default target is 8–12 items;
- when `target_slide_count` strongly suggests otherwise, coverage may scale accordingly;
- coverage should reflect the teaching story, not the paper’s section order.

### Visual style requirements
These style constraints are mandatory in v2:
- white background
- black text
- colorful figures and diagrams where helpful
- clean academic presentation style
- one key idea per slide

### Negative constraints
The prompt should retain a very small `Do NOT include:` block.

This block exists to prevent common failure modes, not to become a second specification.

Default guardrails should stay short and high-signal, for example:
- no long paragraphs
- do not restate the abstract as slides
- no more than one core idea per slide
- avoid dense equations unless essential

---

## Workflow updates

### Upstream workflow
Keep the current paper-analysis and teaching-reframe workflow. Those stages remain valuable because they produce the story that powers the final NotebookLM prompt.

### Stage 4 artifact generation
Stage 4 should still generate:
- `output/teaching-summary.md`
- `output/slide-outline.md`
- `output/notebooklm-prompt.md`
- `output/lecture-script.md`

But the NotebookLM prompt artifact must now be explicitly defined as a short prompt for NotebookLM Custom Presentations.

### Quality-control split
v1 Stage 5 mixes together internal artifact checks and implied confidence about downstream deck quality. v2 must separate them.

#### Artifact QC
Artifact QC validates the local outputs only.

Checks should include:
- teaching summary is not just a rewritten abstract;
- slide outline has one pedagogical purpose per slide;
- NotebookLM prompt is short;
- NotebookLM prompt contains a concrete teaching story;
- NotebookLM prompt contains dynamic paper-specific required coverage;
- NotebookLM prompt contains mandatory visual style bullets;
- NotebookLM prompt contains only a very short negative-constraint block.

#### Deck review
Deck review happens only after the user runs NotebookLM.

SlidesMentor should explicitly ask the user to bring back the generated deck, screenshots, or export for review.

Suggested review rubric:
- the generated deck follows the intended teaching story;
- required coverage appears in recognizable form;
- the deck does not drift into abstract-summary structure;
- slides follow the intended visual style;
- slides are not text-heavy;
- evidence/figures are used where they materially help teaching.

Without this downstream review, SlidesMentor should claim only artifact readiness, not deck success.

---

## Packaging model

### Canonical source
v2 should define `slidesmentor-skill-package/` as the canonical source root.

That package should contain:
- the canonical SlidesMentor skill source;
- canonical templates;
- package README and install docs;
- platform-specific wrappers/adapters.

### Platform adapters
The repo should add:
- `.claude-plugin/` package adapter
- `.codex-plugin/` package adapter

The goal is not to claim identical behavior across every tool immediately. The goal is to stop framing the project as if `.claude/skills` were the only real form.

---

## Repository communication changes

README and AGENTS should be updated to describe:
- the v2 product definition;
- the package-vs-adapter architecture;
- the distinction between artifact QC and final deck review;
- the fact that SlidesMentor helps produce better NotebookLM inputs, but final deck quality still needs downstream evaluation.

---

## Acceptance criteria for v2

### Prompt quality
- NotebookLM prompt is shorter than the v1 style scaffold.
- Prompt includes optional short audience/duration lines, not heavy boilerplate.
- Prompt includes dynamic paper-specific required coverage.
- Coverage defaults to 8–12 items but may adapt to `target_slide_count`.
- Prompt includes mandatory white-background / black-text / colorful-visual style constraints.
- Prompt retains a short `Do NOT include:` block with 2–4 items.

### Workflow quality
- Skill instructions clearly distinguish artifact QC from downstream deck review.
- The repository no longer implies that local artifact checks alone prove notebook deck quality.

### Packaging quality
- Canonical package directory exists.
- Claude and Codex adapters exist.
- Install/docs story no longer reads as Claude-only.
