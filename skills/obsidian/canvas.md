# JSON Canvas

A `.canvas` file is a visual map in the vault, written to [JSON Canvas 1.0](https://jsoncanvas.org/spec/1.0/). Mermaid and D2 diagrams for docs belong to the `diagramming` skill.

The file holds two optional top-level arrays, `nodes` and `edges`. Array order is z-order: the first node draws at the bottom.

## Nodes

Every node has these fields:

| Field | Required | Value |
| --- | --- | --- |
| `id` | Yes | Unique string, conventionally 16 lowercase hex characters |
| `type` | Yes | `text`, `file`, `link`, or `group` |
| `x`, `y` | Yes | Integer pixels of the top-left corner; may be negative |
| `width`, `height` | Yes | Integer pixels |
| `color` | No | A color preset or hex string |

| Type | Required | Optional |
| --- | --- | --- |
| `text` | `text`: markdown content | |
| `file` | `file`: path from the vault root | `subpath`: `#Heading` or `#^block-id` |
| `link` | `url`: external URL | |
| `group` | | `label`, `background` (image path), `backgroundStyle` (`cover`, `ratio`, or `repeat`) |

- Line breaks in `text` are the JSON escape `\n`. A doubled `\\n` renders as a literal backslash and `n`.
- A group has no child list. A node belongs to a group by sitting inside its bounds, so place children within them.
- Point a `file` node at a note to show it on the canvas instead of copying its text into a `text` node.

## Edges

| Field | Required | Value |
| --- | --- | --- |
| `id` | Yes | Unique string, shared namespace with node IDs |
| `fromNode`, `toNode` | Yes | IDs of existing nodes |
| `fromSide`, `toSide` | No | `top`, `right`, `bottom`, or `left` |
| `fromEnd` | No | `none` (default) or `arrow` |
| `toEnd` | No | `arrow` (default) or `none` |
| `color` | No | A color preset or hex string |
| `label` | No | Text on the edge |

## Colors

A color is a hex string such as `"#FF0000"` or a preset string: `"1"` red, `"2"` orange, `"3"` yellow, `"4"` green, `"5"` cyan, `"6"` purple. Presets follow the active theme.

## IDs and layout

- Generate IDs with `openssl rand -hex 8`, and check a new one against every node and edge ID already in the file.
- `x` grows to the right and `y` grows down.
- Keep 50 to 100 px between nodes and 20 to 50 px of padding inside groups, on a grid of 10 or 20.
- Size text nodes to their content: about 200 to 300 by 80 to 150 for a line or two, 300 to 450 by 150 to 300 for a paragraph, and 400 to 600 by 300 to 500 for a long block. File previews fit 300 to 500 by 200 to 400.
- When adding to an existing canvas, read it first and place new nodes in empty space.

## Example

```json
{
  "nodes": [
    {"id": "d4e5f6789012345a", "type": "group", "x": -40, "y": -60, "width": 780, "height": 300, "label": "Sources", "color": "5"},
    {"id": "6f0ad84f44ce9c17", "type": "text", "x": 0, "y": 0, "width": 300, "height": 150, "text": "## Main idea\n\nOne sentence on the claim."},
    {"id": "a1b2c3d4e5f67890", "type": "file", "x": 400, "y": 0, "width": 300, "height": 200, "file": "pen/00_ideas/Seed note.md", "subpath": "#Argument"},
    {"id": "c3d4e5f678901234", "type": "link", "x": 400, "y": 300, "width": 300, "height": 120, "url": "https://jsoncanvas.org/spec/1.0/"}
  ],
  "edges": [
    {"id": "0123456789abcdef", "fromNode": "a1b2c3d4e5f67890", "fromSide": "left", "toNode": "6f0ad84f44ce9c17", "toSide": "right", "label": "supports"},
    {"id": "fedcba9876543210", "fromNode": "c3d4e5f678901234", "fromSide": "top", "toNode": "a1b2c3d4e5f67890", "toSide": "bottom", "color": "4"}
  ]
}
```

## Checking a canvas

After every write, confirm the JSON parses, every node has its type's required field, and IDs and edge references hold. This prints `true` when every ID is unique and every edge points at an existing node:

```bash
jq '((.nodes // []) | map(.id)) as $nodes
  | ($nodes + ((.edges // []) | map(.id))) as $ids
  | ($ids | length) == ($ids | unique | length)
    and all(.edges[]?; .fromNode as $f | .toNode as $t
      | ($nodes | index($f)) != null and ($nodes | index($t)) != null)' map.canvas
```
