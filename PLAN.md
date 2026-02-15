# Migration Plan: rotz → chezmoi

> Step-by-step plan for migrating `~/.charmschool` (rotz) to `~/.local/share/chezmoi` (chezmoi)

## Quick Reference

| Item | Value |
| --- | --- |
| Source | `~/.charmschool` (read-only reference) |
| Target | `~/.local/share/chezmoi` (active development) |
| Constraint | chezmoi is NOT installed — all work is declarative |
| Architecture | See `ARCHITECTURE.md` for file trees and design decisions |

## Guiding Principles

1. **Incremental** — One component at a time, verify before proceeding
2. **Non-breaking** — Both systems coexist during migration
3. **Behavior parity** — Final state matches rotz output
4. **Testing each step** — User will manually run `chezmoi diff` and `chezmoi apply --dry-run` to verify
5. **Iterative shift** - When a logical set of changes has been migrated, user will apply changes for real and deactivate corresponding rotz functionality

---

## Migration Phases

### Phase 0: Foundation ✅

- [x] Initialize chezmoi source directory
- [x] Create `.chezmoidata/packages.yaml` with all Homebrew packages
- [x] Create package install script (`run_onchange_darwin-install-packages.sh.tmpl`)
- [x] Create `CLAUDE.md`, `ARCHITECTURE.md`, `PLAN.md`
- [x] Create `.chezmoiignore`

---

### Phase 1: Infrastructure ⏳

**Goal:** Bootstrap scripts and directory structure

| Task | Status | Notes |
| --- | --- | --- |
| Create `.chezmoiscripts/darwin/` | ⏳ | |
| Create `.chezmoiscripts/linux/` | ⏳ | Placeholder for future |
| Move install script to `.chezmoiscripts/darwin/run_onchange_10-install-packages.sh.tmpl` | ⏳ | Currently at repo root |
| Create `run_once_before_00-bootstrap.sh` | ⏳ | Homebrew check/install |
| Create `run_once_20-configure-shell.fish.tmpl` | ⏳ | Fish to /etc/shells, chsh |
| Create `.chezmoidata/fisher.yaml` | ⏳ | Plugin list from fish_plugins |
| Create `run_onchange_30-install-fisher.fish.tmpl` | ⏳ | Fisher + plugins |

**Verify:** `chezmoi diff` shows expected scripts

---

### Phase 2: Fish Shell ⏳

**Goal:** Shell configuration (largest component)

| Task | Status | Notes |
| --- | --- | --- |
| Copy `config.fish` → `dot_config/fish/config.fish.tmpl` | ⏳ | Template for OS checks |
| Copy `00_plugin_config.fish` → `dot_config/fish/conf.d/` | ⏳ | |
| Copy 17 user_conf files → `dot_config/fish/user_conf/` | ⏳ | Mark OS-specific as `.tmpl` |
| Copy 89 functions → `dot_config/fish/functions/` | ⏳ | |
| Review `dot.fish` for deprecation/adaptation | ⏳ | rotz wrapper |
| Copy `fish_plugins` → `dot_config/fish/` | ⏳ | |

**Verify:** Open new Fish shell, test functions/abbrs/prompt

---

### Phase 3: Terminal & Prompt ⏳

**Goal:** Kitty and Starship

| Task | Status | Notes |
| --- | --- | --- |
| Copy `starship.toml` → `dot_config/starship.toml` | ⏳ | |
| Copy Kitty configs → `dot_config/kitty/` | ⏳ | kitty.conf, current-theme.conf, themes/ |

**Verify:** Restart Kitty, check theme and settings

---

### Phase 4: Git Configuration ⏳

**Goal:** Git, GitHub CLI, delta

| Task | Status | Notes |
| --- | --- | --- |
| Copy gitconfig → `dot_config/git/config` | ⏳ | |
| Copy gitignore → `dot_config/git/ignore` | ⏳ | |
| Create `dot_gitconfig` with include directive | ⏳ | Fallback for tools |
| Copy delta theme → `dot_config/delta/catppuccin.gitconfig` | ⏳ | |
| Copy gh config → `dot_config/gh/config.yml` | ⏳ | Check for secrets first |

**Verify:** `git config --list`, `gh auth status`

---

### Phase 5: Neovim ⏳

**Goal:** Symlink approach (not copied)

| Task | Status | Notes |
| --- | --- | --- |
| Copy `~/.charmschool/editor/nvim/` → `nvim/` | ⏳ | Entire directory |
| Create `symlink_dot_config/nvim.tmpl` | ⏳ | Points to source |
| Update `.chezmoiignore` for nvim internals | ⏳ | Ignore .git, etc. |

