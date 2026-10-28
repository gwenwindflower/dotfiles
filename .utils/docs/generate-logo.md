# generate-logo

Render text to SVG using a local font. Each character becomes its own `<path>`
with `data-char` and `data-index` attributes, so glyphs can be targeted
independently for CSS/JS animation.

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

The rendering tests build a synthetic font in memory with opentype.js, add a
`kern` table, and wrap it as OTF and uncompressed WOFF, so no font fixture is
checked in.

## Font resolution

Font names without an extension are resolved against `~/Library/Fonts` (macOS),
trying `.otf` → `.ttf` → `.woff` in that order. An absolute path or
extension-bearing name is tried first, then the other extensions on the same
stem.

WOFF2 isn't supported. A `.woff2` name falls through to a supported sibling, and
a match that only exists as WOFF2 fails with a hint to convert it
(`woff2_decompress font.woff2`).

## Layout

- Glyphs advance by their advance widths plus pair kerning (GPOS or legacy
  `kern`). There is no ligature or mark positioning, so every input character
  keeps its own path.
- Spaces advance the pen and keep their `data-index` but emit no `<path>`.
- Characters missing from the font render as `.notdef` and are listed in a
  warning.
- The viewBox covers the font's ascender-to-descender line box plus any ink
  outside it (accents, deep descenders, overhangs), then `--padding` on every
  side.
- Paths keep their close commands, so stroked outlines animate without gaps.

## Notes

- Uses `opentype.js` 2.x (npm, no runtime deps) with `@types/opentype.js` for
  types.
- Needs `--allow-env=HOME` for font dir resolution.
