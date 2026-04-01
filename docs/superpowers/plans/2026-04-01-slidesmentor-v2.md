# SlidesMentor v2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rework SlidesMentor around a stronger NotebookLM prompt contract and a canonical cross-platform package layout.

**Architecture:** Keep the existing pedagogy-first workflow, but redesign the NotebookLM handoff to be short and high-signal. Introduce `slidesmentor-skill-package/` as the canonical source, then expose Claude- and Codex-specific adapters from that package.

**Tech Stack:** Markdown skills, repository docs, package layout, install wrappers

---

## File Structure

### Create
- `docs/superpowers/specs/2026-04-01-slidesmentor-v2-design.md` — v2 product/design spec
- `docs/superpowers/plans/2026-04-01-slidesmentor-v2.md` — this plan
- `slidesmentor-skill-package/README.md` — package overview and install guide
- `slidesmentor-skill-package/skills/slidesmentor/SKILL.md` — canonical SlidesMentor skill source
- `slidesmentor-skill-package/templates/notebooklm-prompt.md` — canonical NotebookLM prompt template
- `slidesmentor-skill-package/templates/` companion files as needed for canonical artifacts
- `slidesmentor-skill-package/.claude-plugin/` — Claude adapter files
- `slidesmentor-skill-package/.codex-plugin/` — Codex adapter files
- optional deck-review rubric doc under the package or docs tree

### Modify
- `.claude/skills/slidesmentor/SKILL.md`
- `.claude/skills/slidesmentor/templates/notebooklm-prompt.md`
- `README.md`
- `AGENTS.md`
- `output/notebooklm-prompt.md` if refreshing examples
- `output/qc-report.md` if refreshing examples

### Review During Implementation
- `docs/superpowers/specs/2026-03-31-slidesmentor-design.md`
- `docs/superpowers/plans/2026-03-31-slidesmentor-v1.md`

---

### Task 1: Add v2 spec and plan docs

**Files:**
- Create: `docs/superpowers/specs/2026-04-01-slidesmentor-v2-design.md`
- Create: `docs/superpowers/plans/2026-04-01-slidesmentor-v2.md`

- [ ] **Step 1: Verify the docs directories exist**

Run: `ls docs/superpowers/specs && ls docs/superpowers/plans`
Expected: both directories exist and contain the v1 SlidesMentor files.

- [ ] **Step 2: Add the v2 design spec**

Write the spec so it explicitly defines:
- short NotebookLM prompt contract
- optional short audience/duration lines
- dynamic `Required coverage:`
- mandatory visual-style bullets
- short `Do NOT include:` block
- split between artifact QC and downstream deck review
- canonical `slidesmentor-skill-package/`

- [ ] **Step 3: Add the v2 implementation plan**

Write this implementation plan to `docs/superpowers/plans/2026-04-01-slidesmentor-v2.md`.

- [ ] **Step 4: Review both docs for consistency**

Read the new spec and plan and confirm they match on prompt structure, QC split, and package layout.

### Task 2: Write a failing fixture test for the new NotebookLM prompt contract

**Files:**
- Create: `slidesmentor-skill-package/examples/notebooklm-prompt-contract.md` or equivalent fixture doc
- Modify later: canonical NotebookLM prompt template and example output

- [ ] **Step 1: Write the expected v2 prompt contract as a failing fixture**

Create a markdown fixture that captures the required v2 shape:
- short task sentence
- optional short audience line
- optional short duration line
- short teaching story block
- dynamic `Required coverage:` section
- visual-style bullets
- short `Do NOT include:` block

- [ ] **Step 2: Compare the current template to the fixture and verify failure manually**

Run: `diff`-style inspection by reading the current template and the new fixture.
Expected: current template fails because it still includes verbose scaffold sections like source package guidance and does not yet encode the new v2 contract.

### Task 3: Implement the canonical package layout

