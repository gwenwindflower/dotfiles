# CLAUDE.md — chezmoi Dotfiles

Cross-platform dotfiles managed with chezmoi. Fish shell primary, Catppuccin Frappe theming throughout.

- **macOS:** Full interactive workstation — GUI apps, fonts, terminal emulators, all tools
- **Linux:** Dev-focused CLI toolkit for persistent VMs (exe.dev, Fly.io Sprites)

## Constraints

- **chezmoi is NOT installed** on dev VMs — do not run chezmoi commands
- Changes are declarative — nothing applies until the user runs `chezmoi apply`

## Repo Structure

```text
.chezmoidata/packages.yaml       # Homebrew packages (darwin + linux sections)
.chezmoiscripts/                  # Lifecycle scripts (bootstrap, taps, packages, shell, yazi plugins)
.chezmoiignore                    # Excludes dev files + OS-conditional dirs
.chezmoitemplates/fish/           # Fish config fragment templates (assembled into config.fish)

private_dot_config/               # → ~/.config/
  fish/                           #   Assembled config.fish.tmpl + 91 functions + conf.d + completions
  nvim/                           #   LazyVim: lua/, snippets/, spell/, lockfile symlinks
  kitty/                          #   Darwin-only (excluded on linux via .chezmoiignore)
  karabiner/                      #   Darwin-only
  tmux/                           #   tmux.conf + statusline + pane-icon script
  starship.toml                   #   Cross-platform prompt
  bat/, fzf/, ripgrep/, tlrc/     #   CLI tool configs
  yazi/                           #   File manager (package.toml symlinked, rest copied)
  mise/, uv/                      #   Language version managers (mise config.toml symlinked)
  delta/, gh/, gh-dash/, meteor/  #   Git ecosystem
  opencode/                       #   OpenCode config (opencode.jsonc + tui.jsonc)
  bottom/, cmus/, freeze/, glow/  #   System monitor, music player, code snapshots, markdown viewer
  k9s/, lazydocker/, lazygit/     #   Container/cluster/git TUI tools
  lsd/, macchina/                 #   ls replacement, system info
  marimo/, spotify-player/        #   Python notebooks, Spotify TUI
  worktrunk/                      #   Worktrunk config

dot_claude/                       # → ~/.claude/
  keybindings.json, statusline.toml  # Copied normally
  symlink_settings.json.tmpl      #   → symlink_claude/settings.json
  symlink_{rules,skills,agents,prompts}.tmpl  # → symlink_agents/*

dot_agents/                       # → ~/.agents/ (shared agent hub)
  symlink_{rules,skills,agents,prompts}.tmpl  # → symlink_agents/*

dot_gitconfig.tmpl                # → ~/.gitconfig (main git config, templated for OS)
dot_gitignore_global              # → ~/.gitignore_global
dot_bashrc, dot_zshrc             # Minimal configs (worktrunk init, starship, zoxide)
dot_profile.tmpl, dot_zprofile.tmpl  # Login shells (SHELL export, darwin SSH agent)
private_dot_ssh/                  # → ~/.ssh/ (allowed_signers)

# Symlink source dirs (in .chezmoiignore, not deployed as ~/*)
symlink_nvim/                     # lazy-lock.json, lazyvim.json
symlink_claude/                   # settings.json
symlink_yazi/                     # package.toml
symlink_mise/                     # config.toml
symlink_agents/                   # rules/, skills/, agents/, prompts/
```

## Key Patterns

### OS conditionals

Two mechanisms, use whichever fits:

- **In `.tmpl` files:** `{{ if eq .chezmoi.os "darwin" }}...{{ end }}`
- **In `.chezmoiignore`:** Exclude entire dirs on non-darwin (kitty, karabiner)

### Symlinks: only for externally-modified files

chezmoi copies by default, which is the right call for almost everything — it enables templating, permissions control, and clean state management. **Only symlink files that external tools edit themselves:**

| Symlinked file | Why | Source dir |
| --- | --- | --- |
| `~/.config/nvim/lazy-lock.json` | `:Lazy sync` updates it | `symlink_nvim/` |
| `~/.config/nvim/lazyvim.json` | LazyVim framework updates it | `symlink_nvim/` |
| `~/.claude/settings.json` | Claude Code edits its own settings | `symlink_claude/` |
| `~/.config/yazi/package.toml` | `ya pkg add` edits it | `symlink_yazi/` |
| `~/.config/mise/config.toml` | `mise use` edits it | `symlink_mise/` |
| `~/.agents/*`, `~/.claude/{rules,skills,agents,prompts}` | Shared agent content, skill installs | `symlink_agents/` |

Source files live in `symlink_*/` dirs at repo root, excluded by `.chezmoiignore` so chezmoi won't deploy them as top-level home dirs. Each symlink is a `symlink_*.tmpl` file containing `{{ .chezmoi.sourceDir }}/symlink_*/path/to/source`.

**When in doubt, copy.** Symlinks add complexity — they bypass template processing, require ignore entries, and create a second thing to reason about. Only reach for them when you'd otherwise lose data (tool writes to the file and chezmoi would overwrite it on next apply).

### Nerd Font icons

Several files contain Nerd Font glyphs (starship.toml, yazi theme.toml, tmux statusline.conf, pane-icon.sh, nvim dashboard-art.lua, kitty.conf). **Do not Edit these files** — the Edit tool corrupts icon bytes. Use `cp` or Write from a full file read instead.

### Fish config assembly

`config.fish` is built from numbered fragment templates at apply time:

- **Assembler:** `private_dot_config/fish/config.fish.tmpl` — `{{ template }}` includes each fragment
- **Fragments:** `.chezmoitemplates/fish/*.fish` — 15 numbered files (`00-core-env` through `24-tools`)
- **Dynamic command capture:** `{{ output "command" "args" }}` runs commands during `chezmoi apply` and bakes their output directly into the rendered config.fish, so shell startup pays zero cost for `brew shellenv`, `starship init`, `zoxide init`, `vivid generate`, etc.

Fragment ordering: `00–14` are environment setup (PATH, XDG, editor, git, AI, language toolchains), `20–24` are interactive-only (theme, abbreviations, keybindings, tool config) wrapped in `if status is-interactive`.

## Scripts

```text
.chezmoiscripts/
  run_once_before_00-bootstrap.sh.tmpl     # Install Homebrew
  run_once_05-add-taps.sh.tmpl             # Add Homebrew taps (with retry + verification)
  run_once_10-install-packages.sh.tmpl     # brew bundle (formulae + casks, taps already done)
  run_once_20-configure-shell.sh.tmpl      # Fish → /etc/shells, chsh
  run_onchange_40-yazi-plugins.fish.tmpl   # ya pkg install (on package.toml change)
```

Scripts are a surface to minimize. Each is an imperative action that can fail. If something can be a file, make it a file. `run_once_` runs once per content hash — on a fresh machine all fire on first apply. `run_onchange_` re-runs when rendered content changes (also fires on first apply since no previous hash → new hash = change).

## chezmoi Naming Reference

| Prefix/Suffix | Effect |
| --- | --- |
| `dot_` | Adds leading `.` to target |
| `private_` | Sets 0600/0700 permissions |
| `executable_` | Sets +x permission |
| `symlink_` | Creates symlink (content = target path) |
| `.tmpl` | Process as Go template before deploying |

These compose freely: `private_dot_config/tmux/executable_pane-icon.sh` → `~/.config/tmux/pane-icon.sh` with 0700 dir + executable file.

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

- `symlink_agents/skills/chezmoi/` — Full chezmoi skill with deep reference docs on attributes, templates, scripts, hooks
