# Codex Adapter Manifest

Canonical source:
- `../skills/slidesmentor/SKILL.md`
- `../templates/*.md`

Default target:
- `${CODEX_HOME:-$HOME/.codex}/skills/slidesmentor/`

Sync contract:
- copy canonical `SKILL.md` to target `SKILL.md`
- copy all canonical template files to target `templates/`
- keep adapter behavior minimal and content-preserving

Helper scripts:
- `install.sh` installs/syncs canonical files into a Codex skill path
