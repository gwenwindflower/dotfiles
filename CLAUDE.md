# CLAUDE.md - chezmoi Dotfiles Migration

> Project: Migrating from rotz (`~/.charmschool`) to chezmoi (`~/.local/share/chezmoi`)

## Before Starting Work

**Read project docs first** before exploring the codebase:

- `ARCHITECTURE.md` — Target structure, source reference, design decisions
- `PLAN.md` — Migration phases, task tracking, verification steps

After significant exploration or changes, update these docs to prevent re-crawling.

## Critical Constraints

- **chezmoi is NOT installed** — Do not attempt installation or run chezmoi commands
- **rotz is read-only** — Never run rotz commands, only read `~/.charmschool` for reference
- **No git commits** unless explicitly requested
- **Declarative only** — Changes won't apply until user runs `chezmoi apply`

## Project Goals

Replicate `~/.charmschool` behavior using chezmoi idioms:

- macOS (darwin) and Linux as first-class targets (macOS priority)
- Maintainable, AI-agent-friendly structure
- Preserve Catppuccin Frappe theming and Fish shell focus

## Quick Reference

### File Structure

```text
.chezmoidata/          # Data files (packages.yaml, fisher.yaml)
.chezmoiscripts/       # Install/setup scripts
  darwin/              # macOS-specific
  linux/               # Linux-specific (future)
dot_config/            # → ~/.config/
nvim/                  # Symlinked, not copied
```

### Naming Conventions

| Prefix/Suffix | Effect |
| --- | --- |
| `dot_` | Adds leading `.` |
| `private_` | Restricts permissions (0600/0700) |
| `executable_` | Adds execute bit |
| `symlink_` | Creates symlink |
| `.tmpl` | Process as Go template |

### Script Naming

Format: `run_[once_|onchange_][before_|after_]<order>-<name>.<ext>[.tmpl]`

Example: `run_once_before_00-bootstrap.fish.tmpl`

### Commands (when user has chezmoi)

```bash
chezmoi diff              # Preview changes
chezmoi apply --dry-run   # Safe test
chezmoi cat <file>        # Render template
chezmoi doctor            # Diagnose issues
```

## Key Patterns

@.claude/rules/rotz-to-chezmoi.md — Translation patterns
@.claude/rules/fish-shell.md — Fish syntax and conventions
@.claude/rules/git-style.md — Commit message style

## Related Documentation

- [chezmoi docs](https://www.chezmoi.io/)
- [rotz docs](https://volllly.github.io/rotz/docs) (source reference only)
