# Mise Bootstrap Migration

## Project contract

Replace chezmoi with mise bootstrap as the dotfile and workstation bootstrap system. Develop the replacement on the long-lived `refactor/mise-bootstrap` branch and validate it in disposable exe.dev sandboxes before applying any part of it to a persistent macOS environment.

Supported platforms:

- Apple Silicon macOS
- Debian-family Linux sandboxes, VMs, and containers

Intel macOS is not supported by the mise-based system.

The existing `main` branch remains the working chezmoi implementation until the replacement satisfies every cutover gate. The migration branch must never be applied to the current workstation as a whole during Linux development.

## Design decisions

### Repository and branch

- Keep the work in this repository so history and source files remain available.
- Create and push `refactor/mise-bootstrap` before restructuring files.
- Clone that branch directly into test sandboxes.
- Rebase it regularly on `main`; never merge `main` into it.
- Preserve unrelated fixes on `main` and port them deliberately while the branch is long-lived.

### Dotfile ownership

Use mise's modes according to the target's ownership:

| Target type | Mode |
| --- | --- |
| Authored configuration | `copy` |
| OS- or profile-dependent configuration | `template` |
| Files external tools edit | `symlink` |
| Fully owned, churn-heavy collections | Whole-directory `symlink` |
| Mixed directories | Individual entries or `symlink-each` |

Whole-directory symlinks should replace chezmoi's `exact_` behavior for agent skills and rules, Fish functions and completions, and agent/hook collections when the target is fully owned by this repository. Avoid building a general reconciliation database around mise. Any remaining copied targets that need deletion must have a narrow, explicit cleanup strategy.

Git preserves executable bits but not private `0600`/`0700` modes. A focused post-dotfiles task will enforce permissions only on security-sensitive targets.

### Configuration layers

Keep the shared configuration minimal and layer additive configuration by purpose:

```text
base
├── macos-arm64
│   ├── personal
│   └── work
└── linux
    └── sandbox
```

- Enable mise platform environments explicitly.
- Persist `personal` or `work` as a selected configuration environment.
- Keep sandbox packages out of workstation layers and workstation packages out of the base layer.
- Run machine bootstrap from the dotfiles checkout so unrelated project mise files cannot join the configuration hierarchy.

### Package ownership

Classify software by how it is consumed:

| Category | Owner |
| --- | --- |
| Portable, versioned developer CLIs | mise `[tools]` |
| Linux system packages | mise `apt:` bootstrap packages |
| Homebrew/core libraries and supported casks | mise bootstrap packages after compatibility is proven |
| Tapped formulae, unsupported casks, and temporary gaps | Native Homebrew compatibility task |
| Tool-specific packages such as Yazi plugins | mise tasks |

Keep real Homebrew available on macOS. Begin with the complete native Brewfile behavior, then shrink it only after the dotfile migration works. The durable exception boundary is the **Homebrew compatibility layer**, not a tap-only system, because it also owns unsupported casks.

### Imperative work

Use mise bootstrap's fixed phases for coarse ordering and mise task dependencies within those phases:

```text
pre-packages
└── homebrew:install

built-in packages

post-packages
└── homebrew:compat

dotfiles

post-dotfiles
└── dotfiles:permissions

macOS defaults / services / login shell

mise tools

bootstrap task
├── go:configure
├── python:default
├── yazi:plugins
└── bat:cache
```

Use task `sources` and automatic outputs for work that should rerun after an input changes. Keep cheap state checks idempotent rather than manufacturing state files unnecessarily.

### Sandbox lifecycle

Retain the dotfiles checkout in sandboxes. Persistent source removes the need for chezmoi's one-shot symlink materialization and permits updates during the sandbox lifetime.

The sandbox bootstrap entrypoint will:

1. Clone `refactor/mise-bootstrap` into a stable path.
2. Run the repository's pinned mise wrapper.
3. Trust the checkout.
4. Run bootstrap from the checkout with the `sandbox` environment.
5. Write a completion sentinel only after bootstrap and validation succeed.

The flow must fail clearly when sudo or network access is unavailable and must be safe to resume after a partial run.

## Validation policy

Every phase that changes deployed behavior is validated in a fresh exe.dev sandbox. A successful first apply is insufficient.

Required scenarios:

| Scenario | Expected result |
| --- | --- |
| Fresh bootstrap | Completes without manual repair |
| Immediate second bootstrap | No unexpected changes; status is clean |
| Interrupted bootstrap | A rerun resumes safely |
| Source file update | Only the intended target and dependent tasks change |
| Source rename or deletion | No unexplained stale functionality remains |
| Profile isolation | Sandbox receives no workstation-only packages or settings |
| Missing sudo | Fails with an actionable command rather than hanging |
| Missing network | Fails at the responsible operation and resumes later |
| Tool-written symlink target | Edits reach the repository source |
| Sensitive target | Ownership and permissions match the declared policy |

Record material surprises and accepted limitations in the decision log at the end of this file.

## Phase 0: Establish the migration branch

**Goal:** Create an isolated development line without disturbing the applied chezmoi source.

