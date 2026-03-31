# SlidesMentor V1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first working SlidesMentor skill under `.claude/skills/slidesmentor/` with executable workflow instructions and fixed templates for all required artifacts and intermediate outputs.

**Architecture:** Keep the implementation file-based and skill-first. The core behavior lives in a concise `SKILL.md`, while all output contracts live in dedicated markdown templates under `templates/` so the agent workflow stays short and the schemas stay reusable. The first version ships no automation code, only the skill, templates, and minimal supporting docs.

**Tech Stack:** Claude Code skills, Markdown, repository docs

---

## File Structure

### Create
- `.claude/skills/slidesmentor/SKILL.md` — final agent-executable SlidesMentor skill with frontmatter, trigger conditions, workflow stages, rules, fallback modes, and template references.
- `.claude/skills/slidesmentor/templates/session-config.md` — fixed schema for Stage 0 intake output.
- `.claude/skills/slidesmentor/templates/paper-analysis-brief.md` — fixed schema for Stage 1 paper analysis output.
- `.claude/skills/slidesmentor/templates/code-relevance-map.md` — fixed schema for Stage 2 code mapping output.
- `.claude/skills/slidesmentor/templates/teaching-reframe.md` — fixed schema for Stage 3 narrative rewrite output.
- `.claude/skills/slidesmentor/templates/teaching-summary.md` — fixed schema for required final teaching summary artifact.
- `.claude/skills/slidesmentor/templates/slide-outline.md` — fixed schema for required final slide outline artifact.
- `.claude/skills/slidesmentor/templates/notebooklm-prompt.md` — fixed schema for required final NotebookLM prompt artifact.
- `.claude/skills/slidesmentor/templates/lecture-script.md` — fixed schema for required final lecture script artifact.
- `docs/superpowers/plans/2026-03-31-slidesmentor-v1.md` — this implementation plan.

### Modify
- `README.md:1-2` — extend repository overview so the repo explains where the shipped skill and spec live.
- `AGENTS.md:1-76` — replace the original issue-style draft with a concise pointer to the finalized spec and implementation artifacts, so the repo has one source of truth.

### Review During Implementation
- `docs/superpowers/specs/2026-03-31-slidesmentor-design.md` — authoritative design spec to follow while implementing.
- `.gitignore:1-199` — verify no ignore rule would hide `.claude/skills/` artifacts from git.

---

### Task 1: Scaffold the SlidesMentor skill directory

**Files:**
- Create: `.claude/skills/slidesmentor/SKILL.md`
- Create: `.claude/skills/slidesmentor/templates/session-config.md`
- Create: `.claude/skills/slidesmentor/templates/paper-analysis-brief.md`
- Create: `.claude/skills/slidesmentor/templates/code-relevance-map.md`
- Create: `.claude/skills/slidesmentor/templates/teaching-reframe.md`
- Create: `.claude/skills/slidesmentor/templates/teaching-summary.md`
- Create: `.claude/skills/slidesmentor/templates/slide-outline.md`
- Create: `.claude/skills/slidesmentor/templates/notebooklm-prompt.md`
- Create: `.claude/skills/slidesmentor/templates/lecture-script.md`
- Test: repository tree and file presence checks

- [ ] **Step 1: Verify the parent directory state**

Run: `ls -R .claude`
Expected: existing `.claude/` directory is present and currently does not contain `skills/slidesmentor/`.

- [ ] **Step 2: Create the skill directory tree**

Run: `mkdir -p .claude/skills/slidesmentor/templates`
Expected: `.claude/skills/slidesmentor/templates/` exists.

- [ ] **Step 3: Add the Stage 0 template**

```markdown
# Session Config

- audience_level:
- scenario:
- talk_duration_raw:
- talk_duration_minutes:
- target_slide_count:
- code_preference:
- effective_code_mode:
- paper_source:
- code_source:
- paper_title:
```

- [ ] **Step 4: Add the Stage 1 template**

