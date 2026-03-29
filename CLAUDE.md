# CLAUDE.md — chezmoi Dotfiles

Cross-platform dotfiles managed with chezmoi. Fish shell primary, Catppuccin Frappe theming throughout.

- **macOS:** Full interactive workstation — GUI apps, fonts, terminal emulators, all tools
- **Linux:** Dev-focused CLI toolkit for persistent VMs (exe.dev, Fly.io Sprites)

Recently migrated from rotz (`~/.charmschool`). The old repo is read-only reference; periodic adjustments may be needed as edge cases surface during transition.

## Constraints

- **chezmoi is NOT installed** on dev VMs — do not run chezmoi commands
- **`~/.charmschool` is read-only** — reference only, never modify
- Changes are declarative — nothing applies until the user runs `chezmoi apply`

## Repo Structure

```text
.chezmoidata/packages.yaml      # Homebrew packages (darwin + linux sections)
.chezmoiscripts/                # Lifecycle scripts (bootstrap, packages, shell, yazi plugins)
.chezmoiignore                  # Excludes dev files + OS-conditional dirs

dot_config/                     # → ~/.config/
  fish/                         #   Single config.fish.tmpl + 91 functions + conf.d + completions
  nvim/                         #   LazyVim: lua/, snippets/, spell/, lockfile symlinks
  kitty/                        #   Darwin-only (excluded on linux via .chezmoiignore)
  karabiner/                    #   Darwin-only
  tmux/                         #   tmux.conf + statusline + pane-icon script
  starship.toml                 #   Cross-platform prompt
  bat/, fzf/, ripgrep/, tlrc/   #   CLI tool configs
  yazi/                         #   File manager (package.toml is symlinked, rest copied)
  mise/, uv/                    #   Language version managers
  delta/, gh/, gh-dash/, meteor/ #  Git ecosystem
  opencode/                     #   OpenCode agent config

dot_claude/                     # → ~/.claude/
  keybindings.json, statusline.toml  # Copied normally
  symlink_settings.json.tmpl    #   → claude/settings.json (Claude edits this itself)
  symlink_{rules,skills,agents,prompts}.tmpl  # → agents/*

dot_agents/                     # → ~/.agents/ (shared agent hub)
  symlink_{rules,skills,agents,prompts}.tmpl  # → agents/*

dot_gitconfig.tmpl              # → ~/.gitconfig (main git config, templated for OS)
dot_gitignore_global            # → ~/.gitignore_global
dot_bashrc, dot_zshrc           # Minimal configs (worktrunk init, starship, zoxide)
dot_profile.tmpl, dot_zprofile.tmpl  # Login shells (SHELL export, darwin SSH agent)
private_dot_ssh/                # → ~/.ssh/ (config + allowed_signers)

# Symlink source dirs (in .chezmoiignore, not deployed as ~/*)
nvim/                           # lazy-lock.json, lazyvim.json
claude/                         # settings.json
yazi/                           # package.toml
agents/                         # rules/, skills/, agents/, prompts/
```

## Key Patterns

### OS conditionals

Two mechanisms, use whichever fits:

- **In `.tmpl` files:** `{{ if eq .chezmoi.os "darwin" }}...{{ end }}`
- **In `.chezmoiignore`:** Exclude entire dirs on non-darwin (kitty, karabiner)

### Symlinks: only for externally-modified files

chezmoi copies by default, which is the right call for almost everything — it enables templating, permissions control, and clean state management. **Only symlink files that external tools edit themselves:**

| Symlinked file | Why | Source |
| --- | --- | --- |
| `~/.config/nvim/lazy-lock.json` | `:Lazy sync` updates it | `nvim/lazy-lock.json` |
| `~/.config/nvim/lazyvim.json` | LazyVim framework updates it | `nvim/lazyvim.json` |
| `~/.claude/settings.json` | Claude Code edits its own settings | `claude/settings.json` |
| `~/.config/yazi/package.toml` | `ya pkg add` edits it | `yazi/package.toml` |
| `~/.agents/*`, `~/.claude/{rules,skills,agents,prompts}` | Shared agent content, skill installs | `agents/*` |

Source files live at repo root in `.chezmoiignore` so chezmoi won't also deploy them as top-level home dirs. Each symlink is a `symlink_*.tmpl` file containing `{{ .chezmoi.sourceDir }}/path/to/source`.

**When in doubt, copy.** Symlinks add complexity — they bypass template processing, require ignore entries, and create a second thing to reason about. Only reach for them when you'd otherwise lose data (tool writes to the file and chezmoi would overwrite it on next apply).

### Nerd Font icons

Several files contain Nerd Font glyphs (starship.toml, yazi theme.toml, tmux statusline.conf, pane-icon.sh, nvim dashboard-art.lua, kitty.conf). **Do not Edit these files** — the Edit tool corrupts icon bytes. Use `cp` or Write from a full file read instead.

## Scripts

```text
.chezmoiscripts/
  run_once_before_00-bootstrap.sh.tmpl     # Install Homebrew
  run_onchange_10-install-packages.sh.tmpl # brew bundle from packages.yaml
  run_once_20-configure-shell.sh.tmpl      # Fish → /etc/shells, chsh
  run_onchange_40-yazi-plugins.fish.tmpl   # ya pkg install (on package.toml change)
```

Scripts are a surface to minimize. Each is an imperative action that can fail. If something can be a file, make it a file. `run_onchange_` fires on first apply too (no previous hash → new hash = change).

## chezmoi Naming Reference

| Prefix/Suffix | Effect |
| --- | --- |
| `dot_` | Adds leading `.` to target |
| `private_` | Sets 0600/0700 permissions |
| `executable_` | Sets +x permission |
| `symlink_` | Creates symlink (content = target path) |
| `.tmpl` | Process as Go template before deploying |

These compose freely: `dot_config/tmux/executable_pane-icon.sh` → `~/.config/tmux/pane-icon.sh` with +x.

## chezmoi Gotchas

- **`chezmoi add` vs editing source directly:** If you create a new config, either `chezmoi add` it or manually place it in the source tree with correct prefixes. Forgetting `dot_` is the most common mistake.
- **Template whitespace:** Use `{{-` and `-}}` (with hyphens) to trim surrounding whitespace in templates. Without this, OS-conditional blocks leave blank lines.
- **`.chezmoiignore` is itself a template:** It supports `{{ if }}` blocks for OS-conditional excludes. Syntax errors here silently break everything.
- **Script re-runs:** `run_once_` scripts are tracked by filename + content hash. Renaming a script makes it run again. `run_onchange_` scripts re-run when the content (including template output) changes.
- **Symlink targets must be absolute:** Symlink template content should use `{{ .chezmoi.sourceDir }}/...` to produce absolute paths.
- **Order of operations:** Before-scripts → file/symlink updates → after-scripts. Numeric prefixes control ordering within each phase.

## Commands (when chezmoi is available)

```bash
chezmoi diff                    # Preview all pending changes
chezmoi apply -n -v             # Dry run with verbose output
chezmoi apply                   # Apply changes
chezmoi cat ~/.config/fish/config.fish  # Render a template to see output
chezmoi data                    # Show all template variables
chezmoi managed                 # List all managed files
chezmoi manage/unmanage         # Bring an existing file under chezmoi or remove it from chezmoi control
chezmoi doctor                  # Diagnose setup issues
chezmoi state delete-bucket --bucket=scriptState  # Reset run_once tracking
```

## Related Docs

- `agents/skills/chezmoi/` — Full chezmoi skill with deep reference docs on attributes, templates, scripts, hooks
