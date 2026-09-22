# Structure

Modules, imports, signatures, and docstrings shape how code reads. Optimize for the reader who opens one file cold.

## Modules

- Module-level code is limited to imports, constants, type aliases, and definitions. Anything that computes, does I/O, or can fail lives in a function, cached with `functools.cache` when it should run once.
- Absolute imports at the top of the module. Inline imports only to break a genuine cycle, under `TYPE_CHECKING`, or for a measured startup cost noted in a one-line comment.
- One canonical import path per symbol. Keep `__init__.py` empty; never re-export. Plugin entry points that must re-export use `from pkg.mod import name as name`.
- Name modules after what they contain (`event_store.py`, `manifest.py`), not after a layer (`utils.py`, `helpers.py`, `common.py`).

```python
@cache
def settings_path() -> Path:
    """Return the user settings file, honoring ``XDG_CONFIG_HOME``."""
    return Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "spool" / "settings.toml"
```

## Signatures

- The first parameter may be positional (or `self`, or a context object). Everything after it is keyword-only via `*`. Applies at three or more parameters; ABC and Protocol methods and framework callbacks are exempt.
- Defaults are for values that nearly every caller wants. A default that encodes a choice each caller should make (encoding, timeout, destructive flags) is a bug waiting to happen; require it.
- A default that is never overridden is not a parameter. Delete it and inline the behavior.
- Booleans that select behavior are usually two functions or a `Literal` mode. Prefer `mode: Literal["strict", "lenient"]` over `strict: bool` when a third mode is plausible.
- Return a frozen dataclass or `NamedTuple` instead of a tuple when the caller would have to remember positions.

```python
def export_events(
    store: EventStore,
    *,
    since: datetime,
    destination: Path,
    file_format: Literal["jsonl", "parquet"],
) -> ExportSummary: ...
```

## Docstrings

Google style, enforced by ruff's `D` rules. A docstring says what the caller gets and what can go wrong, not how the body works.

```python
def replay(self, since: datetime) -> Iterator[Event]:
    """Yield events recorded after ``since`` in commit order.

    Args:
        since: Exclusive lower bound on the event timestamp.

    Yields:
        Events ordered by commit time.

    Raises:
        StoreClosedError: If the store was closed before replay finished.
    """
```

- One-line docstrings for trivial functions are fine; still end with a period.
- Document `Raises` for exceptions the caller is expected to handle, not every possible internal failure.
- Code inside docstrings is formatted by ruff (`docstring-code-format`), so examples stay runnable.

## Naming

- Functions are verbs (`load_manifest`, `replay_events`); predicates read as questions (`is_expired`, `has_pending`).
- Classes are nouns for the thing they represent. Avoid `Manager`, `Handler`, `Processor`, `Service` unless the codebase already uses them with a precise meaning.
- Collections are plural; a loop variable is the singular (`for event in events`).
- Private module members start with `_`. Name-mangled `__attrs` are almost never worth it.
- Constants are `UPPER_SNAKE` and only for true constants, never for cached results.
