## Temp Dirs while Sandboxed

`$TMPDIR` and `$TEMP` are automatically set to the sandbox-writable project temp dir via a `SessionStart` hook (`~/.claude/hooks/set-sandbox-tmpdir.sh`). All subprocesses inherit these, so tools like `go build`, `pytest`, `npm scripts`, etc. use the sandbox-safe path without manual intervention.

The dir follows the pattern `/private/tmp/claude-<uid>/<kebab-project-path>` and is created on session start if it doesn't exist.

If a tool needs a *different* temp env var (e.g. `GOTMPDIR`), point it at `$TMPDIR` — it's already set correctly.

**`bun` and `bunx` are the exception.** Bun reads the temp dir directly from the darwin system (via `confstr(_CS_DARWIN_USER_TEMP_DIR)`) rather than the `TMPDIR` env var, so it bypasses our re-assignment and hits the sandbox-blocked default path. Hacking around this is not worth it — use `pnpx` instead of `bunx` for one-off package execution, and reach for `pnpm` over `bun` when you need a JS runner in a sandboxed task.
