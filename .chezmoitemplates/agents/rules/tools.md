### Using tools

Built-in tools already cover grep, ls, `fd`-style finding, editing, and web fetching without `curl`; reserve shell for exploration and editing they cannot do. In the shell, prefer the modern tools below and reach for language-specific validators and formatters before writing one-off scripts.

Before running an unfamiliar task through a task runner (`mise run`, `deno task`, `task`, `make`, `wt`, etc.), read what the task does, and let the runner's trust checks stand. Ask the user if a repo hasn't had trust configured yet (most relevant for mise), don't just silently move on and run the commands manually, the tasks are configured for a reason. Package-manager upgrades of configured tools are routine: keep the configured pins, release-age controls, and supply-chain checks in place. If a networked tool is required or requested (Attio, Linear, Slack, GitHub, any kind of API or MCP server) and is not available (blocked, not configured, missing credentials, etc.), stop and work with the user to get it set up first, don't try to hack around it. Make sure the tools you need for a given job are basically functional as early as you can, particularly before starting a long-running unsupervised task. It's better to refine configs and edit the sandbox upfront so the bulk of the work can run smoothly than to dive into execution immediately and burn significant tokens and context window space trying to script your way around tools you can't use.

#### Language-specific tools

Neovim's Mason installs put language tools on `PATH`: `tombi` for TOML, `biome` for JSON, `ty` and `ruff` for Python. A one-off validation script is only warranted for an unusual format none of them cover.

#### Modern tools

| Classic | Prefer |
| --- | --- |
| `grep` | `rg` |
| `find` | `fd` |
| `rm` | `rip` |
| `cat` | `bat` |
| `ls` | `lsd` |
| `sed` | `sd` |
| `ps` | `procs` |
| `which` | `which -a` |
| `npm` / `npx` | `aube` / `aubx` / `aubr` |

`rg`, `fd`, `rip`, and `aube` are the important defaults. Translate `npm` and `npx` in docs to `aube` and `aubx` unless discussed; `pnpm` is the fallback when `aube` is unavailable. A project's designated package manager or runtime (`bun`, `deno`) always wins over these defaults. `rip` deletes to `$XDG_DATA_HOME/graveyard`, needs no `-rf` for directories, and `rip -u` restores the last removal.

#### agent-browser

Use `agent-browser` with an isolated named session. Its browser binaries, sockets, sessions, and encryption state live under `~/.agent-browser`; Puppeteer fallback binaries live under `~/.cache/puppeteer`.

Screenshot, snapshot, PDF, and close operations are fine on any profile, including `--profile Default`. Run everything else on a named non-Default profile. Default can access Keychain-backed signed-in browser state, so use it for other commands only when the user's current request explicitly asks for that access. Never send browser data to another origin without explicit user authorization.

#### Skills

Manage external skills with `gh skill`: search, preview, list, install/add, and update are routine within the task, including user scope. Confirm before removing a skill or force-replacing one. Check the source before installing unfamiliar content; do not use the npm `skills` CLI, package-runner variants, `rei`, or Context7's skill installer. Shared user skills live in `~/.agents/skills`, installed with `--agent universal --scope user`; own skills live in the dotfiles `skills/` tree and edits to a deployed one return there with `skillet save <name>`. Project-scoped skills may shadow global ones.

Many tools also ship version-matched skills. Check whether a skill command prints instructions or installs files before running it; use `gh skill` for external skill management.

### Tool failures

#### Sandbox failures

Inside a sandbox, blocked paths, hosts, env vars, caches, logs, and lockfiles are configuration signals. Surface the block; do not route around it.

Some routine commands need the host by design:

- SSH Git remotes, Git metadata writes in Codex, and Worktrunk.
- chezmoi inspection and dry runs, and `rem`.
- `agent-browser`, and local GPU model work.
- Nested sandboxes, such as mise tasks that sandbox themselves.
- Tool installs and upgrades.

Run these outside the sandbox through the harness's own mechanism. Run each as a bare command, redirecting output to a file in `$TMPDIR` instead of piping or chaining, because host exceptions match whole commands. In Codex, request escalation on the first call rather than waiting for the sandboxed attempt to fail.

Allow rules match a command's leading words, so a `cd <path> &&` prefix, a pipe, or a directory flag such as `git -C` sends an otherwise allowed command to review or the sandbox. Set the directory with a standalone `cd` or the shell tool's working-directory parameter, then run the command alone. When a compound command is rejected but each part looks allowed, retry the parts as separate direct commands before treating the action as blocked.

Change permission, sandbox, trust, or install-script approval settings only when the user explicitly requests work on that surface. Never edit an allowlist, run `mise trust` or `direnv allow`, approve package build scripts, or alter MCP/plugin trust to unblock an unrelated task.

Do not:

- Invent one-off flags/env vars such as `--cache-dir`, `--log-file`, `TMPDIR`, `HOME`, or `XDG_CACHE_HOME` just to pass.
- Move global stores, caches, or state directories.
- Disable logging, telemetry, checksums, signatures, or safety features.
- Retry the same blocked operation hoping it slips through.
- Switch to offline mode, alternate registries, vendored mirrors, or cache rebuilds to dodge network blocks.

Instead, identify the exact blocked path/host/env var and the tool that needed it. Offer the user two options: update the sandbox allowlist, or run the exact command outside the sandbox and share results.

First-class project-local knobs can be legitimate, such as checked-in tool config or conventional per-project cache dirs. Use them only with explicit buy-in.

Package managers are high stakes. Always stop before changing global package-manager settings, rebuilding global stores, relocating caches, or bypassing checksum/signature verification.

#### Edit failures

When an Edit/Write/apply patch fails to match the current content, re-read the affected file and correct the patch against what is actually there. Retry with the edit tool without asking when the intended change is clear and surrounding work can be preserved.

Do not force a failed edit through a shell command, one-off script, whole-file replacement, or alternate write path. If the edit tool still fails after a corrected retry, the file is locked, or the intended change cannot be reconciled safely with the current content, pause, explain the problem, and ask how to proceed.

Nerd Font/devicon files are especially risky: direct edits can corrupt glyph bytes. If a file contains those icons, give the user a precise snippet to apply, or copy the file whole with `cp`.
