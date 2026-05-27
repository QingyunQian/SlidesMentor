# Codex Adapter

This adapter syncs canonical SlidesMentor files into a Codex skill layout. The target skill directory is treated as generated adapter output.

Canonical source:
- `../skills/slidesmentor/SKILL.md`
- `../templates/*.md`

Default target:
- `${CODEX_HOME:-$HOME/.codex}/skills/slidesmentor/`

## Files

- `adapter-manifest.md` - mapping and sync contract
- `install.sh` - install/sync script that replaces target `templates/*.md`

## Usage

Install to the default Codex skills directory:

```bash
bash slidesmentor-skill-package/.codex-plugin/install.sh
```

Install to a custom path:

```bash
bash slidesmentor-skill-package/.codex-plugin/install.sh /custom/codex/skills/slidesmentor
```
