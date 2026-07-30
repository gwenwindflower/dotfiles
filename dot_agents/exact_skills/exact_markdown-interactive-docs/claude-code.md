# Delivery: Claude Artifacts (Claude Code)

The built file is already artifact-ready: self-contained (artifacts run under a strict CSP that blocks every external request), theme-aware (the template's `prefers-color-scheme` tokens plus `:root[data-theme]` overrides match the artifact viewer's theme toggle), and body-only markup (artifacts wrap the file in their own doctype/head — keep the template starting at `<title>`, never add `<html>`/`<head>`/`<body>`).

## Flow

1. Load the `artifact-design` skill before publishing or restyling — it calibrates design investment for artifact delivery.
2. Build, then publish the dist file with the Artifact tool: `file_path` = the built HTML, a stable `favicon` emoji, a one-sentence `description`, and a short `label` per revision.
3. Iterate by editing the markdown source or template, rebuilding, and republishing the **same file path** — same path in the same conversation keeps the same URL. From a later session, pass the existing artifact's `url` (find it with `action: "list"`) or a new URL gets minted.

## Rules

- Never hand-edit the dist file to tweak the artifact — change source or template and rebuild; hand edits are lost on the next build.
- Keep the file self-contained when restyling: fonts as base64 `data:` URIs in `@font-face`, no CDN links, no remote images.
- Keep the favicon stable across redeploys; users find the tab by it.
- For a local preview without publishing, send the dist file with SendUserFile (`display: "render"`).
