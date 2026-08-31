# chezmoi Dotfiles Agent Guidance

Cross-platform dotfiles managed with chezmoi. Fish shell and Neovim running on Kitty terminal, with Catppuccin Frappe theming throughout.

OSes supported:

- **macOS:** Full interactive workstation — GUI apps, fonts, terminal emulators, all tools
- **Linux:** Dev-focused CLI toolkit for VMs (exe.dev, Fly.io Sprites) and containers

> [!IMPORTANT]
> You will need to run `chezmoi apply` on new changes for them to propagate to the system. Because of the potentially destructive nature of this command, `chezmoi apply` is under `ask` permissions, but is allowed with the `-n` dry-run flag for testing changes.

## Repo Structure

```text
.chezmoidata/packages.yaml        # Packages: darwin (homebrew + uv), linux (apt). JS/TS globals live in symsources/mise/config-<arch>.toml.
.chezmoiscripts/                  # Lifecycle scripts (bootstrap, taps, packages, global tools, mise install, shell, yazi plugins, bat cache, ephemeral symlink materialization)
.chezmoiignore                    # Excludes dev files + OS-conditional dirs
.chezmoitemplates/fish/           # Fish config fragment templates (assembled into config.fish)
.chezmoitemplates/agents/         # Shared agent prompt/rule fragments (assembled into platform guidance files)

docs/                             # Repo-level reference docs (chezmoi-ignored); agent-config.md + capabilities/
tmp/                              # Scratch space (git- and chezmoi-ignored); plans, reviews, references

private_dot_config/               # → ~/.config/
  fish/                           #   config.fish.tmpl + exact_functions/ + exact_completions/ + exact_conf.d/
  nvim/                           #   LazyVim: lua/, snippets/; lockfile + spellfile symlinks back to symsources/nvim/
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
  llama-embed/                    #   Darwin-only launchd plist for the local llama.cpp embedding server (managed on demand by the llup fish function)
  lsd/, macchina/                 #   ls replacement, system info
  marimo/, spotify-player/        #   Python notebooks, Spotify TUI
  herdr/                          #   Herdr config (symlinked), plugins are not included in chezmoi as they can be installed idempotently via herdr
  worktrunk/                      #   Worktrunk config

dot_claude/                       # → ~/.claude/
  keybindings.json, statusline.toml  # Copied normally
  exact_hooks/, exact_agents/     # Pruned-on-apply collections
  symlink_settings.json.tmpl      #   → symsources/claude/settings.json
  symlink_skills.tmpl             #   → ~/.agents/skills (post-apply target)

dot_agents/                       # → ~/.agents/ (shared agent hub)
  AGENTS.md.tmpl                  #   → ~/.agents/AGENTS.md, assembled from .chezmoitemplates/agents/
  exact_rules/                    #   → ~/.agents/rules/ generated from .chezmoitemplates/agents/rules/
  exact_skills/                   # Pruned-on-apply skill collection

symlink_dot_gitconfig.tmpl        # → symsources/git/gitconfig (externally writable; native git [include]s pull fragments from ~/.config/git/)
dot_gitignore_global              # → ~/.gitignore_global
dot_bashrc, dot_zshrc             # Minimal configs (worktrunk init, starship, zoxide)
dot_profile.tmpl, dot_zprofile.tmpl  # Login shells (SHELL export, darwin SSH agent)
private_dot_ssh/                  # → ~/.ssh/ (allowed_signers)

# Symlink sources (ignored as `symsources/`, not deployed as ~/symsources)
symsources/nvim/                  # lazy-lock.json, lazyvim.json, spell/en.utf-8.add{,.spl}
symsources/claude/                # settings.json
symsources/codex/                 # config.toml
symsources/yazi/                  # package.toml
symsources/mise/                  # config-arm64.toml (aube), config-amd64.toml (pnpm) — symlink picks by .chezmoi.arch
symsources/uv/                    # .python-version
symsources/aube/                  # config.toml
symsources/amoxide/               # config.toml, profiles.toml
symsources/herdr/                 # config.toml
symsources/worktrunk/             # config.toml
symsources/git/                   # gitconfig (root config; [include]s pull fragments from ~/.config/git/)
```

