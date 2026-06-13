# generate-logo

Render text to SVG using a local font. Each glyph becomes its own `<path>` with
`data-char` and `data-index` attributes, so glyphs can be targeted independently
for CSS/JS animation.

## Source

- `generate-logo.ts` (tool)
- `generate-logo_test.ts` (tests)

## Run

```fish
deno task logo --text "winnie.sh" --font moon_get-Heavy --output logo.svg
```

## Test

```fish
deno task test:logo
```

## Font resolution

Font names without an extension are resolved against `~/Library/Fonts` (macOS),
trying `.otf` → `.ttf` → `.woff2` → `.woff` in that order. An absolute path or
extension-bearing name short-circuits the lookup.

## Notes

- Uses `text-to-svg` (npm) — the only tool in `.utils` with an npm dep, hence
  the `node_modules/` directory (Deno's `nodeModulesDir: "auto"`).
- Needs `--allow-env=HOME` for font dir resolution.
