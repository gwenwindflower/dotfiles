# Architecture Overview

> [!IMPORTANT]
> Update this file as the architecture evolves. This is the source of truth for the migration.

## Goals

- Idempotent and declarative (per chezmoi's philosophy)
- **macOS (darwin):** Full interactive workstation — GUI apps, fonts, all tools, terminal emulators
- **Linux:** Stripped-down, dev-focused toolkit — CLI tools, languages, shell, editor only
  - Target environments: **Fly.io Sprites** and **exe.dev VMs** (persistent dev machines, not ephemeral containers)
  - No GUI apps, no fonts, no macOS-only tools
- Output state matches _the effects_ of current rotz-managed `~/.charmschool` behavior while using chezmoi idioms and best practices
- AI-agent friendly: clear structure, good documentation, predictable patterns

---

## Source: rotz Repository (`~/.charmschool`)

The rotz repo we are migrating FROM. This section exists to avoid repeatedly exploring that repo. Do not let this section influence your target design decisions, beyond understanding where everything you're mapping to the new system currently lives.

### rotz Core Concepts

**rotz** is a Rust-based dotfile manager using:

- **dot.yaml** files to define installable units (called "dots")
- **Handlebars** templating for variable substitution
- **Fish shell** for running install commands (configured in `config.yaml`)
- **Symlinks** to connect repo files to their home directory targets

Key behaviors:

- `rotz link` creates symlinks from repo → home
- `rotz install` runs commands defined in `installs:` sections
- `defaults.yaml` provides inherited values (dots set keys to `null` to inherit)

### rotz File Tree

```text
~/.charmschool/
├── CLAUDE.md                    # Agent instructions
├── README.md                    # User documentation
├── bootstrap.sh                 # Fresh machine setup (sh script)
├── config.yaml                  # rotz config (Fish shell, dotfiles path)
│
├── agents/                      # AI coding tool configs
│   ├── claude/                  # Claude Code (rules/, skills/, settings.json)
│   │   ├── agents/              # Sub-agent definitions (writing-prose-editor.md)
│   │   ├── rules/               # 5 rule docs
│   │   ├── skills/              # 17 skills (incl. chezmoi, rotz-dotfiles)
│   │   ├── _deactivated_skills/ # Inactive skills
│   │   ├── settings.json        # Claude Code settings
│   │   └── statusline.ts        # Status line config
│   ├── codex/                   # OpenAI Codex (install stub)
│   ├── copilot/                 # GitHub Copilot CLI (install stub)
│   ├── opencode/                # OpenCode (config + install)
│   ├── prompt_library/          # Reusable prompts
│   └── tools/
│       └── codemogger/          # Apple Silicon/Linux only
│
├── apps/                        # GUI applications — DARWIN ONLY (22 casks)
│   ├── defaults.yaml            # brew install --cask {{file_name name}}
│   ├── karabiner-elements/      # Has config + dot.yaml
│   └── .../dot.yaml             # Most just inherit defaults
│
├── tools/                       # CLI/TUI tools (67 formulae)
│   ├── defaults.yaml            # brew install {{file_name name}}
│   ├── bat/                     # Has config + dot.yaml
│   ├── yazi/                    # Has multiple config files
│   └── .../dot.yaml             # Most just inherit defaults
│
├── shell/
│   ├── fish/                    # Fish shell (primary)
│   │   ├── dot.yaml             # Links + Fisher install
│   │   ├── config.fish          # Main config (3 namespace for loops)
│   │   ├── 00_plugin_config.fish
│   │   ├── fish_plugins         # Fisher plugin list (6 plugins)
│   │   ├── functions/           # 79 Fish functions (symlinked, incl plugin-generated)
│   │   ├── user_conf/           # 17 numbered config files (symlinked, 0n/1n/2n namespaces)
│   │   └── conf.d/              # Early-load configs (symlinked, incl plugin-generated)
│   ├── kitty/                   # Kitty terminal + themes — DARWIN ONLY
│   ├── tmux/                    # tmux config
│   └── prompt/                  # Starship prompt
│
├── editor/
│   └── nvim/                    # Neovim (LazyVim)
│       ├── init.lua
│       ├── lazy-lock.json
│       ├── lazyvim.json, stylua.toml
│       ├── lua/config/          # autocmds, keymaps, options
│       ├── lua/plugins/         # Plugin specs (ai, colors, dash, lang, utils, ux)
│       ├── snippets/            # VSCode-format snippets (7 language dirs)
│       └── spell/               # Custom dictionary
│
├── git/
│   ├── gitconfig                # Main git config (SSH signing via 1Password)
│   ├── gitignore_global
│   ├── allowed_signers          # SSH allowed signers
│   ├── delta/                   # Git delta pager theme
│   ├── forgit/                  # forgit config
│   ├── gh/                      # GitHub CLI config + gh-dash extension
│   ├── graphite/                # DARWIN ONLY
│   └── meteor/                  # DARWIN ONLY (commit message TUI)
│
├── lang/                        # Language tooling
│   ├── go/, ruby/               # Install stubs
│   ├── python/
│   │   ├── ruff/                # Linter config
│   │   └── uv/                  # uv config (uv.toml)
│   ├── typescript/
│   │   ├── bun/, deno/, pnpm/   # JS runtime install stubs
│   │   └── deno/val-town/       # Val Town CLI (vt)
│   └── mise/                    # Multi-version manager config
│
└── fonts/                       # Nerd fonts — DARWIN ONLY (5 casks)
```

### rotz Statistics

| Category | Count |
| --- | --- |
| Total files | ~375 |
| dot.yaml files | ~123 |
| Fish functions | 79 (incl. plugin-generated) |
| CLI tools | 67 |
| GUI apps | 22 |
| Fonts | 5 |

### Darwin-Only Items (exclude from Linux)

These items are flagged `# TODO: only on Darwin, not devcontainers` in charmschool:

| Category | Items |
| --- | --- |
| Entire directories | `apps/` (22 casks), `fonts/` (5 casks) |
| Terminal | Kitty (`shell/kitty/`) |
| Tools | cmus, databricks, duti, obsidian-cli, postgresql, qmk, spotify-player, xleak, youplot, yt-dlp |
| Git tools | graphite, meteor (install only — meteor CLI is included on Linux) |
| Shell configs | `04-containers.fish` (Orbstack — macOS only) |
| Env vars | `OBSIDIAN_HOME`, `OBSIDIAN_DEFAULT_VAULT`, `MACOS_CONFIG_HOME` |

---

## Target: chezmoi Repository (`~/.local/share/chezmoi`)

The chezmoi structure we are migrating TO.

### chezmoi Core Concepts

**chezmoi** uses a three-state model:

- **Source** (declared in `~/.local/share/chezmoi`)
- **Destination** (current home directory)
- **Target** (computed desired state)

Key behaviors:

- `chezmoi apply` updates destination to match target
- File prefixes (`dot_`, `private_`, `executable_`, `symlink_`) control behavior
- `.tmpl` suffix enables Go template processing
- Scripts in `.chezmoiscripts/` run during apply

### Machine Type Detection

The `.chezmoi.yaml.tmpl` config template auto-detects machine type from OS:

```yaml
# darwin → darwin-full, linux → linux-dev
data:
  machine:
    type: {{ $machineType | quote }}
```

Available via `{{ .machine.type }}` in templates. Values:

- `darwin-full` — macOS interactive workstation (all apps, fonts, tools)
- `linux-dev` — Linux dev VM (CLI tools, languages, shell, editor only)

### Environment Variable: `DOTFILES_HOME`

Set in `00-env.fish` to `~/.local/share/chezmoi`. Used by abbreviations and functions that reference the dotfiles source directory, replacing hardcoded `~/.charmschool` paths.

### chezmoi Target File Tree

```text
~/.local/share/chezmoi/
├── .chezmoi.yaml.tmpl                          # Machine type prompt
│
├── .chezmoidata/                               # Template data
│   └── packages.yaml                           # Homebrew packages (darwin + linux sections)
│
├── .chezmoiscripts/                            # Lifecycle scripts (flat, OS logic in templates)
│   ├── run_once_before_00-bootstrap.sh.tmpl    # Homebrew install (darwin + linux)
│   ├── run_onchange_10-install-packages.sh.tmpl # brew bundle (darwin + linux)
│   └── run_once_20-configure-shell.sh.tmpl     # Fish to /etc/shells, chsh
│
├── .chezmoiignore                              # Docs, OS-specific excludes
│
├── dot_config/
│   ├── fish/
│   │   ├── config.fish                         # Namespace for-loop loader
│   │   ├── fish_plugins                        # Fisher plugin list
│   │   ├── conf.d/                             # Early-load configs (plugin-generated)
│   │   ├── user_conf/                          # Numbered config files (3 namespaces)
│   │   │   ├── 0n — env, editor, git, AI, containers (templates for OS logic)
│   │   │   ├── 1n — language configs (rust, typescript, go, python, ruby, mise)
│   │   │   └── 2n — interactive (theme, prompt, abbrs, bindings, zoxide, fzf, mux)
│   │   └── functions/                          # Fish functions (user-authored)
│   │
│   ├── kitty/                                  # DARWIN ONLY (via .chezmoiignore)
│   │   ├── kitty.conf
│   │   ├── current-theme.conf
│   │   └── themes/
│   │
│   ├── nvim/                                   # Neovim config (mostly copied)
│   │   ├── init.lua
│   │   ├── symlink_lazy-lock.json.tmpl         # → source (updated by :Lazy)
│   │   ├── symlink_lazyvim.json.tmpl           # → source (updated by LazyVim)
│   │   ├── stylua.toml
│   │   ├── lua/config/                         # autocmds, keymaps, options
│   │   ├── lua/plugins/                        # Plugin specs
│   │   ├── snippets/                           # VSCode-format snippets
│   │   └── spell/                              # Custom dictionary
│   │
│   ├── bat/                                    # bat pager config
│   ├── delta/catppuccin.gitconfig              # Delta pager theme
│   ├── fzf/                                    # fzf config (env vars)
│   ├── gh/config.yml                           # GitHub CLI
│   ├── gh-dash/config.yml                      # gh-dash extension config
│   ├── git/                                    # XDG git config
│   │   ├── config.tmpl                         # Main gitconfig (templated for OS)
│   │   └── ignore                              # Global gitignore
│   ├── karabiner/                              # DARWIN ONLY (via .chezmoiignore)
│   ├── meteor/config.json                      # Conventional commit helper
│   ├── mise/config.toml                        # Version manager
│   ├── ripgrep/                                # ripgrep config
│   ├── starship.toml                           # Prompt config
│   ├── tlrc/                                   # tldr client config
│   ├── tmux/tmux.conf                          # tmux config
│   ├── uv/uv.toml                              # Python package manager config
│   └── yazi/                                   # File manager
│       ├── yazi.toml, keymap.toml, theme.toml
│       ├── package.toml
│       └── init.lua
│
├── dot_claude/                                 # Claude Code config
│   ├── symlink_settings.json.tmpl              # → source (edited by Claude Code)
│   ├── symlink_skills.tmpl                     # → source (target for skill installs)
│   └── rules/                                  # Agent rules (copied normally)
│       └── *.md
│
├── claude/                                     # Source for symlinked Claude Code files
│   ├── settings.json                           # (in .chezmoiignore)
│   └── skills/                                 # (in .chezmoiignore)
│
├── nvim/                                       # Source for symlinked Neovim lockfiles
│   ├── lazy-lock.json                          # (in .chezmoiignore)
│   └── lazyvim.json                            # (in .chezmoiignore)
│
├── private_dot_ssh/                                # SSH config (cross-platform, 1Password agent forwarding)
│   └── config                                  # SSH config
│   └── allowed_signers                         # SSH signing (shared with git)
│
├── dot_gitconfig                               # Fallback include → ~/.config/git/config
│
├── .chezmoiignore                              # OS-conditional ignores
├── CLAUDE.md
├── ARCHITECTURE.md                             # This file
└── PLAN.md
```

---

## Key Design Decisions

### 1. Minimal Symlinks for Externally-Modified Files

**Rationale:** Most configs follow normal chezmoi workflow (edit source, `chezmoi apply`). Only files modified by external tools need symlinks back to the source directory, so those changes persist immediately without a manual `chezmoi add` step.

**Symlinked files (modified by external tools):**

| File | External modifier | Source location |
| --- | --- | --- |
| `~/.config/nvim/lazy-lock.json` | Lazy.nvim (`:Lazy sync`) | `nvim/lazy-lock.json` |
| `~/.config/nvim/lazyvim.json` | LazyVim framework | `nvim/lazyvim.json` |
| `~/.claude/settings.json` | Claude Code itself | `claude/settings.json` |
| `~/.claude/skills/` | Skill installation (package-manager-like) | `claude/skills/` |

**Implementation:** Symlink entries live inline at their target path using nested attributes:

```text
dot_config/nvim/symlink_lazy-lock.json.tmpl    # content: {{ .chezmoi.sourceDir }}/nvim/lazy-lock.json
dot_claude/symlink_settings.json.tmpl          # content: {{ .chezmoi.sourceDir }}/claude/settings.json
```

The actual source files live at the repo root (`nvim/`, `claude/`) and are listed in `.chezmoiignore` so chezmoi doesn't also try to deploy them as `~/nvim/` or `~/claude/`.

**Everything else is copied normally** — Neovim's `init.lua`, `lua/`, `snippets/`, `spell/`, and Claude Code's `rules/` all go through standard chezmoi workflow.

### 2. Fish Directory Structure (Copied)

**Rationale:** Fish configs are rarely edited interactively. The copy model:

- Ensures clean separation between source and target
- Allows template processing for OS-specific logic
- Maintains chezmoi's state management

### 3. Scripts: Flat Directory with OS Conditionals

**Rationale:** All scripts live in `.chezmoiscripts/` (no subdirectories). Each script uses `{{ if eq .chezmoi.os "darwin" }}` / `{{ else if eq .chezmoi.os "linux" }}` / `{{ else }}{{ fail }}` to handle OS-specific logic inline. This avoids duplicating near-identical scripts across per-OS directories and keeps the OS differences visible in a single file. Numeric prefixes control ordering (00-, 10-, 20-, etc.).

### 4. Git Config Location

**Decision:** Use XDG-compliant `~/.config/git/config` as primary, with `~/.gitconfig` as fallback include.

```gitconfig
# ~/.gitconfig (dot_gitconfig)
[include]
    path = ~/.config/git/config
```

### 5. Package Data Centralization

All Homebrew packages in `.chezmoidata/packages.yaml`:

- Single source of truth, split into `darwin` and `linux` sections
- Template-accessible via `{{ .packages.darwin.homebrew.* }}` / `{{ .packages.linux.homebrew.* }}`
- Easy to diff and audit
- Darwin section: full set (111 formulae, 35 casks, 18 taps)
- Linux section: dev-focused subset (~50 formulae, no casks, minimal taps)

### 6. No Tool-Specific Directories

Unlike rotz's `tools/<name>/` and `apps/<name>/` structure, chezmoi doesn't need this:

- Package installation is centralized in data files
- Config files go directly to their target paths
- No need for `dot.yaml` per tool

### 7. OS-Conditional Ignores

`.chezmoiignore` uses template logic to exclude platform-specific files:

```text
{{ if ne .chezmoi.os "darwin" }}
dot_config/kitty/
{{ end }}
```

This prevents Darwin-only configs from being deployed on Linux.

### 8. DOTFILES_HOME Environment Variable

Set in `00-env.fish.tmpl` to `{{ .chezmoi.sourceDir }}` (resolves to `~/.local/share/chezmoi`). Replaces hardcoded `~/.charmschool` references in abbreviations and functions.

---

## Translation Patterns

### rotz → chezmoi Mapping

| rotz Pattern | chezmoi Equivalent |
| --- | --- |
| `dot.yaml` per tool | Centralized `.chezmoidata/packages.yaml` |
| `installs: null` (inherit) | Package in data file |
| `installs: [fish commands]` | `run_once_*.fish.tmpl` script |
| `links: {src: dest}` | File at target path with `dot_` prefix |
| `depends: [../tool]` | Script ordering via numeric prefix |
| `defaults.yaml` inheritance | Go templates + centralized data |
| Handlebars `{{file_name name}}` | Explicit package name in data file |
| Directory symlinks | Contents copied, or `symlink_` prefix |

### Template Syntax Conversion

| Handlebars (rotz) | Go template (chezmoi) |
| --- | --- |
| `{{file_name name}}` | N/A (explicit in data) |
| `{{ quote "" cmd }}` | `{{ . \| quote }}` |
| Conditional blocks | `{{ if eq .chezmoi.os "darwin" }}` |

---

## Package Lists

### Darwin Formulae (111)

Full list maintained in `.chezmoidata/packages.yaml` — includes all 67 tools from charmschool plus language tooling, libraries, and build dependencies.

### Darwin Casks (35)

GUI apps (22), fonts (5), plus: 1password-cli, claude-code, copilot-cli, copilot-money, github, ia-presenter, mitmproxy, orion, zed.

### Linux Formulae (~55, dev-focused)

Core dev toolkit — no GUI apps, no fonts, no macOS-only tools:

**Shell & prompt:** fish, starship
**Navigation & search:** zoxide, yazi, fzf, ripgrep, fd
**File ops:** bat, lsd, sd, rm-improved, 7zip
**Git ecosystem:** git, delta, lazygit, forgit, meteor, gh
**Monitoring:** bottom, procs, k9s
**Editor:** neovim
**Multiplexer:** tmux
**Dev tools:** make, cmake, go-task, jless, jq, yq, sqlite, age
**Languages:** go, ruby, deno, bun, pnpm, mise (→ node), uv (→ python)
**Networking:** wget, mitmproxy, mutagen
**Other:** 1password-cli, moor, vivid, prek, mq, tlrc

### Linux Taps (minimal)

Only taps required for the Linux formulae list (e.g., `stefanlogue/tools` for meteor).

---

## Script Categories

### Bootstrap (run_once_before)

- `00-bootstrap.sh.tmpl` — Homebrew install, OS-conditional shellenv setup. Fails on unrecognized OS.

### Package Management (run_onchange)

- `10-install-packages.sh.tmpl` — `brew bundle` from packages.yaml. Darwin: taps + formulae + casks. Linux: taps + formulae only. Fails on unrecognized OS.

### Shell Configuration (run_once)

- `20-configure-shell.sh.tmpl` — Add Fish to `/etc/shells`, chsh. Linux adds brew shellenv preamble. Fails on unrecognized OS.

**Note:** Fisher plugins are NOT installed via script. Fisher functions are tracked directly in `dot_config/fish/functions/` and sync via chezmoi. The `fish_plugins` file is managed as a regular file for reference.

---

## File Attribute Reference

| Attribute | Purpose | Example |
| --- | --- | --- |
| `dot_` | Adds leading `.` | `dot_config/` → `.config/` |
| `private_` | Mode 0600/0700 | `private_dot_ssh/` |
| `executable_` | Mode +x | `executable_script.sh` |
| `symlink_` | Create symlink | `symlink_dot_config/nvim.tmpl` |
| `.tmpl` | Go template | `config.fish.tmpl` |

---

## Theming Consistency

All tools use **Catppuccin Frappe**:

- Fish (via catppuccin/fish plugin)
- Starship prompt
- Git delta
- Git color config (custom Catppuccin palette)
- Kitty terminal (darwin only)
- Neovim (via plugin)
- Yazi file manager
- bat (via theme)
- fzf (via color opts)
- vivid (LS_COLORS)
- moor (CLI output highlighting)

---

## Future Considerations

### External Sources (`.chezmoiexternal.yaml`)

Potential candidates:

- Large plugin repos
- Themes that update frequently
- Shared config snippets

### Secrets Management

Options to evaluate:

- 1Password CLI integration (`op://` URIs)
- chezmoi's age encryption
- Template includes from `~/.config/chezmoi/`
