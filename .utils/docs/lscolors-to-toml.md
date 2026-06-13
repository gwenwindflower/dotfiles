# lscolors-to-toml

Convert `$LS_COLORS` into yazi-compatible TOML rules. Primary use: theming
yazi's file panel from the same color scheme the shell uses for `lsd`/`ls`.

## Source

- `lscolors_to_toml.ts` (tool)
- `lscolors_to_toml_test.ts` (tests)

## Run

```fish
deno task lscolors           # reads $LS_COLORS from the env, prints TOML
```

## Test

```fish
deno task test:lscolors
```

## Notes

- `$LS_COLORS` must be set in the calling shell — the tool reads it directly
  via `--allow-env`.
- Output is stdout TOML; pipe into `~/.config/yazi/theme.toml` or similar.
