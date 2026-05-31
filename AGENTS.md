# chezmoi Dotfiles Agent Guidance

Cross-platform dotfiles managed with chezmoi. Fish shell and Neovim running on Kitty terminal, with Catppuccin Frappe theming throughout.

OSes supported:

- **macOS:** Full interactive workstation — GUI apps, fonts, terminal emulators, all tools
- **Linux:** Dev-focused CLI toolkit for VMs (exe.dev, Fly.io Sprites) and containers

> [!IMPORTANT]
> You will need to run `chezmoi apply` on new changes for them to propagate to the system. Because of the potentially destructive nature of this command, `chezmoi apply` is under `ask` permissions, but is allowed with the `-n` dry-run flag for testing changes.

## Repo Structure

```text
.chezmoidata/packages.yaml        # Packages: darwin (homebrew + pnpm + uv), linux (apt + pnpm)
.chezmoiscripts/                  # Lifecycle scripts (bootstrap, taps, packages, global tools, shell, yazi plugins, bat cache, ephemeral symlink materialization)
.chezmoiignore                    # Excludes dev files + OS-conditional dirs
.chezmoitemplates/fish/           # Fish config fragment templates (assembled into config.fish)

private_dot_config/               # → ~/.config/
  fish/                           #   config.fish.tmpl + exact_functions/ + exact_completions/ + exact_conf.d/
  nvim/                           #   LazyVim: lua/, snippets/; lockfile + spellfile symlinks back to symsource_nvim/
  kitty/                          #   Darwin-only (excluded on linux via .chezmoiignore)
  karabiner/                      #   Darwin-only
  tmux/                           #   tmux.conf + statusline + pane-icon script
  starship.toml                   #   Cross-platform prompt
  bat/, fzf/, ripgrep/, tlrc/     #   CLI tool configs
  yazi/                           #   File manager (package.toml symlinked, rest copied)
  mise/, uv/                      #   Language version managers (mise config.toml symlinked)
  delta/, gh/, gh-dash/, meteor/  #   Git ecosystem
  git/                            #   Gitconfig fragments included by ~/.gitconfig (os.gitconfig.tmpl, aliases.gitconfig, pretty.gitconfig)
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
  symlink_{rules,skills}.tmpl     #   → ~/.agents/{rules,skills} (post-apply targets)

dot_agents/                       # → ~/.agents/ (shared agent hub)
  exact_rules/, exact_skills/     # Pruned-on-apply collections (source of truth for shared agent config)

symlink_dot_gitconfig.tmpl        # → symsource_git/gitconfig (externally writable; native git [include]s pull fragments from ~/.config/git/)
dot_gitignore_global              # → ~/.gitignore_global
dot_bashrc, dot_zshrc             # Minimal configs (worktrunk init, starship, zoxide)
dot_profile.tmpl, dot_zprofile.tmpl  # Login shells (SHELL export, darwin SSH agent)
private_dot_ssh/                  # → ~/.ssh/ (allowed_signers)

# Symlink source dirs (in .chezmoiignore as `symsource_*/`, not deployed as ~/*)
symsource_nvim/                   # lazy-lock.json, lazyvim.json, spell/en.utf-8.add{,.spl}
symsource_claude/                 # settings.json
symsource_yazi/                   # package.toml
symsource_mise/                   # config.toml
symsource_amoxide/                # config.toml, profiles.toml
symsource_worktrunk/              # config.toml
symsource_git/                    # gitconfig (root config; [include]s ~/.config/git/*.gitconfig fragments)
```

## Key Patterns

### OS conditionals

Two mechanisms, use whichever fits:

- **In `.tmpl` files:** `{{ if eq .chezmoi.os "darwin" }}...{{ end }}`
- **In `.chezmoiignore`:** Exclude entire dirs on non-darwin (kitty, karabiner)

> [!TIP]
> When a `.tmpl` file's entire body is OS-gated, the wrong-OS render evaluates to empty — and chezmoi removes empty files by default (only `empty_`-prefixed sources stay). `private_dot_config/git/os.gitconfig.tmpl` uses this: darwin gets a real `~/.config/git/os.gitconfig`, linux gets nothing on disk. Combined with git's tolerance for missing `[include]` paths, that's a clean OS split with no `if`-wrapped consumer.

### Symlinks: only for externally-modified files

chezmoi copies by default, which is the right call for almost everything — it enables templating, permissions control, and clean state management. **Only symlink files that external tools edit themselves:**

| Symlinked file | Why | Source dir |
| --- | --- | --- |
| `~/.config/nvim/lazy-lock.json` | `:Lazy sync` updates it | `symsource_nvim/` |
| `~/.config/nvim/lazyvim.json` | LazyVim framework updates it | `symsource_nvim/` |
| `~/.config/nvim/spell/en.utf-8.add` | nvim writes new words via `zg` | `symsource_nvim/` |
| `~/.config/nvim/spell/en.utf-8.add.spl` | nvim regenerates the compiled spellfile | `symsource_nvim/` |
| `~/.claude/settings.json` | Claude Code edits its own settings | `symsource_claude/` |
| `~/.config/yazi/package.toml` | `ya pkg add` edits it | `symsource_yazi/` |
| `~/.config/mise/config.toml` | `mise use` edits it | `symsource_mise/` |
| `~/.config/amoxide/config.toml` | `amoxide` CLI edits aliases | `symsource_amoxide/` |
| `~/.config/amoxide/profiles.toml` | `amoxide` CLI edits profiles | `symsource_amoxide/` |
| `~/.config/worktrunk/config.toml` | `wt` CLI edits its own config | `symsource_worktrunk/` |
| `~/.gitconfig` | `git config --global` writes through to source | `symsource_git/` |

