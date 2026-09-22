---
name: clean-python
description: Write clean, modern, strictly typed Python on the Astral toolchain (uv, ruff, ty). Use when writing, reviewing, or refactoring Python, setting up pyproject.toml, configuring ruff or ty, or wiring Python CI. Skip for Pydantic model design (use pydantic) and dbt Python models (use dbt-analytics-engineering).
metadata:
  inspired-by: dagster-io/skills dignified-python v1.13.20
---

# Clean Python

Readable, explicit Python for the latest stable CPython. Great names carry meaning, types carry contracts, and the Astral toolchain enforces both.

## Defaults

- **Toolchain**: uv manages Python and packages, ruff lints and formats, ty type-checks. Everything is configured in `pyproject.toml`. See [toolchain](toolchain.md).
- **Version**: target the latest stable CPython and use its features. Never add compatibility shims for older versions unless the project declares a lower `requires-python`.
- **Typing**: strict and explicit. Every function signature is fully annotated; `Any` and `cast()` need justification. See [typing](typing.md).
- **Docstrings**: every public module, class, and function has a Google-style docstring stating purpose, arguments, return, and raised exceptions.
- **Naming**: names describe purpose, not implementation. No `data`, `result`, `helper`, `manager`, `tmp` unless the surrounding convention makes them precise.
- **Errors**: prefer a cheap precondition check over `try/except` for ordinary branching. Catch at boundaries, chain with `from`, never swallow. See [errors](errors.md).
- **Structure**: module-level imports, no import-time side effects, no re-exports, keyword-only arguments past the first parameter, defaults only when almost every caller wants them. See [structure](structure.md).
- **Async**: use `asyncio` structured concurrency for I/O-bound work. Never block the event loop. See [async](async.md).
- **Testing**: pytest, red-green TDD, fakes over mocks, tests named for the behavior they prove. See [testing](testing.md).
- **CLI and subprocess**: patterns in [cli](cli.md).

## Style Rules

- `pathlib.Path` everywhere; never `os.path`. Always pass `encoding="utf-8"`.
- Absolute imports only.
- Properties and dunder methods are O(1). Anything that does I/O or iteration is a named method.
- Maximum four levels of indentation. Extract a named function instead of nesting deeper.
- Declare variables next to their first use. Do not pull object attributes into single-use locals.
- Keep context managers inline in `with`; extract a function that returns one if the expression grows.
- `dataclass(frozen=True, slots=True)` for value objects; `Enum` or `Literal` for fixed sets of strings.
- Break internal APIs and migrate call sites in one change. Preserve compatibility only for published public APIs or on explicit request.

## Review Pass

Before finishing Python work, confirm:

1. `uv run ruff check` and `uv run ruff format --check` pass with the full rule set.
2. `uv run ty check` passes with no suppressions added.
3. Every public symbol has a type-complete signature and a docstring.
4. No new `try/except` without a boundary, a context-adding re-raise, or an operation that is its own authoritative test.
5. Tests cover the behavior, not the plumbing.
