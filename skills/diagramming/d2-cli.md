# D2 CLI

The installed CLI is the authority for supported flags and bundled layout engines:

```bash
d2 --version
d2 --help
d2 layout
d2 themes
```

## Format, validate, render

```bash
d2 fmt diagram.d2
d2 validate diagram.d2
d2 diagram.d2 diagram.svg
```

Use `d2 fmt --check diagram.d2` for a non-mutating format check. Never treat output-file existence as proof of success; D2 may leave a partial render after an error, so check the exit status.

SVG is the best default for docs and interactive links. Choose PNG for raster-only destinations, PDF or PPTX for multi-page delivery, GIF or animated SVG for board transitions, and TXT for terminal-oriented output. Confirm supported formats with `d2 --help` because they vary by release.

D2 may prompt to download a large Chromium bundle on the first PNG render. Do not approve that install solely for routine visual QA. When raster output is required, surface the dependency and obtain any needed authorization.

## Layout and theme selection

```bash
d2 --layout elk --theme 4 --dark-theme 200 diagram.d2 diagram.svg
d2 --sketch diagram.d2 diagram.svg
d2 layout elk
```

Start with bundled Dagre for fast hierarchical diagrams. Try ELK for dense graphs, nested containers, orthogonal routing, or SQL-table edges. Use `d2 layout <name>` before layout-specific configuration; optional engines may not be installed.

Use `d2 themes` rather than memorized IDs. Pair a light and dark theme when the destination honors adaptive SVG styling. Explicit color styles remain active in dark mode, so visually check both appearances when using `--dark-theme`. For brand or personal palettes layered on top of a base theme, use the class tokens in [themes](themes.md).

## Watch and targeted boards

```bash
d2 --watch diagram.d2 diagram.svg
d2 --target 'layers.detail.*' diagram.d2 diagram.svg
d2 --animate-interval 1200 diagram.d2 diagram.svg
```

Watch mode serves a live preview and normally opens a browser. `--target=''` renders only the root board; a path ending in `*` includes its scenarios, steps, and layers.

Multi-board defaults produce multiple SVG files. Use animated SVG/GIF for a small sequence, PDF for multipage reading, or PPTX for presentation workflows. See the official [composition export guide](https://d2lang.com/tour/composition-formats/).

## Visual QA

After validation, render SVG. If the image viewer does not accept SVG, convert the temporary render with an already-installed tool such as `rsvg-convert` or ImageMagick, then inspect the rasterized copy. For multi-board diagrams, target and inspect each important board or inspect the multipage/animated deliverable.

Check:

- labels are complete and readable at the intended size;
- hierarchy and primary flow are evident without explanation;
- edges are distinguishable, correctly directed, and not misleading;
- containers do not imply false ownership or trust boundaries;
- light/dark contrast survives chosen themes and custom styles;
- icons, fonts, tooltips, and links behave in the destination format.

If routing is poor, simplify the model or try another bundled layout before adding manual dimensions and styling. Re-run format, validation, render, and inspection after structural changes.

## Official references

- [CLI manual](https://d2lang.com/tour/man/)
- [layouts](https://d2lang.com/tour/layouts/)
- [themes](https://d2lang.com/tour/themes/)
- [D2 repository quickstart](https://github.com/d2lang/d2#quickstart)