**Verify:** `nvim`, run `:checkhealth`

---

### Phase 6: File Manager & Tools ⏳

**Goal:** Yazi and mise

| Task | Status | Notes |
| --- | --- | --- |
| Copy Yazi configs → `dot_config/yazi/` | ⏳ | 5 files |
| Create `run_onchange_40-yazi-plugins.fish.tmpl` | ⏳ | Triggered by package.toml hash |
| Copy mise config → `dot_config/mise/config.toml` | ⏳ | |

**Verify:** `yazi`, `mise doctor`

---

### Phase 7: Multiplexers ⏳

**Goal:** tmux and zellij

| Task | Status | Notes |
| --- | --- | --- |
| Copy tmux.conf → `dot_config/tmux/tmux.conf` | ⏳ | |
| Copy zellij config → `dot_config/zellij/config.kdl` | ⏳ | |

**Verify:** Launch tmux/zellij, test keybindings

---

### Phase 8: AI Agent Configs ⏳

**Goal:** Claude, Copilot, etc.

| Task | Status | Notes |
| --- | --- | --- |
| Copy Claude Code settings | ⏳ | May need symlink approach |
| Copy GitHub Copilot configs | ⏳ | |
| Copy CRUSH, OpenCode configs | ⏳ | |

---

### Phase 9: Karabiner Elements ⏳

**Goal:** Keyboard remapping

| Task | Status | Notes |
| --- | --- | --- |
| Copy karabiner.json → `dot_config/karabiner/karabiner.json` | ⏳ | |

**Verify:** Karabiner-Elements recognizes config

---

### Phase 10: Cleanup & Polish ⏳

**Goal:** Finalization

| Task | Status | Notes |
| --- | --- | --- |
| Update `.chezmoiignore` (docs, etc.) | ⏳ | |
| Create `.chezmoi.yaml.tmpl` if needed | ⏳ | For prompts/machine config |
| Deprecate or adapt `dot.fish` | ⏳ | rotz wrapper → chezmoi helper? |
| Update CLAUDE.md with chezmoi workflows | ⏳ | |
| Finalize ARCHITECTURE.md | ⏳ | |
| Create README.md | ⏳ | User documentation |

---

## Verification Checklist

User will run the follow manually after complete migration (**reminder**: you will not run any `chezmoi` commands, and `chezmoi` is not installed to avoid issues):

- [ ] `chezmoi apply` runs without errors
- [ ] Fish shell starts correctly
- [ ] All abbreviations work
- [ ] Starship prompt displays
- [ ] Git commands work with correct identity
- [ ] Neovim starts without errors
- [ ] `:checkhealth` passes
- [ ] Yazi opens with plugins
- [ ] Kitty terminal renders correctly
- [ ] Catppuccin Frappe theme consistent across tools

---

## Rollback Strategy

During migration, both systems coexist:

- rotz symlinks remain until `chezmoi apply` overwrites
- To rollback: `rotz link --force` restores rotz symlinks
- Keep `~/.charmschool` intact until migration verified

---

## Post-Migration

After successful migration:

1. Push starting state to GitHub repo
2. Add GitHub Action to test on Linux and macOS runners
3. Update documentation for macOS and Linux fresh machine setup
4. Designate 'dotfiles' repo as GitHub Codespaces dotfile repo (gets automatically bootstrapped)
5. Make sure all changes are synced to GitHub and we're done!

---

## Critical Path

```text
Phase 1 (Infrastructure) → Phase 2 (Fish) → Phase 3 (Terminal/Prompt)
```

Shell must work before prompt can be tested.

---

## Decision Log

| Date | Decision | Rationale |
| --- | --- | --- |
| 2025-01-31 | Neovim as symlink | Frequent editing, plugin updates need immediate persistence |
| 2025-01-31 | Fish configs copied | Rarely edited interactively, templates needed for OS logic |
| 2025-01-31 | XDG git config | Modern standard, `~/.gitconfig` as fallback |

---

## Workflow Reference

**For each component:**

1. Read source files from `~/.charmschool`
2. Determine target path using `ARCHITECTURE.md`
3. Decide if `.tmpl` suffix needed (OS checks, data refs, path variations)
4. Create file with correct prefixes (`dot_`, `private_`, `executable_`, `symlink_`)
5. Have user verify working when chezmoi installed

**When chezmoi is installed, user steps:**

```bash
chezmoi diff                 # Preview changes
chezmoi cat <target>         # See rendered output
chezmoi apply --dry-run      # Safe test
chezmoi apply                # Apply changes
chezmoi doctor               # Check setup
```
