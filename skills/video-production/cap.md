# Cap CLI

`cap` ships inside Cap Desktop and drives recording, export, upload, and the Cap library. Use it, never the Cap dashboard through a browser, for anything it covers. `cap guide --json` is the authoritative command and schema contract, and `cap <command> --help` gives current arguments.

- Add `--json` everywhere. stdout is the result, stderr is diagnostics. Exit `1` is a runtime failure with an `error` field, `2` is bad usage.
- `record` and `export` stream NDJSON events. Export events use PascalCase `type` tags and snake_case fields.
- Capture needs the host's screen-recording permission, so `cap` runs outside the sandbox. A sandboxed `doctor` reports `denied` and `targets` lists one empty display.

## Record

```sh
cap doctor --json                                   # captureReady must be true
cap targets --json                                  # screen/window ids, camera deviceIds, mic names
cap record start --window <id> --path <dir>/<slug>.cap --detach --json   # -> {recordingId, pid, path}
cap record stop --id <recordingId> --json           # complete only when recordingMetaExists is true
cap project validate <slug>.cap --json
```

- Prefer `--window` over `--screen` so other windows and notifications stay out of frame.
- `--mode studio` (default) keeps separate tracks for editing in Cap; `instant` produces a ready-to-share file.
- `--duration N` stops on its own and suits a known-length scripted run; use `--detach` plus `stop` otherwise.
- `--camera`, `--mic`, and `--system-audio` add tracks. Record a voice only when the user asked for one.
- `--path` must not exist yet. Without it the project lands in the working directory; `cap recordings list` shows the Cap Desktop library.
- `cap screenshot --window <id> --path shot.png --json` captures a still.

## Drive the content

1. Prepare the window first: open and size it, dismiss cookie banners, and close stray windows.
2. Start the recording, then drive with `agent-browser` or computer-use tools. Use virtual input (CDP mouse and keyboard) rather than moving the user's cursor.
3. Pause about a second after each action and two to three seconds on results, so edits have room to cut.
4. Stop, validate, then QA frames before exporting.

```sh
ffmpeg -y -ss <t> -i <slug>.cap/content/segments/segment-0/display.mp4 -frames:v 1 $TMPDIR/frame-<t>.png
ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames,duration -of csv=p=0 <slug>.cap/content/segments/segment-0/display.mp4
```

Look at the frames: the right window, no leftover footage, no banners or desktop bleeding in, and a clean final frame. Detached recordings can start late and window capture stalls on static pixels, so the real rate is often about 58 fps. Export at the measured rate rather than forcing 60.

## Export

```sh
cap export <slug>.cap --output out.mp4 --json
cap export <slug>.cap --output out.gif --format gif --fps 15 --resolution 1280x720 --json
cap export-preview <slug>.cap --frame-time <seconds> --json    # render one edited frame to check
```

`--quality maximum|social|web|potato` and `--optimize-filesize` apply to mp4. `--settings-json` takes the full settings object instead of the flags.

## Library and sharing

- **Auth:** `cap auth status --json` reports the credential source; it reuses the Cap Desktop login. `cap auth login --json` requests the least-privileged `creator` profile by default; ask for `admin` or `full` only when the task needs it.
- **Reads:** `cap caps list`, `get <id-or-url>`, and `context <id-or-url>` (title, summary, chapters, transcript, comments, views, sharing). Stream large content to disk with `cap caps transcript <id> --format text --output t.txt` and `cap caps download <id> --output v.mp4`.
- **Waits:** `cap caps wait <id> --for transcript|ai|all` only observes processing; it never starts paid work. `cap jobs wait <operationId>` confirms durable operations; an accepted or queued response is not success.
- **Writes:** `cap upload`, metadata, visibility and sharing, comments, moves, deletes, `caps process`, transcript replacement, and membership, storage, and billing changes all need the user's explicit confirmation of the exact action. Pass `--yes` only after it.
- **Secure input:** for `PASSWORD_REQUIRED`, S3 credentials, and new developer keys, hand the user the exact terminal command, such as `cap caps unlock <id>`. Never take a password or secret into chat or command arguments.
- **Browser handoffs:** checkout, billing portal, Google Drive authorization, and referrals return a URL for the user to finish; re-read state afterwards.
- `cap organizations invite add` emails by default; `--no-email` makes a link-only invite. `cap account sign-out-all` also revokes the current CLI credential.
- `cap caps import loom <url> --organization <id> --yes --json` imports a Loom; wait on the returned operation.
