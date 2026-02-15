# Architecture Overview

> [!IMPORTANT]
> Update this file as the architecture evolves. This is the source of truth for the migration.

## Goals

- Idempotent and declarative (per chezmoi's philosophy)
- Linux and macOS (darwin) BOTH first-class targets
  - macOS is priority for interactive use; Linux support should not break macOS
  - Linux-specific logic should allow quickly establishing a productive environment on containers, VMs, and VPS
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
│   ├── claude/                  # Claude Code (rules/, skills/)
│   ├── copilot/                 # GitHub Copilot
│   ├── crush/                   # CRUSH CLI
│   └── opencode/                # OpenCode CLI
│
├── apps/                        # GUI applications (22 casks)
│   ├── defaults.yaml            # brew install --cask {{file_name name}}
│   ├── karabiner-elements/      # Has config + dot.yaml
│   └── .../dot.yaml             # Most just inherit defaults
│
├── tools/                       # CLI/TUI tools (71 formulae)
│   ├── defaults.yaml            # brew install {{file_name name}}
│   ├── bat/                     # Has config + dot.yaml
│   ├── yazi/                    # Has multiple config files
│   └── .../dot.yaml             # Most just inherit defaults
│
├── shell/
│   ├── fish/                    # Fish shell (primary)
│   │   ├── dot.yaml             # Links + Fisher install
│   │   ├── config.fish          # Main config
│   │   ├── 00_plugin_config.fish
│   │   ├── fish_plugins         # Fisher plugin list
│   │   ├── functions/           # 89 Fish functions
│   │   └── user_conf/           # 17 numbered config files
│   ├── kitty/                   # Kitty terminal + themes
│   ├── mux/                     # tmux + zellij configs
│   └── prompt/                  # Starship prompt
│
├── editor/
│   └── nvim/                    # Neovim (LazyVim)
│       ├── init.lua
│       ├── lazy-lock.json
│       ├── lua/config/          # autocmds, keymaps, options
│       ├── lua/plugins/         # Plugin specs
│       └── snippets/            # VSCode-format snippets
│
├── git/
│   ├── gitconfig                # Main git config
│   ├── gitignore_global
│   ├── delta/                   # Git delta pager theme
│   └── gh/                      # GitHub CLI config
│
├── lang/                        # Language tooling
│   ├── go/, python/, typescript/
│   └── mise/                    # Multi-version manager config
│
└── fonts/                       # Nerd fonts (6 casks)
```

### rotz Statistics

| Category | Count |
| --- | --- |
| Total files | ~341 |
| dot.yaml files | ~121 |
| Fish functions | 89 |
| Fish user_conf | 17 |
| CLI tools | 71 |
| GUI apps | 22 |
| Fonts | 6 |

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

### chezmoi Target File Tree

```text
~/.local/share/chezmoi/
├── .chezmoidata/                        # Template data
│   ├── packages.yaml                    # ✅ Homebrew taps/formulae/casks
│   └── fisher.yaml                      # Fisher plugins (to create)
│
├── .chezmoiscripts/                     # Lifecycle scripts
│   ├── darwin/
│   │   ├── run_once_before_00-bootstrap.sh
│   │   ├── run_onchange_10-install-packages.sh.tmpl
│   │   ├── run_once_20-configure-shell.fish.tmpl
│   │   ├── run_onchange_30-install-fisher.fish.tmpl
│   │   └── run_onchange_40-yazi-plugins.fish.tmpl
│   └── linux/                           # Future
│
├── dot_config/
│   ├── fish/
│   │   ├── config.fish.tmpl
│   │   ├── fish_plugins
│   │   ├── conf.d/
│   │   │   └── 00_plugin_config.fish
│   │   ├── user_conf/                   # 17 numbered files
│   │   └── functions/                   # 89 functions
│   │
│   ├── kitty/
│   │   ├── kitty.conf
│   │   ├── current-theme.conf
│   │   └── themes/
│   │
│   ├── starship.toml
│   │
│   ├── yazi/
│   │   ├── yazi.toml
│   │   ├── keymap.toml
│   │   ├── theme.toml
│   │   ├── package.toml
│   │   └── init.lua
│   │
│   ├── mise/config.toml
│   │
│   ├── git/
│   │   ├── config
│   │   └── ignore
│   │
│   ├── gh/config.yml
│   ├── delta/catppuccin.gitconfig
│   ├── tmux/tmux.conf
│   └── zellij/config.kdl
│
├── private_dot_ssh/
│   └── config.tmpl
│
├── symlink_dot_config/
│   └── nvim.tmpl                        # → source-managed nvim/
│
├── nvim/                                # Neovim (symlinked, not copied)
│   ├── init.lua
│   ├── lazy-lock.json
│   ├── lua/config/
│   ├── lua/plugins/
│   └── snippets/
│
├── dot_gitconfig                        # Fallback include
│
├── run_onchange_darwin-install-packages.sh.tmpl  # ⚠️ Move to .chezmoiscripts/
│
├── .chezmoiignore                       # ✅ Exists
├── CLAUDE.md                            # ✅ Exists
├── ARCHITECTURE.md                      # This file
└── PLAN.md                              # Migration plan
```

---

## Key Design Decisions

### 1. Neovim as Symlink (Not Copied)

**Rationale:** Neovim configs are frequently edited during use. A symlink allows:

- Direct editing without `chezmoi edit`
- `lazy-lock.json` updates to persist immediately
- Better LazyVim/plugin development workflow

**Implementation:**

```go
# symlink_dot_config/nvim.tmpl
{{ .chezmoi.sourceDir }}/nvim
```

Creates `~/.config/nvim` → `~/.local/share/chezmoi/nvim`

### 2. Fish Directory Structure (Copied)

**Rationale:** Unlike Neovim, Fish configs are rarely edited interactively. The copy model:

- Ensures clean separation between source and target
- Allows template processing for OS-specific logic
- Maintains chezmoi's state management

### 3. Scripts Organized by OS

**Rationale:** Clear separation of platform-specific scripts:

- `.chezmoiscripts/darwin/` for macOS
- `.chezmoiscripts/linux/` for Linux (future)
- Numeric prefixes for ordering (00-, 10-, 20-, etc.)

### 4. Git Config Location

**Decision:** Use XDG-compliant `~/.config/git/config` as primary, with `~/.gitconfig` as fallback include.

```gitconfig
# ~/.gitconfig (dot_gitconfig)
[include]
    path = ~/.config/git/config
```

### 5. Package Data Centralization

All Homebrew packages in `.chezmoidata/packages.yaml`:

- Single source of truth
- Template-accessible via `{{ .packages.darwin.homebrew.* }}`
- Easy to diff and audit

### 6. No Tool-Specific Directories

Unlike rotz's `tools/<name>/` and `apps/<name>/` structure, chezmoi doesn't need this:

- Package installation is centralized in data files
- Config files go directly to their target paths
- No need for `dot.yaml` per tool

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

## Script Categories

### Bootstrap (run_once_before)

- `00-bootstrap.sh` — Ensure Homebrew exists (macOS)

### Package Management (run_onchange)

- `10-install-packages.sh.tmpl` — `brew bundle` from packages.yaml
- `30-install-fisher.fish.tmpl` — Fisher + plugins
- `40-yazi-plugins.fish.tmpl` — `ya pkg install`

### Configuration (run_once)

- `20-configure-shell.fish.tmpl` — Add Fish to `/etc/shells`, chsh

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
- Kitty terminal
- Neovim (via plugin)
- Yazi file manager
- moor (CLI output highlighting)

---

## Future Considerations

### Linux Support

- Separate package management (apt, dnf, pacman)
- Different paths for some tools
- Conditional templates via `{{ if eq .chezmoi.os "linux" }}`

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
