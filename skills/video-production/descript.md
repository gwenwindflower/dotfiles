# Descript

Descript edits through its transcript, which makes it the place for captions, designed text, voice work (Studio Sound, filler-word removal, overdub), and layered media. Agents reach it through the Descript MCP connector, which is signed in to one Drive. When its tools aren't loaded, ask the user to start a session that inherits the desktop app's connectors rather than adding the server yourself. The editor itself stays the user's; agents import, prompt Underlord, and export.

## Jobs and waiting

`import_media`, `import_drive_media`, `prompt_project_agent`, `publish_project`, and `export_timeline` return a `job_id`. Poll `descript:wait_for_job` with `wait_seconds: 20` until the job is terminal, and report `progress.label` and `percent` as it goes. A `-32001` timeout or a `still_running` status means poll the same `job_id` again; never re-issue the import, prompt, or publish.

## Find a project

`descript:search_drive` matches on names and spoken content. `descript:list_projects` pages through projects with a name filter, and `descript:get_project` returns compositions, media, and existing publishes. When a project has more than one composition, confirm which one with the user and pass its `composition_id`.

## Import

`descript:import_media` takes a `project_name` (a new project) or a project ID, an `add_media` map, and `add_compositions` so the media lands on a timeline. Show the user the returned `project_url`.

- **URL:** set `url`. Pass Google Drive and Dropbox share links unchanged. YouTube URLs are not accepted.
- **Local file**, such as a Cap export: set `content_type` and `file_size` (bytes) instead of `url`. The response's `upload_urls` maps each media key to an `upload_url`; `PUT` the raw bytes there with `Content-Type: application/octet-stream`, matching the declared size exactly. Then wait on the job.

  ```sh
  curl --fail -X PUT -H 'Content-Type: application/octet-stream' --data-binary @out.mp4 "<upload_url>"
  ```

- **Failed upload:** call `descript:report_upload_status` with the `job_id`, the media key, and `status: "failed"`, and wait until the job stops, since a second import into the project is rejected while it runs. Then retry, or ask the user for a URL Descript can fetch. Never pass local paths in tool arguments; Descript can't reach them.
- `add_media: {}` with only `project_name` makes an empty project.

## Edit with Underlord

`descript:prompt_project_agent` takes the project ID, the `composition_id`, and a plain-language prompt: trims, captions and their style, filler-word removal, Studio Sound, rearranging, titles, b-roll. Prompts spend the Drive's AI credits; a `402` means media minutes or credits ran out.

- Save the returned `conversation_id` and pass it on follow-up prompts anywhere in the project, with the target `composition_id`, to keep one thread.
- Run one agent job per composition at a time.
- Confirm the edit from the completed job result and the composition state, not `updated_at`.

## Export and publish

- **Transcript:** `descript:export_transcript` with `format` `txt`, `markdown`, `html`, `rtf`, or `srt`, plus optional `include_speaker_labels`, `include_markers`, and `timecodes`. It returns the content directly, with no job.
- **Timeline for another editor:** `descript:export_timeline` with `format` `edl`, `sesx`, `fcp`, `premiere`, `davinci_resolve`, or `aaf`. Media isn't bundled. The `download_url` expires at `download_url_expires_at`, so tell the user to grab it promptly.
- **Publish:** `descript:publish_project` makes a share link and a rendered download, and republishing a composition overwrites its earlier output at the same URL. Publish only when the user asked for it, and read existing links from `get_project` instead of republishing. Report `share_url` and `download_url` exactly as returned. Publishing is the only way to get a rendered file through the API.
