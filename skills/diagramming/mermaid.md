# Mermaid

`scripts/diagram.ts` checks and renders Mermaid through [pele](https://pele.run), a synchronous renderer for Mermaid 12.1 syntax that needs no browser; usage is in [the skill](SKILL.md#checking-and-rendering).

## Diagram types

Pick the type before writing any source. Scan this table for the one that matches the content's real shape, and open its gallery page for working syntax before authoring a type you haven't used yet in this session. A flowchart standing in for a commit history, a timeline, or a schema is the wrong diagram. Every type below parses and renders in pele 1.9; the [gallery](https://pele.run/examples) shows each one, at `https://pele.run/examples/<slug>`.

| Type | Header | Slug | Fits |
| --- | --- | --- | --- |
| Flowchart | `flowchart LR` | `flowchart` | Process, control flow, architecture sketches |
| Sequence | `sequenceDiagram` | `sequence` | Calls and messages between participants over time |
| Class | `classDiagram` | `class` | Types, fields, methods, inheritance |
| Entity relationship | `erDiagram` | `er` | Tables, keys, cardinality |
| State | `stateDiagram-v2` | `state` | Lifecycles and transitions |
| Gantt | `gantt` | `gantt` | Scheduled work with dates and dependencies |
| Git graph | `gitGraph` | `git` | Commits, branches, merges, release flow |
| Timeline | `timeline` | `timeline` | Dated events or eras without durations |
| User journey | `journey` | `journey` | Steps a person takes, scored by experience |
| Mindmap | `mindmap` | `mindmap` | Hierarchical brainstorms from one root |
| Tree view | `treeView-beta` | `treeview` | File trees and other strict hierarchies |
| Kanban | `kanban` | `kanban` | Work items by status column |
| C4 | `C4Context`, `C4Container`, `C4Component` | `c4` | System context and container architecture |
| Architecture | `architecture-beta` | `architecture` | Cloud services and groups with icons |
| Block | `block` | `block` | Grid-placed blocks where position matters |
| Requirement | `requirementDiagram` | `requirement` | Requirements and what satisfies or verifies them |
| Packet | `packet` | `packet` | Bit and byte layouts of headers and frames |
| Pie | `pie` | `pie` | A few parts of one whole |
| Quadrant chart | `quadrantChart` | `quadrant` | Items placed on two axes, such as effort and impact |
| XY chart | `xychart` | `xychart` | Bar and line series over an axis |
| Sankey | `sankey` | `sankey` | Flow volumes between stages |
| Radar | `radar-beta` | `radar` | Several entities scored across shared dimensions |
| Treemap | `treemap-beta` | `treemap` | Nested proportions |
| Venn | `venn-beta` | `venn` | Overlapping sets |
| Event modeling | `eventmodeling` | `eventmodeling` | Commands, events, and views along a timeline |
| Agentflow | `agentflow-beta` | `agentflow` | Agent, tool, and model steps |
| Swimlane | `swimlane-beta` | `swimlane` | Process steps split by owner |
| Use case | `usecase-beta` | `usecase` | Actors and the goals they reach |
| Ishikawa | `ishikawa-beta` | `ishikawa` | Cause and effect, root-cause analysis |
| Cynefin | `cynefin-beta` | `cynefin` | Problems sorted into Cynefin domains |
| Wardley map | `wardley-beta` | `wardley` | Components by visibility and evolution |
| Railroad | `railroad-beta`, `railroad-ebnf-beta` | `railroad` | Grammar and syntax rules |

Types outside GitHub's list in [Destinations](#destinations) are export-only: render them to SVG rather than leaving a fence that GitHub can't draw.

## Check

`check` parses a `.mmd` file, or every ```` ```mermaid ```` and `~~~mermaid` fence in a `.md` file, and prints `path:line:col [code] message` with a source snippet for each failure. Line numbers point into the file you passed. It exits 1 when anything fails.

Codes: `syntax` and `semantic` are authoring errors; `unsupported-diagram` means no diagram type was detected (often a typo in the first line); `limit` means the source, edge count, or nesting is too large; `unclosed-fence` is a Markdown fence with no closing marker.

Check every diagram before writing it into a document, and recheck a Markdown file after editing any fence in it.

## Destinations

| Target | Delivery |
| --- | --- |
| GitHub markdown, PRs, wiki; Obsidian | Fenced ```` ```mermaid ```` block, checked first |
| Docs sites, committed exports, slides | `render --mode auto` SVG, with the `.mmd` beside it |
| Claude Artifacts | Inline `render --mode auto` SVG, or load pele from `cdn.jsdelivr.net/npm/pele@1` and `pele.mount()` each diagram so it adapts to the page width and theme |
| Confluence, Notion, Word, PDF | `render --mode light` piped to `rsvg-convert`; never a fence as the only view |

GitHub renders fences with its own Mermaid.js, so pele's layout and colors are not a preview of GitHub, and a check that passes on Mermaid 12.1 syntax may still fail on GitHub's older version. Keep GitHub fences to `flowchart`, `sequenceDiagram`, `classDiagram`, `erDiagram`, `stateDiagram-v2`, `gantt`, `pie`, and C4; when C4, `architecture-beta`, or `block-beta` fail there, fall back to `flowchart TD` with subgraphs for boundaries.

Avoid in fences: `click` handlers, `%%{init}%%` directives (pele ignores themes and `themeVariables`, GitHub mangles them), unquoted `end`, and subgraphs nested more than two levels.

## Syntax traps

These render wrong or fail in non-obvious ways:

- Node ids beginning with `o` or `x` merge into edge-marker tokens: `dev---ops` parses as a circle-terminated edge to `ps`. Renders without error, draws the wrong diagram. Insert a space or capitalize the id. Same collision hits sequence-diagram participants and state names starting with `x` via the `-x` deactivation shorthand — use explicit `deactivate` instead.
- Reserved words break as bare node ids; quote or re-case them — `default`, `style`, `class`, `end`, `subgraph`, `click`, `graph`, `classDef`, `linkStyle`, `call`, `interpolate`, `_self`, `_blank`, `_parent`, `_top`. Gantt reserves its own keywords (`section`, `title`, `dateFormat`, …), truncates task names at `#`, errors on `;`, and every task field must be comma-separated.
- Label escaping — quote the label; a literal `"` inside needs `#34;`, and parentheses that confuse the shape parser need `#40;`/`#41;`.
- `classDef` takes comma-separated `key:value` pairs, no braces, no semicolons — `classDef warn fill:#f00,color:#fff`. `classDef` cannot attach to `[*]` pseudo-states.
- Draw edges to leaf nodes, never to a subgraph id that wraps another subgraph.
- ER attributes are type-then-name (`int id`); class-diagram cardinality must be quoted (`Customer "1" --> "*" Order`); static/abstract markers go after the signature (`+staticMethod()$`).
- Pie charts fail silently on non-positive or non-numeric values.
- A subgraph keeps its own `direction` in pele even when linked to outside nodes; Mermaid.js overrides it.

When a diagram fails opaque, reduce to a minimal reproduction and add elements back.

## Styling

Style through the semantic classes in [themes](themes.md), applied with `class A,B,C roleName`. `linkStyle N` (zero-based index) is the only edge-styling hook.

Every `classDef` and `style` statement sets `color:` explicitly, because GitHub's text color follows the viewer's theme and a fill without a text color is unreadable in one of the modes. Audit with:

```bash
rg 'classDef|^\s*style ' file.md | rg -v 'color:'
```

Any output is a contrast bug. Pele treats `style` colors as fixed, so keep one-off `style` statements out of themed exports and reach for a semantic class instead.

Emoji in labels are optional; if used as type indicators, use them consistently across the whole document.
