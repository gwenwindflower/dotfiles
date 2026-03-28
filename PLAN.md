# Migration Plan v2: rotz -> chezmoi

> Revised plan incorporating charmschool's single-file fish config, multi-agent setup, and all source changes since early March 2026.

## What's Done

Phases 0-4 from the original plan are complete. The chezmoi repo has:

- Machine type detection (`.chezmoi.yaml.tmpl`: darwin-full / linux-dev)
- Package data (`.chezmoidata/packages.yaml`: darwin full + linux dev-focused)
- Bootstrap, package install, and shell config scripts (`.chezmoiscripts/`)
- Git & SSH configuration (XDG gitconfig, delta, gh, gh-dash, meteor, SSH with 1Password agent)
- Fish shell -- **but using the OLD multi-file `user_conf/` approach** that charmschool has since replaced

## What Changed in Charmschool

### Fish: Single-file config.fish (biggest change)

The old multi-file `user_conf/` loader was replaced with a single 785-line `config.fish` that inlines everything. Key differences:

- **No subprocess init**: `brew shellenv`, `starship init fish`, and `zoxide init fish` are fully inlined
- **Static LS_COLORS**: `vivid generate` output baked in as a string
- **Mise removed**: Activation stripped for startup speed; PATH fixup preserved
- **OS detection**: Single `uname -s`/`uname -m` check at top, reused via local vars
- **Go PATH**: Hardcoded `$HOME/.go/bin` instead of `$(go env GOPATH)/bin`
- **user_conf/ preserved but dead**: Still exists as reference; no longer sourced

For chezmoi, we'll use the new single-file config as source, converted to `.tmpl` with Go template OS guards replacing `uname` checks.

### Agent configs: Shared multi-agent hub

The agent setup now uses a hub-and-spoke model. Source of truth is `agents/shared/{rules,skills,agents,prompts}`, symlinked to `~/.agents/` for cross-agent discovery. Claude Code has its own settings (settings.json, keybindings.json, statusline.toml, completions). OpenCode has its own config (opencode.jsonc, tui.jsonc).

For chezmoi, we'll:

- Map `agents/shared/` -> `~/.agents/` (symlinks for rules/, skills/, agents/, prompts/)
- Map Claude settings as regular copied files to `~/.claude/`
- Map OpenCode config as regular files to `~/.config/opencode/`

### Functions: 91 files (up from 79)

New functions added: `agents`, `cco`, `confcomp`, `ee`, `ghc`, `gho`, `gpgrl`, `grel`, `man`, `opc`, `pmux`, `tmux_hint`, `tstat`, `twin`, `wt`. Some existing functions have updated internals.

### Other changes

- tmux config split: `tmux.conf` + `statusline.conf` + `pane-icon.sh`
- New tool configs to migrate: fzf (`fzf.conf`), ripgrep (`ripgrep.conf`), tlrc (`tlrc.toml`)
- Claude keybindings.json, statusline.toml, claude.fish completions are new files
- Yazi has a custom `editor.yazi` plugin directory
- bat needs its Catppuccin-Frappe.tmTheme theme file (2112 lines)

---

## Remaining Work

Organized into **parallel lanes** -- groups of independent work that can be executed simultaneously by different agents.

### Dependency Graph

```text
Lane A (Fish rewrite)  ──────> standalone, no deps
Lane B (Prompt+Terminal) ────> standalone, no deps
Lane C (Neovim) ─────────────> standalone, no deps
Lane D (Tools+Dev) ──────────> standalone, no deps
Lane E (Agents) ─────────────> standalone, no deps
Lane F (Multiplexers) ───────> standalone, no deps
Lane G (Darwin extras) ──────> standalone, no deps
Lane H (Cleanup+Polish) ────> depends on ALL above
```

All lanes A-G can execute in parallel. Lane H is the final pass.

---

## Lane A: Fish Shell Rewrite

**Priority: High** -- The biggest single piece of work. The current chezmoi fish config uses the old multi-file approach. Replace it entirely with the new single-file config.

### A1: Replace config.fish with single-file .tmpl version

| Task | Notes |
| --- | --- |
| Delete `dot_config/fish/config.fish` (28-line loader) | Old multi-file loader, no longer used |
| Delete entire `dot_config/fish/user_conf/` directory | Old modular fragments, replaced by single file |
| Create `dot_config/fish/config.fish.tmpl` from charmschool's 785-line `config.fish` | Convert `uname`/`test "$__os"` checks to Go template `{{ if eq .chezmoi.os "darwin" }}` guards |

**Templating strategy for config.fish.tmpl:**

