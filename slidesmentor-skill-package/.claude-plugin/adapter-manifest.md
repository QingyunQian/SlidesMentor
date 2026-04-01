# Claude Adapter Manifest

Canonical source:
- `../skills/slidesmentor/SKILL.md`
- `../templates/*.md`

Default target:
- `.claude/skills/slidesmentor/`

Sync contract:
- copy canonical `SKILL.md` to target `SKILL.md`
- copy all canonical template files to target `templates/`
- do not edit canonical content inside adapter scripts

Helper scripts:
- `install.sh` installs/syncs canonical files into a target path