```markdown
# Paper Analysis Brief

## Paper
- Title:
- Authors:

## Research Question

## Motivation

## Core Claim

## Main Method

## Evaluation Setup

## Main Results

## Limitations

## Core Takeaway

## Teach This
-

## Exclude From Lecture
-

## Claim to Evidence Map
| Claim | Evidence anchor | Evidence note | Confidence |
| --- | --- | --- | --- |
|  |  |  |  |
```

- [ ] **Step 5: Add the Stage 2 template**

```markdown
# Code Relevance Map

| Concept | Code location | Teaching tag | Match status | Confidence |
| --- | --- | --- | --- | --- |
|  |  | core | matched | high |
```

- [ ] **Step 6: Add the Stage 3 template**

```markdown
# Teaching Reframe

## Hook

## Problem Framing

## Method Intuition

## Method Mechanics

## Evidence and Results

## Limits and Open Questions

## Takeaway
```

- [ ] **Step 7: Add the four final artifact templates**

```markdown
# Teaching Summary

## Paper

## Core Takeaway

## Why It Matters

## How It Works (High Level)

## Key Evidence
-

## Teach This
-

## Skip This
-
```

```markdown
# Slide Outline

## Session Config
- Audience:
- Duration:
- Slide count:

## Slide 1: [Title]
- **Purpose**:
- **Content**:
- **Visual**:
- **Speaker note**:
```

```markdown
# NotebookLM Prompt

## Prompt

You are creating a slide deck for a [scenario] presentation about [paper title].

Target audience: [audience_level description].
Duration: [talk_duration].

The presentation should tell this story:
[5-8 sentence teaching narrative]

Required slides (in this order):
1.

Recommended source package and upload order:
1.

Style constraints:
- One key idea per slide
- Emphasize intuition over formalism
- Audience-appropriate notation/code guidance: [notation and code guidance]
- Specific constraints from session config: [session-specific constraints]

Do NOT include:
-
```

```markdown
# Lecture Script

## Opening (Slide [X]-[Y])

## Problem Setup (Slide [X]-[Y])

## Core Method (Slide [X]-[Y])

## Results (Slide [X]-[Y])

## Closing (Slide [X]-[Y])
```

- [ ] **Step 8: Verify all files exist**

Run: `ls .claude/skills/slidesmentor && ls .claude/skills/slidesmentor/templates`
Expected: `SKILL.md` placeholder may still be missing, and all eight template files are present.

- [ ] **Step 9: Commit the scaffold**

```bash
git add .claude/skills/slidesmentor/templates
git commit -m "chore: scaffold slidesmentor skill templates"
```

### Task 2: Write the executable SKILL.md

**Files:**
- Modify: `.claude/skills/slidesmentor/SKILL.md`
- Review: `docs/superpowers/specs/2026-03-31-slidesmentor-design.md:1-520`
- Test: markdown review and file readback

- [ ] **Step 1: Write the skill frontmatter and trigger description**

```markdown
---
name: slidesmentor
description: >-
  Use when converting a research paper (with or without code) into
  teaching-oriented lecture material, slide outlines, or NotebookLM prompts.
  Use when the user mentions "make slides from a paper", "teach this paper",
  "lecture prep", or "NotebookLM prompt".
---
```

- [ ] **Step 2: Write the overview and hard boundaries**

```markdown
# SlidesMentor

Transform a research paper (and optionally its codebase) into teaching-oriented artifacts.

This skill:
- extracts the teachable story,
- uses code as support when available,
- rewrites publication-style exposition into teaching flow,
- produces fixed markdown artifacts and a NotebookLM-ready prompt.

This skill does not:
- automate NotebookLM,
- generate final slide files,
- perform MCP orchestration,
- guarantee code reproducibility.
```

- [ ] **Step 3: Write the required intake questions for Stage 0**

