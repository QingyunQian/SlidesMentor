# Claude Adapter Manifest

Canonical source:
- `../skills/slidesmentor/SKILL.md`
- `../templates/*.md`

Default target:
- `.claude/skills/slidesmentor/`

Sync contract:
- copy canonical `SKILL.md` to target `SKILL.md`
- replace target `templates/*.md` with the canonical template files
- do not edit canonical content inside adapter scripts

Helper scripts:
- `install.sh` installs/syncs canonical files into a target path
