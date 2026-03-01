# Migration Plan: rotz → chezmoi

> Step-by-step plan for migrating `~/.charmschool` (rotz) to `~/.local/share/chezmoi` (chezmoi)

## Quick Reference

| Item | Value |
| --- | --- |
| Source | `~/.charmschool` (read-only reference) |
| Target | `~/.local/share/chezmoi` (active development) |
| Constraint | chezmoi is NOT installed — all work is declarative |
| Dev environment | exe.dev Linux VM (for building and testing) |
| Architecture | See `ARCHITECTURE.md` for file trees and design decisions |

## Guiding Principles

1. **Incremental** — One component at a time, verify before proceeding
2. **Non-breaking** — Both systems coexist during migration
3. **Behavior parity** — Final state matches rotz output (per platform)
4. **Cross-platform from the start** — Linux support woven into every phase, not deferred
5. **Testing each step** — User will manually run `chezmoi diff` and `chezmoi apply --dry-run` to verify
6. **Iterative shift** — When a logical set of changes has been migrated, user will apply changes for real and deactivate corresponding rotz functionality

---

## Phase Overview

```text
Phase 0: Foundation ✅
Phase 1: Machine Config & Data Files
Phase 2: Infrastructure Scripts
Phase 3: Fish Shell
Phase 4: Git Configuration
Phase 5: Terminal & Prompt
Phase 6: Neovim
Phase 7: File Manager & Dev Tools
Phase 8: Multiplexers
Phase 9: Claude Code Agent Config
Phase 10: Darwin Extras (Karabiner)
Phase 11: Cleanup & Polish
```

### Critical Path

```text
Phase 1 (Config/Data) → Phase 2 (Scripts) → Phase 3 (Fish) → Phase 5 (Prompt)
```

Shell must work before prompt can be tested. Scripts must exist before shell can be configured. Machine config must exist before scripts can branch on OS.

Phases 4, 6, 7, 8, 9 are independent of each other (can be done in any order after Phase 3).

---

## Phase 0: Foundation ✅

- [x] Initialize chezmoi source directory
- [x] Create `.chezmoidata/packages.yaml` with all Homebrew packages (darwin)
- [x] Create package install script (`run_onchange_darwin-install-packages.sh.tmpl`)
- [x] Create `CLAUDE.md`, `ARCHITECTURE.md`, `PLAN.md`
- [x] Create `.chezmoiignore`
- [x] Create `.gitignore`

**Note:** The install script is at repo root — will be moved in Phase 2.

---

## Phase 1: Machine Config & Data Files ⏳

**Goal:** Establish machine type detection and complete data files so all subsequent phases can branch on OS.

**Depends on:** Phase 0

| Task | Status | Notes |
| --- | --- | --- |
| Create `.chezmoi.yaml.tmpl` | ✅ | Auto-detects from OS: darwin→darwin-full, linux→linux-dev |
| Add `packages.linux` section to `packages.yaml` | ✅ | 3 taps + 47 dev-focused formulae |
| Add Linux taps to `packages.yaml` | ✅ | mutagen-io/mutagen, oven-sh/bun, stefanlogue/tools |
| Update `.chezmoiignore` with OS-conditional excludes | ✅ | Excludes kitty/karabiner on Linux; nvim/claude source dirs everywhere |

**Linux formulae to include:**

```text
# Shell & prompt
fish, starship

# Navigation & search
zoxide, yazi, fzf, ripgrep, fd

# File ops
bat, lsd, sd, rm-improved, 7zip

# Git ecosystem
git, git-delta, lazygit, forgit, meteor, gh

# Monitoring
bottom, procs, k9s

# Editor
neovim

# Dev tools
make, cmake, go-task, jless, jq, yq, sqlite, age

# Languages
go, ruby, deno, bun, pnpm, mise, uv

# Networking
wget, mitmproxy, mutagen

# Other
1password-cli, moor, vivid, prek, mq
```

**Verify:** `chezmoi data` shows correct machine type and package lists for both platforms.

---

## Phase 2: Infrastructure Scripts ⏳

**Goal:** Bootstrap and package install scripts for both platforms.

**Depends on:** Phase 1

