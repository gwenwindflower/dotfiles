# CLI and Subprocess

## Click

- `click.echo()` for output, never `print()`. Errors go to stderr with `err=True`.
- Each command is an error boundary: catch package exceptions, print one actionable line, `raise SystemExit(1) from error`.
- Flush stderr before `click.confirm()` or `click.prompt()` so buffered warnings appear before the prompt.
- Take paths as `click.Path(path_type=Path)` so handlers receive `Path`, not `str`.
- Business logic lives in importable functions; the command function parses, calls, and reports. This keeps tests fast and the CLI thin.
- Provide `--help` text on every option, `--json` output on commands whose output an agent or script will parse, and a `--verbose` flag that raises log level.
- Exit codes: `0` success, `1` failure, `2` usage error (Click's default). Document any others.

```python
@click.command("export")
@click.option("--destination", type=click.Path(path_type=Path, file_okay=False), required=True, help="Directory to write into.")
@click.option("--format", "file_format", type=click.Choice(["jsonl", "parquet"]), required=True, help="Output encoding.")
@click.pass_obj
def export_command(app: AppContext, *, destination: Path, file_format: Literal["jsonl", "parquet"]) -> None:
    """Export the event log."""
    try:
        summary = export_events(app.store, since=app.since, destination=destination, file_format=file_format)
    except SpoolError as error:
        click.echo(f"error: {error}", err=True)
        raise SystemExit(1) from error
    click.echo(f"wrote {summary.count} events to {summary.path}")
```

Typer is acceptable when a project already uses it; its type-driven options map cleanly to this style. Argparse is for scripts with no dependencies.

## Subprocess

- Always pass `check` explicitly: `check=True` to raise, `check=False` when you inspect `returncode` yourself.
- Always pass `text=True` and `capture_output=True` unless streaming to the terminal is the point.
- Argument lists, never shell strings. `shell=True` is a security review item.
- Set a `timeout` for anything that talks to a network or another process you do not control.
- Wrap in a package exception at the boundary with `stderr` in the message.

```python
def git_output(args: Sequence[str], *, cwd: Path) -> str:
    """Run ``git`` with ``args`` in ``cwd`` and return trimmed stdout."""
    try:
        completed = subprocess.run(["git", *args], check=True, capture_output=True, text=True, cwd=cwd, timeout=60)
    except subprocess.CalledProcessError as error:
        raise GitCommandError(f"git {' '.join(args)} failed: {error.stderr.strip()}") from error
    return completed.stdout.strip()
```

In async code use `asyncio.create_subprocess_exec` and `await process.communicate()`; never `subprocess.run` inside a coroutine.
