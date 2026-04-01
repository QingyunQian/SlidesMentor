---
name: slidesmentor
description: Use when converting a research paper into teaching-oriented lecture material or a NotebookLM Custom Presentations prompt, especially when you need a short high-signal prompt rather than a long summary-style instruction block.
---

# SlidesMentor

Turn a research paper, and optionally its codebase, into teaching-oriented markdown artifacts and a stronger NotebookLM prompt.

## Boundaries

- Produce markdown artifacts only.
- Prefer pedagogy over paper section order.
- Use the paper as the source of truth.
- Use code only when it improves teaching clarity.
- Do not automate NotebookLM.
- Do not claim notebook deck success from local artifact checks alone.
- Treat every file in `templates/` as a read-only schema reference.

## Stage 0 - Intake

Ask one question at a time until `paper_source` is known and the remaining fields are either known, implied, or defaulted.

Possible fields:
- `audience_level`
- `scenario`
- `talk_duration_raw`
- `code_preference`
- `paper_source`
- `code_source`
- `slide_count_raw`

Rules:
- `paper_source` is required.
- `audience_level` and `talk_duration_raw` may be carried into the final NotebookLM prompt only as optional short steering lines.
- Do not make language control the responsibility of this skill.
- Do not make NotebookLM UI settings the center of the prompt contract.

## Stage 1 - Understand the paper

Read the paper and identify:
- research question
- motivation
- core claim
- method
- setup
- results
- limitations

Then:
- produce `output/paper-analysis-brief.md`
- choose exactly one core takeaway sentence
- decide what to teach, what to support briefly, and what to skip

## Stage 2 - Inspect the code

Skip this stage if `code_source` is `none`.

When code exists:
- read README first
- read entry points before deeper files
- map teaching-relevant concepts from Stage 1 to the codebase
- stop once the teaching-relevant mapping is clear

Produce `output/code-relevance-map.md`.

## Stage 3 - Reframe for teaching

Produce `output/teaching-reframe.md` with these headings:
- `Hook`
- `Problem Framing`
- `Method Intuition`
- `Method Mechanics`
- `Evidence and Results`
- `Limits and Open Questions`
- `Takeaway`

Rules:
- prefer pedagogy over publication order
- convert contribution framing into a teachable story
- reduce density
- calibrate detail to the audience

## Stage 4 - Produce artifacts

Write these outputs under `output/`:
- `teaching-summary.md`
- `slide-outline.md`
- `notebooklm-prompt.md`
- `lecture-script.md`

### NotebookLM prompt contract

The prompt for NotebookLM Custom Presentations must be short and high-signal.

Use this shape:
- task sentence
- optional short `Audience:` line
- optional short `Duration:` line
- `Build the deck around this teaching story:`
- short narrative (3-5 sentences)
- `Required coverage:`
- dynamic paper-specific slide topics, usually 8-12 items but allowed to scale with `target_slide_count`
- `Visual style:` bullets
- `Do NOT include:` with only 2-4 short high-value guardrails

Required visual style bullets:
- white background
- black text
- colorful figures and diagrams where helpful
- clean academic presentation style
- one key idea per slide

Default negative constraints should stay short, for example:
- no long paragraphs
- do not restate the abstract as slides
- no more than one core idea per slide
- avoid dense equations unless essential

## Stage 5 - Artifact QC

Check before presenting local outputs:
- teaching summary is not a rewritten abstract
- every slide has exactly one pedagogical purpose
- NotebookLM prompt is short
- NotebookLM prompt contains a concrete teaching story
- `Required coverage` is paper-specific and usually 8-12 items unless scaled by `target_slide_count`
- NotebookLM prompt contains the required visual style bullets
- NotebookLM prompt contains only a very short negative-constraint block

Write `output/qc-report.md`.

## Stage 6 - Deck review

After the user runs NotebookLM, ask them to bring back the generated deck, screenshots, or export for review.

Review for:
- story alignment
- coverage alignment
- no drift into abstract-summary deck structure
- white-background academic styling
- low text density where possible
- effective use of figures and diagrams

Without this stage, claim only artifact readiness, not final deck success.
