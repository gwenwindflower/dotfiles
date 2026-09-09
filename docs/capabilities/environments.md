# Remote environments

Agents can run in disposable Linux environments that carry the same dotfiles, tools, and guidance as the workstation, so long-running or risky work leaves the laptop without changing how the agent behaves.

## Expected behavior

- exe.dev VMs host longer-running project sandboxes; `et` creates one, bootstraps the dotfiles, optionally clones a repository through an exe.dev GitHub integration, and opens a shell.
- Fly.io Sprites host many short-lived or frequently checkpointed sandboxes; `spritecan` creates one, bootstraps the dotfiles, and opens its console.
- microsandbox (`msb`) provides local sandboxes more contained than the harness sandbox when a task needs stronger isolation without leaving the machine.
- Every remote target bootstraps with `chezmoi init --one-shot` under `CHEZMOI_ONESHOT=1`, which installs the Linux profile and materializes symlinked sources as copies before the source tree is purged.
- Inside a remote environment an agent follows the same shared guidance and capability boundaries as on macOS; only the platform-specific surfaces (GUI apps, Homebrew, Kitty, Karabiner) are absent.

## Safety boundary

Remote environments are ephemeral: nothing durable lives only there. Work is pushed to its repository before the environment is discarded, and the notes vault is not reachable from them. Credentials arrive through the platform's own integration (exe.dev GitHub integrations, Fly.io auth), never by copying keys or tokens from the workstation.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Same settings and rules rendered by the Linux profile; the harness sandbox is layered on top of the VM boundary | No remote-specific configuration; behavior parity comes from the shared dotfiles. |
| Codex | Same rendered `AGENTS.md` and config on the Linux profile | As above. |
| OpenCode | Same rendered `AGENTS.md` and config on the Linux profile | As above. |

The environments are entered from the user's terminal (`et`, `spritecan`, `msb`); no harness launches them on its own.

## Verification

- A fresh exe.dev VM or Sprite reaches a working Fish shell with the shared agent guidance rendered after one bootstrap.
- Symlinked sources inside the one-shot target are real files, not dangling links.
- An agent in a remote environment cannot reach the workstation's credentials or vault.
