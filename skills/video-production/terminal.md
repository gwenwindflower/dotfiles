# Terminal recordings and screenshots

## Recordings with vhs

[vhs](https://github.com/charmbracelet/vhs) renders a `.tape` script into a GIF, MP4, or WebM through a headless terminal, which beats screen-recording a real terminal for repeatable demos. The tape's commands run for real.

1. Write the tape to `demo.tape` in the working directory or `$TMPDIR/<name>.tape`, starting with the shared defaults line below.
2. `vhs validate <file>`; silence means valid.
3. Show the user the tape and confirm before rendering, since rendering runs its commands and takes seconds to minutes.
4. Render with `vhs <file>`. Without a confirmation, leave the tape on disk for the user.

```text
Source "/Users/winnie/.config/vhs/defaults.tape"
Output demo.mp4              # .gif and .webm also work; several Output lines render each

Hide                         # setup stays out of the recording
Type "cd /tmp && clear"
Enter
Show

Type "lsd --tree --depth 2"
Sleep 500ms                  # a pause before Enter reads as human
Enter
Sleep 3s                     # time to read the output
```

- `~/.config/vhs/defaults.tape` holds the user's shell, theme, font, and sizing; vhs has no global config. `Source` paths are not tilde-expanded, and an absolute path must be quoted.
- Override a default by re-`Set`ting it after the `Source` line, such as `Set TypingSpeed 0ms`. `Set` and `Output` lines come before any action.
- `Type` only types; follow it with `Enter`. Sleep about 500ms before `Enter` and 2 to 4 seconds after output.
- GIFs grow fast (a 10 second 1000x600 GIF is 1 to 3 MB). Prefer `.mp4` or `.webm` outside GitHub READMEs, and use MP4 for anything headed into Cap or Descript.
- `vhs new <file>` scaffolds a tape and `vhs themes` lists themes.

## Static screenshots

For a still of terminal output or code to drop into a video or thumbnail:

- **`termshot`** (fish function): `termshot -o out.png -- <command>` runs the command through termframe and adds the standard gradient background. The house style; reach for it first.
- **`termframe`**: `termframe -o out.svg -- <command>` for a plain terminal-window SVG with Catppuccin defaults.
- **`freeze`**: `freeze file.go -o code.png` for syntax-highlighted code, or `freeze --execute "<command>" -o out.png` for output.
