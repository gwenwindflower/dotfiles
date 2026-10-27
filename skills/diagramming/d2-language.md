# D2 Language

Use this reference for ordinary D2 authoring. The [D2 tour](https://d2lang.com/tour/intro/) remains authoritative for the full language.

## Keys, labels, and connections

Keys identify objects; labels are display text. Connections must use keys, not labels.

```d2
direction: right

web: Web application
api: Analytics API
warehouse: Data warehouse {
  shape: cylinder
}

web -> api: query
api -> warehouse: SQL
warehouse -> api: results
api -> web: response
```

D2 supports `--`, `->`, `<-`, and `<->`. A connection creates undeclared endpoint objects, but explicit declarations make labels and intent easier to maintain. Quote keys or values when they collide with reserved syntax.

## Containers and scope

Nested maps create containers. Reference a child with its full key from outside; `_` refers to the parent scope from inside a container.

```d2
cloud: Production {
  api: API
  db: PostgreSQL {
    shape: cylinder
  }
  api -> db
}

client -> cloud.api
```

Containers should express ownership, deployment, trust, or another domain boundary—not serve as decorative boxes.

## Shapes, styles, and classes

Common shapes include `rectangle`, `oval`, `circle`, `diamond`, `hexagon`, `cloud`, `person`, `cylinder`, `queue`, `page`, `package`, `sql_table`, `class`, `code`, and `sequence_diagram`. Check the [shape catalog](https://d2lang.com/tour/shapes/) before guessing a shape name.

Style through the semantic classes in [themes](themes.md); paste that `classes` block and attach classes rather than writing fill and stroke values:

```d2
check: Valid? {class: decision}
reject: Reject {class: warn}
check -> reject: no
```

Use globs only when their broad effect is intentional; an explicit class is safer when exceptions are likely. Avoid excessive fixed widths, heights, colors, and edge styling that fight themes or autolayout.

## Variables and file configuration

Use `vars` for repeated values. `${name}` substitutes a value; dotted names address nested variables.

```d2
vars: {
  owner: "Platform team"
  d2-config: {
    layout-engine: elk
    pad: 40
  }
}

service: Service {
  tooltip: Owned by ${owner}
}
```

CLI flags and environment variables override `vars.d2-config`. Keep durable render choices in the file when every consumer should get the same result; use CLI flags for one-off exports.

## Imports and reuse

Imports resolve relative to the importing file. D2 files are required, and the `.d2` suffix can be omitted.

```d2
library: @components

production: {
  ...@shared-styles
  api -> db
}
```

A regular import assigns the imported map as a value. A spread import (`...@file`) merges it into the current map. Use imports once a diagram has genuinely reusable models, styles, or views; keep small diagrams self-contained.

## Boards

D2 composition provides three board types:

| Keyword | Inheritance | Use |
| --- | --- | --- |
| `layers` | Starts from a blank board | Different abstraction levels or independent views |
| `scenarios` | Inherits from the base board | Variants of the same system |
| `steps` | Each inherits from the prior step | Progressive processes or animations |

Use object `link` values such as `layers.detail` for navigation. Choose an export that represents all boards; see [cli](d2-cli.md).

## Interactive content and remote assets

`tooltip` and `link` are interactive in SVG. PNG exports place them in an appendix; `--force-appendix` also adds one to SVG. Remote `icon` URLs make rendering network-dependent, so prefer stable hosted icons or checked-in assets when reproducibility matters. Official hosted icons live at <https://icons.d2lang.com/>.
