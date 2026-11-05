# Excalidraw scripts

ExcalidrawAutomate (EA) scripts are JavaScript files in the vault's `Excalidraw/Scripts/` folder that the plugin runs with an `ea` object and a `utils` object. Drawing edits that don't need a reusable script go through the CLI in [excalidraw.md](excalidraw.md).

## Looking up APIs

Before using an EA method, check its signature with `obsidian obsidian-excalidraw-plugin:api surface=ea name=<method>`, which reflects the installed version. For usage in context, the plugin repo's [api-usage-index.md](https://github.com/zsviczian/obsidian-excalidraw-plugin/blob/master/docs/AITrainingData/excalidraw-automate/references/api-usage-index.md) maps each `ea.*`, `api.*`, and `ExcalidrawLib.*` call to the [example scripts](https://github.com/zsviczian/obsidian-excalidraw-plugin/tree/master/docs/AITrainingData/excalidraw-automate/references/scripts) that use it; read a real example rather than guessing a call's context. Full types are in [type-definitions.md](https://github.com/zsviczian/obsidian-excalidraw-plugin/blob/master/docs/AITrainingData/excalidraw-automate/references/type-definitions.md).

Three APIs are in reach, in order of preference:

| API | Use |
| --- | --- |
| `ea` | Anything it covers; its wrappers handle Obsidian integration |
| `ea.getExcalidrawAPI()` | Scene-level calls; needs `ea.targetView` set |
| `window.ExcalidrawLib` | View-independent utilities `ea` lacks |

The Obsidian module is `ea.obsidian` (`Notice`, `Modal`, `Setting`, `normalizePath`, `getIcon`, `moment`). Script engine runs bind `ea.targetView` already; elsewhere call `ea.setView()` for a default or `ea.setView(view)` explicitly, and `ea.setView(null)` clears it without picking another.

## The workbench

Scene elements are immutable. EA stages changes on an in-memory workbench, one transaction at a time per `ea`:

```javascript
ea.clear();
try {
  const selected = ea.getViewSelectedElements();
  ea.copyViewElementsToEAforEditing(selected);
  for (const el of selected) ea.getElement(el.id).strokeColor = "#e78284";
  await ea.addElementsToView();
} finally {
  ea.clear();
}
```

- `ea.clear()` empties the workbench only; it never touches the scene or `ea.style`.
- `copyViewElementsToEAforEditing` keeps IDs. `cloneElement` and `cloneElements` make new IDs and are only for real duplicates.
- Commit persistent edits once with `await ea.addElementsToView()`, which saves by default. Don't call unpublished methods on `ea.targetView`.
- Delete with `isDeleted = true` on the workbench copy. Hide with `opacity = 0`, storing the original opacity in `customData` and locking the element.
- Write `customData` only through `ea.addAppendUpdateCustomData(id, data)`, which keeps other scripts' keys.
- Set `ea.style` before `addText`, `addRect`, and friends; restyle existing elements on their workbench copy.
- Measure with `ea.getBoundingBox(elements)` and `ea.measureText(text)` before layout. Group with `ea.addToGroup(ids)`; find top-level groups with `ea.getMaximumGroups` and a group's container with `ea.getLargestElement`.
- A text element has `rawText` (markup and intentional breaks), `originalText` (rendered, unwrapped), and `text` (wrapped). Update all three unless the element autoresizes or sits in a container.
- Get an image element's vault file with `ea.getViewFileForImageElement(el)`.
- When a method needs a known element, pass it (`api.startLineEditor(line, indices)`) rather than rereading the selection.

## Export

| Source | Call |
| --- | --- |
| Workbench elements | `ea.createSVG(null, ...)` or `ea.createPNG(null, ...)` |
| A drawing that isn't open | `ea.createSVG(file.path, ...)`; never rebuild the scene by hand |
| The active view | `ea.createViewSVG(...)` or `ea.createViewPNG(...)` |

`elementsOverride` on the view exports replaces the whole element array, so pass the full workbench (`ea.getElements()`). Use `exportArea: {x, y, width, height}` to export a viewport without carrying every image in the scene.

## UI

- Simple input: `await utils.inputPrompt()` and `await utils.suggester()`.
- Confirmations and alerts: `new ea.obsidian.Modal(ea.plugin.app)` with buttons in `contentEl`. Never `alert`, `confirm`, or `prompt`.
- Multi-control dialogs: `const modal = new ea.FloatingModal(ea.plugin.app)`, assigning `onOpen` and `onClose` on the instance, never subclassing. Build controls with `ea.obsidian.Setting`.
- Long forms, especially on mobile, and tools that stay open across drawings: a sidepanel from `ea.createSidepanelTab(title, persist, reveal)`. Check `ea.checkForActiveSidepanelTabForScript()` first and reuse or open an existing tab instead of making a duplicate.
- A persisted sidepanel restores with `ea.targetView === null`. Defer view work to `onFocus(view)`, bind with `ea.setView(view)`, and call `ea.setView(null)` when focus leaves Excalidraw.
- Icons are Lucide names via `ea.obsidian.getIcon(name)`; `registerElementActionProvider` takes the name, not SVG markup.

## Lifecycle

- `utils.executionSource` says why this run started: `manual`, `plugin-startup`, `view-autostart`, `sidepanel-restore`, `sidepanel-reload`, or `drawing-onload`.
- `ea.registerAutostart(message?)` asks permission to attach once to each view; `ea.registerCleanup(fn)` tears down listeners, timers, and observers with the `ea`.
- Settings come from `ea.getScriptSettings()` and save with `await ea.setScriptSettings(settings)` into the plugin's `data.json`. Keep them small; never store images or large arrays there.
- `ea.verifyMinimumPluginVersion()` checks the plugin and `ea.obsidian.requireApiVersion()` checks Obsidian. Leave version checks out unless asked.

## Script shape

Open with a comment block covering purpose, features, and approach, and keep it current. Put constants and user-facing strings at the top, all logic in small named functions with JSDoc headers, and keep existing comments on edits. `await` every promise-returning call.

## Custom pens

Freehand strokes use Perfect Freehand options. `ea.viewUpdateScene({ appState: { currentStrokeOptions: penOptions } })` plus `api.setActiveTool({ type: "freedraw" })` sets the pen for new strokes, and `currentStrokeOptions: null` resets it. Existing strokes change only through `customData.strokeOptions`. The `PenOptions` shape is in the plugin's `src/types/penTypes.ts`; `highlighter: true` draws beneath everything else.
