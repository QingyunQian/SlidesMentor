# QC Report Example

## Scope
- Paper-only mode
- Audience: grad-intro
- Scenario: group meeting
- Duration: 20 min

## Artifact QC checks
- Teaching Summary is not a rewritten abstract and includes explicit teach/skip decisions: PASS
- Every slide in the outline has exactly one pedagogical purpose: PASS
- NotebookLM prompt is short and high-signal: PASS
- NotebookLM prompt contains a concrete teaching story: PASS
- Required coverage is paper-specific and appropriately sized for the deck: PASS
- Visual style explicitly requires white background, black text, and colorful figures/diagrams: PASS
- Negative constraints remain short and high-value: PASS
- Lecture Script follows the teaching reframe rather than paper section order: PASS

## Notes
- This report validates local SlidesMentor artifacts only.
- It does not prove that NotebookLM generated a high-quality final deck.
- The paper was processed in paper-only mode, so no `output/code-relevance-map.md` was generated.

## Downstream deck review required
After running NotebookLM Custom Presentations, review the actual deck for:
- alignment with the intended teaching story
- recognizable coverage of the required topics
- no drift into abstract-summary slides
- white-background academic styling
- acceptable text density
- useful figures and diagrams

## Unresolved flags
- NotebookLM deck quality is still unverified until a real generated deck is reviewed.
