---
name: termframe-capture
description: Capture terminal command output as styled SVG/PNG images with termframe — catppuccin frappe window chrome, Ellograph font, optional pink/lilac gradient background. Use when asked for a termframe capture, a terminal screenshot/snapshot of a command, or a shareable pic of CLI output.
---

# Termframe Capture

Standardized terminal screenshots. Config (`~/.config/termframe/config.toml`) and the `catppuccin` window style load automatically — defaults produce a frappe-themed macOS-style window with rounded corners, traffic lights, soft shadow, and comfy padding. Only pass flags to override.

> [!IMPORTANT]
> termframe needs a pty (`openpty`), which the sandbox blocks with "Operation not permitted". Run the `termframe` command outside the sandbox; every other step is sandbox-safe.

## Default workflow

```sh
termframe --title "<short name>" -o <name>.svg -- <command with args>
python3 ~/.agents/skills/termframe-capture/scripts/termframe-bg.py <name>.svg
resvg --use-fonts-dir ~/Library/Fonts --zoom 2 <name>.svg <name>.png
```

- Name outputs after the command in kebab-case (`lsd-docs.svg`); write to the cwd unless told otherwise.
- The gradient step adds the pink→mauve→blue noisy background with rounded outer corners. Skip it when the user wants a transparent background, and never run it twice (it refuses re-processing).
- `--use-fonts-dir` is required for PNG conversion: the SVG references Ellograph by name only, and resvg won't find it without the user font dir. Deliver the PNG for sharing; keep the SVG when the user wants to iterate.
- Piped input works too: `<command> | termframe -o <name>.svg` (needed when the command is a pipeline; the pipeline itself runs in your shell).

## Common overrides

| Want | Flag |
| --- | --- |
| Show the command line in the capture | `--show-command` |
| Light mode (latte) | `--mode light` |
| Fixed size | `-W 100 -H 20` (cells; ranges like `-W 80..120` also work) |
| No window chrome, raw text | `--window false` |
| Longer-running command | `--timeout <seconds>` (default 5) |
| Gradient colors/shape | `termframe-bg.py --from/--mid/--to <hex> --angle <deg> --rx <px> --grain <0..1>` |

Width/height auto-size from output within 60–160 × 4–60 cells; TUI apps that fill the terminal get the initial 100×24, so pass explicit `-W`/`-H` for those.

## Constraints

- First capture on a machine needs network: metric/icon fonts (JetBrains Mono, Symbols Nerd Font Mono) download by URL, then cache in `~/.cache/termframe`.
- Local font files can't be listed under `[[fonts]]` — termframe v0.8.7 panics on them (`main.rs:300` URL unwrap). Ellograph therefore renders only where it's installed; elsewhere the SVG falls back to JetBrains Mono.
- Commands run non-interactively in termframe's virtual terminal — no stdin, so nothing that prompts.
