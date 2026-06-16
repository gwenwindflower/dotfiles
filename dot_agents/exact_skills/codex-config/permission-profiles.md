# Codex Permission Profiles

Use this reference when changing `default_permissions`, `[permissions.<name>]`, filesystem/network rules, or Claude-style sandbox mappings. Permission profiles are beta; refresh official Codex permissions and managed-configuration docs before editing real config.

Source references:

- Seatbelt sandbox builder: <https://github.com/openai/codex/blob/rust-v0.139.0/codex-rs/sandboxing/src/seatbelt.rs>
- `:minimal` platform defaults: <https://github.com/openai/codex/blob/rust-v0.139.0/codex-rs/sandboxing/src/restricted_read_only_platform_defaults.sbpl>

## Model Boundary

Permission profiles use `default_permissions` and `[permissions.<name>]`.

Legacy sandboxing uses `sandbox_mode` and `[sandbox_workspace_write]`. If any loaded layer sets `sandbox_mode`, or the user passes `--sandbox`, Codex uses legacy sandboxing instead of `default_permissions`.

Managed rollout exception: `allowed_permission_profiles` selects the profile model. `allowed_sandbox_modes` is only a mixed-version compatibility constraint until every managed client supports Codex 0.138.0 or later.

## Scope

Approvals decide when an action needs review. Permission profiles decide what sandboxed local commands can read, write, and reach.

Built-ins:

| Profile | Use |
| --- | --- |
| `:read-only` | Inspect files and run read-only local commands |
| `:workspace` | Write effective workspace roots and temp dirs |
| `:danger-full-access` | Remove local sandbox restrictions; requires explicit broad-access intent |

Custom profile tables:

| Table | Purpose |
| --- | --- |
| `[permissions.<name>]` | Metadata and `extends` |
| `[permissions.<name>.workspace_roots]` | Extra roots that receive `:workspace_roots` rules |
| `[permissions.<name>.filesystem]` | Global filesystem rules |
| `[permissions.<name>.filesystem.":workspace_roots"]` | Rules inside runtime and profile workspace roots |
| `[permissions.<name>.network]` | Sandboxed command networking |
| `[permissions.<name>.network.domains]` | Host allow/deny rules |
| `[permissions.<name>.network.unix_sockets]` | Narrow socket exceptions |

Higher-precedence config layers can add or replace entries under the same profile name.

## Filesystem Rules

Values are `read`, `write`, or `deny`. More specific paths override broader paths; for identical paths, `deny` beats `write`, and `write` beats `read`.

Prefer special roots before broad absolute paths:

| Path | Meaning |
| --- | --- |
| `:root` | Filesystem root |
| `:minimal` | Platform/runtime paths common tools need |
| `:workspace_roots` | Session roots plus profile-defined roots |
| `:tmpdir` | `$TMPDIR` when available |
| `:slash_tmp` | `/tmp` when available |
| `~/path` | Current user's home-relative path |
| `/absolute/path` | Platform absolute path |

Workspace-editing baseline:

```toml
default_permissions = "workspace-scoped"

[permissions.workspace-scoped]
extends = ":workspace"

[permissions.workspace-scoped.filesystem]
glob_scan_max_depth = 3
":root" = "deny"
":minimal" = "read"
":tmpdir" = "write"
":slash_tmp" = "write"
"~/.ssh" = "deny"
"~/.aws" = "deny"
"~/.config/gcloud" = "deny"
"~/.gnupg" = "deny"

[permissions.workspace-scoped.filesystem.":workspace_roots"]
"." = "write"
"**/.env" = "deny"
"**/.env.*" = "deny"
"**/*.key" = "deny"
"**/*.pem" = "deny"
"**/secrets/**" = "deny"
```

Set `glob_scan_max_depth` for unbounded deny globs on Linux, WSL, or native Windows, or enumerate bounded depths.

## Network Rules

Keep `[permissions.<name>.network] enabled = false` unless sandboxed command networking is required. When enabled, prefer domain allowlists over `"*"`.

```toml
[permissions.workspace-scoped.network]
enabled = true
allow_local_binding = false

[permissions.workspace-scoped.network.domains]
"api.github.com" = "allow"
"github.com" = "allow"
"registry.npmjs.org" = "allow"
"**.openai.com" = "allow"
"ads.example.com" = "deny"
```

Domain syntax:

| Pattern | Meaning |
| --- | --- |
| `example.com` | Exact host only |
| `*.example.com` | Subdomains only |
| `**.example.com` | Apex and subdomains |
| `*` | All public destinations |

Deny rules narrow allow rules. Local/private destinations are guarded by default; allowlist exact literals such as `localhost` or `127.0.0.1`. Set `allow_local_binding = true` only for explicit local/private-network access.

Unix socket rules are escape hatches. Use absolute socket paths and keep proxy listeners bound to loopback addresses.

```toml
[permissions.workspace-scoped.network.unix_sockets]
"/Users/winnie/.agent-browser/default.sock" = "allow"
"/var/run/docker.sock" = "deny"
```

