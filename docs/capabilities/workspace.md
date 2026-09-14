# Workspace access

Agents can edit the active project and use the local state required by its toolchain without receiving broad access to the rest of the home directory.

## Expected behavior

- Read and write the active workspace, including normal worktrees created for it.
- Read installed toolchains, shared agent context, and user configuration needed to understand the environment.
- Write temporary directories, build caches, package stores, and selected tool state needed for normal development loops.
- Edit dotfiles in the chezmoi source tree while treating deployed user configuration as a separate, approval-gated target.
- Deny direct access to credentials, private keys, secret directories, and environment files by default.

## Safety boundary

Writable caches and state directories are enumerated by purpose. Access to one tool's state does not imply general home-directory write access. Sensitive-file protection must cover both file tools and subprocesses to count as containment; the current implementations below do not establish full parity.

Permission, sandbox, trust, and install-script approval changes require a task explicitly about that surface. Do not run `mise trust`, `direnv allow`, approve package build scripts, or change MCP/plugin trust as a recovery step for unrelated work. Config source edits and deployed changes remain separate operations; use `chezmoi --dry-run --no-pager` to make a change reviewable before applying it.

## Dotfiles deployment

A real `chezmoi apply` (and `update`, `init`) rewrites the whole home directory in one pass: `exact_` directories delete unmanaged files, run scripts fire, and the shell config is replaced. A half-finished workstream in the source tree can therefore break the shell or other basics of the machine, and the source tree often carries several in-progress workstreams at once.

- Agents never run a real apply on their own. Verification is `chezmoi --dry-run --no-pager apply` plus `chezmoi diff --no-pager`; the report says what the user should apply.
- The dry run is written flags-first because every harness keys its allow on that form. `chezmoi apply -n` prompts like a real apply.
- Apply is ask-level, not denied: with a single active workstream the user will approve it. Automatic review approves only when the user's own message explicitly asked to apply after the changes. Editing dotfiles, or an agent wanting to see its change live, is not that ask.
- chezmoi's state database lives outside the sandbox, so chezmoi commands run on the host. A sandboxed chezmoi call failing on that database is expected and never a reason to bypass the sandbox into a real apply.
- `chezmoi state`, `manage`, and `unmanage` are ask-level for the same reason; `diff`, `cat`, `data`, `managed`, `doctor`, `verify`, and any dry run are routine.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | `sandbox.filesystem.allowWrite` plus `Read` and `Edit` deny rules | Read/Edit denies also merge into the Bash sandbox. Excluded host commands retain command policy but lose process containment. |
| Codex | Selected beta `workspace-winnie` profile extending `:workspace` | Minimal/toolchain reads, scoped workspace/cache/state writes, and explicit secret denies. Symlinked writable roots are unsupported; grant the real skill-lock manifest target. |
| OpenCode | `permission.read` and `permission.edit` rules | Protects agent file tools; shell commands do not receive an equivalent filesystem sandbox from this config. |

Dotfiles deployment across harnesses:

| Platform | Dry run and inspection | Real apply |
| --- | --- | --- |
| Claude Code | `Bash(chezmoi --dry-run *)`, `-n`, and the inspection subcommands are allowed; all chezmoi commands are host-excluded | `Bash(chezmoi apply *)`, `update`, `init`, `state`, `manage`, `unmanage` are `ask`; classifier guidance approves only on an explicit user request to apply |
| Codex | Unmatched, so contextual policy applies | `prefix_rule` prompts on `chezmoi apply\|update\|init\|state\|manage\|unmanage`; the justification carries the explicit-request condition to the reviewer |
| OpenCode | Same allow patterns as Claude | Same subcommands are `ask`, placed after the allows so last-match wins |

## Verification

- A project test can write its normal cache and temporary output without requesting broad home access.
- Verify secret protection separately through file tools and subprocesses using synthetic fixtures, never real credentials. Current process-level read gaps remain open; do not report this check as passing from pattern inspection alone.
- Editing a chezmoi source file is routine; `chezmoi --dry-run --no-pager apply` runs without a prompt; `chezmoi apply` and `chezmoi apply -n` both prompt, and automatic review declines the former unless the user asked for it.