The source config.fish uses `uname -s` to detect OS. In the chezmoi version:

- **Remove**: The `uname -s`/`uname -m` detection block (lines 1-24). Replace with Go template conditionals.
- **Replace**: `if test "$__os" = Darwin` blocks with `{{ if eq .chezmoi.os "darwin" }}`
- **Remove on linux**: SSH_AUTH_SOCK (1Password socket), MACOS_CONFIG_HOME, OrbStack section, Obsidian section, `open .` binding, spotify/media abbrs, darwin-only keeb abbr
- **Template DOTFILES_HOME**: Set to `{{ .chezmoi.sourceDir }}` instead of hardcoded path
- **Template Homebrew prefix**: Use `{{ if eq .chezmoi.os "darwin" }}{{ if eq .chezmoi.arch "arm64" }}/opt/homebrew{{ else }}/usr/local{{ end }}{{ else }}/home/linuxbrew/.linuxbrew{{ end }}`
- **Keep**: All inlined tool outputs (starship, zoxide, LS_COLORS) -- they're cross-platform
- **Keep**: Mise removal (just PATH fixup)
- **Template `dots` abbr**: Change `$HOME/.charmschool` reference to `$DOTFILES_HOME`

**Known darwin-only blocks to guard or strip:**

1. `SSH_AUTH_SOCK` 1Password socket path (line 62-64)
2. `MACOS_CONFIG_HOME` (line 72)
3. `TEMP` = `$TMPDIR` (line 74 -- `$TMPDIR` may not be set on Linux)
4. OrbStack section (lines 136-138)
5. Obsidian/Monodraw section (lines 780-784)
6. `sshk` abbr (kitten ssh -- kitty is darwin-only)
7. `keeb` abbr (darwin-only project)
8. `notes`, `ob*` abbrs (Obsidian -- darwin-only)
9. `spotify`, `spt`, `ytdl`, `gdl` abbrs (darwin-only media)
10. `super-F` / `alt-F` binding for `open .` (Finder -- darwin-only)
11. `clyj` abbr (references `.charmschool` path)
12. `cp.` abbr uses `pbcopy` (darwin-only, or could use `fish_clipboard_copy`)
13. `dbx` abbr (databricks -- darwin-only)

### A2: Replace functions/ directory

| Task | Notes |
| --- | --- |
| Delete all files in `dot_config/fish/functions/` | Stale -- charmschool has 91 files, chezmoi has 79 |
| Copy all 91 functions from charmschool `shell/fish/functions/` | 1:1 copy, no templating needed |

### A3: Update conf.d/ and fish_plugins

| Task | Notes |
| --- | --- |
| Verify `conf.d/` files match charmschool | 5 files -- likely identical but confirm |
| Verify `fish_plugins` matches charmschool | 6 plugins -- likely identical but confirm |

### A4: Add fish completions directory

| Task | Notes |
| --- | --- |
| Create `dot_config/fish/completions/claude.fish` | Copy from `agents/claude/claude.fish` |

---

## Lane B: Prompt & Terminal

**Priority: Medium** -- Small, self-contained.

### B1: Starship prompt

| Task | Notes |
| --- | --- |
| Copy `starship.toml` -> `dot_config/starship.toml` | 325 lines, cross-platform, no templating needed |

### B2: Kitty terminal (darwin-only)

| Task | Notes |
| --- | --- |
| Copy `kitty.conf` -> `dot_config/kitty/kitty.conf` | 182 lines. **Warning**: Contains Nerd Font icons in tab title template -- may need manual handling |
| Copy `catppuccin-winnie.conf` -> `dot_config/kitty/catppuccin-winnie.conf` | 81 lines, custom Catppuccin variant |
| Copy `open-actions.conf` -> `dot_config/kitty/open-actions.conf` | Kitten icat config |
| Copy `quick-access-terminal.conf` -> `dot_config/kitty/quick-access-terminal.conf` | Overlay terminal config |
| Confirm `.chezmoiignore` excludes `dot_config/kitty/` on Linux | Already set up from Phase 1 |

---

## Lane C: Neovim

**Priority: Medium** -- Independent, well-understood.

### C1: Copy nvim config

| Task | Notes |
| --- | --- |
| Copy `init.lua` -> `dot_config/nvim/init.lua` | 5 lines |
| Copy `stylua.toml` -> `dot_config/nvim/stylua.toml` | |
| Copy `lua/` -> `dot_config/nvim/lua/` | config/ (4 files) + plugins/ (7 files) + 3 modules |
| Copy `snippets/` -> `dot_config/nvim/snippets/` | 7 language dirs + package.json |
| Copy `spell/` -> `dot_config/nvim/spell/` | en.utf-8.add + .spl |

