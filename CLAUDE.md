# CLAUDE.md - chezmoi Dotfiles

> Cross-platform dotfiles managed with chezmoi. Migrated from rotz (`~/.charmschool`).

## Before Starting Work

Read `ARCHITECTURE.md` for structure, design decisions, and package lists. Update docs after significant changes.

## Constraints

- **chezmoi is NOT installed** — Do not run chezmoi commands
- **`~/.charmschool` is read-only** — Reference only, never modify
- **No git commits** unless explicitly requested
- **Declarative only** — Changes apply when user runs `chezmoi apply`

## Goals

- **macOS (darwin-full):** Full interactive workstation (GUI apps, fonts, all tools, terminal emulators)
- **Linux (linux-dev):** Dev-focused CLI toolkit for Fly.io Sprites and exe.dev VMs
- Catppuccin Frappe theming, Fish shell primary
- AI-agent-friendly, maintainable structure

## File Structure

```text
.chezmoi.yaml.tmpl         # Machine type auto-detect (darwin-full / linux-dev)
.chezmoidata/packages.yaml # Homebrew packages (darwin + linux sections)
.chezmoiscripts/           # Install/setup scripts (flat, OS logic in templates)
  00-bootstrap             # Homebrew install
  10-install-packages      # brew bundle from packages.yaml
  20-configure-shell       # Fish to /etc/shells, chsh
dot_config/                # → ~/.config/ (fish, git, nvim, starship, yazi, tmux, etc.)
private_dot_ssh/           # → ~/.ssh/ (SSH config + allowed_signers)
dot_claude/                # → ~/.claude/ (rules copied, settings/skills symlinked)
nvim/                      # Symlink source for nvim lockfiles (in .chezmoiignore)
claude/                    # Symlink source for Claude Code files (in .chezmoiignore)
```

## Key Patterns

- **OS conditionals:** `{{ if eq .chezmoi.os "darwin" }}` in `.tmpl` files, or `.chezmoiignore` entries for darwin-only dirs (kitty, karabiner)
- **DOTFILES_HOME:** Set in `00-env.fish.tmpl` to `{{ .chezmoi.sourceDir }}` — use `$DOTFILES_HOME` in abbrs/functions
- **Symlinks:** Only for externally-modified files (nvim lockfiles, Claude settings/skills). Everything else is copied
- **Fish config:** Single `config.fish` loader with numbered `user_conf/` files in 3 namespaces (0n env/tools, 1n languages, 2n interactive)

## Naming Conventions

| Prefix/Suffix | Effect |
| --- | --- |
| `dot_` | Adds leading `.` |
| `private_` | Restricts permissions (0600/0700) |
| `executable_` | Adds execute bit |
| `symlink_` | Creates symlink |
| `.tmpl` | Process as Go template |

## Template Variables

| Variable | Purpose |
| --- | --- |
| `{{ .chezmoi.os }}` | `darwin` or `linux` |
| `{{ .machine.type }}` | `darwin-full` or `linux-dev` |
| `{{ .chezmoi.sourceDir }}` | Path to chezmoi source directory |
| `{{ .packages.<os>.homebrew.* }}` | Package lists (taps, formulae, casks) |

## Commands (when chezmoi is installed)

```bash
chezmoi diff              # Preview changes
chezmoi apply --dry-run   # Safe test
chezmoi cat <file>        # Render template
chezmoi data              # Show template variables
```

## Related Documentation

- `ARCHITECTURE.md` — Full structure, design decisions, package lists, translation patterns
- [chezmoi docs](https://www.chezmoi.io/)
