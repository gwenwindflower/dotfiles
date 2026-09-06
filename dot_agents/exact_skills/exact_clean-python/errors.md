# Errors

Default: let exceptions propagate. Handle them where you can add context or where the program meets the outside world.

## Preconditions before try/except

```python
if key in settings:
    apply(settings[key])

timeout = settings.get("timeout", DEFAULT_TIMEOUT)

config_dir = config_path.resolve(strict=True)
```

- Membership, `.get()`, `is None`, `.exists()`, and `isinstance` are precise and cheap. Use them for ordinary branching.
- Check `.exists()` only when filesystem presence is part of the requirement. `Path.resolve()` accepts missing paths unless `strict=True`; `is_relative_to()` returns a bool and never raises for unrelated paths.
- Prefer a real parser inside a small `try` over a brittle shape check like `str.isdigit()`. When the try/parse/default pattern repeats, extract `try_parse(parser, value, default)`.

## When try/except is right

1. **Error boundaries**: CLI commands, request handlers, task entry points. Translate to an exit code, a response, or a log line.
2. **The operation is its own test**: parsing, network calls, a library that offers no precondition.
3. **Adding context**: wrap and re-raise with what the caller needs to know.

```python
try:
    document = parse_manifest(manifest_path)
except tomllib.TOMLDecodeError as error:
    raise ManifestError(f"{manifest_path} is not valid TOML") from error
```

## Chaining

- Raising inside `except` always uses `from error` (preserve cause) or `from None` (deliberately drop it). Ruff B904 enforces this.
- `from None` is for boundaries that already surfaced the error to the user, or when the original type is noise to the caller.

## Custom exceptions

- Define one base exception per package (`class SpoolError(Exception)`), subclass per failure category, and raise those from library code. Callers catch the base at boundaries.
- Put the actionable detail in the message: the path, the key, the expected form. `add_note()` attaches context without re-raising.
- Use `ExceptionGroup` and `except*` when a `TaskGroup` can fail in more than one way.

## Never

- Bare `except:` or `except Exception: pass`. Even at a boundary, log with `logger.exception` so the failure is diagnosable.
- Silent fallbacks that mask failure (`try primary() except Exception: return degraded()`). Let it fail loudly, or make the fallback an explicit, logged mode.
- Catching broad exceptions deep inside library code to return `None`. Return a typed result or raise a package exception.
