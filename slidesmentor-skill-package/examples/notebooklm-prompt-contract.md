# NotebookLM Prompt Contract Fixture

This fixture captures the expected v2 NotebookLM prompt shape.

Required elements:
- short teaching story block that opens directly with the core claim
- `Narrative priorities:` that steer what gets foregrounded, where to spend time, and how cautious the tone should be
- dynamic `Required coverage:` section with 6-10 default items and flexibility beyond that only when `target_slide_count` warrants it
- `Evidence to show:` with specific paper figures, diagnostics, or result types
- `Image handling:` with figure recreation and explanation rules
- visual style bullets

This exists because NotebookLM already has access to the paper and UI-level controls. The prompt should therefore emphasize teaching decisions, evidence priorities, image usage, and story control rather than generic summary instructions.
