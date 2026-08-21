# Workspace access

Agents can edit the active project and use the local state required by its toolchain without receiving broad access to the rest of the home directory.

## Expected behavior

- Read and write the active workspace, including normal worktrees created for it.
- Read installed toolchains, shared agent context, and user configuration needed to understand the environment.
- Write temporary directories, build caches, package stores, and selected tool state needed for normal development loops.
- Edit dotfiles in the chezmoi source tree while treating deployed user configuration as a separate, approval-gated target.
- Deny direct access to credentials, private keys, secret directories, and environment files by default.

## Safety boundary

Writable caches and state directories are enumerated by purpose. Access to one tool's state does not imply general home-directory write access. Sensitive-file rules remain effective inside otherwise writable workspaces.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | `sandbox.filesystem.allowWrite` plus `Read` and `Edit` deny rules | Native sandbox for writes; explicit tool-level protection for sensitive paths. |
| Codex | Workspace sandbox and the `workspace-winnie` filesystem profile | Native read/write/deny rules, including selected caches, tool state, and chezmoi symsources. |
| OpenCode | `permission.read` and `permission.edit` rules | Protects agent file tools; shell commands do not receive an equivalent filesystem sandbox from this config. |

## Verification

- A project test can write its normal cache and temporary output without requesting broad home access.
- Reading or editing `.env`, key material, `credentials/`, or `secrets/` is blocked.
- Editing a chezmoi source file is routine; applying it or editing the deployed target requires separate authority.
