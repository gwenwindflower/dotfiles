# termshot

Capture a command through termframe, add the standard pink–mauve–blue gradient,
and render a shareable PNG through resvg. The Fish wrapper makes the utility
available anywhere as `termshot`.

## Run

```fish
termshot -- lsd docs
termshot -o prs.png --title "Pull requests" -- gh pr list
termshot --theme dracula --from '#f5c2e7' --to '#89b4fa' -- glow README.md
termshot --transparent --svg-only -o tree.svg -- eza --tree --level 2
```

The default output name comes from the command. PNG captures retain the sibling
SVG for iteration; pass `--no-keep-svg` when only the PNG matters.

Termframe's configured terminal dimensions, Catppuccin theme, padding, and
window style remain the defaults. Captured commands run with common pager
variables set to `cat`, so commands such as `git log`, `gh pr list`, and `bat`
finish without waiting for interactive pager input. Command-specific no-pager
flags are only needed for tools that ignore the standard variables.

Termframe uses JetBrains Mono to measure terminal cells. Before rasterization,
termshot sets the terminal SVG stack to Ellograph CF Fixed Pitch for text,
Symbols Nerd Font Mono for PUA icons, and IBM Plex Mono for box-drawing and
block characters. Apple Color Emoji supplies emoji on macOS, with Noto Color
Emoji available as the portable fallback. Resvg loads only these explicit
families with system fonts disabled. Use `--emoji-font` to point at another
color font.

Box-drawing and block characters (U+2500–U+259F) render in their own `<text>`
elements, set explicitly in IBM Plex Mono and pinned to termframe's 0.6em cell
grid, with label runs pinned the same way. Resvg re-resolves an entire `<text>`
at the default weight once any glyph in it falls back to another family, so
mixing tree lines and labels in one element would render the labels at Regular
instead of the configured Thin. Box glyphs stretch 4% vertically around each
row's center and rows render with visible overflow, which closes the
anti-aliasing seams between stacked vertical lines.

This split depends on termframe's SVG shape: one nested `<svg>` per row holding
`<text>` elements made only of `<tspan>` runs, with `x` offsets in `em`. Markup
outside that shape fails the capture with an `unexpected terminal text markup`
or `unsupported terminal text offset` error rather than rendering misaligned.

Run `termshot --help` for the focused override surface covering dimensions,
theme, padding, gradient, grain, and raster scale.

Pipelines and shell expressions need an explicit shell command:

```fish
termshot -o errors.png --title "Recent errors" -- fish -c 'rg error logs | head -20'
```

## Test

```fish
deno task test:termshot
```

The suite tests path derivation, SVG transformation, option forwarding, command
ordering, failure propagation, and cleanup without requiring termframe's PTY.
