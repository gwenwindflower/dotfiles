# fix-md-tables

Fix markdown table spacing to compact style — `|foo|bar|` becomes `| foo | bar |`,
separator rows normalized to `| --- | --- |` (alignment markers preserved).

## Source

- `fix-md-tables.ts` (tool)
- `fix-md-tables_test.ts` (tests)

## Run

```fish
deno task fix-tables <glob...>     # rewrite files in place
deno task check-tables <glob...>   # lint, exit 1 on issues
deno task preview-tables <glob...> # print fixed output to stdout, no writes
```

Globs are expanded via `@std/fs/expand-glob`. With no args the tool processes
nothing (no implicit cwd recursion).

## Test

```fish
deno task test:tables
```

## Notes

- Pure functions exported for test reuse — driver shells the same
  `findIssues` / `applyFixes` from the suite.
- The rule mirrors the markdownlint MD030 convention encoded in
  `~/.agents/rules/markdown-editing.md`.