| Task | Status | Notes |
| --- | --- | --- |
| Create `run_once_before_00-bootstrap.sh.tmpl` | ✅ | OS-conditional Homebrew install + shellenv |
| Create `run_onchange_10-install-packages.sh.tmpl` | ✅ | `brew bundle` — darwin (taps/formulae/casks), linux (taps/formulae) |
| Create `run_once_20-configure-shell.sh.tmpl` | ✅ | Fish to /etc/shells, chsh — linux adds brew shellenv |
| Delete per-OS subdirectories | ✅ | Consolidated from darwin/ + linux/ + universal/ to flat structure |

**Verify:** `chezmoi diff` shows expected scripts. Each script uses `if/else if/else fail` for OS guards.

---

## Phase 3: Fish Shell ✅

**Goal:** Shell configuration — the largest and most critical component.

**Depends on:** Phase 2

| Task | Status | Notes |
| --- | --- | --- |
| Create `dot_config/fish/config.fish` | ✅ | Namespace for-loop loader, copied directly |
| Create `dot_config/fish/fish_plugins` | ✅ | Fisher plugin list (reference file, Fisher not auto-run) |
| Copy `conf.d/` plugin configs → `dot_config/fish/conf.d/` | ✅ | autopair.fish, fzf.fish, git.fish, no_auto_mise.fish, puffer_fish_key_bindings.fish — full plugin conf.d tracking |
| Create `dot_config/fish/user_conf/00-env.fish.tmpl` | ✅ | Template: DOTFILES_HOME, Darwin guards for OBSIDIAN/MACOS vars |
| Copy `01-editor.fish` → `user_conf/` | ✅ | |
| Copy `02-git.fish` → `user_conf/` | ✅ | |
| Copy `03-ai.fish` → `user_conf/` | ✅ | |
| Create `04-containers.fish.tmpl` | ✅ | Template: Darwin-only Orbstack |
| Copy `1n-*.fish` language configs → `user_conf/` | ✅ | 10-rust, 11-typescript, 12-go, 13-python, 14-ruby, 19-mise |
| Copy `2n-*.fish` interactive configs → `user_conf/` | ✅ | 20-theme, 21-prompt, 23-bindings, 24-zoxide, 25-fzf, 26-mux |
| Create `22-abbrs.fish.tmpl` | ✅ | Template: $DOTFILES_HOME paths, Darwin guards for obsidian/spotify/media abbrs |
| Copy ALL functions → `functions/` | ✅ | 79 functions (user + plugin-generated) |
| Copy `user_conf/AGENTS.md` | ✅ | Added to .chezmoiignore (not deployed) |

**Files using `.tmpl`:** `00-env.fish.tmpl`, `04-containers.fish.tmpl`, `22-abbrs.fish.tmpl`

**Known minor issues (deferred):** `pbcopy` in 25-fzf.fish and functions/ops.fish, `open .` in 23-bindings.fish — macOS-only commands that fail silently on Linux. Not worth templating now.

**Verify:** Open new Fish shell, test functions/abbrs/prompt. Confirm `$DOTFILES_HOME` resolves correctly. Confirm Darwin-only configs don't load on Linux.

---

## Phase 4: Git & SSH Configuration ✅

**Goal:** Git, SSH (1Password agent forwarding + allowed signers), GitHub CLI, delta, forgit. SSH is cross-platform — uses agent forwarding with the 1Password SSH agent, so config must be in place on both darwin and linux.

**Depends on:** Phase 3 (for env vars), but can be done in parallel

| Task | Status | Notes |
| --- | --- | --- |
| Copy gitconfig → `dot_config/git/config.tmpl` | ✅ | Template: darwin-only `gpg.ssh.program` for 1Password, Linux omits (uses ssh-keygen). Fixed hardcoded `/Users/winnie/` paths |
| Copy gitignore → `dot_config/git/ignore` | ✅ | |
| Create `private_dot_ssh/config.tmpl` | ✅ | Template: darwin → 1Password agent socket, linux → `$SSH_AUTH_SOCK` (forwarded agent) |
| Copy allowed_signers → `private_dot_ssh/allowed_signers` | ✅ | Used by git for SSH commit signing |
| Create `dot_gitconfig` with include directive | ✅ | Fallback include → `~/.config/git/config` |
| Copy delta theme → `dot_config/delta/catppuccin.gitconfig` | ✅ | All 4 Catppuccin variants (Frappe active) |
| Copy forgit config → `dot_config/forgit/config` | N/A | No config file — forgit configured via fish env vars in `02-git.fish` |
| Copy gh config → `dot_config/gh/config.yml` | ✅ | No secrets — plain config |
| Copy gh-dash config → `dot_config/gh-dash/config.yml` | ✅ | Removed stale `.charmschool` repoPath, kept chezmoi path |
| Copy meteor config → `dot_config/meteor/config.json` | ✅ | Cross-platform (meteor CLI available on Linux too) |