Source files live in `symsource_*/` dirs at repo root, excluded by `.chezmoiignore` so chezmoi won't deploy them as top-level home dirs. Each symlink is a `symlink_*.tmpl` file containing `{{ .chezmoi.sourceDir }}/symsource_*/path/to/source`.

> [!NOTE]
> `symsource_` is a **repo-local naming convention**, not a chezmoi prefix — chezmoi has no built-in behavior tied to it. We use it purely so a single `symsource_*/` glob in `.chezmoiignore` excludes all symlink-target source dirs at once, and so these dirs are visually distinct from the chezmoi-meaningful `symlink_*` prefix used on actual managed files. Glance at a dir name and you immediately know which side of the symlink relationship it's on.

**When in doubt, copy.** Symlinks add complexity — they bypass template processing, require ignore entries, and create a second thing to reason about. Only reach for them when you'd otherwise lose data (tool writes to the file and chezmoi would overwrite it on next apply).

#### `--one-shot` and ephemeral installs

`chezmoi init --one-shot` purges the source dir after applying, which would dangle every `symsource_*` symlink. Bootstrappers for ephemeral targets (Fly Sprites, exe.dev VMs, Docker images) **must** export `CHEZMOI_ONESHOT=1` before invoking init. The `run_after_99-materialize-symsource-symlinks.sh.tmpl` script picks up the flag and replaces each symlink with a copy of its target before purge fires. Drift back to source is moot in ephemeral envs, so copies are the right shape.

The env var is the only knob — no config-file flag, no template detection. Set it on the parent process; it propagates to chezmoi and to the apply-phase scripts.

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

### Fish plugins (tackle)

Third-party fish plugins (functions, conf.d, completions, themes from upstream repos) are managed by [`tackle`](https://github.com/gwenwindflower/tackle), a personal, modern fish plugin manager. The manifest at is, by default, co-located with the fish configs at `private_dot_config/fish/tacklebox.yaml`. This manifest lists plugins (managed via `tackle add` and `tackle remove`) as a `repo + pinned SHA + files` object; `tackle sync` reconciles plugin files against the latest HEAD of each repo. Then `chezmoi add` (or `re-add`) to pull the updates into chezmoi.

We initially rolled our own instead of Fisher because Fisher assumes it owns the install dir, but chezmoi is already tracking the content Fisher wants to install or update for existing plugins — even on a new machine — so `fisher update` failed every plugin and then "helpfully" cleared the manifest of any failed installs. To address this tackle is stateless beyond the manifest and idempotent, if HEAD on main has moved for the plugin, it will sync new versions of the files (and add or remove if needed). Users are responsible for tracking these changes wherever they'd prefer. After solving the initial problem it became clear having a more modern, testable tool was useful here, so `tackle` is evolving from there.

Plugin file extraction matches Fisher's: top-level files in `functions/`, `completions/`, `conf.d/` (extension `.fish`) and `themes/` (extension `.theme`). Subdirectories under those are intentionally skipped for the time being.

## Scripts

```text
.chezmoiscripts/
  run_once_before_00-bootstrap.sh.tmpl           # darwin: install Homebrew
  run_once_05-add-taps.sh.tmpl                   # darwin: add Homebrew taps (retry + verify)
  run_once_10-install-homebrew-packages.sh.tmpl  # darwin: brew bundle (formulae + casks)
  run_once_10-install-apt-packages.sh.tmpl       # linux: apt install (dpkg-s presence check + upgrade)
  run_once_15-install-global-tools.sh.tmpl       # Global CLIs via pnpm + uv (uv darwin-only)
  run_once_20-configure-shell.sh.tmpl            # Fish → /etc/shells, chsh
  run_once_30-yazi-plugins.sh.tmpl               # ya pkg install (yazi plugin sync)
  run_once_31-bat-cache.sh.tmpl                  # Build bat theme cache (after themes deployed)
  run_after_99-materialize-symsource-symlinks.sh.tmpl  # One-shot ephemeral support (gated on CHEZMOI_ONESHOT=1)
```

Scripts are a surface to minimize. Each is an imperative action that can fail. If something can be a file, make it a file. `run_once_` runs once per content hash — on a fresh machine all fire on first apply. `run_onchange_` re-runs when rendered content changes (also fires on first apply since no previous hash → new hash = change).

**Linux package philosophy:** apt only, manually curated in `packages.yaml` under `linux.apt.packages`. Linuxbrew is intentionally not used — too heavy for the small-VM Linux use case. Tools not in standard apt repos (yazi, mise, rm-improved, vivid, lsd, zoxide, starship, sd, forgit, lazygit, neovim) are installed via mise or direct binary download. The apt install script checks `dpkg -s` for each package and only fetches what's missing — fast on Sprites/exe machines that arrive pre-loaded. `packy` does **not** snapshot apt (the curated list is the source of truth, not the live system).

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
