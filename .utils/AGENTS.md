# .utils — Internal Tooling Sandbox

Prototyping ground for small utilities that support dotfiles maintenance. Tools here are chezmoi-ignored — they never deploy to the home directory. Anything that matures into a proper project graduates to its own repo.

## Stack

- **Runtime:** Deno (use `jsr:@std/*` for stdlib, no `node_modules`)
- **CLI framework:** Single-command tools are standalone scripts. Reach for [Cliffy](https://cliffy.io) when a tool needs subcommands
- **Tests:** Colocated as `<tool>_test.ts`, run with `deno test`
- **Tasks:** Register common invocations in `deno.json` tasks — the goal is `deno task <verb>` from this directory

## Conventions

- One file per tool unless complexity demands splitting
- Shebangs use `#!/usr/bin/env -S deno run --allow-read ...` with minimal permissions
- Glob inputs should work (tools process multiple files by default)
- Three output modes when applicable: **fix** (write in-place), **check** (lint, exit 1 on issues), **dry-run** (stdout preview)
- Helpful errors: show the file path, line number, and what went wrong

## Current Tools

| Tool | Task | Purpose |
| --- | --- | --- |
| `fix-md-tables.ts` | `deno task fix-tables` | Fix markdown table spacing to compact style |
