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

Termframe's configured terminal dimensions, Catppuccin theme, Ellograph font
stack, padding, and window style remain the defaults. Run `termshot --help` for
the focused override surface covering dimensions, theme, padding, gradient,
grain, and raster scale.

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
