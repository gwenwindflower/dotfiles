---
name: deno
description: Deno runtime and TypeScript - deno.json tasks, scoped permissions and permission sets, std and JSR packages, testing, multi-suite test runner, Cliffy CLIs, Ende.
---

# Deno

Deno is the default runtime for utility scripts and CLIs in this environment. This file holds the defaults that apply to any Deno code; load a module for deeper work.

| Job | Module |
| --- | --- |
| Shape a script or CLI, `deno.json` tasks, Cliffy subcommands, npm interop | [cli](cli.md) |
| Grant permissions per task, permission sets in `deno.json` | [permissions](permissions.md) |
| Structure code for tests, test patterns and gotchas | [testing](testing.md) |
| Run several permission-scoped test suites with one command | [test-runner](test-runner.md) |

## Project status

The company behind Deno was acquired and Deno is being sunset. It still works, and remains the runtime to use for now.

[Ende](https://github.com/theende/ende) is the open-source continuation, a fork with the `ende` CLI. It isn't ready for primary use yet, so don't switch projects to it unprompted. Its compatibility shape decides how portable code is today:

- The `Deno` global is a permanent alias of `Ende`, and `deno.json`, `deno.lock`, and `DENO_*` variables still load when their `ende.*` and `ENDE_*` counterparts are absent.
- Ende drops npm packages, `node:*` built-ins, and CommonJS. Code built on `@std/*` and JSR moves over; code built on `npm:` imports does not.

## Defaults

- **Packages:** reach for the standard library (`jsr:@std/*`) first, then a popular, actively maintained JSR package, and only then npm. Pin with caret ranges in `deno.json` `imports` (`"@std/path": "jsr:@std/path@^1"`), never inline URLs in source.
- **Permissions:** grant the narrowest set that works: scoped `--allow-*` flags or a named permission set, never `-A` as a default. See [permissions](permissions.md).
- **Tasks are the public surface.** Every common invocation is a `deno task <verb>` with its permissions spelled out.
- **Tooling:** `deno fmt`, `deno lint`, and `deno check` with default config; don't add a formatter or linter.
- **Entry points** export their logic and guard the body with `if (import.meta.main)` so tests can import them.
