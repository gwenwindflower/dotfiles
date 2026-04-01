# Global Context

## Temp Dirs while Sandboxed

If you need a temp directory for a tool to run, but you're sandboxed from asking the usual $TMPDIR $TMP $TEMP env vars, here's a pattern you can use: you have a per-project temp directory for writing tasks, tracking transient session state, etc. Use that as you temp directory.

For example:

```bash
GOTMPDIR=/private/tmp/claude-501/-Users-winnie-dev-rowing-machine
```

The pattern is:

```bash
ENV_VAR_NAME=/private/tmp/claude-501/-{path-to-project}
# note the '-' before the path, and the kebab-casing of the path
```
