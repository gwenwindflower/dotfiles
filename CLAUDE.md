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

- **macOS (darwin):** Full interactive workstation (all apps, fonts, tools, terminal emulators)
- **Linux:** Stripped-down, dev-focused toolkit (CLI tools, languages, shell, editor)
- Target Linux environments: **Fly.io Sprites** and **exe.dev VMs**
- Maintainable, AI-agent-friendly structure
- Preserve Catppuccin Frappe theming and Fish shell focus

## Quick Reference

### File Structure

```text
.chezmoi.yaml.tmpl     # Machine type auto-detect (darwin-full / linux-dev)
.chezmoidata/          # Data files (packages.yaml)
.chezmoiscripts/       # Install/setup scripts (flat, OS logic in templates)
dot_config/            # → ~/.config/
private_dot_ssh/       # → ~/.ssh/ (SSH config + allowed_signers)
nvim/                  # Symlinked, not copied
claude/                # Claude Code config (symlinked, not copied)
```

### Naming Conventions

| Prefix/Suffix | Effect |
| --- | --- |
| `dot_` | Adds leading `.` |
| `private_` | Restricts permissions (0600/0700) |
| `executable_` | Adds execute bit |
| `symlink_` | Creates symlink |
| `.tmpl` | Process as Go template |

### Key Template Variables

| Variable | Purpose |
| --- | --- |
| `{{ .chezmoi.os }}` | `darwin` or `linux` |
| `{{ .machine.type }}` | `darwin-full` or `linux-dev` |
| `{{ .chezmoi.sourceDir }}` | Path to chezmoi source directory |
| `{{ .packages.darwin.homebrew.* }}` | macOS package lists |
| `{{ .packages.linux.homebrew.* }}` | Linux package lists |

### Script Naming

Format: `run_[once_|onchange_][before_|after_]<order>-<name>.<ext>[.tmpl]`

Example: `run_once_before_00-bootstrap.sh.tmpl`

### Commands (when user has chezmoi)

```bash
chezmoi diff              # Preview changes
chezmoi apply --dry-run   # Safe test
chezmoi cat <file>        # Render template
chezmoi doctor            # Diagnose issues
chezmoi data              # Show template variables
```

## Key Patterns

- **Darwin-only content:** Use `{{ if eq .chezmoi.os "darwin" }}` guards in `.tmpl` files, or OS-conditional `.chezmoiignore` entries
- **DOTFILES_HOME:** Set in `00-env.fish.tmpl` to `{{ .chezmoi.sourceDir }}`. Use `$DOTFILES_HOME` in abbrs/functions instead of hardcoded paths
- **Symlink sparingly:** Only symlink files modified by external tools (lockfiles, agent settings, skill dirs). Use `symlink_` prefix inline at target path, with source files at repo root in `.chezmoiignore`
- **Copy by default:** Everything else uses normal chezmoi workflow — `dot_` prefix, optional `.tmpl` for templating

## Related Documentation

- [chezmoi docs](https://www.chezmoi.io/)
- [rotz docs](https://volllly.github.io/rotz/docs) (source reference only)