### C2: Set up lockfile symlinks

| Task | Notes |
| --- | --- |
| Copy `lazy-lock.json` -> `nvim/lazy-lock.json` (repo root) | Source for symlink, listed in .chezmoiignore |
| Copy `lazyvim.json` -> `nvim/lazyvim.json` (repo root) | Source for symlink, listed in .chezmoiignore |
| Create `dot_config/nvim/symlink_lazy-lock.json.tmpl` | Content: `{{ .chezmoi.sourceDir }}/nvim/lazy-lock.json` |
| Create `dot_config/nvim/symlink_lazyvim.json.tmpl` | Content: `{{ .chezmoi.sourceDir }}/nvim/lazyvim.json` |
| Verify `nvim/` is in `.chezmoiignore` | Should already be there |

---

## Lane D: Tools & Dev Configs

**Priority: Medium** -- Several independent tool configs.

### D1: Yazi file manager

| Task | Notes |
| --- | --- |
| Copy `yazi.toml` -> `dot_config/yazi/yazi.toml` | 15 lines |
| Copy `keymap.toml` -> `dot_config/yazi/keymap.toml` | 81 lines |
| Copy `theme.toml` -> `dot_config/yazi/theme.toml` | 709 lines. **Warning**: Contains Nerd Font icons -- copy carefully |
| Copy `package.toml` -> `dot_config/yazi/package.toml` | 49 lines |
| Copy `init.lua` -> `dot_config/yazi/init.lua` | 104 lines |
| Copy `plugins/editor.yazi/` -> `dot_config/yazi/plugins/editor.yazi/` | Custom plugin dir |
| Create `run_onchange_40-yazi-plugins.fish.tmpl` in `.chezmoiscripts/` | Hash-triggered `ya pkg install`. Cross-platform (yazi is on both) |

### D2: Bat config

| Task | Notes |
| --- | --- |
| Copy `config` -> `dot_config/bat/config` | 21 lines, bat syntax mappings |
| Copy `Catppuccin-Frappe.tmTheme` -> `dot_config/bat/themes/Catppuccin-Frappe.tmTheme` | 2112-line TextMate theme XML |

### D3: fzf config

| Task | Notes |
| --- | --- |
| Copy `fzf.conf` -> `dot_config/fzf/fzf.conf` | 25 lines, Catppuccin Frappe colors + keybinds |

### D4: Ripgrep config

| Task | Notes |
| --- | --- |
| Copy `ripgrep.conf` -> `dot_config/ripgrep/ripgrep.conf` | 5 lines. Note: `--hyperlink-format=kitty` is darwin-specific but harmless on Linux |

### D5: tlrc config

| Task | Notes |
| --- | --- |
| Copy `tlrc.toml` -> `dot_config/tlrc/tlrc.toml.tmpl` | 85 lines. Needs templating: `dir` uses `~/Library/Caches/tlrc` which is darwin-only. Linux should use `$XDG_CACHE_HOME/tlrc` |

### D6: mise config

| Task | Notes |
| --- | --- |
| Copy `config.toml` -> `dot_config/mise/config.toml` | 5 lines, node = "latest" |

### D7: uv config

| Task | Notes |
| --- | --- |
| Copy `uv.toml` -> `dot_config/uv/uv.toml` | 1 line, python-preference = "managed" |

---

## Lane E: Agent Configurations

**Priority: High** -- Significant structural change from original plan.

### Architecture

```text
Repo source (at repo root, in .chezmoiignore):
  agents/                        # Single source of truth
  └── shared/
      ├── rules/                 # 12 rule docs
      ├── skills/                # 26+ skills (with _deactivated/, _skillutil/)
      ├── agents/                # Custom agent definitions
      └── prompts/               # Reusable prompts

Deployed targets:
  ~/.agents/                     # Shared hub (symlinks from agents/shared/)
  ├── symlink rules/  -> repo/agents/shared/rules/
  ├── symlink skills/ -> repo/agents/shared/skills/
  ├── symlink agents/ -> repo/agents/shared/agents/
  └── symlink prompts/ -> repo/agents/shared/prompts/

  ~/.claude/                     # Claude Code (copied files, NOT symlinked to shared)
  ├── settings.json              # Copied
  ├── keybindings.json           # Copied
  └── statusline.toml            # Copied

  ~/.config/opencode/            # OpenCode (copied files)
  ├── opencode.jsonc             # Copied
  └── tui.jsonc                  # Copied

  ~/.config/fish/completions/    # Fish completions
  └── claude.fish                # Covered in Lane A
```

