# NotebookLM Prompt Contract Fixture

This fixture captures the expected v2 NotebookLM prompt shape.

Required elements:
- short task sentence
- audience line only when it materially helps
- duration line only when it materially helps
- short teaching story block
- dynamic `Required coverage:` section with 8-12 default items and flexibility beyond that when `target_slide_count` warrants it
- visual style bullets
- short `Do NOT include:` block

This exists to make the old verbose template clearly fail comparison against the v2 contract.
