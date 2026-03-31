# SlidesMentor Design Spec

## Meta: What This Document Is

This is the **design spec** — the blueprint for building SlidesMentor.

It is NOT the final `SKILL.md`. The relationship:

| Document | Location | Purpose |
|----------|----------|---------|
| This design spec | `docs/superpowers/specs/2026-03-31-slidesmentor-design.md` | Full reasoning, trade-offs, acceptance criteria |
| Final SKILL.md | `.claude/skills/slidesmentor/SKILL.md` | Concise, agent-executable skill (<500 lines) |
| Artifact templates | `.claude/skills/slidesmentor/templates/` | Fixed output schemas |

### Path Convention

- Canonical path for this project: `.claude/skills/slidesmentor/`.
- If developing in another client (for example Cursor), you may mirror to `.cursor/skills/slidesmentor/`.
- Inside `SKILL.md`, prefer relative paths (for example `templates/slide-outline.md`) to avoid client-specific lock-in.

The SKILL.md should be derived from this spec but written for agent consumption: terse, imperative, with frontmatter.

### Target SKILL.md Frontmatter

```yaml
---
name: slidesmentor
description: >-
  Use when converting a research paper (with or without code) into
  teaching-oriented lecture material, slide outlines, or NotebookLM prompts.
  Use when the user mentions "make slides from a paper", "teach this paper",
  "lecture prep", or "NotebookLM prompt".
---
```

### Trigger Conditions for the Skill

The skill should activate when the agent detects any of:

- user provides a paper and asks for slides / lecture material
- user mentions NotebookLM in context of a paper
- user asks to "teach" or "explain" a paper to an audience
- user wants to convert research artifacts into presentation form

---

## Overview

SlidesMentor v1 is a workflow-oriented skill for transforming a research paper (and optionally its codebase) into teaching-oriented artifacts. Its purpose is to identify the most teachable story, reorganize technical material into a pedagogically useful sequence, and produce outputs that support lecture preparation and NotebookLM-based slide generation.

The first version targets human + AI collaboration. It should be understandable to human readers while remaining precise enough for an AI agent to execute consistently.

## Positioning

SlidesMentor is not a generic paper summarization tool. It is a teaching preparation workflow.

Its job is to:

- extract the real teaching story from the paper,
- use the codebase (when available) as supporting evidence,
- convert publication-style exposition into teaching-oriented artifacts,
- generate NotebookLM-ready prompting material.

Its job is NOT to:

- automate NotebookLM operations,
- generate final slide files (`.pptx`, `.pdf`),
- provide deep domain-specific specialization in v1,
- act as a full MCP automation layer.

---

## Workflow Stages

SlidesMentor v1 runs as an explicit multi-stage workflow with user checkpoints.

```
Stage 0: Intake → Stage 1: Paper → Stage 2: Code → Stage 3: Reframe → Stage 4: Produce → Stage 5: QC
              ↑                                                                              |
              └──────────────── (revision loop if QC fails) ─────────────────────────────────┘
```

### Stage 0 — Intake

**Before any analysis**, the agent collects session parameters from the user. Use structured questions (AskQuestion tool when available, otherwise ask conversationally). One question at a time.

Required parameters:

| Parameter | Question | Default if skipped |
|-----------|----------|--------------------|
| `audience_level` | Target audience? (undergrad / grad-intro / grad-advanced / seminar-mixed) | `grad-intro` |
| `talk_duration` | Approximate talk length or slide count? | `20 min / ~15 slides` |
| `scenario` | What is this for? (course lecture / group meeting / conference tutorial / self-study) | `group meeting` |
| `code_preference` | Should code be included in the teaching material? (yes-central / yes-supporting / no / auto-decide) | `auto-decide` |
| `paper_source` | Where is the paper? (file path / URL / pasted text) | — (must provide) |
| `code_source` | Where is the code? (repo path / URL / none) | `none` |

When `code_source` is `none`, the workflow enters **paper-only mode** (see Fallback Modes).

Normalization rules:

- Parse `talk_duration` into `talk_duration_minutes` when possible.
- Derive `target_slide_count` only when user does not provide a slide count:
  - `<=15 min` -> `10` slides (range `8-12`)
  - `16-30 min` -> `15` slides (range `12-20`)
  - `31-45 min` -> `22` slides (range `18-28`)
  - `>45 min` -> ask user for explicit slide count (no default guess)
- Compute `effective_code_mode` from Rule 3 (code preference matrix + code availability).

**Stage 0 output**: A filled `session-config.md` block with fixed fields used by later stages:

