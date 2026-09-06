# Typing

Types are the contract. Write them so ty can verify the program and a reader can understand a signature without opening the body.

## Rules

- Annotate every parameter and return, including `-> None`. Annotate class attributes at declaration.
- Use builtin generics (`list[str]`, `dict[str, int]`) and `X | None`. Never import `List`, `Dict`, `Optional`, or `Union`.
- Accept the broadest abstract type that works (`Sequence`, `Mapping`, `Iterable` from `collections.abc`); return the concrete type you actually build.
- Use PEP 695 syntax for generics and aliases. `TypeVar` is only for constrained (not bounded) type variables.
- On 3.14+, annotations are lazily evaluated (PEP 649). Do not add `from __future__ import annotations` or quote forward references.
- Model fixed string sets as `Literal` or `StrEnum`. Kebab-case internal values; mirror the external convention when modeling an external API.
- Return `X | None` explicitly. Never return `None` from a function typed to return `X`.
- `Any` is a last resort at untyped third-party boundaries. Narrow it immediately.
- `typing.cast()` is a claim, not a check. Pair it with an `isinstance` assertion unless a type guard just ran.
- Use `Self` for fluent and constructor-like methods. Use `@override` on every overriding method.
- Prefer `TypedDict` for structured dict payloads crossing a boundary, a frozen dataclass for internal values, and Pydantic only where validation is the point.

## Generics and aliases

```python
from collections.abc import Callable, Iterable

type JsonValue = dict[str, JsonValue] | list[JsonValue] | str | int | float | bool | None
type Parser[T] = Callable[[str], T]


def first_matching[T](items: Iterable[T], predicate: Callable[[T], bool]) -> T | None:
    """Return the first item satisfying ``predicate``, or ``None`` when nothing matches."""
    for item in items:
        if predicate(item):
            return item
    return None


class Registry[K: str, V]:
    """Ordered mapping from string keys to registered values."""

    def __init__(self) -> None:
        self._entries: dict[K, V] = {}

    def register(self, key: K, value: V) -> Self:
        self._entries[key] = value
        return self
```

## Narrowing

```python
def port_from(env: Mapping[str, str]) -> int:
    raw = env.get("PORT")
    if raw is None:
        return 8080
    return int(raw)


def is_shutdown(event: Event) -> TypeIs[ShutdownEvent]:
    return event.kind == "shutdown"
```

- Prefer `TypeIs` over `TypeGuard`; it narrows both branches.
- `match` statements narrow structurally and read well for tagged unions.

## Interfaces

| Situation | Use |
| --- | --- |
| Internal interface you own, shared behavior, `isinstance` checks | `ABC` with `@abstractmethod` |
| Facade over a third-party library, minimal one-or-two-method contract | `Protocol` |

```python
class Clock(Protocol):
    def now(self) -> datetime: ...


class EventStore(ABC):
    @abstractmethod
    def append(self, event: Event) -> None:
        """Persist ``event`` at the end of the log."""

    @abstractmethod
    def replay(self, since: datetime) -> Iterator[Event]:
        """Yield events recorded after ``since`` in order."""
```

`@runtime_checkable` Protocols check method presence only, not signatures. Reach for an ABC when runtime validation matters.
