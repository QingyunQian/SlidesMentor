---
name: slidesmentor
description: >-
  Use when converting a research paper (with or without code) into
  teaching-oriented lecture material, slide outlines, or NotebookLM prompts.
  Use when the user mentions "make slides from a paper", "teach this paper",
  "lecture prep", or "NotebookLM prompt".
---

# SlidesMentor

Transform a research paper, and optionally its codebase, into teaching-oriented artifacts.

This skill extracts the teachable story, uses code as support when available, rewrites publication-style exposition into teaching flow, and produces fixed markdown artifacts plus a NotebookLM-ready prompt.

Do not use this skill to automate NotebookLM, generate final slide files, perform MCP orchestration, or guarantee code reproducibility.

## Boundaries

- Produce markdown artifacts only.
- Prefer pedagogy over paper section order.
- Use the paper as the source of truth; use code only to support teaching decisions.
- Stop when the paper source is missing or unusable.

## Stage 0 - Intake

Ask one question at a time until `paper_source` is known and each remaining field is either user-specified or resolved to a default:
- `audience_level`
- `scenario`
- `talk_duration_raw`
- `code_preference`
- `paper_source`
- `code_source`

Defaults:
- `audience_level = grad-intro`
- `scenario = group meeting`
- `talk_duration_raw = 20 min / ~15 slides`
- `code_preference = auto-decide`
- `code_source = none`

Rules:
- If `paper_source` is missing, stop and ask for it.
- Accept `paper_source` as file path, URL, or pasted text.
- Accept `code_source` as repo path, URL, or `none`.
- Keep intake to one question at a time.
- For each non-paper field, ask only if the user has not already implied it. If the user leaves it unspecified, apply the default, record it, and continue.
- Treat `templates/session-config.md` as a reference schema. Produce a session config output that follows that schema; do not overwrite the template file itself.

## Workflow

### Stage 1 - Understand the paper

Read the paper and identify:
- research question
- motivation
- core claim
- method
- setup
- results
- limitations

Then:
- Produce a paper analysis brief that follows `templates/paper-analysis-brief.md`.
- Choose exactly one core takeaway sentence.
- Decide what to teach, what to support briefly, and what to skip.
- Prefer the explanation path that best serves the audience and time budget.
- If the paper title is missing in Stage 0, fill it in here.

### Stage 2 - Inspect the code

Skip this stage if `code_source` is `none`.

When code exists:
- Read the README first.
- Read entry points before deeper files.
- Map teaching-relevant concepts from Stage 1 to files and symbols.
- Tag each code item as `core`, `supporting`, or `noise`.
- Mark gaps explicitly when the repo does not match the paper.
- Produce a code relevance map that follows `templates/code-relevance-map.md`.
- Stop once the teaching-relevant mapping is clear; do not exhaustively read the repo.

### Stage 3 - Reframe for teaching

Produce a teaching reframe that follows `templates/teaching-reframe.md`.

Use these headings exactly:
- `Hook`
- `Problem Framing`
- `Method Intuition`
- `Method Mechanics`
- `Evidence and Results`
- `Limits and Open Questions`
- `Takeaway`

Rules:
- Prefer pedagogy over publication order.
- Convert contribution framing into a teachable story.
- Reduce density and explain why each concept matters.
- Calibrate notation, jargon, and detail to the audience.

### Stage 4 - Produce artifacts

Treat every file in `templates/` as a reference schema, not a destination to edit.
Generate final markdown outputs that follow these schemas:
- Teaching Summary from `templates/teaching-summary.md`
- Slide Outline from `templates/slide-outline.md`
- NotebookLM Prompt from `templates/notebooklm-prompt.md`
- Lecture Script from `templates/lecture-script.md`

Keep all four artifacts aligned to the same core takeaway, audience, scenario, duration, and resolved code handling decision.

### Stage 5 - Quality control

Check before presenting:
- Each slide has exactly one pedagogical purpose.
- The Teaching Summary is not a rewritten abstract.
- Code usage matches the chosen code mode.
- The lecture flow follows the teaching reframe, not the paper section order.
- Notation and detail fit the audience.

If a check fails, revise the artifacts before presenting them.

## Rules

- One lecture, one core takeaway.
- Teach method before results unless the result itself is the hook.
- Cut topics instead of compressing everything.
- Code is supportive by default; only elevate it when it clearly improves understanding.
- Calibrate notation and detail to the audience.

## Code handling terms

- `code_preference` is the intake field captured in Stage 0: `no`, `yes-central`, `yes-supporting`, or `auto-decide`.
- The resolved code handling decision is the mode actually used in the artifacts after considering `code_preference`, `code_source`, and paper-code fit.
- Fallback modes are forced resolutions used when the ideal preference cannot be followed because the source material is missing, partial, or unreadable.

## Resolving code handling

- If `code_preference = no`, resolve to no-code.
- If `code_preference = yes-central`, resolve to code-central.
- If `code_preference = yes-supporting`, resolve to code-supporting.
- If `code_preference = auto-decide`, resolve to whichever of no-code, code-supporting, or code-central best improves teaching clarity.
- If code is unavailable, override any preference and resolve to the paper-only fallback.
- If code exists but is incomplete, keep the resolved decision as central or supporting only for the parts the repo actually covers.

## Fallback modes

### Paper-only mode

Use when `code_source` is `none`.

- This is a fallback mode that resolves code handling to no-code.
- Skip Stage 2.
- Produce all final artifacts without code.
- Keep the explanation conceptual and teaching-focused.

### Partial code mode

Use when code exists but does not fully cover the paper.

- This is a fallback mode that constrains a code-central or code-supporting decision.
- Map only what exists.
- Mark missing areas explicitly.
- Use paper evidence where code is absent.

### Unreadable paper mode

Use when the paper text cannot be read reliably.

- Stop.
- Ask for extracted text, pasted sections, or a better source.
- Do not continue with low-quality input.

## Templates

Use these exact paths:
- `templates/session-config.md`
- `templates/paper-analysis-brief.md`
- `templates/code-relevance-map.md`
- `templates/teaching-reframe.md`
- `templates/teaching-summary.md`
- `templates/slide-outline.md`
- `templates/notebooklm-prompt.md`
- `templates/lecture-script.md`

## Output requirements

- Treat files under `templates/` as read-only schema references.
- Produce intermediate and final outputs as markdown that follows those schemas; do not edit the template files in place.
- Keep intermediate outputs in the same schema-first style.
- Prefer concise teaching language over publication prose.
- Surface uncertainty explicitly when evidence is weak or missing.
