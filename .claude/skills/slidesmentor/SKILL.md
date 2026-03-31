---
name: slidesmentor
description: >-
  Use when converting a research paper (with or without code) into
  teaching-oriented lecture material, slide outlines, or NotebookLM prompts.
  Use when the user mentions "make slides from a paper", "teach this paper",
  "lecture prep", or "NotebookLM prompt".
---

# SlidesMentor

Transform a research paper, and optionally its codebase, into teaching-oriented markdown artifacts.

This skill extracts the teachable story, uses code only when it improves understanding, rewrites publication-style exposition into teaching flow, and writes fixed markdown outputs. Do not use this skill to automate NotebookLM, generate final slide files, perform MCP orchestration, or guarantee code reproducibility.

## Boundaries

- Produce markdown artifacts only.
- Prefer pedagogy over paper section order.
- Use the paper as the source of truth; use code only to support teaching decisions.
- Stop when the paper source is missing or unusable.
- Treat every file in `templates/` as a read-only schema reference, not a destination to edit.

## Stage 0 - Intake and normalization

Ask one question at a time until `paper_source` is known and each remaining field is either user-specified or resolved to a default:
- `audience_level`
- `scenario`
- `talk_duration_raw`
- `code_preference`
- `paper_source`
- `code_source`
- `slide_count_raw` if the user explicitly gives a slide count

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
- For each non-paper field, ask only if the user has not already implied it. If unspecified, apply the default, record it, and continue.
- Treat `templates/session-config.md` as a reference schema. Produce `output/session-config.md`; do not overwrite the template file itself.

Normalization:
- Derive `talk_duration_minutes` from `talk_duration_raw` when possible. Parse explicit minute counts such as `20 min`, `45 minutes`, or mixed strings such as `20 min / ~15 slides`. If duration cannot be resolved reliably, ask one follow-up question.
- Derive `target_slide_count` only when the user did not specify a slide count:
  - `<=15 min` -> `10` slides, acceptable range `8-12`
  - `16-30 min` -> `15` slides, acceptable range `12-20`
  - `31-45 min` -> `22` slides, acceptable range `18-28`
  - `>45 min` -> ask the user for an explicit slide count
- Derive `effective_code_mode` from the code decision matrix in “Resolving code handling”.

Write the normalized intake to:
- `output/session-config.md`

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
- Produce `output/paper-analysis-brief.md` following `templates/paper-analysis-brief.md`.
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
- Produce `output/code-relevance-map.md` following `templates/code-relevance-map.md`.
- Stop once the teaching-relevant mapping is clear; do not exhaustively read the repo.

### Stage 3 - Reframe for teaching

Produce `output/teaching-reframe.md` following `templates/teaching-reframe.md`.

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

Treat every file in `templates/` as a read-only schema reference.

Intermediate outputs must exist as files in `output/`:
- `output/session-config.md`
- `output/paper-analysis-brief.md`
- `output/code-relevance-map.md` when code is used
- `output/teaching-reframe.md`

Final artifacts must be written to these canonical filenames in `output/`:
- `output/teaching-summary.md` following `templates/teaching-summary.md`
- `output/slide-outline.md` following `templates/slide-outline.md`
- `output/notebooklm-prompt.md` following `templates/notebooklm-prompt.md`
- `output/lecture-script.md` following `templates/lecture-script.md`

Artifact rules:
- Keep all final artifacts aligned to the same core takeaway, audience, scenario, normalized duration, target slide count, and `effective_code_mode`.
- Make outputs explicitly file-based. Do not present Stage 4 as only conversational text.
- Prefer concise teaching language over publication prose.
- Surface uncertainty explicitly when evidence is weak or missing.

### Stage 5 - Quality control

Check before presenting:
- Teaching Summary is not a rewritten abstract and includes explicit teach/skip decisions.
- Every slide has exactly one pedagogical purpose.
- Slide count is within plus or minus 30% of `target_slide_count`.
- NotebookLM prompt is specific about the paper name, method, and audience.
- Lecture Script follows the teaching reframe rather than paper section order.
- Audience level, notation, terminology, and pacing are consistent across all artifacts.
- Code slide quotas match the resolved `effective_code_mode` after any fallback downgrade:
  - `no-code`: zero code-centric slides
  - `code-supporting`: limited code slides used only to reinforce key concepts
  - `code-central`: code is integral to the teaching path, but only when explicitly resolved to this mode and not downgraded by partial code coverage
- No dense-but-purposeless slides.

Revision loop:
- If a check fails, revise the affected artifacts and re-run Stage 5.
- Cap revisions at 2 loops.
- If unresolved issues remain after 2 loops, surface the remaining flags explicitly instead of silently continuing.

## Rules

- One lecture, one core takeaway.
- Teach method before results unless the result itself is the hook.
- Cut topics instead of compressing everything.
- Code is supportive by default; only elevate it when it clearly improves understanding.
- Calibrate notation and detail to the audience.

## Code handling terms

- `code_preference` is the intake field captured in Stage 0: `no`, `yes-central`, `yes-supporting`, or `auto-decide`.
- The resolved code handling decision is the mode actually used in the artifacts after considering `code_preference`, `code_source`, and paper-code fit.
- `effective_code_mode` is the final resolved mode recorded in `output/session-config.md` and enforced in Stage 4 and Stage 5.
- Fallback modes are forced resolutions used when the ideal preference cannot be followed because the source material is missing, partial, or unreadable.

## Resolving code handling

Decision matrix:
- If `code_preference = no`, resolve to `no-code`.
- If `code_preference = yes-central`, resolve to `code-central`.
- If `code_preference = yes-supporting`, resolve to `code-supporting`.
- If `code_preference = auto-decide`, resolve only to `code-supporting` or `no-code`; never resolve `auto-decide` to `code-central`.
- If code is unavailable, override any preference and resolve to the paper-only fallback.
- If code exists but is incomplete, downgrade any would-be `code-central` resolution to `code-supporting`; partial coverage never leaves `effective_code_mode` ambiguous and never justifies `code-central`.
- If code is present but low-value for teaching clarity, prefer `no-code`.

## Fallback modes

### Paper-only mode

Use when `code_source` is `none`.

- This fallback resolves code handling to `no-code`.
- Skip Stage 2.
- Produce all outputs without code.
- Keep the explanation conceptual and teaching-focused.

### Partial code mode

Use when code exists but does not fully cover the paper.

- This fallback downgrades any would-be `code-central` resolution to `code-supporting`, and `effective_code_mode` must be recorded as `code-supporting`.
- Map only what exists.
- Mark missing areas explicitly.
- Use paper evidence where code is absent.

### Unreadable paper mode

Use when the paper text cannot be read reliably.

- Stop.
- Ask for extracted text, pasted sections, or a better source.
- Do not continue with low-quality input.

## Templates

Use these exact schema-reference paths:
- `templates/session-config.md`
- `templates/paper-analysis-brief.md`
- `templates/code-relevance-map.md`
- `templates/teaching-reframe.md`
- `templates/teaching-summary.md`
- `templates/slide-outline.md`
- `templates/notebooklm-prompt.md`
- `templates/lecture-script.md`

## Output requirements

- Keep templates read-only.
- Write all intermediate and final artifacts as markdown files under `output/`.
- Use the canonical output filenames listed above.
- Keep intermediate outputs in the same schema-first style.
- Do not overwrite template files in place.