**Verify:** `git config --list`, `ssh -T git@github.com`, `gh auth status`, `delta` renders correctly.

---

## Phase 5: Terminal & Prompt ⏳

**Goal:** Starship prompt (both platforms) and Kitty terminal (darwin only).

**Depends on:** Phase 3

| Task | Status | Notes |
| --- | --- | --- |
| Copy `starship.toml` → `dot_config/starship.toml` | ⏳ | Cross-platform |
| Copy Kitty configs → `dot_config/kitty/` | ⏳ | kitty.conf, current-theme.conf, themes/ |
| Confirm `.chezmoiignore` excludes kitty on Linux | ⏳ | Already set up in Phase 1 |

**Verify:** Starship prompt displays correctly. On macOS: restart Kitty, check theme.

---

## Phase 6: Neovim ⏳

**Goal:** Copy config normally, symlink only lockfiles (modified by Lazy.nvim/LazyVim). Cross-platform.

**Depends on:** Phase 0

| Task | Status | Notes |
| --- | --- | --- |
| Copy nvim config → `dot_config/nvim/` | ⏳ | init.lua, stylua.toml, lua/, snippets/, spell/ |
| Create `dot_config/nvim/symlink_lazy-lock.json.tmpl` | ⏳ | `{{ .chezmoi.sourceDir }}/nvim/lazy-lock.json` |
| Create `dot_config/nvim/symlink_lazyvim.json.tmpl` | ⏳ | `{{ .chezmoi.sourceDir }}/nvim/lazyvim.json` |
| Create `nvim/lazy-lock.json` at repo root | ⏳ | Source for lockfile symlink (in .chezmoiignore) |
| Create `nvim/lazyvim.json` at repo root | ⏳ | Source for lazyvim.json symlink (in .chezmoiignore) |

**Verify:** `nvim`, run `:checkhealth`, run `:Lazy sync` and confirm lazy-lock.json changes persist back to source.

---

## Phase 7: File Manager & Dev Tools ⏳

**Goal:** Yazi, mise, bat, and other tools with config files.

**Depends on:** Phase 3

| Task | Status | Notes |
| --- | --- | --- |
| Copy Yazi configs → `dot_config/yazi/` | ⏳ | yazi.toml, keymap.toml, theme.toml, package.toml, init.lua |
| Create `darwin/run_onchange_40-yazi-plugins.fish.tmpl` | ⏳ | Triggered by package.toml hash |
| Copy mise config → `dot_config/mise/config.toml` | ⏳ | |
| Copy bat config → `dot_config/bat/config` | ⏳ | If config file exists in charmschool |
| Copy uv config → `dot_config/uv/uv.toml` | ⏳ | From `lang/python/uv/uv.toml` |
| Copy ruff config | ⏳ | If config file exists |
| Copy tlrc config | ⏳ | If config exists at `$XDG_CONFIG_HOME/tlrc/tlrc.toml` |

**Verify:** `yazi` opens with plugins, `mise doctor`, `bat --config-file`.

---

## Phase 8: Multiplexers ⏳

**Goal:** tmux

**Depends on:** Phase 0

| Task | Status | Notes |
| --- | --- | --- |
| Copy tmux.conf → `dot_config/tmux/tmux.conf` | ⏳ | |

**Verify:** Launch tmux, make sure sessions start without errors and config is loaded.

---

## Phase 9: Claude Code Agent Config ⏳

**Goal:** Copy rules normally, symlink only settings.json and skills/ (modified by external tools).

**Depends on:** Phase 0

| Task | Status | Notes |
| --- | --- | --- |
| Copy `rules/` → `dot_claude/rules/` | ⏳ | 5 rule docs, copied normally |
| Copy `settings.json` → `claude/settings.json` (repo root) | ⏳ | Source for symlink (in .chezmoiignore) |
| Copy active `skills/` → `claude/skills/` (repo root) | ⏳ | Source for symlink (in .chezmoiignore), active skills only |
| Create `dot_claude/symlink_settings.json.tmpl` | ⏳ | `{{ .chezmoi.sourceDir }}/claude/settings.json` |
| Create `dot_claude/symlink_skills.tmpl` | ⏳ | `{{ .chezmoi.sourceDir }}/claude/skills` |

