# twinsies

Reconcile shared `bash` and `edit` permission entries across multiple agent
config files from a single source of truth (`twinsies.toml`). Full sync inside
the regions twinsies owns: missing entries added, extras removed, mode drift
resolved source-wins. Everything outside the owned regions is left untouched.

## Source

- `twinsies.ts` (tool)
- `twinsies.toml` (manifest)
- `twinsies_test.ts` (tests)

## Targets

| Adapter | Path | Owned regions |
| --- | --- | --- |
| Claude | `symsource_claude/settings.json` | `Bash(…)` and `Edit(…)` entries in `permissions.allow` / `permissions.ask` / `permissions.deny` |
| OpenCode | `private_dot_config/opencode/opencode.jsonc` | `permission.bash` and `permission.edit` blocks |

## Run

```fish
deno task twinsies            # apply (writes both target files)
deno task twinsies:preview    # rich diff + proposed file contents, exit 0
deno task twinsies:check      # terse drift report, exit 1 on drift
```

Options on the underlying script: `--target <claude|opencode>` (repeatable) to
limit scope, `--source <path>` to override the manifest path.

## Test

```fish
deno task test:twinsies
```

## Channels

Only `bash` and `edit` are tracked. `read` was deliberately dropped — Claude's
sandbox read-root allowlist is a Claude-only feature with no OpenCode parallel,
and there's no meaningful cross-agent thing to sync. Hand-maintain Claude's
`Read(…)` entries in `settings.json` directly.

## What twinsies leaves alone

- **Claude-only**: `Read(…)` sandbox roots, `WebFetch(domain:…)`, `Skill` and
  other bare-capability scalars, `mcp__*` server entries.
- **OpenCode-only**: the catch-all `"*": "ask"` inside `permission.bash` (the
  default-ask floor), and sibling scalar keys under `permission` like
  `permission.skill`.

These are agent-specific and intentionally out of scope. The TOML header lists
them.

## Editing the manifest

`twinsies.toml` has one section per channel:

```toml
[permissions.bash]
"git status *" = "allow"
"rm -rf *" = "deny"

[permissions.edit]
"**/*.env" = "deny"
```

Modes are `allow` / `ask` / `deny`. Add an entry, run `deno task twinsies`,
both target files update.

## Reconciliation semantics

For each owned channel:

- **Missing**: source has it, target doesn't → add to target.
- **Extra**: target has it inside an owned region, source doesn't → remove.
- **Conflict** (mode drift): same pattern, different mode in source vs target →
  source mode wins.

Sorting inside each block is automatic: ask → allow → deny groups, alphabetical
within. The bare-glob `"*"` catch-all in OpenCode sorts to position 0 of its
group thanks to its ASCII value (42).
