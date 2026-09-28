# Obsidian Bases

A base (`.base`) is a YAML file that renders database-style views over vault notes. Filters pick the notes, formulas compute extra columns, and views lay them out. Filters and columns read existing properties and tags; the frontmatter rules in [markdown.md](markdown.md) apply, so a base never needs a field the notes don't already have.

## Schema

```yaml
filters:                         # global, applies to every view
  and:
    - file.hasTag("Book")
    - 'file.ext == "md"'
formulas:
  days_since_edit: '(now() - file.mtime).days'
properties:                      # display settings per column
  author:
    displayName: Author
  formula.days_since_edit:
    displayName: "Days since edit"
summaries:                       # custom summary formulas over `values`
  mean_rounded: 'values.mean().round(1)'
views:
  - type: table                  # table, cards, list, or map
    name: "By status"
    limit: 50
    groupBy:
      property: status
      direction: ASC             # or DESC
    filters:                     # per-view, same syntax as global
      not:
        - file.inFolder("archive")
    order:                       # columns, left to right
      - file.name
      - author
      - formula.days_since_edit
    summaries:
      formula.days_since_edit: Average
```

The `map` view needs latitude and longitude properties and the Maps community plugin. Embed a base in a note with `![[Name.base]]` or one view with `![[Name.base#View name]]`.

## Filters

A filter is a single expression string, or an object with exactly one key, `and`, `or`, or `not`, holding a list. Lists nest.

```yaml
filters:
  or:
    - file.hasTag("Book")
    - and:
        - file.hasTag("Dataset")
        - file.hasLink("Sources")
    - not:
        - file.inFolder("archive")
```

Operators: `==`, `!=`, `>`, `<`, `>=`, `<=`, `&&`, `||`, and `!`.

## Properties

- **Note properties** are frontmatter fields: `author` or `note.author`.
- **File properties** are metadata: `file.name`, `file.mtime`, and the rest of the table below.
- **Formula properties** are computed: `formula.<name>`, which must be defined under `formulas`.

| Property | Type | Holds |
| --- | --- | --- |
| `file.name` | String | File name |
| `file.basename` | String | File name without extension |
| `file.path` | String | Path from the vault root |
| `file.folder` | String | Parent folder path |
| `file.ext` | String | Extension |
| `file.size` | Number | Size in bytes |
| `file.ctime` | Date | Created time |
| `file.mtime` | Date | Modified time |
| `file.tags` | List | Every tag in the file |
| `file.links` | List | Internal links out of the file |
| `file.backlinks` | List | Files linking to this one |
| `file.embeds` | List | Embeds in the note |
| `file.properties` | Object | All frontmatter properties |

`this` is the base file when the base is open in the main area, the embedding note when embedded, and the active note when the base sits in the sidebar.

## Formulas

```yaml
formulas:
  total: "price * quantity"
  done_label: 'if(done, "Done", "Open")'
  created: 'file.ctime.format("YYYY-MM-DD")'
  days_until_due: 'if(due, (date(due) - today()).days, "")'
  next_week: 'today() + "7d"'
```

- Subtracting two dates gives a Duration, not a number. Read a field (`.days`, `.hours`, `.minutes`, `.seconds`, `.milliseconds`) before any number function: `(now() - file.ctime).days.round(0)`, never `(now() - file.ctime).round(0)` or division by milliseconds.
- Adding a string duration shifts a date: `now() + "1 day"`, `date(due) - "2h"`, `now() + (duration("1d") * 2)`. Units are `y`/`year`/`years`, `M`/`month`/`months`, `w`/`week`/`weeks`, `d`/`day`/`days`, `h`/`hour`/`hours`, `m`/`minute`/`minutes`, and `s`/`second`/`seconds`.
- Guard properties that some notes lack with `if()`, or the formula errors on those rows.
- Every `formula.X` in `order`, `properties`, or `summaries` needs a matching `X` under `formulas`; a missing one fails silently.

## YAML quoting

- Wrap a formula that contains double quotes in single quotes: `'if(done, "Yes", "No")'`.
- Quote any string holding `:`, `{`, `}`, `[`, `]`, `,`, `&`, `*`, `#`, `?`, `|`, `-`, `<`, `>`, `=`, `!`, `%`, `@`, or a backtick: `displayName: "Status: active"`.
- A regex literal goes inside a single-quoted string: `'/^\d{4}-\d{2}-\d{2}$/.matches(file.basename)'`.

## Summaries

| Name | Input | Result |
| --- | --- | --- |
| `Average`, `Median`, `Stddev` | Number | Mean, median, standard deviation |
| `Min`, `Max`, `Sum` | Number | Smallest, largest, total |
| `Range` | Number or Date | Max minus min, or latest minus earliest |
| `Earliest`, `Latest` | Date | First and last date |
| `Checked`, `Unchecked` | Boolean | Count of true, count of false |
| `Empty`, `Filled`, `Unique` | Any | Count of empty, non-empty, distinct values |

