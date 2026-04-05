# Global Context

## Temp Dirs while Sandboxed

`$TMPDIR` and `$TEMP` are automatically set to the sandbox-writable project temp dir via a `SessionStart` hook (`~/.claude/hooks/set-sandbox-tmpdir.sh`). All subprocesses inherit these, so tools like `go build`, `pytest`, `npm scripts`, etc. use the sandbox-safe path without manual intervention.

The dir follows the pattern `/private/tmp/claude-<uid>/<kebab-project-path>` and is created on session start if it doesn't exist.

If a tool needs a *different* temp env var (e.g. `GOTMPDIR`), point it at `$TMPDIR` — it's already set correctly.