- `audience_level`
- `scenario`
- `talk_duration_raw`
- `talk_duration_minutes`
- `target_slide_count`
- `code_preference`
- `effective_code_mode`
- `paper_source`
- `code_source`
- `paper_title` (if known at intake; otherwise filled in Stage 1)

### Stage 1 — Understand the Paper

The agent reads the paper and produces a **Paper Analysis Brief**.

The agent identifies:

- research question (one sentence),
- motivation (why this problem matters),
- core claim (what the paper argues),
- main method (how it works, high level),
- evaluation setup (what experiments / benchmarks),
- main results (key findings),
- limitations (what the paper doesn't solve).

The brief must also include evidence anchors for each major claim:

- paper section / figure / table reference,
- short evidence note,
- confidence tag (`high` / `medium` / `low` when interpretation is uncertain).

Then the agent applies the **Teaching Priority Rules** (see below) to decide:

- what is the #1 thing the audience should walk away understanding,
- what is supporting material vs. core material,
- what should be explicitly excluded from the lecture.

**Stage 1 output**: `paper-analysis-brief.md` — structured document with the fields above plus a `claim -> evidence` table.

### Stage 2 — Inspect the Code

**Skip condition**: If `code_source` is `none`, skip to Stage 3 with `code_mode: paper-only`.

The agent inspects the codebase to produce a **Code Relevance Map**.

Steps:

1. Read README and entry points first.
2. Identify which modules correspond to the main method.
3. Identify which scripts produce the central figures or results.
4. For each teaching-relevant concept from Stage 1, find the corresponding code location (file + line range).
5. Tag each code piece as: `core` (must show), `supporting` (show if time), `noise` (omit).

**Large repo strategy**:

- If the repository has `>50` files, do NOT read everything. Prioritize: README -> entry scripts -> files referenced in paper -> main method modules.
- If the repository has `>100` files, cap detailed inspection to `20` files. If mapping is still incomplete, switch to Partial Code Mode.
- Stop once the core mapping is established.

**Stage 2 output**: `code-relevance-map.md` — a table with:

- `concept`,
- `code_location` (file path + symbol/function anchor; line range if stable),
- `teaching_tag` (`core` / `supporting` / `noise`),
- `match_status` (`matched` / `[not in repo]` / `[code differs from paper]`),
- `confidence`.

**User review gate (optional)**: After Stage 2, optionally present the Paper Analysis Brief + Code Relevance Map for user confirmation before proceeding.

### Stage 3 — Reframe for Teaching

The agent converts publication-style exposition into teaching-style explanation by:

- turning contribution framing into conceptual story,
- reducing unnecessary density,
- emphasizing intuition and interpretability,
- aligning explanation order with pedagogy rather than paper structure,
- applying audience level from `session-config`.

The agent produces a **Teaching Reframe Draft**: a narrative skeleton that defines the story arc of the lecture.

Required skeleton headings:

- `Hook`
- `Problem Framing`
- `Method Intuition`
- `Method Mechanics`
- `Evidence and Results`
- `Limits and Open Questions`
- `Takeaway`

**Stage 3 output**: `teaching-reframe.md` — the rewritten narrative skeleton.

### Stage 4 — Produce Teaching Artifacts

The agent generates the four required outputs (see Output Schemas below):

1. Teaching Summary,
2. Slide-by-Slide Outline,
3. NotebookLM-ready Prompt,
4. Lecture Script (speaker-facing narrative).

All outputs must be internally consistent and reflect the same teaching story. All outputs must respect the `session-config` parameters.

**Stage 4 output**: Four markdown files written to `output/`.

### Stage 5 — Quality Control

The agent checks each artifact against its acceptance criteria.

**QC Checklist**:

- [ ] Teaching Summary is not a rewritten abstract — it has a clear "what to teach" decision
- [ ] Slide outline has exactly one pedagogical purpose per slide
- [ ] Slide count is within ±30% of `session-config.target_slide_count`
- [ ] NotebookLM prompt is specific (mentions paper name, method, audience) not generic
- [ ] Lecture Script follows the story arc from the reframe, not the paper section order
- [ ] Audience level is consistently reflected (no jargon leakage for undergrad; no over-simplification for advanced)
- [ ] Code slide count obeys `effective_code_mode`:
  - `yes-central` -> code appears in `>=3` slides
  - `yes-supporting` -> code appears in `1-2` slides
  - `no` / paper-only -> `0` code slides
- [ ] No slide is "dense but purposeless" — every slide passes the "what should the audience think after this slide?" test

**If any check fails**: Loop back to Stage 4, revise the failing artifact, re-check. Maximum 2 revision loops before presenting to user with flagged issues.

**Stage 5 output**: Final artifacts + a brief QC report noting any unresolved flags.

---

## Teaching Priority Rules

These are explicit decision rules, not abstract principles. The agent must apply them during Stage 1 and Stage 3.

### Rule 1: One Core Takeaway

Every lecture needs exactly ONE sentence the audience should remember. The agent must write this sentence in Stage 1 and all artifacts must serve it.

**Test**: If a slide doesn't help the audience understand or believe the core takeaway, cut it or demote it to backup.

### Rule 2: Method Before Results

Teach how the method works before showing that it works. Results without method intuition are meaningless to learners.

**Exception**: When the result itself is the surprise (e.g., "X is actually possible"), lead with the result as a hook, then explain how.

### Rule 3: Code Inclusion Decision Matrix

| `code_preference` | Code available? | Action |
|--------------------|----------------|--------|
| `yes-central` | Yes | Code is a first-class teaching element. Dedicate 3+ slides to code walkthrough. |
| `yes-supporting` | Yes | Use code snippets to illustrate key concepts. 1-2 slides max. |
| `no` | Any | No code in slides. Focus on conceptual explanation. |
| `auto-decide` | Yes | Agent decides based on: does the code make the method clearer? If yes → `yes-supporting`. If method is math-heavy and code is just engineering → `no`. |
| Any | No | Paper-only mode. No code in slides. |

After applying this matrix, the result is stored as `effective_code_mode` in `session-config`.

### Rule 4: Cut, Don't Compress

When material doesn't fit the time budget, cut entire topics rather than cramming everything in at lower quality. Prioritize: core method > motivation > results > related work > proofs.

### Rule 5: Audience Calibration

| Audience | Notation | Code | Assumed background |
|----------|----------|------|--------------------|
| `undergrad` | Minimal, define all symbols | Pseudocode only | Textbook-level |
| `grad-intro` | Standard, define non-obvious | Real snippets OK | Has read related papers |
| `grad-advanced` | Full, can skip basics | Full implementation detail OK | Active in the field |
| `seminar-mixed` | Moderate, define key terms | Optional, keep high-level | Varies widely |

---

## Fallback Modes

### Paper-Only Mode

Triggered when `code_source` is `none`.

- Stage 2 is skipped entirely.
- Code Relevance Map is not produced.
- All artifacts focus on conceptual explanation only.
- `code_preference` is forced to `no`.
- The skill still produces all four required outputs.

### Partial Code Mode

Triggered when the code exists but doesn't cover the full paper (e.g., only training code, no evaluation; or only one experiment).

- Stage 2 maps only what is available.
- Code Relevance Map marks missing areas as `[not in repo]`.
- Agent uses code where available, falls back to paper description elsewhere.

### Unreadable Paper Mode

Triggered when the paper is a scanned PDF, image-heavy, or the agent cannot extract clean text.

- Agent flags the issue to the user in Stage 1.
- Asks user to provide: extracted text, key sections copy-pasted, or an alternative source.
- Does NOT proceed with garbage input. Blocks until usable text is available.

---

## Output Schemas

All artifacts are written as markdown files to `output/`. Each has a fixed schema.

### 1. Teaching Summary (`output/teaching-summary.md`)

```markdown
# Teaching Summary

## Paper
[Full paper title and authors, one line]

## Core Takeaway
[One sentence: the single most important idea the audience should remember]

## Why It Matters
[2-3 sentences: why this problem/solution is interesting or important]

## How It Works (High Level)
[3-5 sentences: the method at an intuitive level, no jargon if possible]

## Key Evidence
[2-3 bullet points: what results support the core claim]

## Teach This
[Bullet list: topics that MUST appear in the lecture]

## Skip This
[Bullet list: topics to explicitly omit and why]
```

**Acceptance criteria**: Not a rewritten abstract. Contains explicit teach/skip decisions. Useful for a presenter who has 2 minutes to understand the lecture's core story.

### 2. Slide-by-Slide Outline (`output/slide-outline.md`)

```markdown
# Slide Outline

## Session Config
- Audience: [from session-config]
- Duration: [from session-config]
- Slide count: [N]

## Slide 1: [Title]
- **Purpose**: [What should the audience understand after this slide?]
- **Content**: [Bullet points of what appears on the slide]
- **Visual**: [Figure / equation / code snippet / diagram / none]
- **Speaker note**: [What the presenter should say that isn't on the slide]

## Slide 2: [Title]
...
```

**Acceptance criteria**: One clear purpose per slide. Coherent ordering. Slide count matches duration expectation. No slide exists without a clear "what should the audience think after this?" answer.

### 3. NotebookLM-ready Prompt (`output/notebooklm-prompt.md`)

```markdown
# NotebookLM Prompt

## Prompt

You are creating a slide deck for a [scenario] presentation about [paper title].

Target audience: [audience_level description].
Duration: [talk_duration].

The presentation should tell this story:
[Compressed version of the teaching reframe — the narrative arc in 5-8 sentences]

Required slides (in this order):
[Numbered list of slide topics with one-line purpose each]

Recommended source package and upload order:
[Numbered list of sources to upload to NotebookLM and why each source is included]

Style constraints:
- One key idea per slide
- [Audience-appropriate notation/code guidance]
- Emphasize intuition over formalism
- [Any specific constraints from session-config]

Do NOT include:
[List from "Skip This" in teaching summary]
```

**Acceptance criteria**: Specific (names the paper, method, audience). Not a generic "make slides about X" prompt. Directly pasteable into NotebookLM. Includes explicit source upload strategy.

**Good vs. bad example**:

Bad (too generic):
> "Create a slide deck about this machine learning paper. Make it educational and clear."

Good (specific):
> "Create a 15-slide deck about the Tensor Network paper by Smith et al. for a graduate intro audience. The core story is: tensor networks compress high-dimensional data by exploiting local structure. Start with the curse of dimensionality as motivation, then explain TT-decomposition visually before showing compression results. Skip the convergence proof. Use code snippets from the `decompose.py` module to show the core algorithm."

### 4. Lecture Script (`output/lecture-script.md`)

```markdown
# Lecture Script

## Opening (Slide [X]-[Y])
[What the presenter says to open. Written in spoken style, not paper style.]

## Problem Setup (Slide [X]-[Y])
[Transition + explanation]

## Core Method (Slide [X]-[Y])
[The heart of the lecture]

## Results (Slide [X]-[Y])
[What to emphasize, what to skip]

## Closing (Slide [X]-[Y])
[Takeaway + discussion hooks]
```

**Acceptance criteria**: Written in spoken style (not paper-abstract style). Follows the story arc from Stage 3, not the paper section order. Each section references the corresponding slide numbers.

---

## Failure Handling

### Large Repository (>50 files)

- Do NOT attempt to read everything.
- Priority order: README → entry point / main script → files referenced in paper → core method modules.
- Stop exploring once the Code Relevance Map covers all Stage 1 teaching-relevant concepts.
- If repository has `>100` files and coverage is still incomplete after reading 20 files, switch to Partial Code Mode.

### Paper Too Dense or Too Long

- If the paper exceeds ~30 pages or is extremely notation-heavy:
  - Focus on Abstract, Introduction, Method section, and Conclusion.
  - Skip appendices, supplementary material, and full proofs unless specifically requested.
  - Flag to user: "This paper is very dense. I focused on [sections]. Want me to also cover [other sections]?"

### Code Doesn't Match Paper

- If the code appears to implement a different version, older draft, or only a subset:
  - Flag the mismatch explicitly in the Code Relevance Map.
  - Mark mismatched areas as `[code differs from paper]`.
  - Use paper description as the authoritative teaching source; use code only where it clearly matches.

### Agent Cannot Determine What to Teach

- If the paper is too broad or the agent cannot identify a single core takeaway:
  - Present 2-3 candidate takeaway options to the user.
  - Ask user to pick one before proceeding.
  - Do NOT proceed with a vague "this paper covers many topics" approach.

---

## Scope Boundaries for Version 1

Version 1 does NOT require:

- automatic code execution or reproducibility verification,
- automatic extraction of every figure or result,
- full recovery of every technical proof chain,
- NotebookLM automation or API integration,
- MCP-based orchestration,
- final slide file generation (`.pptx` / `.pdf`).

---

## Minimum Prototype Deliverables

### A. SKILL.md

A concise (<500 line) skill document at `.claude/skills/slidesmentor/SKILL.md` with:

- proper frontmatter (`name`, `description` with trigger conditions),
- the 6-stage workflow as an imperative checklist,
- teaching priority rules inline,
- fallback mode descriptions,
- links to template files.

### B. Artifact Templates

Template files at `.claude/skills/slidesmentor/templates/`:

- `teaching-summary.md`
- `slide-outline.md`
- `notebooklm-prompt.md`
- `lecture-script.md`

### C. Intermediate Templates

- `session-config.md`
- `paper-analysis-brief.md`
- `code-relevance-map.md`
- `teaching-reframe.md`

---

## Future Extensions

Potential future directions (explicitly out of scope for v1):

- source bundle preparation for NotebookLM,
- NotebookLM workflow automation via MCP,
- audience presets (save and reuse session configs),
- interactive teaching-planning with iterative refinement,
- multi-paper comparison decks,
- slide file generation.
