# ast-grep

`ast-grep` matches code by syntax tree, not text. Patterns match whole AST nodes, so it finds constructs `rg` can't express and ignores formatting differences.

| Need | Command |
| --- | --- |
| Map a file or directory before reading source | `ast-grep outline` |
| One construct, no relational logic | `ast-grep run --pattern '<code>' --lang <lang> <path>` |
| Nested, contextual, or negated conditions | `ast-grep scan --rule rule.yml <path>` or `--inline-rules` |
| See how code or a pattern parses | `--debug-query=cst\|ast\|pattern` on `run` |

## Outline

A syntax-only structural map with line numbers: top-level items (imports, functions, classes, structs, interfaces, enums) and their direct members. Read code in stages: find candidate files, outline them, then open only the range the outline points to.

```bash
ast-grep outline <file>                                  # local structure with member digests
ast-grep outline <file> --items imports|exports
ast-grep outline <dir> --items exports                   # public surface (directory default)
ast-grep outline <dir> --type struct,enum,function
ast-grep outline <file> --match <regex> --type class --view expanded
ast-grep outline $(git diff --name-only HEAD) --items exports   # structure of what changed
```

- `--view` runs from least to most detail: `names`, `signatures`, `digest` (signatures plus member names), `expanded` (one line per member).
- `--match` is a case-sensitive Rust regex on top-level names and signatures, never members. `--type` also filters top-level items only.
- `--pub-members` hides private members; `--json=stream` gives one object per file for post-processing.
- It doesn't resolve references, infer types, follow re-exports, or build call graphs. Answer those with `run`, `rg`, or `zg`, then outline what they surface.

## Writing a rule

1. Write a small snippet that contains the target code, in the target language.
2. Start with the simplest rule: a `pattern`, then `kind`, then relational rules (`has`, `inside`, `precedes`, `follows`), then composites (`all`, `any`, `not`).
3. Put `stopBy: end` on every relational rule so the search traverses the whole subtree instead of stopping at the first non-match.
4. Test against the snippet before the codebase:

   ```bash
   echo 'async function t() { await fetch(); }' | ast-grep scan --stdin --inline-rules 'id: t
   language: javascript
   rule:
     kind: function_declaration
     has:
       pattern: await $EXPR
       stopBy: end'
   ```

5. Run it on the codebase. Keep complex rules in a file (`--rule rule.yml`) rather than inline.

Full rule syntax (atomic, relational, composite rules, metavariables, pattern objects with `selector`, `context`, `strictness`) is in [ast-grep-rules](ast-grep-rules.md).

## Zero matches

- A pattern matches a complete node shape: `env::var($E)` does not match `std::env::var("X")`. Try bare and fully qualified forms, or absorb extra nodes with `$$$`.
- Test the pattern on a snippet known to contain the code, and check how it parsed with `--debug-query=pattern`. Use `--debug-query=cst` on target code to find the right `kind` names.
- For rules: simplify to one sub-rule, add missing `stopBy: end`, and confirm `kind` values for the language.

## Output and quoting

- `--json` (on `run` and `scan`) prints a bare array. Each match has `text`, `file`, `lines`, `language`, a 0-based `range`, and `metaVariables` with `single` (`$ARG`) and `multi` (`$$$REST`, a list).

  ```bash
  ast-grep run --pattern 'foo($ARG)' --lang javascript --json . \
    | jq -r '.[] | "\(.file):\(.range.start.line + 1): \(.metaVariables.single.ARG.text)"'
  ```

- Single-quote inline rules and patterns so the shell leaves `$VAR` alone; inside double quotes escape it as `\$VAR`.
