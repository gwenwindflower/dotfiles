# chezmoi Dotfiles Agent Guidance

Cross-platform dotfiles managed with chezmoi. Fish shell and Neovim running on Kitty terminal, with Catppuccin Frappe theming throughout.

OSes supported:

- **macOS:** Full interactive workstation — GUI apps, fonts, terminal emulators, all tools
- **Linux:** Dev-focused CLI toolkit for VMs (exe.dev, Fly.io Sprites) and containers

> [!IMPORTANT]
> You will need to run `chezmoi apply` on new changes for them to propagate to the system. Because of the potentially destructive nature of this command, `chezmoi apply` is under `ask` permissions, but is allowed with the `-n` dry-run flag for testing changes.

## Repo Structure

```text
.chezmoidata/packages.yaml        # Homebrew packages (darwin + linux sections)
.chezmoiscripts/                  # Lifecycle scripts (bootstrap, taps, packages, shell, yazi plugins)
.chezmoiignore                    # Excludes dev files + OS-conditional dirs
.chezmoitemplates/fish/           # Fish config fragment templates (assembled into config.fish)

private_dot_config/               # → ~/.config/
  fish/                           #   config.fish.tmpl + exact_functions/ + exact_completions/ + exact_conf.d/
  nvim/                           #   LazyVim: lua/, snippets/, spell/, lockfile symlinks
  kitty/                          #   Darwin-only (excluded on linux via .chezmoiignore)
  karabiner/                      #   Darwin-only
  tmux/                           #   tmux.conf + statusline + pane-icon script
  starship.toml                   #   Cross-platform prompt
  bat/, fzf/, ripgrep/, tlrc/     #   CLI tool configs
  yazi/                           #   File manager (package.toml symlinked, rest copied)
  mise/, uv/                      #   Language version managers (mise config.toml symlinked)
  delta/, gh/, gh-dash/, meteor/  #   Git ecosystem
  opencode/                       #   OpenCode config (opencode.jsonc + tui.jsonc + exact_agents/)
  bottom/, cmus/, freeze/, glow/  #   System monitor, music player, code snapshots, markdown viewer
  k9s/, lazydocker/, lazygit/     #   Container/cluster/git TUI tools
  lsd/, macchina/                 #   ls replacement, system info
  marimo/, spotify-player/        #   Python notebooks, Spotify TUI
  worktrunk/                      #   Worktrunk config

dot_claude/                       # → ~/.claude/
  keybindings.json, statusline.toml  # Copied normally
  exact_hooks/, exact_agents/     # Pruned-on-apply collections
  symlink_settings.json.tmpl      #   → symsource_claude/settings.json
  symlink_{rules,skills,agents,prompts}.tmpl  # → dot_agents/exact_{rules,skills}/...

dot_agents/                       # → ~/.agents/ (shared agent hub)
  exact_rules/, exact_skills/     # Pruned-on-apply collections (source of truth for shared agent config)

dot_gitconfig.tmpl                # → ~/.gitconfig (main git config, templated for OS)
dot_gitignore_global              # → ~/.gitignore_global
dot_bashrc, dot_zshrc             # Minimal configs (worktrunk init, starship, zoxide)
dot_profile.tmpl, dot_zprofile.tmpl  # Login shells (SHELL export, darwin SSH agent)
private_dot_ssh/                  # → ~/.ssh/ (allowed_signers)

# Symlink source dirs (in .chezmoiignore as `symsource_*/`, not deployed as ~/*)
symsource_nvim/                   # lazy-lock.json, lazyvim.json
symsource_claude/                 # settings.json
symsource_yazi/                   # package.toml
symsource_mise/                   # config.toml
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
| `~/.config/nvim/lazy-lock.json` | `:Lazy sync` updates it | `symsource_nvim/` |
| `~/.config/nvim/lazyvim.json` | LazyVim framework updates it | `symsource_nvim/` |
| `~/.claude/settings.json` | Claude Code edits its own settings | `symsource_claude/` |
| `~/.config/yazi/package.toml` | `ya pkg add` edits it | `symsource_yazi/` |
| `~/.config/mise/config.toml` | `mise use` edits it | `symsource_mise/` |

Source files live in `symsource_*/` dirs at repo root, excluded by `.chezmoiignore` so chezmoi won't deploy them as top-level home dirs. Each symlink is a `symlink_*.tmpl` file containing `{{ .chezmoi.sourceDir }}/symsource_*/path/to/source`.

> [!NOTE]
> `symsource_` is a **repo-local naming convention**, not a chezmoi prefix — chezmoi has no built-in behavior tied to it. We use it purely so a single `symsource_*/` glob in `.chezmoiignore` excludes all symlink-target source dirs at once, and so these dirs are visually distinct from the chezmoi-meaningful `symlink_*` prefix used on actual managed files. Glance at a dir name and you immediately know which side of the symlink relationship it's on.

**When in doubt, copy.** Symlinks add complexity — they bypass template processing, require ignore entries, and create a second thing to reason about. Only reach for them when you'd otherwise lose data (tool writes to the file and chezmoi would overwrite it on next apply).

#### Agent Config Symlinks

There's a different set of symlinks related to coding agent configs, for a different use case. Some agent configs - specifically skills and rules - are largely compatible across agents. Because of this, many agents have standardized on using a unified `~/.agents/` directory for configs. Claude Code remains idiosyncratic with its own `~/.claude/` dir and `CLAUDE.md` files though. As such, we use `dot_agents/` as the source of truth for shared agent configs (deployed via `dot_agents/exact_skills/`, `dot_agents/exact_rules/`, etc.). Then, `dot_claude/` contains symlinks pointing at the applied `~/.agents/skills` and `~/.agents/rules` targets, which surface as `~/.claude/skills` and `~/.claude/rules` respectively. This way, shared configs are edited in one place (`dot_agents/exact_skills/` and friends), applied out to `~/.agents/*` with full reconciliation, and Claude Code picks up those changes via symlink without duplication or drift.

If other file relationships like this arise, where you need a set of files in 2 locations, this is the pattern to follow. Pick a unified source of truth to function like normal chezmoi-managed files, then symlink any secondary locations to those applied source-of-truth files.

### `exact_` dirs: full reconciliation for churn-prone collections

By default chezmoi only adds and updates target files — it never deletes a target file just because the corresponding source file is gone. That's the right default for tool-config dirs that hold a single config file, since other tools may also write into the same target dir. But for our own collections of independently-named *functionality* files (functions, completions, hooks, skills, rules, etc.), it means renamed or deleted source files leave stale ghosts in the target.

The `exact_` directory prefix opts a dir into full reconciliation: on `chezmoi apply`, anything in the target that doesn't exist in source gets deleted. Currently used on:

| Source dir | Target |
| --- | --- |
| `private_dot_config/fish/exact_functions/` | `~/.config/fish/functions/` |
| `private_dot_config/fish/exact_completions/` | `~/.config/fish/completions/` |
| `private_dot_config/fish/exact_conf.d/` | `~/.config/fish/conf.d/` |
| `dot_agents/exact_skills/` | `~/.agents/skills/` |
| `dot_agents/exact_rules/` | `~/.agents/rules/` |
| `dot_claude/exact_hooks/` | `~/.claude/hooks/` |
| `dot_claude/exact_agents/` | `~/.claude/agents/` |
| `private_dot_config/opencode/exact_agents/` | `~/.config/opencode/agents/` |

**When to add `exact_`:** the dir is a collection of independently-named functionality files (not a single tool's mixed config), source-of-truth lives entirely in this repo, and renames/deletions are routine. **When to skip:** the dir holds a single config file, or an external tool also writes into the target (e.g. `~/.config/yazi/plugins/` is populated by `ya pkg install`, so `exact_` would delete those plugins on every apply).

The prefix is stripped on deploy, so `dot_agents/exact_skills/` still produces `~/.agents/skills/` — no other refs need to change when adding it.

### Nerd Font icons

Several files contain Nerd Font glyphs (starship.toml, yazi theme.toml, tmux statusline.conf, pane-icon.sh, nvim dashboard-art.lua, kitty.conf). **Do not Edit these files** — the Edit tool corrupts icon bytes. Use `cp` or Write from a full file read instead. For targeted edits you can give the user a snippet to manually edit themselves.

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
| `exact_` | Dirs only — target is reconciled to match source exactly (deletes anything not in source) |
| `symlink_` | Creates symlink (content = target path) |
| `.tmpl` | Process as Go template before deploying |

These compose freely: `private_dot_config/tmux/executable_pane-icon.sh` → `~/.config/tmux/pane-icon.sh` with 0700 dir + executable file. There are a lot more prefixes, if you need to control some attribute of the target file, there's a good chance there's a prefix to handle it - [you can find them here](https://www.chezmoi.io/reference/source-state-attributes/).

## chezmoi Gotchas

- **`chezmoi add` vs editing source directly:** If you create a new config, either `chezmoi add` it or manually place it in the source tree with correct prefixes. Forgetting `dot_` (or permissions prefixes like `private_`) are the most common mistakes.
- **Template whitespace:** Use `{{-` and `-}}` (with hyphens) to trim surrounding whitespace in templates. Without this, OS-conditional blocks leave blank lines.
- **`.chezmoiignore` is itself a template:** It supports `{{ if }}` blocks for OS-conditional excludes. Syntax errors here silently break everything.
- **Script re-runs:** `run_once_` scripts are tracked by filename + content hash. Renaming a script makes it run again. `run_onchange_` scripts re-run when the content (including template output) changes. Like the file attribute prefixes, these compose freely and there are many more.
- **Symlink targets must be absolute:** Symlink template content should use `{{ .chezmoi.sourceDir }}/...` to produce absolute paths.
- **Order of operations:** Before-scripts → file/symlink updates → after-scripts. Numeric prefixes control ordering within each phase.
- **Never use `.tmpl` as a literal suffix in this tree:** chezmoi renders any `.tmpl` file as a Go template and strips the suffix on deploy. For template-style assets that aren't chezmoi templates (skill scaffolds, workflow stubs, etc.), use `.template`. If you need real templating for those assets, pick a non-Go format like Handlebars or Jinja so it can't collide with chezmoi.

## Commands

### Common tasks

```text
chezmoi diff                    # Preview all pending changes (allowed)
chezmoi apply                   # Apply changes (ask)
chezmoi apply -n                # Dry run (allowed with -n flag)
chezmoi cat <template>          # Render a template e.g. config.fish (allowed)
chezmoi data                    # Show all template variables (allowed)
chezmoi managed                 # List all managed files (allowed)
chezmoi manage/unmanage         # Bring an existing file under chezmoi or remove it (ask)
chezmoi doctor                  # Diagnose setup issues (allowed)
```

### Troubleshooting

```text
chezmoi state delete-bucket --bucket=scriptState  # Reset run_once tracking (ask)
chezmoi apply -n --verbose                        # Dry run with detailed output (allowed)
```

## Related Docs

- `~/.agents/skills/chezmoi/` (source: `dot_agents/exact_skills/chezmoi/`) — Full chezmoi skill with deep reference docs on attributes, templates, scripts, hooks
- [chezmoi documentation](https://www.chezmoi.io) — Official docs, comprehensive reference for all features