```markdown
## Stage 0 — Intake

Ask one question at a time until these are known:
- `audience_level`
- `scenario`
- `talk_duration_raw`
- `code_preference`
- `paper_source`
- `code_source`

Defaults:
- `audience_level`: `grad-intro`
- `scenario`: `group meeting`
- `talk_duration_raw`: `20 min / ~15 slides`
- `code_preference`: `auto-decide`
- `code_source`: `none`

If `paper_source` is missing, stop and ask for it.
Treat `templates/session-config.md` as a reference schema. Produce `output/session-config.md`; do not overwrite the template file itself.
```

- [ ] **Step 4: Write the Stage 1-5 execution checklist**

```markdown
## Workflow

1. **Understand the paper**
   - Identify the research question, motivation, core claim, method, setup, results, and limitations.
   - Write `templates/paper-analysis-brief.md` content.
   - Decide one `Core Takeaway` sentence and explicit teach/skip decisions.

2. **Inspect the code**
   - Skip when `code_source` is `none`.
   - Read README and entry points first.
   - Map teaching-relevant concepts to files or symbols.
   - Tag code as `core`, `supporting`, or `noise`.
   - Write `templates/code-relevance-map.md` content.

3. **Reframe for teaching**
   - Rewrite the material using the headings in `templates/teaching-reframe.md`.
   - Prefer pedagogy over paper section order.

4. **Produce artifacts**
   - Generate Teaching Summary, Slide Outline, NotebookLM Prompt, and Lecture Script using the template schemas.

5. **Run quality control**
   - Confirm every slide has one pedagogical purpose.
   - Confirm the output is not a rewritten abstract.
   - Confirm code usage matches the chosen code mode.
   - Revise before presenting results.
```

- [ ] **Step 5: Write teaching priority rules and fallback modes**

```markdown
## Rules

- One lecture, one core takeaway.
- Teach method before results unless the result itself is the hook.
- Cut topics instead of compressing everything.
- Code is supportive by default; only elevate it when it clearly improves understanding.
- Calibrate notation and detail to the audience.

## Fallback Modes

- **Paper-only mode**: skip Stage 2 and produce all final artifacts without code.
- **Partial code mode**: map only what exists and mark missing areas explicitly.
- **Unreadable paper mode**: stop and ask for extracted text or better source material.
```

- [ ] **Step 6: Add template references and output expectations**

```markdown
## Templates

Use these files as fixed schemas:
- `templates/session-config.md`
- `templates/paper-analysis-brief.md`
- `templates/code-relevance-map.md`
- `templates/teaching-reframe.md`
- `templates/teaching-summary.md`
- `templates/slide-outline.md`
- `templates/notebooklm-prompt.md`
- `templates/lecture-script.md`

Final outputs should be written as markdown using those schemas.
```

- [ ] **Step 7: Read back the completed skill and verify it stays concise**

Run: `wc -l .claude/skills/slidesmentor/SKILL.md`
Expected: fewer than `500` lines.

- [ ] **Step 8: Commit the skill document**

```bash
git add .claude/skills/slidesmentor/SKILL.md
git commit -m "feat: add slidesmentor skill workflow"
```

### Task 3: Align repository docs with the finalized skill

**Files:**
- Modify: `README.md:1-2`
- Modify: `AGENTS.md:1-76`
- Review: `.claude/skills/slidesmentor/SKILL.md`
- Test: readback review of both docs

- [ ] **Step 1: Replace the README stub with a minimal project overview**

```markdown
# SlidesMentor

SlidesMentor is a skill-first project for turning research papers and accompanying code into teaching-oriented lecture materials and NotebookLM-ready prompts.

## Project layout
- `docs/superpowers/specs/2026-03-31-slidesmentor-design.md` — design spec and acceptance criteria
- `docs/superpowers/plans/2026-03-31-slidesmentor-v1.md` — implementation plan
- `.claude/skills/slidesmentor/SKILL.md` — executable skill
- `.claude/skills/slidesmentor/templates/` — fixed schemas for intermediate and final artifacts
```