## Key Patterns

### Repo docs

`docs/` holds repo-level reference docs — chezmoi-ignored, so they stay in the repo and never deploy to `~`. One file per domain, loaded on demand: durable explanation belongs there rather than in this file. Docs scoped to a subtree live with it, like `.utils/docs/` for the Deno utilities.

### Scratch space

`tmp/` is the home for anything transient — plans, review notes, research, references, generated output. Its contents are ignored by both git and chezmoi (only `.gitkeep` is tracked), so nothing there leaks into a commit or deploys to `~`. Put scratch work there instead of at the repo root; root-level files need their own ignore entries and are easy to commit by accident.

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
| `~/.config/nvim/lazy-lock.json` | `:Lazy sync` updates it | `symsources/nvim/` |
| `~/.config/nvim/lazyvim.json` | LazyVim framework updates it | `symsources/nvim/` |
| `~/.config/nvim/spell/en.utf-8.add` | nvim writes new words via `zg` | `symsources/nvim/` |
| `~/.config/nvim/spell/en.utf-8.add.spl` | nvim regenerates the compiled spellfile | `symsources/nvim/` |
| `~/.claude/settings.json` | Claude Code edits its own settings | `symsources/claude/` |
| `~/.codex/config.toml` | Codex writes trust, hooks, plugins, and skill state | `symsources/codex/` |
| `~/.config/yazi/package.toml` | `ya pkg add` edits it | `symsources/yazi/` |
| `~/.config/mise/config.toml` | `mise use` edits it | `symsources/mise/config-{arm64,amd64}.toml` |
| `~/.config/uv/.python-version` | `uv python pin --global` writes it | `symsources/uv/` |
| `~/.config/aube/config.toml` | `aube config` edits it | `symsources/aube/` |
| `~/.config/amoxide/config.toml` | `amoxide` CLI edits aliases | `symsources/amoxide/` |
| `~/.config/amoxide/profiles.toml` | `amoxide` CLI edits profiles | `symsources/amoxide/` |
| `~/.config/herdr/config.toml` | `herdr` writes its own config | `symsources/herdr/` |
| `~/.config/worktrunk/config.toml` | `wt` CLI edits its own config | `symsources/worktrunk/` |
| `~/.gitconfig` | `git config --global` writes through to source | `symsources/git/` |

Source files live in `symsources/<tool>/`, excluded by `.chezmoiignore` so chezmoi won't deploy them as `~/symsources`. Each symlink is a `symlink_*.tmpl` file containing `{{ .chezmoi.sourceDir }}/symsources/<tool>/path/to/source`.

> [!NOTE]
> `symsources/` is a **repo-local naming convention**, not a chezmoi feature. It keeps externally-written symlink targets out of the root tree while `symlink_*` files stay at their managed target paths.

**When in doubt, copy.** Symlinks add complexity — they bypass template processing, require ignore entries, and create a second thing to reason about. Only reach for them when you'd otherwise lose data (tool writes to the file and chezmoi would overwrite it on next apply).

#### `--one-shot` and ephemeral installs

`chezmoi init --one-shot` purges the source dir after applying, which would dangle every symlink into `symsources/`. Bootstrappers for ephemeral targets (Fly Sprites, exe.dev VMs, Docker images) **must** export `CHEZMOI_ONESHOT=1` before invoking init. The `run_after_99-materialize-symsource-symlinks.sh.tmpl` script picks up the flag and replaces each symlink with a copy of its target before purge fires. Drift back to source is moot in ephemeral envs, so copies are the right shape.

The env var is the only knob — no config-file flag, no template detection. Set it on the parent process; it propagates to chezmoi and to the apply-phase scripts.

#### Agent Config Templates

