# Pydantic

Pydantic is dataclasses with runtime validation, driven by type hints. Use it where untrusted data crosses a boundary: HTTP payloads, config files, API responses. Classes instantiated only by our own code are frozen dataclasses; ty already catches their type mismatches, and Pydantic would cost flexibility.

## Fields and metadata

`Field()` carries two kinds of metadata:

- **Field-specific**: `alias`, `default`, `default_factory`, `deprecated`. Meaningful only on the field itself.
- **Type-specific**: constraints (`gt`, `max_length`) and JSON Schema metadata (`description`, `title`).

Prefer the `Annotated` form. It holds any number of metadata elements and never looks like a default. Use the assignment form for anything a static type checker reads: `alias`, `default`, `default_factory`.

```python
from typing import Annotated

from pydantic import BaseModel, Field


class User(BaseModel):
    first_name: str = Field(alias="name")
    age: Annotated[int, Field(ge=0, description="Age in whole years")]
    nickname: Annotated[str | None, Field(deprecated=True)] = None
```

Field-specific metadata applies to the whole top-level type. `Annotated[int, Field(deprecated=True)] | None` attaches it to the `int` arm only; wrap the whole union instead, as `nickname` does.

## Constraints before validators

Express rules as built-in constraints whenever one exists: `Field(gt=1)`, `annotated_types.Gt(1)`, or `StringConstraints(strip_whitespace=True, to_lower=True)` for string normalization that `Field()` can't express. The [standard library types reference](https://pydantic.dev/docs/validation/latest/api/pydantic/standard_library_types/) lists every supported constraint.

When a custom rule is unavoidable, write an *after* validator in the `Annotated` form, next to the field. The value is already the field's type by then; a *before* validator receives arbitrary input (for model validators, not even necessarily a dict).

```python
from typing import Annotated

from pydantic import AfterValidator, BaseModel


def require_even(value: int) -> int:
    if value % 2:
        raise ValueError(f"{value} is not even")
    return value


class Batch(BaseModel):
    size: Annotated[int, AfterValidator(require_even)]
```

Decorator validators (`@field_validator`) must be `@classmethod`s and have hard-to-predict ordering across subclasses; reach for them only when a validator needs several fields.

## Coercion, unions, and collections

Outside [strict mode](https://pydantic.dev/docs/validation/latest/concepts/strict_mode/), Pydantic coerces compatible input: `"123"` validates as `int`, and `list[str]` accepts tuples and sets. So:

- Don't type a field `int | str` to coerce the string in a validator; `int` already coerces it.
- Don't type a field `Sequence[...]` to accept lists and tuples; `list[...]` already does, and abstract collections validate slowly.
- Avoid unions generally: every reader of the field has to branch on its type.

## Annotations and aliases

Annotations are lazily evaluated on 3.14+, so models need neither `from __future__ import annotations` nor quoted forward references. Recursive aliases use the `type` statement, which Pydantic resolves; it can't resolve a quoted `TypeAlias`.

```python
type JsonValue = dict[str, JsonValue] | list[JsonValue] | str | int | float | bool | None
```

## Subclasses and polymorphism

Pydantic validates and serializes by the *declared* type, not the runtime subclass. A field typed `Base` holding a `Sub1` dumps only `Base`'s fields, and a dict input validates as `Base`, silently dropping the subclass fields.

Use a discriminated union when the variants can carry a tag:

```python
from typing import Annotated, Literal

from pydantic import BaseModel, Field


class Cat(BaseModel):
    kind: Literal["cat"]
    indoor: bool


class Dog(BaseModel):
    kind: Literal["dog"]
    breed: str


type Pet = Annotated[Cat | Dog, Field(discriminator="kind")]


class Owner(BaseModel):
    pet: Pet
```

Otherwise make the container generic over the base class (`class Owner[PetT: Animal](BaseModel)`, then `Owner[Cat](...)`). [Polymorphic serialization](https://pydantic.dev/docs/validation/latest/concepts/serialization/#polymorphic-serialization) (Pydantic 2.13+) is the last resort.
