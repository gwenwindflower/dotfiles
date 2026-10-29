# Editing in Cap

A studio-mode `.cap` project keeps its edits in `project-config.json`. Cap Desktop's editor writes it, and `cap export` renders it. Agents edit it as JSON:

```sh
cap project config get <slug>.cap --json > $TMPDIR/config.json
# edit the JSON
cap project config set <slug>.cap --settings-json "$(cat $TMPDIR/config.json)" --json
cap export-preview <slug>.cap --frame-time <seconds> --json   # check a frame before a full export
```

`set` replaces the whole document and resets omitted fields to defaults, so always start from `get` and change only the keys you mean to. Keys are camelCase.

| Key | Holds |
| --- | --- |
| `timeline.segments` | Kept ranges of the recording (`recordingSegment`, `start`, `end`, `timescale`). Trim by splitting or shortening these; `timescale` changes speed. |
| `timeline.zoomSegments` | Zooms (`start`, `end`, `amount`, `mode` `auto` follows the cursor or `manual`). |
| `timeline.camera3dSegments` | 3D camera moves. Never stack these with 2D zooms over the same span. |
| `timeline.textSegments`, `captionSegments`, `keyboardSegments`, `maskSegments`, `sceneSegments` | Titles, captions, keystroke overlays, masks, and scene layouts. |
| `background` | Wallpaper, color, or gradient `source`, plus `padding`, `rounding`, `shadow`, `crop`, and `border`. |
| `cursor` | Size, hide-when-idle, click ripple, and motion springs. |
| `captions.settings` | Burned-in caption style: font, size, colors, position, word highlight. `enabled` turns them on. |
| `camera`, `audio`, `aspectRatio` | Camera bubble shape and position, track levels, and output aspect. |

Cap's captions and text are serviceable. When the piece needs designed titles, caption styling beyond these settings, or voice cleanup, export and move to [descript](descript.md).