- [ ] **Step 2: Replace AGENTS.md with a concise source-of-truth pointer**

```markdown
# SlidesMentor Project Notes

This repository started from an idea draft for a teaching-oriented research-paper skill.

The current source of truth is:
- `docs/superpowers/specs/2026-03-31-slidesmentor-design.md` — design specification
- `docs/superpowers/plans/2026-03-31-slidesmentor-v1.md` — implementation plan
- `.claude/skills/slidesmentor/SKILL.md` — executable skill definition

If the draft in this repository and the implementation differ, follow the spec and skill files.
```

- [ ] **Step 3: Read both docs back and verify they match the implemented structure**

Run: `sed -n '1,80p' README.md && printf '\n---\n' && sed -n '1,80p' AGENTS.md`
Expected: both files reference the same spec, plan, and skill paths.

- [ ] **Step 4: Commit the doc alignment changes**

```bash
git add README.md AGENTS.md
git commit -m "docs: align repository docs with slidesmentor skill"
```

### Task 4: Verify the shipped prototype end-to-end

**Files:**
- Review: `.claude/skills/slidesmentor/SKILL.md`
- Review: `.claude/skills/slidesmentor/templates/*.md`
- Review: `README.md`
- Review: `AGENTS.md`
- Test: repository checks only

- [ ] **Step 1: Verify the full file set exists**

Run: `test -f .claude/skills/slidesmentor/SKILL.md && test -f .claude/skills/slidesmentor/templates/session-config.md && test -f .claude/skills/slidesmentor/templates/paper-analysis-brief.md && test -f .claude/skills/slidesmentor/templates/code-relevance-map.md && test -f .claude/skills/slidesmentor/templates/teaching-reframe.md && test -f .claude/skills/slidesmentor/templates/teaching-summary.md && test -f .claude/skills/slidesmentor/templates/slide-outline.md && test -f .claude/skills/slidesmentor/templates/notebooklm-prompt.md && test -f .claude/skills/slidesmentor/templates/lecture-script.md`
Expected: command exits successfully with no output.

- [ ] **Step 2: Verify the skill references all templates**

Run: `grep -n "templates/" .claude/skills/slidesmentor/SKILL.md`
Expected: output includes all eight template paths.

- [ ] **Step 3: Verify the repo docs point to the shipped artifacts**

Run: `grep -n "slidesmentor" README.md AGENTS.md .claude/skills/slidesmentor/SKILL.md`
Expected: README, AGENTS, and SKILL all refer to the same SlidesMentor implementation.

- [ ] **Step 4: Commit the verification pass**

```bash
git add .claude/skills/slidesmentor README.md AGENTS.md
git commit -m "test: verify slidesmentor v1 skill package"
```

---

## Self-Review

### Spec coverage
- Stage 0 intake parameters are implemented in Task 2 Step 3 and Task 1 `session-config.md`.
- Stage 1 paper analysis brief is implemented in Task 1 Step 4 and Task 2 Step 4.
- Stage 2 code relevance map is implemented in Task 1 Step 5 and Task 2 Step 4.
- Stage 3 teaching reframe is implemented in Task 1 Step 6 and Task 2 Step 4.
- Final artifacts are implemented in Task 1 Step 7 and Task 2 Step 4.
- Teaching rules and fallback modes are implemented in Task 2 Step 5.
- Repo-facing documentation alignment is implemented in Task 3.
- End-to-end existence and reference verification is implemented in Task 4.

### Placeholder scan
- No `TODO`, `TBD`, or deferred implementation notes remain.
- All file paths are explicit.
- All shell commands are concrete.
- All code-writing steps include the content to write.

### Type and naming consistency
- The skill name is consistently `slidesmentor`.
- Template paths consistently live under `.claude/skills/slidesmentor/templates/`.
- Final artifact names consistently use `teaching-summary`, `slide-outline`, `notebooklm-prompt`, and `lecture-script`.