Network profiles affect sandboxed local commands only. MCP servers, app connectors, browser/computer-use tools, Codex cloud internet, web search, and approved escalations have separate controls.

## Claude Mapping

| Claude setting | Codex equivalent |
| --- | --- |
| `sandbox.filesystem.allowRead` | `read` rules in `[permissions.<name>.filesystem]` |
| `sandbox.filesystem.allowWrite` | `write` rules in `[permissions.<name>.filesystem]` |
| `permissions.deny` for `Read(...)` / `Edit(...)` | `deny` rules, usually repo globs under `:workspace_roots` and credential dirs globally |
| `sandbox.network.allowedDomains` | `"domain" = "allow"` in `[permissions.<name>.network.domains]` |
| `sandbox.network.allowLocalBinding` | `allow_local_binding = true`, only with explicit intent |
| `sandbox.network.allowUnixSockets` | `"absolute/socket/path" = "allow"` in `[permissions.<name>.network.unix_sockets]` |

Claude `permissions.allow` / `permissions.deny` entries for `Bash(...)`, `WebFetch(...)`, `Read(...)`, or `Edit(...)` are not one-for-one Codex keys. Translate filesystem and network intent; use approval policy, managed rules, hooks, MCP config, or instructions for workflow behavior.

## Personal Template

Use this shape for workspace writes, selected tool caches, package registries, and sensitive-file denies. Prune extras; writable caches, local binding, sockets, and broad registries are access grants.

```toml
approval_policy = "on-request"
approvals_reviewer = "auto_review"
default_permissions = "personal-workspace-net"

[permissions.personal-workspace-net]
extends = ":workspace"

[permissions.personal-workspace-net.filesystem]
glob_scan_max_depth = 3
":root" = "deny"
":minimal" = "read"
":tmpdir" = "write"
":slash_tmp" = "write"
"~/.agents" = "read"
"~/.claude" = "read"
"~/.cache/pnpm" = "write"
"~/.cache/uv" = "write"
"~/.local/share/pnpm" = "write"
"~/.local/share/uv" = "write"
"~/.ssh" = "deny"
"~/.aws" = "deny"
"~/.config/gcloud" = "deny"
"~/.gnupg" = "deny"

[permissions.personal-workspace-net.filesystem.":workspace_roots"]
"." = "write"
"**/.env" = "deny"
"**/.env.*" = "deny"
"**/*.key" = "deny"
"**/*.p12" = "deny"
"**/*.pem" = "deny"
"**/*.pfx" = "deny"
"**/credentials/**" = "deny"
"**/secrets/**" = "deny"
"**/id_ed25519" = "deny"
"**/id_rsa" = "deny"

[permissions.personal-workspace-net.network]
enabled = true
allow_local_binding = true

[permissions.personal-workspace-net.network.domains]
"api.github.com" = "allow"
"github.com" = "allow"
"registry.npmjs.org" = "allow"
"pypi.org" = "allow"
"pythonhosted.org" = "allow"
"proxy.golang.org" = "allow"
"sum.golang.org" = "allow"
"storage.googleapis.com" = "allow"
"workers.cloudflare.com" = "allow"

[permissions.personal-workspace-net.network.unix_sockets]
"/Users/winnie/.agent-browser/default.sock" = "allow"
```

## Managed Requirements

Use `requirements.toml` or cloud-managed requirements for organization constraints. `allowed_permission_profiles` is a complete allowlist, including built-ins added later.

```toml
default_permissions = "org-workspace"

[allowed_permission_profiles]
":read-only" = true
org-workspace = true

[permissions.org-workspace]
extends = ":workspace"

[permissions.org-workspace.filesystem]
glob_scan_max_depth = 3

[permissions.org-workspace.filesystem.":workspace_roots"]
"**/*.env" = "deny"
```

Every allowed custom profile must be defined in a loaded config or requirements source. Use organization-specific names that do not start with `:` and do not use reserved table names such as `filesystem`.

## Checklist

1. Choose the target layer: `symsource_codex/config.toml`, trusted `.codex/config.toml`, selected `~/.codex/<profile>.config.toml`, or managed `requirements.toml`.
2. Search loaded layers for `sandbox_mode`, `[sandbox_workspace_write]`, selected `--profile` files, and `--sandbox` usage.
3. Use a built-in profile for simple cases; define custom profiles only for reusable filesystem/network carveouts.
4. Translate filesystem access first: workspace writes, temp access, cache/tool access, credential denies.
5. Translate network access second: default off; use allowlists when on.
6. Keep approvals separate: `approval_policy` and `approvals_reviewer` set review posture, not filesystem or network shape.
7. Parse TOML and dry-run chezmoi:

```bash
python3 -c 'import sys,tomllib; tomllib.load(open(sys.argv[1], "rb"))' symsource_codex/config.toml
chezmoi --dry-run --no-pager diff
```

Start a fresh Codex session after changing loaded permission keys. If behavior still looks legacy, re-check loaded layers for `sandbox_mode` or `--sandbox`.
