# Excalidraw drawings

Drawings are `.excalidraw.md` notes, saved compressed (new ones land in `org/` by default). Never edit their Markdown by hand: create, read, edit, and render them through the Excalidraw plugin's commands on the `obsidian` CLI, which needs the running app. Run the preflight in [obsidian-cli.md](obsidian-cli.md) first and keep its rule against passing `vault=`.

## Discover before writing

The plugin's commands live under `obsidian-excalidraw-plugin:` and are version-matched to the installed plugin, so read them rather than guessing fields:

```bash
obsidian obsidian-excalidraw-plugin:help
obsidian obsidian-excalidraw-plugin:schema action=create
```

`:schema` gives exact fields, operation limits, and runnable examples for each action. `:api surface=ea name=<method>` prints an ExcalidrawAutomate signature, and `:icons query=<name>` pages through installed Lucide icon names.

## Results

Every result is JSON with `apiVersion: 1`. A zero exit code proves nothing; check `ok`, `mutation`, and `persistence` in the body.

## Edit loop

1. `:read source=live detail=elements` for the current elements and revision, or `detail=images` to inventory embedded images.
2. `:apply` with `expectedRevision` from the read and a fresh unique `requestId`.
3. Confirm `persistence` is `saved`.
4. `:export out=<path>.png` (or `.svg`), then open the image and look at it.

- Pass the drawing's exact vault path with its extension. Never rely on the active drawing.
- On `STALE_REVISION`, read again and rebuild the change.
- Retry `BUSY` with the same `requestId` only when the result says it was refused before execution.
- An unknown outcome needs a read-back before any other write. `:result requestId=<id>` recovers a lost receipt for 15 minutes or until reload.
- Repeating an identical request with the same `requestId` returns its receipt; different content under that ID fails.
- IDs in a new skeleton are local labels. Update elements by the actual IDs in the returned `idMap`; icons map through `groupMap` instead.
- Updates can't change element identity, bindings, or asset internals.

## Requests

Small requests go inline as JSON (`:schema` names the parameter). Large ones go in a vault-relative JSON file outside any dot-folder, passed as `input=<file>` and deleted once the receipt confirms the write. A file request carries `apiVersion: 1` but no `command`; the CLI supplies it.

Icons (`create icons` or `apply op=lucide`) insert editable native groups. Defaults are size 96, stroke `#1e1e1e`, roughness 1, opacity 100; `strokeWidth` is in final scene units.

## Export

- `out=` must end in `.svg` or `.png`; an existing file needs `overwrite=true`.
- A live export never saves the drawing.
- A disk export needs local vault assets. Use a loaded live source or placeholders for remote images.
- For a cheap preview, run `:read detail=images`, then export with `imagePolicy={"default":"placeholder","rules":[{"ids":["<id>"],"mode":"original"}]}`. The drawing itself is unchanged.
- Bound size with `maxWidth`, `maxHeight`, `maxPixels`, and `maxArtifactBytes`. SVG `width` sets display size only; shrink embedded rasters with `imagePolicy`.
- Image labels and tags persist only through `imageMetadata` apply operations, with `null` clearing them; `imagePolicy.labels` lasts for one request.

## Commands that need Winnie's request

- `:open` creates a tab and can run the drawing's configured scripts.
- `:script trusted=true` runs a local script file with full app access. It is not a sandbox, has no timeout, and is not a transaction; scripts follow [excalidraw-scripts.md](excalidraw-scripts.md).

Never install another Excalidraw CLI.