**Files:**
- Create: `slidesmentor-skill-package/README.md`
- Create: `slidesmentor-skill-package/skills/slidesmentor/SKILL.md`
- Create: `slidesmentor-skill-package/templates/notebooklm-prompt.md`
- Create: adapter files under `.claude-plugin/` and `.codex-plugin/`

- [ ] **Step 1: Create package root structure**

Run: `mkdir -p slidesmentor-skill-package/skills/slidesmentor slidesmentor-skill-package/templates slidesmentor-skill-package/.claude-plugin slidesmentor-skill-package/.codex-plugin`
Expected: canonical package directories exist.

- [ ] **Step 2: Add canonical package README**

Document:
- package purpose
- supported platforms
- install story
- source-of-truth relationship between canonical package and adapters

- [ ] **Step 3: Add canonical skill source**

Write the v2 skill source under `slidesmentor-skill-package/skills/slidesmentor/SKILL.md`.

- [ ] **Step 4: Add canonical NotebookLM prompt template**

Write the prompt template so it follows the v2 contract exactly.

- [ ] **Step 5: Add minimal Claude and Codex adapter files**

Document how each adapter maps back to the canonical source.

### Task 4: Update the repo-local Claude skill and template

**Files:**
- Modify: `.claude/skills/slidesmentor/SKILL.md`
- Modify: `.claude/skills/slidesmentor/templates/notebooklm-prompt.md`

- [ ] **Step 1: Write the failing comparison target**

Use the canonical v2 package skill/template as the target behavior.
Expected: the current repo-local Claude skill and template do not yet match that target.

- [ ] **Step 2: Update the repo-local NotebookLM prompt template**

Change it to:
- keep prompt short
- keep optional short audience/duration lines
- use dynamic `Required coverage:`
- add mandatory visual-style bullets
- keep only 2–4 short negative constraints
- remove verbose source-package/upload-order scaffolding

- [ ] **Step 3: Update the repo-local SKILL.md**

Change it to:
- describe the new prompt contract
- keep upstream pedagogy stages
- distinguish artifact QC from downstream deck review
- stop over-claiming completion after local checks

- [ ] **Step 4: Read back the updated files and verify they match the canonical package**

Confirm repo-local Claude files reflect the canonical source.

### Task 5: Refresh root docs

**Files:**
- Modify: `README.md`
- Modify: `AGENTS.md`

- [ ] **Step 1: Write the failing doc expectation**

Expected new messaging:
- SlidesMentor is a package, not only a Claude skill
- v2 focuses on NotebookLM prompt quality
- deck quality still requires downstream review

- [ ] **Step 2: Update README**

Add:
- v2 positioning
- package architecture
- current platform adapters
- downstream review note

- [ ] **Step 3: Update AGENTS**

Point it at the v2 spec/plan/package source of truth.

### Task 6: Refresh example outputs and QC language

**Files:**
- Modify: `output/notebooklm-prompt.md`
- Modify: `output/qc-report.md`
- Optionally create: deck review rubric doc

- [ ] **Step 1: Rewrite the example NotebookLM prompt**

Make it follow the new contract and reflect:
- short teaching story
- dynamic required coverage
- visual style
- short negative constraints

- [ ] **Step 2: Rewrite QC wording**

Update example QC language so it explicitly distinguishes artifact QC from actual NotebookLM deck review.

- [ ] **Step 3: Add or link a downstream review rubric**

Include concrete review questions for the generated deck.

### Task 7: Verify end-to-end consistency

**Files:**
- Review all new/updated spec, plan, skill, template, package, and example files

- [ ] **Step 1: Check prompt-contract consistency across all files**

Verify the same contract appears in:
- v2 spec
- v2 plan
- canonical package template
- `.claude` template
- sample output

- [ ] **Step 2: Check package/documentation consistency**

Verify README, AGENTS, and package docs describe the same source-of-truth model.

- [ ] **Step 3: Manual downstream validation**

Use the refreshed `output/notebooklm-prompt.md` in NotebookLM Custom Presentations and review the resulting deck against the downstream rubric.
Expected: at least one real NotebookLM run is used before claiming v2 is validated.
