---
name: video-production
description: Screen recording and video editing - Cap CLI capture, export, and sharing; Descript MCP for polished edits, captions, and voice; vhs terminal recordings; static terminal screenshots.
---

# Video production

Agents capture with Cap and edit in Cap or Descript. Pick the path, then load only its docs.

| Job | Doc |
| --- | --- |
| Record the screen, a window, or a scripted browser session; screenshots; export; upload | [cap](cap.md) |
| Trim, zoom, backgrounds, cursor, and captions on a Cap recording | [cap-editing](cap-editing.md) |
| Short product demos: pacing, cuts, and frame QA | [demo-editing](demo-editing.md) |
| Polished edits in Descript: Underlord, captions and text, voice, media, publishing | [descript](descript.md) |
| Terminal recordings, and static terminal screenshots for a video | [terminal](terminal.md) |

- **Cap or Descript:** finish in Cap when the recording needs trims, zooms, and a background. Move to Descript when it needs transcript-driven edits, styled captions and titles, voice work (Studio Sound, overdub, filler removal), or other media layered in.
- **Descript recording** is the user's own tool. Agents capture with Cap and import the export into Descript.
- **Driving the content:** when the agent drives what's on screen, use `agent-browser` (load `browser-automation`) or the harness's computer-use tools, and keep the user's real cursor untouched.
- **Publishing:** `cap upload` and Descript's `publish_project` create shareable links. Run them only when the user asks.
