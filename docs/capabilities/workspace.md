# Workspace access

Agents can edit the active project and use the local state required by its toolchain without receiving broad write access to the rest of the home directory.

## Expected behavior

- Read and write the active workspace, including normal worktrees created for it.
- Read installed toolchains, shared agent context, and user configuration needed to understand the environment.
- Write temporary directories, build caches, package stores, and selected tool state needed for normal development loops.
- Edit dotfiles in the chezmoi source tree while treating deployed user configuration as a separate, approval-gated target.
- Keep credentials, private keys, secret directories, and environment files out of agent reads.

## Safety boundary

Writable directories are granted by purpose; access to one tool's state does not imply general home-directory write access. No sandbox writes a directory that a host `PATH` lookup resolves into or a trust file, so installs and trust changes run on the host where a reviewer or the user sees them.

Credential protection differs by harness, deliberately. Claude's `Read` denies merge into its sandbox, so file tools and subprocesses both lose access. Codex's profile has no `deny` entries at all, because any deny entry disables every unsandboxed execution: allow rules and escalations silently stay sandboxed. Codex subprocesses can therefore read credential stores, and [the review policy](../agent-review-policy.md) plus guidance govern those reads.

Permission, sandbox, trust, and install-script approval changes require a task explicitly about that surface. Config source edits and deployed changes remain separate operations; `chezmoi --dry-run --no-pager apply` makes a change reviewable before the user applies it.

## Paths by purpose

Claude grants live in `sandbox.filesystem`; Codex grants live in `[permissions.dev.filesystem]`. Codex reads everywhere (`":root" = "read"`); Claude reads everything outside its deny list.

| Purpose | Paths | Claude | Codex |
| --- | --- | --- | --- |
| Workspace and temp | Session directory and worktrees, `$TMPDIR` | Write | Write (`:workspace`, `:tmpdir`, `:slash_tmp`); `.git`, `.agents`, and `.codex` inside workspace roots stay read-only |
| Darwin user temp dir | `getconf DARWIN_USER_TEMP_DIR` | Write, because `/usr/bin/mktemp` and `diff` ignore `$TMPDIR` | Covered by `:tmpdir` |
| Caches and package stores | `~/.cache`, `~/.npm`, `~/.bun/install`, `~/.cargo/{git,registry}`, `~/.go/pkg`, `~/.local/share/{aube,mise,pnpm,uv}`, `~/.local/state/mise`, `~/Library/Caches/{Homebrew,deno,go-build,mise,node-gyp,pip,com.apple.python,dev.biomejs.biome,kitty,ms-playwright}` | Write | Write |
| Tool state | `~/.agent-browser`, `~/.blacksmith`, `~/.context7`, `~/.critique`, `~/.duckdb`, `~/.mintlify`, `~/.zvec-grep`, `~/.dbt/leases`, `~/.local/share/{agentsview,graveyard,nvim}`, `~/.local/state/{herdr,nvim}`, `~/Library/Application Support/go`, `~/Library/Application Support/linear-cli/cache` | Write | Write |
| Tool configs that hold their own token | `~/.config/lightdash`, `~/.config/rclone`, `~/.config/.wrangler` | Write | Write |
| Agent state | `~/.codex/{tmp,.tmp,sqlite,cache,memories,plugins,skills}`, `~/.agents/skills`, `symsources/agents/skill-lock.json` | `~/.agents/skills` is a protected path in Claude's sandbox (`~/.claude/skills` links to it), so `gh skill` runs `open`; the manifest is writable | Write |
| Notes vault | `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/girlOS` | Write | Write |
| PATH and trust directories | `~/.local/share/mise/{installs,shims}`, `~/.local/share/uv/{python,tools}`, `~/.local/share/nvim/{lazy,mason}`, `~/.bun/install/global`, `~/.deno/bin`, `~/.local/state/mise/{trusted-configs,ignored-configs}`, symlinked tool configs under `symsources/` (aube, herdr, mise, worktrunk, yazi) | Read-only: not granted, or `denyWrite` under a granted parent | Read-only: not granted, or a `read` entry under a granted parent |
| Credential stores | `~/.ssh` (except `allowed_signers`), `~/.aws`, `~/.gnupg`, `~/.config/{gcloud,op,github-copilot}`, `~/.codex/auth.json`, the chezmoi age identity, `~/.fly`, `~/.sprites`, 1Password and browser profile data, `~/Library/Cookies`, `.env` and key files | Read-denied | Readable; reviewer policy and guidance govern access |

## Levels

Levels are defined in [agent configuration](../agent-config.md#permission-levels).

| Family | Level | Notes |
| --- | --- | --- |
| Dotfiles inspection and dry run (`chezmoi diff`, `status`, `verify`, `doctor`, `--dry-run --no-pager apply`) | `open` | They read every managed target and chezmoi's state database. Codex also runs `cat`, `data`, and `managed` on the host; Claude runs those sandboxed. |
| `chezmoi add`, `re-add`, `forget` | `review-open` | Files the task changed. |
| Real `chezmoi apply`, `update`, `init` | `review-request-open` | Approved only when the user's message asked to apply after the changes. |
| `chezmoi state`, `purge`, `manage`, `unmanage`, `destroy` | `user-open` | |
| Recoverable deletion (`rip`, single-file `rm`) | `sandboxed` | |
| Unrecoverable deletion (recursive `rm` in any flag order, `rip -d`, `sudo rm`, `dd`, `mkfs`, `chmod -R 777`) | `deny` | `rip` is the recoverable path. |
| Trust and permission surfaces (`mise trust`, `direnv allow`, build-script approvals, agent permission or sandbox config, `ctx7 setup`/`remove`, `zg install`, `zg auth grant`, agent MCP and plugin changes) | `review-request-open` | Only on a direct request about that surface. Trust files are read-only in both sandboxes, so these fail there and reach review. |

## Dotfiles deployment

A real `chezmoi apply` (and `update`, `init`) rewrites the whole home directory in one pass: `exact_` directories delete unmanaged files, run scripts fire, and the shell config is replaced. A half-finished workstream in the source tree can break the shell, and the source tree often carries several workstreams at once.

- Verification is `chezmoi --dry-run --no-pager apply` plus `chezmoi diff --no-pager`; the report says what the user should apply.
- The dry run is written flags-first because both harnesses key their host rule on that form. `chezmoi apply -n` matches the real-apply rule and goes to review.
- chezmoi's state database lives outside the sandbox. A sandboxed chezmoi call failing on it is expected and never grounds for a real apply.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | `sandbox.filesystem.allowWrite`/`denyWrite` plus `Read` and `Edit` deny rules | Read and Edit denies merge into the Bash sandbox. Excluded host commands keep permission evaluation but lose process containment. |
| Codex | Permission profile `dev`: `":root" = "read"`, purpose-listed writes, `read` overrides for PATH and trust directories, no `deny` entries | Real symlink targets are listed, including the skill-lock manifest. Rules in `command-safety.rules` and `services.rules` set the command levels above. |
| OpenCode | `permission.read` and `permission.edit` rules | Protects agent file tools; shell commands do not receive an equivalent filesystem sandbox from this config. |

## Verification

- A project test writes its normal cache and temporary output without requesting broad home access.
- `codex sandbox -P dev -- touch ~/.local/share/mise/shims/x` fails, and the same probe against `~/.cache` succeeds.
- Verify Claude's credential denies through file tools and subprocesses with synthetic fixtures, never real credentials. Codex has no equivalent check to pass.
- `chezmoi --dry-run --no-pager apply` runs without review; `chezmoi apply` and `chezmoi apply -n` both reach review, which declines unless the user asked to apply.
