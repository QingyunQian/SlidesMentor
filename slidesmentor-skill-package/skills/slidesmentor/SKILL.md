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

Normalization contract:
- write `output/session-config.md` before Stage 1.
- normalize `talk_duration_minutes` from `talk_duration_raw`; if parsing fails, use `20`.
- normalize `target_slide_count` in this order:
  - use `slide_count_raw` if explicit and parseable;
  - else compute `round(talk_duration_minutes / 1.5)`.
- clamp `target_slide_count` to `[8, 30]`.
- normalize code mode:
  - if `code_source` is `none`, force `code_preference: no` and `effective_code_mode: paper-only`;
  - if code exists and `code_preference` is explicit, set `effective_code_mode` to that value;
  - if code exists and `code_preference` is `auto-decide`, set `effective_code_mode: auto-pending` and resolve in Stage 2.

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

Mode resolution:
- if `effective_code_mode` is `auto-pending`, choose `yes-supporting` only when code makes method intuition clearer; otherwise choose `no`.
- if fewer than half of Stage 1 teaching-relevant concepts can be mapped to code, mark missing concepts as `[not in repo]` and downgrade to partial coverage behavior.

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

Assume NotebookLM already has the paper as a source and already exposes UI controls for language and presentation length. The prompt should therefore control teaching decisions and evidence usage, not repeat generic paper summary boilerplate or UI-level settings.

Use this shape:
- task sentence
- `Teaching thesis:`
- one-sentence takeaway anchor
- `Build the deck around this story:`
- short narrative (3-4 sentences)
- `Narrative priorities:`
- 3-5 bullets that specify what to foreground, where to spend time, what to treat as the key obstacle or method, and what tone of confidence to keep
- `Required coverage:`
- dynamic paper-specific slide topics, usually 6-10 items and only larger when `target_slide_count` clearly requires it
- `Evidence to show:`
- 2-4 specific figures, diagnostics, tables, or result types from the paper that should anchor the deck
- `Image handling:`
- 3-4 bullets specifying how important paper figures should be recreated and explained
- `Visual style:` bullets

Required visual style bullets:
- white background
- black text
- colorful figures and diagrams where helpful
- clean academic presentation style
- one key idea per slide
- use paper figures or paper-faithful redraws when possible
- prioritize image clarity over ornamental layout

Prompt-writing rules:
- do not use a `Do NOT include:` block unless the user explicitly asks for negative prompt wording
- do not spend prompt budget on generic background that NotebookLM can infer from the paper
- do specify which evidence should be shown, because that is harder for NotebookLM to infer reliably
- do tell NotebookLM to explain what each important figure proves, not just to place it on the slide
- do require high-quality, paper-faithful figure recreation when the original figure quality is not presentation-ready
- do specify the intended confidence level when the paper is proof-of-principle or otherwise limited
- do compress the prompt until removing any more text would weaken story control

## Stage 5 - Artifact QC

Check before presenting local outputs:
- teaching summary is not a rewritten abstract
- every slide has exactly one pedagogical purpose
- NotebookLM prompt is short
- NotebookLM prompt contains a concrete teaching thesis and teaching story
- NotebookLM prompt contains narrative priorities rather than generic summary instructions
- `Required coverage` is paper-specific and count is:
  - 6-10 when `target_slide_count` is 10-16
  - otherwise within +/-30% of `target_slide_count`, clamped to 5-12
- `Evidence to show` names specific paper figures, diagnostics, tables, or result types
- `Image handling` explicitly requires faithful recreation and explanation of important figures
- NotebookLM prompt contains the required visual style bullets

Write `output/qc-report.md`.

## Stage 6 - Deck review

After the user runs NotebookLM, ask them to bring back the generated deck, screenshots, or export for review.

Review for:
- story alignment
- coverage alignment
- no drift into abstract-summary deck structure
- deck spends little time on generic background unless the audience truly needs it
- paper claims are stated with the right level of caution
- white-background academic styling
- low text density where possible
- effective use of figures and diagrams

Without this stage, claim only artifact readiness, not final deck success.