Shared agent rules live in `.chezmoitemplates/agents/rules/`. The platform root files (`~/.agents/AGENTS.md`, `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, and `~/.config/opencode/AGENTS.md`) render `.chezmoitemplates/agents/AGENTS.md`, which includes those fragments with native `{{ template }}` calls.

`dot_agents/exact_rules/*.md.tmpl` are generated wrappers for tools and skill docs that still read `~/.agents/rules/*.md` directly. Edit the `.chezmoitemplates/agents/rules/` fragments, not the wrappers. Shared skills remain normal copied files in `dot_agents/exact_skills/`, with `~/.claude/skills` symlinked to the applied `~/.agents/skills` target.

### `exact_` dirs: full reconciliation for churn-prone collections

By default chezmoi only adds and updates target files — it never deletes a target file just because the corresponding source file is gone. That's the right default for tool-config dirs that hold a single config file, since other tools may also write into the same target dir. But for our own collections of independently-named *functionality* files (functions, completions, hooks, skills, rules, etc.), it means renamed or deleted source files leave stale ghosts in the target.

The `exact_` directory prefix opts a dir into full reconciliation: on `chezmoi apply`, anything in the target that doesn't exist in source gets deleted. Currently used on:

| Source dir | Target |
| --- | --- |
| `private_dot_config/fish/exact_functions/` | `~/.config/fish/functions/` |
| `private_dot_config/fish/exact_completions/` | `~/.config/fish/completions/` |
| `private_dot_config/fish/exact_conf.d/` | `~/.config/fish/conf.d/` |
| `dot_agents/exact_skills/` | `~/.agents/skills/` |
| `dot_agents/exact_rules/` | `~/.agents/rules/` generated from `.chezmoitemplates/agents/rules/` |
| `dot_claude/exact_hooks/` | `~/.claude/hooks/` |
| `dot_claude/exact_agents/` | `~/.claude/agents/` |
| `private_dot_config/opencode/exact_agents/` | `~/.config/opencode/agents/` |

**When to add `exact_`:** the dir is a collection of independently-named functionality files (not a single tool's mixed config), source-of-truth lives entirely in this repo, and renames/deletions are routine. **When to skip:** the dir holds a single config file, or an external tool also writes into the target (e.g. `~/.config/yazi/plugins/` is populated by `ya pkg install`, so `exact_` would delete those plugins on every apply).

The prefix is stripped on deploy, so `dot_agents/exact_skills/` still produces `~/.agents/skills/` — no other refs need to change when adding it.

`exact_` does not recurse: each directory level reconciles only its own immediate entries, so a subdirectory needs its own `exact_` prefix to have its stale files cleaned up too. `dot_agents/exact_skills/` carries `exact_` on every nested directory (each skill folder and any `references/`/`templates/`/etc. inside it) so drifted or renamed skill files never linger in the deployed target.

### Nerd Font icons

Several files contain Nerd Font glyphs (starship.toml, yazi theme.toml, tmux statusline.conf, pane-icon.sh, nvim dashboard-art.lua, kitty.conf, herdr's heraldr plugin icon conf). **Do not Edit these files without taking precautions** — the Edit tool corrupts icon bytes; BMP private-use glyphs (U+E000 range) are also stripped from agent-authored Write content. Heraldr reads icons from its `icons.conf` manifest, which is hand-edited only — an agent needing to change it must move existing glyph bytes programmatically (script/sed), never type them; in code (e.g. heraldr's Rust tests) spell glyphs as escapes (`\u{e62b}`), never literals. Use `cp` or Write from a full file read instead. For targeted edits you can give the user a snippet to manually edit themselves.

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
  run_once_07-install-mise.sh.tmpl               # linux: install mise via `mise.run` (not in standard apt repos; darwin gets it from brew)
  run_once_09-add-fish-ppa.sh.tmpl                # linux: add the official Fish 4 Ubuntu PPA and install Fish
  run_once_10-install-homebrew-packages.sh.tmpl  # darwin: brew bundle (formulae + casks)
  run_once_10-install-apt-packages.sh.tmpl       # linux: apt install (dpkg-s presence check + upgrade)
  run_once_15-install-global-tools.sh.tmpl       # uv tools (darwin-only)
  run_once_15-install-llama.sh.tmpl               # darwin: install the llama.app build of llama.cpp (Metal) to ~/.local/bin
  run_once_16-install-rust.sh.tmpl                # install stable Rust via rustup
  run_onchange_17-install-cargo-tools.sh.tmpl     # install OS/profile Cargo tools with cargo-binstall
  run_onchange_18-mise-install.sh.tmpl            # `mise install` to materialize node + npm-backend package manager + CLI globals; re-runs on active arch's mise config change
  run_onchange_19-sync-gh-extensions.sh.tmpl      # install/update GitHub CLI extensions (gh-dash); monthly refresh stamp
  run_onchange_19-sync-luarocks-tools.sh.tmpl     # darwin: install/update LuaRocks tools (busted, luacheck); monthly refresh stamp
  run_once_20-configure-shell.sh.tmpl            # Fish → /etc/shells, chsh
  run_once_30-yazi-plugins.sh.tmpl               # ya pkg install (yazi plugin sync)
  run_once_31-bat-cache.sh.tmpl                  # Build bat theme cache (after themes deployed)
  run_after_99-materialize-symsource-symlinks.sh.tmpl  # One-shot ephemeral support (gated on CHEZMOI_ONESHOT=1)
```

Scripts are a surface to minimize. Each is an imperative action that can fail. If something can be a file, make it a file. `run_once_` runs once per content hash — on a fresh machine all fire on first apply. `run_onchange_` re-runs when rendered content changes (also fires on first apply since no previous hash → new hash = change).

**Cargo packages:** Every package under the active OS's `cargo` section is installed with `cargo binstall`. Core packages are combined with the active profile's packages. Packy manages Cargo packages on macOS and Linux; `packy upgrade -m cargo` upgrades every installed Cargo package through `cargo-update`.

**Linux package philosophy:** Linuxbrew is intentionally not used — too heavy for the small-VM Linux use case. System packages are manually curated in `packages.yaml` under `linux.apt.packages`; Fish comes from its official Ubuntu PPA so every supported Linux target runs Fish 4. Mise and direct binary installers cover tools outside apt and Cargo. The apt install script checks `dpkg -s` for each package and only fetches what's missing — fast on Sprites/exe machines with preloaded packages. `packy` does **not** manage apt — apt entries are hand-edited in `packages.yaml`.

**JS/TS tooling (mise + arch-specific npm backend):** Node and the four global npm CLIs (`@agentclientprotocol/claude-agent-acp`, `@aredotna/cli`, `@readwise/cli`, `mintlify`) are installed and pinned by mise. The mise config is split by arch — `~/.config/mise/config.toml` is a symlink whose template picks `symsources/mise/config-{{ .chezmoi.arch }}.toml`.

- **arm64 (Apple Silicon):** `aube` is the npm backend ([jdx/aube](https://github.com/jdx/aube)). Installed via mise, set as `npm.package_manager = "aube"` so mise's npm-backend tool installs route through it. Aube reads/writes `pnpm-lock.yaml` in place, so projects with a pnpm lockfile (including ones that pin pnpm via `packageManager`) keep working without pnpm on PATH. The two low-traffic CLIs (`@aredotna/cli`, `@readwise/cli`) are exempted from aube's low-download supply-chain gate in `symsources/aube/config.toml` via `allowedUnpopularPackages`.
- **amd64 (Intel):** Aube doesn't ship a darwin-amd64 binary yet, so this config drops `aube` and uses `npm.package_manager = "pnpm"`. pnpm comes from Homebrew (already in `packages.yaml`).

Both configs are materialized on a fresh machine by `run_onchange_18-mise-install.sh.tmpl`, which hashes the arch-specific file and re-runs when it changes. Bun and Deno are unchanged — still Homebrew, still owning their own dirs.

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

- `docs/agent-config.md` — Semantic contract for Claude Code, Codex, and OpenCode configuration: sandbox access, approval policy, and agent guidance as three separate controls, plus the config surface map per platform. Read before changing any agent's settings
- `docs/capabilities/` — One file per capability domain (workspace, network, development, git, delegation, context, integrations, session, interaction), each with expected behavior, safety boundary, per-platform implementation, and verification. Indexed by `docs/agent-config.md`
- `.utils/AGENTS.md` — Internal Deno tooling sandbox, with a reference doc per tool under `.utils/docs/`
- `~/.agents/skills/chezmoi/` (source: `dot_agents/exact_skills/exact_chezmoi/`) — Full chezmoi skill with deep reference docs on attributes, templates, scripts, hooks
- [chezmoi documentation](https://www.chezmoi.io) — Official docs, comprehensive reference for all features