## Checking a base

Parse the file as YAML, confirm every `formula.X` is defined, and confirm every property it reads exists in the target notes. With the app running, `obsidian base:query path="<file>.base" view="<view>" format=json` returns the rows the view would show ([obsidian-cli.md](obsidian-cli.md)); an empty result usually means a filter is wrong.

## Functions

Methods chain on a value of the listed type: `file.mtime.format("YYYY-MM-DD")`, `author.lower()`.

### Global

| Signature | Does |
| --- | --- |
| `date(string): date` | Parses `YYYY-MM-DD HH:mm:ss` |
| `duration(string): duration` | Parses a duration string |
| `now(): date` | Current date and time |
| `today(): date` | Current date at 00:00:00 |
| `if(condition, trueResult, falseResult?)` | Conditional |
| `min(n1, n2, ...): number` | Smallest number |
| `max(n1, n2, ...): number` | Largest number |
| `number(any): number` | Converts to a number |
| `link(path, display?): Link` | Builds a link |
| `list(element): List` | Wraps in a list unless already one |
| `file(path): file` | Gets a file object |
| `image(path): image` | Renders an image |
| `icon(name): icon` | Lucide icon by name |
| `html(string): html` | Renders HTML |
| `escapeHTML(string): string` | Escapes HTML characters |

### Any

| Signature | Does |
| --- | --- |
| `any.isTruthy(): boolean` | Coerces to boolean |
| `any.isType(type): boolean` | Checks the type |
| `any.toString(): string` | Converts to a string |

### Date

Fields: `year`, `month`, `day`, `hour`, `minute`, `second`, `millisecond`.

| Signature | Does |
| --- | --- |
| `date.date(): date` | Drops the time |
| `date.format(string): string` | Formats with a Moment.js pattern |
| `date.time(): string` | Time as a string |
| `date.relative(): string` | Human-readable relative time |
| `date.isEmpty(): boolean` | Always false |

### String

Field: `length`.

| Signature | Does |
| --- | --- |
| `string.contains(value): boolean` | Has the substring |
| `string.containsAll(...values): boolean` | Has every substring |
| `string.containsAny(...values): boolean` | Has any substring |
| `string.startsWith(query): boolean` | Starts with the query |
| `string.endsWith(query): boolean` | Ends with the query |
| `string.isEmpty(): boolean` | Empty or missing |
| `string.lower(): string` | Lowercases |
| `string.title(): string` | Title-cases |
| `string.trim(): string` | Strips surrounding whitespace |
| `string.replace(pattern, replacement): string` | Replaces a pattern |
| `string.repeat(count): string` | Repeats |
| `string.reverse(): string` | Reverses |
| `string.slice(start, end?): string` | Substring |
| `string.split(separator, n?): list` | Splits into a list |

### Number

| Signature | Does |
| --- | --- |
| `number.abs(): number` | Absolute value |
| `number.ceil(): number` | Rounds up |
| `number.floor(): number` | Rounds down |
| `number.round(digits?): number` | Rounds to `digits` places |
| `number.toFixed(precision): string` | Fixed-point string |
| `number.isEmpty(): boolean` | Missing |

### List

Field: `length`. `filter` and `map` expose `value` and `index`; `reduce` adds `acc`.

| Signature | Does |
| --- | --- |
| `list.contains(value): boolean` | Has the element |
| `list.containsAll(...values): boolean` | Has every element |
| `list.containsAny(...values): boolean` | Has any element |
| `list.filter(expression): list` | Keeps matching elements |
| `list.map(expression): list` | Transforms elements |
| `list.reduce(expression, initial): any` | Folds to one value |
| `list.flat(): list` | Flattens nested lists |
| `list.join(separator): string` | Joins into a string |
| `list.reverse(): list` | Reverses |
| `list.slice(start, end?): list` | Sublist |
| `list.sort(): list` | Sorts ascending |
| `list.unique(): list` | Drops duplicates |
| `list.isEmpty(): boolean` | Has no elements |

### File, link, object, regex

| Signature | Does |
| --- | --- |
| `file.asLink(display?): Link` | Converts to a link |
| `file.hasLink(otherFile): boolean` | Links to the other file |
| `file.hasTag(...tags): boolean` | Has any of the tags (no `#`) |
| `file.hasProperty(name): boolean` | Has the property |
| `file.inFolder(folder): boolean` | Is in the folder or a subfolder |
| `link.asFile(): file` | Gets the file object |
| `link.linksTo(file): boolean` | Points at the file |
| `object.isEmpty(): boolean` | Has no properties |
| `object.keys(): list` | Keys |
| `object.values(): list` | Values |
| `regexp.matches(string): boolean` | Tests a match |
