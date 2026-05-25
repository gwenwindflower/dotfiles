# twinsies — handoff

Building a "make these things the same" tool to sync agent permission entries from a single source (`twinsies.toml`) into multiple agent config files. The pattern is general (adapter-per-target) so it can extend beyond permissions later. Run from `.utils/` so Deno's LSP picks up `deno.json`.

## Why this exists

Bash/read/edit permission allowlists in `symsource_claude/settings.json` and `private_dot_config/opencode/opencode.jsonc` drift constantly — same patterns wrapped differently per agent. chezmoi templating is out (both files are symlinked because the agents edit them). Reconcile-style tool instead: source TOML → adapters → additive merge into each target.

## What's done

- `twinsies.toml` — seeded with the union of current bash/read/edit perms from both agents, plus `permissions.scalars.skill = "allow"`. Heavy comments at top explain channels and per-agent wire format.
- `twinsies.ts` — CLI with `--check`, `--dry-run`, `--target <name>`, `--source <path>`. Two adapters: `ClaudeAdapter` (JSON, wraps as `Bash(…)` / `Read(…)` / `Edit(…)`, bare scalar key) and `OpencodeAdapter` (JSONC, native keys under `permission.bash|read|edit`, scalar as `permission.<key>`).
- `deno.json` — added tasks `twinsies`, `check-twinsies`, `preview-twinsies`, `test:twinsies`.

## What's not done

1. **`twinsies_test.ts` doesn't exist yet.** The `test:twinsies` task references it. Cover at minimum:
   - `findObjectBlock` — nested braces, strings containing braces, key not found.
   - `sortEntries` — mode group order then alpha.
   - `loadSource` — parses a fixture TOML correctly.
   - Adapter `diff` — `Missing` for absent patterns, `Conflict` for same pattern in wrong mode bucket. Use fixture JSON/JSONC strings, no disk I/O — refactor adapters to accept text instead of paths if needed, or use temp files.
2. **Smoke test the actual tool.** Run `deno task check-twinsies` from `.utils/`. Expected: a list of missing entries per target (the seed is intentionally the union, so some entries will be missing in one agent or the other). If it crashes on JSONC parsing or block-finding, the OpenCode adapter is the likely culprit.
3. **`.utils/AGENTS.md` "Current Tools" table** — add a row for twinsies.
4. **Sanity-check the OpenCode JSONC rewrite.** `rewriteJsoncObjectBlock` rewrites the entire contents of `permission.bash` / `read` / `edit` when adding entries. Today those blocks have no inline comments, so no loss — but verify on first `--dry-run` that the output matches expected formatting (tab indent, blank line between mode groups, trailing commas except last entry).
5. **Decide on `skipped` reporting.** Currently if source has channels an adapter doesn't support, they're silently ignored. Reasonable now (every adapter supports every channel), but worth a `warn` once we add a Claude-only channel like `webfetch` to source.

## Key design decisions (don't undo without thinking)

- **Additive only.** Never delete entries from target files. Agents (and the user) may add extras directly; that's fine.
- **Conflicts ≠ auto-fixed.** If source says `allow` and target has the same pattern in `deny`, that's reported as a conflict (exit code 2), not silently overwritten. Forces the user to resolve.
- **No external deps for JSONC editing.** Tried `npm:jsonc-parser` — sandbox can't reach the npm registry proxy. Wrote a small block-finder that brace-matches and avoids string-literal pitfalls; works because our permission blocks are data-only. If a future channel needs to land inside a block that has comments, this strategy breaks — switch to `jsonc-parser` then.
- **Source file paths are hardcoded in adapter classes**, not declared in TOML. Two adapters, the user owns this repo — config-in-code is fine and avoids a `targets` section in TOML that just restates the obvious.
- **Sort on write.** Claude `permissions.allow|ask|deny` arrays are sorted alphabetically (matches current state). OpenCode blocks are sorted by mode group (allow → ask → deny) then alpha within. Keeps diffs small on re-runs.

## Source TOML shape

```toml
[permissions.bash]
"pnpm check *" = "allow"
"rm -rf *" = "deny"

[permissions.read]
".env" = "deny"

[permissions.edit]
".env" = "deny"

[permissions.scalars]
skill = "allow"   # → Claude "Skill" bare in allow[]; OpenCode permission.skill = "allow"
```

Channels currently supported by both adapters: `bash`, `read`, `edit`, `scalars`. To add a new channel: define it in the `Channel` union, add encoders in each adapter, add to `supports` set. Channels in source but not in an adapter's `supports` are skipped silently (TODO: warn).

## Quick reference — running it

```sh
deno task check-twinsies     # lint, exit 1 on drift
deno task preview-twinsies   # print proposed full file contents
deno task twinsies           # apply
deno task twinsies -- --target claude   # one adapter only
```

## Sandbox gotcha for any new agent

The npm registry proxy is unreachable inside the Claude sandbox (`registry.npmjs.org` shows in the allowlist but the deno fetch fails with "Proxy server unreachable"). Stick to `jsr:` for deps; if you need an npm package, either pre-cache outside the sandbox or ask Winnie to run the fetch.

JSR fetches occasionally need a warm cache too — first call to `jsr:@std/jsonc` pulled `@std/json` transitively, which may or may not be cached depending on the machine. If a fresh `deno check` fails on JSR resolution, ask Winnie to run `deno cache twinsies.ts` outside the sandbox.
