# Mermaid

Guidance targets Mermaid v11+ and current mermaid-cli. Core diagram syntax is stable across versions; `architecture-beta` and `block-beta` are newer and less portable.

## Destinations

| Target | Delivery |
| --- | --- |
| GitHub markdown, PRs, wiki; Obsidian; Claude Artifacts | Fenced ```mermaid block — renders natively |
| Confluence, Notion, Word, PDF | Rendered PNG or SVG image; never a fence as the only view |

GitHub renders `flowchart`, `sequenceDiagram`, `classDiagram`, `erDiagram`, `stateDiagram-v2`, `gantt`, `pie`, and C4 — keep all of these in Mermaid rather than reaching for another tool. When C4, `architecture-beta`, or `block-beta` fail to render on GitHub, fall back to `flowchart TD` with subgraphs for boundaries.

Avoid on GitHub: `click` handlers, `%%{init}%%` directives, unquoted `end`, and subgraphs nested more than two levels.

## Validate by rendering

mmdc (`npm install -g @mermaid-js/mermaid-cli`, probe with `mmdc --version`) has no validate-only mode — validation is a render:

```bash
timeout 60 mmdc -i diagram.mmd -o diagram.png -b transparent
```

Success requires all three: exit code 0, output file exists, output file size greater than zero — mmdc occasionally exits 0 having written an empty file. Always wrap in a timeout; mmdc launches headless Chromium via puppeteer and hangs rather than failing when the browser can't start. In containers or CI hitting `No usable sandbox!`, pass a puppeteer config via `-p` (surface the sandbox implication rather than silently disabling it).

| Flag | Purpose |
| --- | --- |
| `-i` / `-o` | input (`-` for stdin); output `.png` / `.svg` / `.pdf`, format inferred from extension |
| `-b` | background — `transparent` default, `white` for dark-page embeds |
| `-t` | base theme (`default`, `dark`, `forest`, `neutral`) |
| `-w` / `-H` / `-s` | width, height, scale factor for high-DPI PNG |
| `-c` / `-p` | mermaid config JSON, puppeteer config JSON |

Never add a diagram to a document until it has rendered successfully — generate, render, check, then write the fence or image reference. Keep the `.mmd` source next to any exported image so it can be edited and re-rendered.

## Syntax traps

These render wrong or fail in non-obvious ways:

- Node ids beginning with `o` or `x` merge into edge-marker tokens: `dev---ops` parses as a circle-terminated edge to `ps`. Renders without error, draws the wrong diagram. Insert a space or capitalize the id. Same collision hits sequence-diagram participants and state names starting with `x` via the `-x` deactivation shorthand — use explicit `deactivate` instead.
- Reserved words break as bare node ids; quote or re-case them — `default`, `style`, `class`, `end`, `subgraph`, `click`, `graph`, `classDef`, `linkStyle`, `call`, `interpolate`, `_self`, `_blank`, `_parent`, `_top`. Gantt reserves its own keywords (`section`, `title`, `dateFormat`, …), truncates task names at `#`, errors on `;`, and every task field must be comma-separated (a missing comma renders in Chrome but fails in Firefox).
- Label escaping — quote the label; a literal `"` inside needs `#34;`, and parentheses that confuse the shape parser need `#40;`/`#41;`.
- `classDef` takes comma-separated `key:value` pairs, no braces, no semicolons — `classDef warn fill:#f00,color:#fff`. Semicolon separators fail in state diagrams. `classDef` cannot attach to `[*]` pseudo-states.
- Draw edges to leaf nodes, never to a subgraph id that wraps another subgraph.
- ER attributes are type-then-name (`int id`); class-diagram cardinality must be quoted (`Customer "1" --> "*" Order`); static/abstract markers go after the signature (`+staticMethod()$`).
- Pie charts fail silently on non-positive or non-numeric values; empty `%%` comments break some parsers.

When a diagram fails opaque, reduce to a minimal reproduction and add elements back. A fence that silently doesn't render on a page logs the real error in the browser console.

## Styling

Style through the semantic classes in [themes](themes.md), applied with `class A,B,C roleName` so a diagram re-themes by editing its `classDef` block. `linkStyle N` (zero-based index) is the only edge-styling hook.

**Every `classDef` and `style` statement must set `color:` explicitly.** Default text color follows the viewer's theme, so a hardcoded fill without a text color is unreadable in either GitHub light or dark mode. Audit with:

```bash
rg 'classDef|^\s*style ' file.md | rg -v 'color:'
```

Any output is a contrast bug. Two checks before delivering: every label readable against its own fill, and the diagram still legible in grayscale.

Emoji in labels are optional; if used as type indicators, use them consistently across the whole document.
