# Claude Adapter

This adapter syncs canonical SlidesMentor files into a Claude-style skill layout. The target skill directory is treated as generated adapter output.

Canonical source:
- `../skills/slidesmentor/SKILL.md`
- `../templates/*.md`

Default target:
- `.claude/skills/slidesmentor/`

## Files

- `adapter-manifest.md` - mapping and sync contract
- `install.sh` - install/sync script that replaces target `templates/*.md`

## Usage

From repository root:

```bash
bash slidesmentor-skill-package/.claude-plugin/install.sh
```

Install to a custom path:

```bash
bash slidesmentor-skill-package/.claude-plugin/install.sh /path/to/.claude/skills/slidesmentor
```