**Note:** Only Claude Code is managed. Other AI agent configs (Codex, Copilot, OpenCode) are exploratory and excluded from the migration.

**Verify:** `claude` starts and loads settings correctly. Rules are present. Edit settings.json in `~/.claude/` and confirm changes appear in source dir.

---

## Phase 10: Darwin Extras ⏳

**Goal:** macOS-only configurations that don't fit other phases.

**Depends on:** Phase 1 (for OS conditionals)

| Task | Status | Notes |
| --- | --- | --- |
| Copy karabiner.json → `dot_config/karabiner/karabiner.json` | ⏳ | Darwin-only |
| Review for any remaining macOS configs | ⏳ | |

**Verify:** Karabiner-Elements recognizes config.

---

## Phase 11: Cleanup & Polish ⏳

**Goal:** Finalization, documentation, and verification.

**Depends on:** All other phases

| Task | Status | Notes |
| --- | --- | --- |
| Finalize `.chezmoiignore` (complete OS-conditional list) | ⏳ | |
| Audit all `.tmpl` files render correctly | ⏳ | Test with both machine types |
| Remove rotz-specific artifacts | ⏳ | Old `dot.fish` wrapper, etc. |
| Update CLAUDE.md with chezmoi-native workflows | ⏳ | |
| Finalize ARCHITECTURE.md | ⏳ | |
| Create README.md | ⏳ | User documentation for fresh machine setup |

---

## Verification Checklist

User will run the following manually after complete migration (**reminder**: you will not run any `chezmoi` commands, and `chezmoi` is not installed to avoid issues):

### Both Platforms

- [ ] `chezmoi apply` runs without errors
- [ ] Fish shell starts correctly
- [ ] All abbreviations work
- [ ] Starship prompt displays
- [ ] `$DOTFILES_HOME` points to chezmoi source dir
- [ ] Git commands work with correct identity
- [ ] SSH agent forwarding works (`ssh -T git@github.com`)
- [ ] Git SSH signing works with allowed_signers
- [ ] Neovim starts without errors, `:checkhealth` passes
- [ ] Yazi opens with plugins
- [ ] Catppuccin Frappe theme consistent across tools
- [ ] mise works, `mise doctor` passes

### macOS Only

- [ ] Kitty terminal renders correctly
- [ ] Karabiner-Elements recognizes config
- [ ] GUI apps installable via `brew bundle`
- [ ] Fonts installed
- [ ] Orbstack integration works

### Linux Dev VMs

- [ ] Linuxbrew installs cleanly
- [ ] Dev tool set is complete and functional
- [ ] No macOS-only configs present
- [ ] Claude Code settings/rules/skills load correctly

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
4. Test on a fresh exe.dev VM to validate Linux dev setup end-to-end
5. Make sure all changes are synced to GitHub

---

## Decision Log

| Date | Decision | Rationale |
| --- | --- | --- |
| 2025-01-31 | Fish configs copied | Rarely edited interactively, templates needed for OS logic |
| 2025-01-31 | XDG git config | Modern standard, `~/.gitconfig` as fallback |
| 2026-03-01 | Linux = dev-focused only | No GUI apps/fonts/macOS tools on Linux VMs |
| 2026-03-01 | Linuxbrew for Linux packages | Unified package management, same tool versions |
| 2026-03-01 | DOTFILES_HOME env var | Replaces hardcoded `~/.charmschool` in abbrs/functions |
| 2026-03-01 | Minimal symlinks only | Only symlink files modified by external tools (lockfiles, agent settings, skill dirs). Everything else copied normally. |
| 2026-03-01 | exe.dev + Fly Sprites as targets | Persistent dev VMs, not ephemeral containers |
| 2026-03-01 | Only Claude Code for agents | Other AI tools (Codex, Copilot, OpenCode) are exploratory |
| 2026-03-01 | SSH is cross-platform (Phase 4) | Uses 1Password agent forwarding, not machine-specific. Grouped with git (allowed_signers for commit signing) |
| 2026-03-01 | tmux only, no zellij | Zellij removed from charmschool — `shell/tmux` replaces `shell/mux/` |
| 2026-03-01 | Flat scripts with OS conditionals | Per-OS subdirs were redundant — every script already had OS guards. Single files with if/else if/else fail are clearer and avoid duplication |

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
