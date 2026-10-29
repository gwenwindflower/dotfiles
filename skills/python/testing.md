# Testing

pytest, red-green TDD, and tests that fail when the behavior is wrong. If a test would still pass with the requirement broken, it is noise.

## Rules

- Name tests for condition and outcome: `test_replay_skips_events_before_since`, not `test_replay`.
- One behavior per test. Arrange, act, assert, with no branching inside the test body.
- Prefer fakes over mocks. A fake implements the interface (`FakeEventStore(EventStore)`) and holds state; a `Mock` asserts call plumbing and breaks on refactor. Reach for `monkeypatch` only at process boundaries such as environment variables or the clock.
- Do not add parameters to fakes or fixtures for hypothetical scenarios. Grow test infrastructure when a real test needs it.
- No speculative tests for features that do not exist yet.
- Fixtures live in `conftest.py` at the narrowest scope that needs them. Prefer plain factory functions when a fixture would only build a value.
- `tmp_path` for filesystem tests; never write into the repository.
- Parametrize instead of copy-pasting near-identical tests; give each case an `id`.
- Property-based tests with `hypothesis` for parsers, encoders, and anything with an inverse.

## Layout

```text
tests/
  conftest.py
  fakes.py
  test_event_store.py
  test_cli.py
```

- Mirror the package layout by module. Do not mirror classes.
- `tests/**` ignores `S101` (assert), `D` (docstrings), and `PLR2004` (magic numbers) in ruff config; nothing else.

## pytest configuration

```toml
[tool.pytest.ini_options]
addopts = ["-ra", "--strict-markers", "--strict-config"]
testpaths = ["tests"]
asyncio_mode = "auto"
xfail_strict = true
filterwarnings = ["error"]
```

`filterwarnings = ["error"]` turns deprecation warnings into failures, which keeps dependencies current instead of quietly rotting.

## CLI tests

```python
def test_export_writes_jsonl(tmp_path: Path) -> None:
    result = CliRunner().invoke(cli, ["export", "--destination", str(tmp_path), "--format", "jsonl"])

    assert result.exit_code == 0, result.output
    assert (tmp_path / "events.jsonl").read_text(encoding="utf-8").count("\n") == 3
```

Assert on exit code and the output the user sees, and include `result.output` in the assertion message so failures are readable.
