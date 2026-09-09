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

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | `sandbox.filesystem.allowWrite` plus `Read` and `Edit` deny rules | Read/Edit denies also merge into the Bash sandbox. Excluded host commands retain command policy but lose process containment. |
| Codex | Selected beta `workspace-winnie` profile extending `:workspace` | Minimal/toolchain reads, scoped workspace/cache/state writes, and explicit secret denies. Symlinked writable roots are unsupported; grant the real skill-lock manifest target. |
| OpenCode | `permission.read` and `permission.edit` rules | Protects agent file tools; shell commands do not receive an equivalent filesystem sandbox from this config. |

## Verification

- A project test can write its normal cache and temporary output without requesting broad home access.
- Verify secret protection separately through file tools and subprocesses using synthetic fixtures, never real credentials. Current process-level read gaps remain open; do not report this check as passing from pattern inspection alone.
- Editing a chezmoi source file is routine; applying it or editing the deployed target requires separate authority.