- [ ] Start `refactor/mise-bootstrap` from a clean, current `main`.
- [ ] Push the branch before restructuring the repository.
- [ ] Define the stable sandbox checkout path.
- [ ] Confirm sandbox clones can select the branch directly.
- [ ] Add a short branch workflow note for future sessions.
- [ ] Capture a baseline inventory of managed targets, scripts, symlinks, templates, permissions, packages, and profile behavior.

**Exit criteria:** The branch can be cloned independently, and the baseline identifies every behavior that the replacement must preserve or deliberately retire.

## Phase 1: Scaffold the mise bootstrap system

**Dependencies:** Phase 0

**Goal:** Produce a trusted, inspectable mise configuration that performs no broad home-directory migration.

- [ ] Commit a version-pinned `bin/mise` bootstrap wrapper.
- [ ] Create the base, `linux`, `macos-arm64`, `sandbox`, `personal`, and `work` configuration layers.
- [ ] Enable platform configuration environments explicitly.
- [ ] Define profile selection and persistence.
- [ ] Establish the target repository layout without chezmoi filename prefixes.
- [ ] Add bootstrap status and dry-run commands to the development documentation.
- [ ] Add a minimal sandbox entrypoint that clones, trusts, and invokes the branch.

**Exit criteria:** A fresh exe.dev sandbox can install and invoke the pinned mise version, load only the Linux and sandbox configuration layers, and report bootstrap status without applying dotfiles.

## Phase 2: Prove dotfile semantics

**Dependencies:** Phase 1

**Goal:** Validate each ownership mode before moving the full tree.

- [ ] Port one ordinary copied config.
- [ ] Port one OS-dependent template.
- [ ] Port one tool-written file as an individual symlink.
- [ ] Port one fully owned collection as a directory symlink.
- [ ] Port one executable file.
- [ ] Implement and test the focused private-permissions task.
- [ ] Prove shared fragment composition for Fish or agent guidance with Tera.
- [ ] Test apply, status, update, rename, deletion, and conflict behavior.
- [ ] Decide the cleanup policy for copied targets removed from configuration.

**Exit criteria:** All target modes behave predictably through first apply, no-op apply, update, and deletion scenarios in fresh sandboxes.

## Phase 3: Port the Linux dotfile surface

**Dependencies:** Phase 2

**Goal:** Replace the deployed Linux file tree while retaining the chezmoi implementation on `main`.

- [ ] Convert Linux-relevant source paths to literal target-oriented paths.
- [ ] Port Fish configuration and its assembled fragments.
- [ ] Port shared agent guidance, rules, skills, and platform agent definitions.
- [ ] Port Neovim, Git, shell, terminal, and CLI configuration used in sandboxes.
- [ ] Port externally modified state files using direct symlinks.
- [ ] Replace `exact_` collections with directory ownership decisions.
- [ ] Remove chezmoi-specific paths and instructions from migrated content.
- [ ] Verify generated files and symlink targets from within the sandbox.

**Exit criteria:** A Linux sandbox uses only mise-managed or repository-linked targets, and its interactive shell and agent tooling work without chezmoi.

## Phase 4: Port packages and imperative setup

**Dependencies:** Phase 3

**Goal:** Express Linux system setup and post-install work through mise bootstrap and task dependencies.

- [ ] Move apt packages into mise bootstrap packages.
- [ ] Move portable global CLIs into mise `[tools]` where backend behavior is verified.
- [ ] Port Node and npm-backend configuration without duplicating architecture-independent declarations.
- [ ] Replace uv tool installation with mise tools or a declared task, based on package fit.
- [ ] Port Rust installation to mise tools if it preserves the required rustup behavior.
- [ ] Define task dependencies for Go configuration, default Python, Yazi plugins, and bat cache.
- [ ] Use task sources and outputs for input-driven reruns.
- [ ] Retain a custom Linux login-shell task if mise's `chsh` behavior cannot run noninteractively on exe.dev.
- [ ] Verify task failure messages and partial-run recovery.

**Exit criteria:** A fresh Linux sandbox reaches the intended tool and shell state through one bootstrap command, and an immediate second run is clean.

## Phase 5: Harden exe.dev bootstrap

**Dependencies:** Phase 4

**Goal:** Make disposable sandboxes the reliable acceptance environment for the branch.

- [ ] Update the sandbox bootstrap entrypoint to clone `refactor/mise-bootstrap`.
- [ ] Run the complete validation matrix across multiple fresh VMs.
- [ ] Test with and without an additional project clone.
- [ ] Test private repository integration independently from dotfile bootstrap.
- [ ] Confirm the completion sentinel is written only after validation.
- [ ] Exercise interrupted package, dotfile, and task phases.
- [ ] Measure bootstrap duration and identify avoidable repeated work.
- [ ] Verify failures identify the blocked path, host, credential, or sudo command.
- [ ] Document the exact sandbox command future sessions should use.

**Exit criteria:** Three consecutive fresh exe.dev sandboxes bootstrap successfully, rerun cleanly, and survive at least one deliberate interruption test.

