---
name: vhs-terminal-gifs
description: Create terminal GIFs/MP4s with charmbracelet vhs from a .tape script. Use when the user wants to record, demo, or capture a terminal workflow for docs, blogs, or READMEs.
---

# VHS Terminal GIFs

[vhs](https://github.com/charmbracelet/vhs) renders a `.tape` script (DSL of `Type`, `Enter`, `Sleep`, `Set`, `Hide`/`Show`) into a GIF/MP4/WebM via a headless terminal. Deps: `vhs`, `ffmpeg`, `ttyd`.

## Workflow

1. **Gather intent.** Ask the user (only if unclear): commands to demo, output filename. Don't over-ask — pick sensible defaults.
2. **Write the tape** to a working path (e.g. `demo.tape` in cwd, or `$TMPDIR/<name>.tape`). **Always start the tape with `Source "/Users/winnie/.config/vhs/defaults.tape"`** to inherit the user's shell, theme, font, and sizing (see below).
3. **Validate:** `vhs validate <file>`. Silent success = valid. Fix and revalidate on error.
4. **Confirm with the user** before rendering — vhs runs the actual commands and can take 10s–minutes. Show the tape contents and ask: "Render this to a GIF now?"
5. **Render** on confirm: `vhs <file>`. Otherwise stop — tape stays on disk for the user to run themselves.

Never run vhs without confirmation; the tape's commands execute for real in a subshell.

## Tape essentials

```text
Source "/Users/winnie/.config/vhs/defaults.tape"
Output demo.gif              # also .mp4 / .webm; multiple Output lines allowed

Hide                         # setup not recorded
Type "cd /tmp && clear"
Enter
Show

Type "lsd --tree --depth 2"
Sleep 500ms                  # pause between typing and Enter feels human
Enter
Sleep 3s                     # let viewer read output before next command
```

Per-tape overrides go after the `Source` line, e.g. `Set TypingSpeed 0ms` for instant text.

Key gotchas:

- `Type` types; it does **not** execute. Always follow with `Enter`.
- `Sleep` before `Enter` (~500ms) and after output (2–4s) — without these the GIF feels jerky.
- `Hide`/`Show` brackets non-recorded setup. Use it for `cd`, `clear`, env exports.
- Settings (`Set ...`, `Output`) must come before any action.

## Shared defaults via `Source`

vhs has **no global config file**. The idiomatic substitute is the `Source` directive, which inlines another tape. The user keeps shared `Set` lines (shell, theme, font, sizing) at `~/.config/vhs/defaults.tape`. Every tape must start with:

```text
Source "/Users/winnie/.config/vhs/defaults.tape"
Output demo.gif
# ... actions
```

`Output` is always per-tape. Override any inherited setting by re-`Set`ting it after the `Source` line.

`Source` quirks: paths are **not** tilde-expanded and bare absolute paths fail to parse. Always quote the absolute path: `Source "/Users/winnie/..."`. Relative paths (resolved from cwd at render time) also work bare.

## Output sizing

GIFs balloon fast (1000×600 × 10s ≈ 1–3 MB). For non-GitHub destinations prefer `.mp4` or `.webm` — often 5–10× smaller. Add a second `Output` line to render both formats in one pass.

## Useful commands

```bash
vhs new <file>        # scaffold a starter tape
vhs themes            # list available themes
vhs validate <file>   # parse-check without running
vhs <file>            # render
```
