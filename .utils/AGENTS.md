# .utils — Internal Tooling Sandbox

Prototyping ground for small utilities that support dotfiles maintenance. Tools here are chezmoi-ignored — they never deploy to the home directory. Anything that matures into a proper project graduates to its own repo.

## Stack

- **Runtime:** Deno (use `jsr:@std/*` for stdlib, no `node_modules`)
- **CLI framework:** Single-command tools are standalone scripts. Reach for [Cliffy](https://cliffy.io) when a tool needs subcommands
- **Tests:** Colocated as `<tool>_test.ts`, run via the custom suite runner (`deno task test`)
- **Tasks:** Register common invocations in `deno.json` tasks — the goal is `deno task <verb>` from this directory

## Conventions

- One file per tool unless complexity demands splitting
- Shebangs use `#!/usr/bin/env -S deno run --allow-read ...` with minimal permissions
- Glob inputs should work (tools process multiple files by default)
- Three output modes when applicable: **fix** (write in-place), **check** (lint, exit 1 on issues), **dry-run** (stdout preview)
- Helpful errors: show the file path, line number, and what went wrong
- **Export pure functions, guard `main()`** with `if (import.meta.main) { main(); }` so the tool is importable from tests

## Testing

Tests live alongside each tool as `<tool>_test.ts`. The pattern:

1. Each tool exports its pure functions (parsing, transforming, validation)
2. The test file imports those functions and asserts behavior with `Deno.test` + `@std/assert`
3. A per-tool task in `deno.json` (`test:<tool>`) runs that suite with the right permissions
4. The top-level `test` task runs `scripts/test.ts`, a custom runner that auto-discovers every `test:*` task and reports across all suites with a compact / verbose / plain output mode

```text
deno task test              # all suites, compact (spinner + progress bar)
deno task test -v           # full deno test output per suite
deno task test tables       # filter to suites with "tables" in label
deno task test:tables       # run a single suite directly
```

Adding a new tool: create `<tool>_test.ts`, then add a `test:<tool>` task to `deno.json` with the minimum permissions that suite needs. The runner picks it up automatically — no runner edit required.

The runner source lives at `scripts/test.ts`, copied from the `deno-tools` skill (`~/.claude/skills/deno-tools/assets/test.ts`). Update the asset there first if you improve it; copy back to keep this dir in sync.

## Current Tools

| Tool | Run | Test | Purpose |
| --- | --- | --- | --- |
| `fix-md-tables.ts` | `deno task fix-tables` | `deno task test:tables` | Fix markdown table spacing to compact style |
| `generate-logo.ts` | `deno task logo` | `deno task test:logo` | Render text to SVG (one `<path>` per glyph) using a local font |