## Phase 6: Build the Apple Silicon configuration

**Dependencies:** Phase 5

**Goal:** Add macOS behavior without applying the full migration to the primary workstation.

- [ ] Port macOS-only dotfiles and templates.
- [ ] Add native Homebrew installation as the pre-package compatibility step.
- [ ] Run the current full Brewfile through the Homebrew compatibility task.
- [ ] Add declarative Dock, Finder, keyboard, and trackpad defaults.
- [ ] Add explicit application-restart follow-up behavior.
- [ ] Define static Apple Silicon paths for Fish and other Homebrew-owned executables.
- [ ] Port private permissions and macOS-specific symlinks.
- [ ] Remove all Intel-specific configuration and package branches.
- [ ] Validate the `personal` and `work` layer composition without cross-contamination.

**Exit criteria:** The complete macOS configuration has a clean dry-run and bootstrap status report from an Apple Silicon environment, with every planned mutation understood.

## Phase 7: Validate macOS safely

**Dependencies:** Phase 6

**Goal:** Prove the Apple Silicon setup before allowing full workstation ownership.

- [ ] Prefer a disposable Apple Silicon VM or separate macOS user for the first real apply.
- [ ] Validate dotfiles independently from packages and defaults.
- [ ] Validate Homebrew compatibility before moving formulae to mise.
- [ ] Verify macOS defaults by reading back values and plist types.
- [ ] Verify login-shell behavior in a fresh login session.
- [ ] Run first apply, no-op apply, update, rename, and rollback scenarios.
- [ ] Inventory any target that differs from the Linux ownership mode.
- [ ] On the primary workstation, stage only narrowly scoped targets after the disposable environment passes.
- [ ] Preserve recoverable copies of any existing target before its first ownership change.

**Exit criteria:** A disposable Apple Silicon environment passes the full validation matrix, and scoped workstation trials show no unexplained drift or data loss.

## Phase 8: Reduce the Homebrew compatibility layer

**Dependencies:** Phase 7

**Goal:** Move package ownership only where mise provides a clearer system.

- [ ] Classify every formula and cask as mise tool, mise bootstrap package, or Homebrew compatibility package.
- [ ] Move portable CLIs in small, independently verified groups.
- [ ] Move Homebrew/core formulae to mise only after coexistence tests pass.
- [ ] Move supported casks only after install and upgrade behavior pass.
- [ ] Keep tapped formulae and unsupported casks in the compatibility Brewfile.
- [ ] Verify real Homebrew recognizes mise-poured formulae and dependencies.
- [ ] Confirm package status, upgrade, and removal procedures for each owner.
- [ ] Keep the compatibility boundary explicit; do not create a custom package plugin unless the task boundary proves inadequate.

**Exit criteria:** Every package has one declared owner, Homebrew exceptions are focused, and package convergence works on both fresh and existing Apple Silicon environments.

## Phase 9: Prepare and execute cutover

**Dependencies:** Phase 8

**Goal:** Transfer production ownership from chezmoi to mise without dual management.

- [ ] Rebase `refactor/mise-bootstrap` on current `main` and resolve all behavior changes deliberately.
- [ ] Freeze unrelated dotfile edits during the ownership transfer.
- [ ] Compare the final mise target inventory with the chezmoi baseline.
- [ ] Remove or disable chezmoi ownership before applying mise to the same targets.
- [ ] Update `DOTFILES`, editor automation, sandbox helpers, agent guidance, README installation instructions, and project documentation.
- [ ] Replace the Neovim chezmoi apply hook with targeted mise dotfile application.
- [ ] Replace the exe.dev chezmoi one-shot flow with the validated mise bootstrap entrypoint.
- [ ] Run full bootstrap status and dry-run checks.
- [ ] Apply in recoverable groups, validating after each group.
- [ ] Retain the chezmoi branch and source checkout through a defined soak period.
- [ ] Remove chezmoi packages, config, and migration-only compatibility code only after the soak period succeeds.

**Exit criteria:** Apple Silicon and Linux are fully mise-managed, bootstrap is repeatable, documentation describes only the supported system, and chezmoi can be removed without losing source state.

## Cutover gates

All gates are mandatory:

- [ ] Three consecutive fresh exe.dev sandboxes pass bootstrap and no-op rerun.
- [ ] Interrupted sandbox bootstrap resumes safely.
- [ ] A disposable Apple Silicon environment passes the complete validation matrix.
- [ ] Personal and work profiles load deterministically.
- [ ] Every exact collection has an ownership or cleanup strategy.
- [ ] Sensitive targets have verified ownership and permissions.
- [ ] Every package has one owner.
- [ ] Homebrew compatibility exceptions are explicit.
- [ ] macOS defaults are read back with the intended values and types.
- [ ] Mise bootstrap status is clean from the dotfiles checkout.
- [ ] No target is simultaneously owned by chezmoi and mise.
- [ ] Rollback has been tested before removing chezmoi.

## Decision log

Record only decisions that change the project contract, supported behavior, phase boundaries, or cutover gates.