### E1: Set up shared agent hub

| Task | Notes |
| --- | --- |
| Create `agents/shared/` directory at repo root | Contains rules/, skills/, agents/, prompts/ |
| Copy ALL of charmschool `agents/shared/rules/` | 12 rule files |
| Copy ALL of charmschool `agents/shared/skills/` | 26+ skills including _deactivated/,_skillutil/ |
| Copy ALL of charmschool `agents/shared/agents/` | writing-prose-editor.md |
| Copy ALL of charmschool `agents/shared/prompts/` | l6.md, professor_faygen.md |
| Add `agents/` to `.chezmoiignore` | Prevent deploying as `~/agents/` |

### E2: Create ~/.agents/ symlinks

| Task | Notes |
| --- | --- |
| Create `dot_agents/symlink_rules.tmpl` | Content: `{{ .chezmoi.sourceDir }}/agents/shared/rules` |
| Create `dot_agents/symlink_skills.tmpl` | Content: `{{ .chezmoi.sourceDir }}/agents/shared/skills` |
| Create `dot_agents/symlink_agents.tmpl` | Content: `{{ .chezmoi.sourceDir }}/agents/shared/agents` |
| Create `dot_agents/symlink_prompts.tmpl` | Content: `{{ .chezmoi.sourceDir }}/agents/shared/prompts` |

### E3: Claude Code config (copied, not symlinked)

| Task | Notes |
| --- | --- |
| Create `dot_claude/settings.json` | Copy from charmschool `agents/claude/settings.json` (245 lines) |
| Create `dot_claude/keybindings.json` | Copy from charmschool (19 lines) |
| Create `dot_claude/statusline.toml` | Copy from charmschool (152 lines) |

### E4: OpenCode config (copied)

| Task | Notes |
| --- | --- |
| Create `dot_config/opencode/opencode.jsonc` | Copy from charmschool (20 lines) |
| Create `dot_config/opencode/tui.jsonc` | Copy from charmschool (100 lines) |

---

## Lane F: Multiplexers

**Priority: Low** -- Small, self-contained.

### F1: tmux config

| Task | Notes |
| --- | --- |
| Copy `tmux.conf` -> `dot_config/tmux/tmux.conf` | 146 lines |
| Copy `statusline.conf` -> `dot_config/tmux/statusline.conf` | 113 lines. **Warning**: Contains Nerd Font icons |
| Copy `pane-icon.sh` -> `dot_config/tmux/executable_pane-icon.sh` | 88 lines, needs `executable_` prefix. **Warning**: Contains Nerd Font icons |

---

## Lane G: Darwin Extras

**Priority: Low** -- macOS-only, small.

### G1: Karabiner

| Task | Notes |
| --- | --- |
| Copy `karabiner.json` -> `dot_config/karabiner/karabiner.json` | 237 lines, darwin-only |
| Confirm `.chezmoiignore` excludes `dot_config/karabiner/` on Linux | Already set up |

---

## Lane H: Cleanup & Polish

**Priority: High (but last)** -- Depends on all lanes completing.

### H1: .chezmoiignore audit

| Task | Notes |
| --- | --- |
| Add `agents/` to ignore list | Symlink source dir at repo root |
| Verify `nvim/` is in ignore list | Symlink source for lockfiles |
| Remove stale entries | Any refs to old structure |
| Verify all OS-conditional excludes | kitty, karabiner on Linux |

### H2: packages.yaml audit

| Task | Notes |
| --- | --- |
| Diff darwin formulae against charmschool `tools/` | Ensure nothing new was added |
| Diff linux formulae against current needs | Ensure completeness |
| Add any missing tools discovered during migration | fzf, ripgrep, tlrc if not present |

### H3: Git config refresh

| Task | Notes |
| --- | --- |
| Diff chezmoi `dot_config/git/config.tmpl` against charmschool `git/gitconfig` | Pick up any changes |
| Verify `allowed_signers` path is templated | Currently hardcoded `/Users/winnie/` in charmschool |
| Diff `dot_config/gh-dash/config.yml` against charmschool | Pick up changes |

### H4: Script updates

| Task | Notes |
| --- | --- |
| Review bootstrap script against charmschool `bootstrap.sh` | Ensure parity |
| Review install-packages script | Ensure all taps are current |

### H5: Documentation

| Task | Notes |
| --- | --- |
| Update ARCHITECTURE.md | Reflect new single-file fish, agent hub, all new tool configs |
| Update CLAUDE.md | Reflect current state |
| Deprecate old PLAN.md | Rename or archive |

