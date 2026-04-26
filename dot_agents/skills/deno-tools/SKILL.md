---
name: deno-tools
description: >
  Build CLI tools and utility scripts in Deno — from one-off scripts to multi-command
  CLIs with Cliffy. Use when: (1) Writing any TypeScript script that runs under Deno,
  (2) Creating a CLI with subcommands, (3) Structuring a Deno project with deno.json,
  tasks, tests, and permissions, (4) Choosing between a single-file script and a
  commands/ layout.
---

# Deno Tools

Deno is the default runtime for utility scripts and CLIs in this environment. This skill covers the full range — from a 30-line single-file script to a multi-command CLI built with [Cliffy](https://cliffy.io) — with the same conventions for typing, testing, formatting, and permissions throughout.

## Picking the right shape

| Shape | When |
| --- | --- |
| **Single-file script** | One job, no subcommands. `script.ts` with shebang, optional `@std/cli/parse-args` for flags. |
| **Multi-file utility** | Logic worth extracting into `lib/` + a thin entry point. Still no subcommands. |
| **Cliffy CLI** | Two or more subcommands, or you want typed options + auto-generated help. |

Don't reach for Cliffy until you actually have subcommands. A 50-line script with three flags doesn't need a framework.

## Project skeleton

Even a single script benefits from a `deno.json`:

```json
{
  "tasks": {
    "run": "deno run --allow-read=. script.ts",
    "test": "deno test --allow-read=.",
    "check": "deno check script.ts",
    "fmt": "deno fmt",
    "lint": "deno lint"
  },
  "imports": {
    "@std/cli": "jsr:@std/cli@^1",
    "@std/assert": "jsr:@std/assert@^1",
    "@std/testing": "jsr:@std/testing@^1"
  }
}
```

Tasks are the public surface. Permissions are scoped per task — `--allow-all` only when truly needed (e.g. Playwright, broad shell-out).

For a Cliffy CLI, add `"@cliffy/command": "jsr:@cliffy/command@^1.0.0-rc.7"` and use a `commands/` directory:

```text
project/
├── cli.ts              # Entry: wires up commands
├── commands/
│   ├── build.ts        # export async function build(...)
│   └── deploy.ts
├── lib/                # Shared, pure-ish helpers (easiest to test)
│   └── helpers.ts
├── tests/              # Or co-located *_test.ts files
└── deno.json
```

## Writing testable scripts

The single most important pattern: **separate logic from I/O**. Pure functions in `lib/` are trivially testable; the entry point only does argv parsing, file reads, and `console.log`.

```typescript
// lib/parse.ts
export function parseRecord(line: string): Record<string, string> { /* ... */ }

// script.ts
if (import.meta.main) {
  const text = await Deno.readTextFile(Deno.args[0]);
  for (const line of text.split("\n")) {
    console.log(parseRecord(line));
  }
}
```

The `import.meta.main` guard means the file can be imported by tests without running the script body.

Tests live next to code as `*_test.ts` (Deno's default discovery):

```typescript
// lib/parse_test.ts
import { assertEquals } from "@std/assert";
import { parseRecord } from "./parse.ts";

Deno.test("parseRecord splits on '='", () => {
  assertEquals(parseRecord("a=1"), { a: "1" });
});
```

Run with `deno task test`. BDD-style (`describe`/`it`) is available from `@std/testing/bdd` if the project's existing tests use it — match the local style.

## Permissions discipline

Granular permissions are documentation. A reader of `deno.json` should be able to tell at a glance what each task touches.

```json
"tasks": {
  "fetch-feed": "deno run --allow-net=api.example.com --allow-write=./out cli.ts fetch-feed",
  "build":      "deno run --allow-read=. --allow-write=./dist cli.ts build",
  "scrape":     "deno run --allow-all cli.ts scrape"
}
```

`--allow-all` is a code smell for everything except heavy deps that genuinely need it (Playwright reads env, spawns Chrome, writes anywhere). When you reach for it, leave a comment in `deno.json` or a one-line note in the README explaining why.

## Quick reference

- **Shebang for direct execution**: `#!/usr/bin/env -S deno run --allow-read=.` then `chmod +x`.
- **Format**: `deno fmt` (no config needed, use defaults).
- **Type check without running**: `deno check file.ts`.
- **npm packages**: `"foo": "npm:foo@^1"` in imports. Set `"nodeModulesDir": "auto"` if the package reads its own files from disk (Handlebars partials, etc.).
- **Stdin**: `await new Response(Deno.stdin.readable).text()`.
- **Exit codes**: `Deno.exit(1)` on failure. Default 0 on clean return.

## Custom test runner

Once a project has several test files with different permission needs, plain `deno test` output gets noisy. This skill ships a multi-suite runner with compact / verbose / plain output modes that auto-discovers `test:*` tasks from `deno.json`. Copy `assets/test.ts` into the project's `scripts/` directory — see [test-runner.md](test-runner.md) for setup and tradeoffs.

## Reference

- [patterns.md](patterns.md) — Cliffy specifics (option types, subcommand nesting, global options, lazy imports, error handling) and deeper testing patterns.
- [test-runner.md](test-runner.md) — Custom multi-suite test runner setup.
