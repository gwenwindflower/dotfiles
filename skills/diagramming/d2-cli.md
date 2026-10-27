# D2 CLI

The installed CLI is the authority for supported flags and bundled layout engines:

```bash
d2 --version
d2 --help
d2 layout
d2 themes
```

## Format, validate, render

Format with `d2 fmt diagram.d2` (`--check` for a non-mutating check), then validate and render through `diagram.ts` as in [the skill](SKILL.md#checking-and-rendering), which themes the output. Plain `d2 diagram.d2 diagram.svg` is fine for a quick preview but carries no theme. Never treat output-file existence as proof of success; D2 may leave a partial render after an error, so check the exit status.

Rasterize the SVG with `rsvg-convert` as in [the skill](SKILL.md#rasterizing); D2's own PNG export downloads a large Chromium bundle, so never use it. Reach for D2's native exports only for what an SVG cannot carry: PDF or PPTX for multi-board delivery, GIF or animated SVG for board transitions, TXT for terminal output. Confirm supported formats with `d2 --help` because they vary by release.

## Layout

```bash
deno run --allow-read --allow-run=d2 "$DIAGRAM" render diagram.d2 -o diagram.svg -- --layout elk
deno run --allow-read --allow-run=d2 "$DIAGRAM" render diagram.d2 -o diagram.svg -- --sketch
d2 layout elk
```

Start with bundled Dagre for fast hierarchical diagrams. Try ELK for dense graphs, nested containers, orthogonal routing, or SQL-table edges. Use `d2 layout <name>` before layout-specific configuration; optional engines may not be installed.

Leave `--theme`, `--dark-theme`, `theme-id`, and `dark-theme-id` unset. `diagram.ts` repaints D2's base theme colors and the semantic classes in Frappe and Dawn, and a D2 dark theme only adds a competing media query.

## Watch and targeted boards

```bash
d2 --watch diagram.d2 diagram.svg
d2 --target 'layers.detail.*' diagram.d2 diagram.svg
d2 --animate-interval 1200 diagram.d2 diagram.svg
```

Watch mode serves a live preview and normally opens a browser. `--target=''` renders only the root board; a path ending in `*` includes its scenarios, steps, and layers.

Multi-board defaults produce multiple SVG files. Use animated SVG/GIF for a small sequence, PDF for multipage reading, or PPTX for presentation workflows. See the official [composition export guide](https://d2lang.com/tour/composition-formats/).

## Visual QA

After validation, render with `--mode light` and `--mode dark` and inspect an `rsvg-convert` PNG of each. For multi-board diagrams, target and inspect each important board or inspect the multipage/animated deliverable.

Check:

- labels are complete and readable at the intended size;
- hierarchy and primary flow are evident without explanation;
- edges are distinguishable, correctly directed, and not misleading;
- containers do not imply false ownership or trust boundaries;
- contrast holds in both modes, including any one-off `style` colors;
- icons, fonts, tooltips, and links behave in the destination format.

If routing is poor, simplify the model or try another bundled layout before adding manual dimensions and styling. Re-run format, validation, render, and inspection after structural changes.

## Official references

- [CLI manual](https://d2lang.com/tour/man/)
- [layouts](https://d2lang.com/tour/layouts/)
- [D2 repository quickstart](https://github.com/d2lang/d2#quickstart)