### H6: Template rendering audit

| Task | Notes |
| --- | --- |
| Verify all `.tmpl` files render correctly for darwin-full | |
| Verify all `.tmpl` files render correctly for linux-dev | |
| Check for hardcoded `/Users/winnie/` or `~/.charmschool` paths | Must all be templated |

---

## Execution Strategy

### Parallel execution plan

```text
Sprint 1 (parallel):
  Agent 1: Lane A (Fish rewrite) -- highest complexity, start first
  Agent 2: Lane C (Neovim) + Lane F (Multiplexers)
  Agent 3: Lane D (Tools & Dev configs)
  Agent 4: Lane E (Agent configurations)

Sprint 2 (parallel, smaller):
  Agent 1: Lane B (Prompt & Terminal)
  Agent 2: Lane G (Darwin extras)

Sprint 3 (sequential):
  Agent 1: Lane H (Cleanup & Polish)
```

Lane A is the critical path item -- it's the largest piece of work and the most complex due to the templating conversion. The other lanes are all straightforward copy-and-adapt operations.

### Per-lane verification

Each lane should be verified independently before moving to Lane H:

- **Lane A**: Inspect rendered config.fish for both darwin and linux. Confirm no stale `user_conf/` references. Confirm function count matches (91).
- **Lane B**: Confirm starship.toml exists. Confirm kitty/ excluded on Linux.
- **Lane C**: Confirm nvim dir structure. Confirm lockfile symlink templates point to repo root.
- **Lane D**: Confirm all tool config files present at correct paths.
- **Lane E**: Confirm agent symlink templates. Confirm Claude/OpenCode configs present.
- **Lane F**: Confirm tmux files present with correct attributes.
- **Lane G**: Confirm karabiner excluded on Linux.

### Full verification (post Lane H)

User runs manually on macOS:

- [ ] `chezmoi diff` -- review all changes
- [ ] `chezmoi apply --dry-run` -- safe test
- [ ] `chezmoi apply` -- apply changes
- [ ] New Fish shell starts, prompt works, abbreviations load
- [ ] `$DOTFILES_HOME` resolves to `~/.local/share/chezmoi`
- [ ] Git works, SSH signing works
- [ ] Neovim starts, `:checkhealth` passes, `:Lazy sync` persists lockfile
- [ ] `~/.agents/{rules,skills,agents,prompts}` are symlinks to repo
- [ ] Claude Code starts, loads settings/keybindings/statusline
- [ ] OpenCode starts, loads config
- [ ] All tools (yazi, bat, fzf, ripgrep, tmux, starship) work
- [ ] Kitty terminal renders correctly
- [ ] Karabiner recognizes config

User runs on fresh Linux VM:

- [ ] `chezmoi apply` runs without errors
- [ ] No darwin-only configs present
- [ ] Fish shell starts with correct (linux) config
- [ ] Dev tools work
- [ ] Agent configs load

---

## Decision Log (continued from v1)

| Date | Decision | Rationale |
| --- | --- | --- |
| 2026-03-28 | Single-file config.fish with Go templates | Charmschool moved to single-file for startup perf. Go templates replace `uname` checks for clean per-platform output |
| 2026-03-28 | Delete user_conf/, replace entirely | Single-file config is source of truth; old fragments are dead code |
| 2026-03-28 | Charmschool is 100% source of truth | Delete-and-replace for 1:1 dirs (functions, rules, skills) rather than merge |
| 2026-03-28 | Shared agent hub at ~/.agents/ only | Map agents/shared/ to ~/.agents/ via symlinks. Claude ~/.claude/ wiring deferred -- only copy Claude's own settings |
| 2026-03-28 | OpenCode config as regular copied files | No symlink needed -- opencode.jsonc and tui.jsonc at ~/.config/opencode/ |
| 2026-03-28 | New tool configs: fzf, ripgrep, tlrc | Discovered during exploration -- all have config files in charmschool |
| 2026-03-28 | bat theme file needed | Catppuccin-Frappe.tmTheme (2112 lines) lives alongside bat config |
| 2026-03-28 | tmux has 3 files now | tmux.conf + statusline.conf + pane-icon.sh (executable) |
| 2026-03-28 | Claude completions, keybindings, statusline are new | Not in original plan -- all need migration |
| 2026-03-28 | Nerd Font icon files need careful handling | theme.toml, statusline.conf, pane-icon.sh, kitty.conf all contain icons that can corrupt in automated edits -- prefer direct copy |
