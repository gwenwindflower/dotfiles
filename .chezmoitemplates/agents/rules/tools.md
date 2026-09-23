### Using tools

Built-in tools already cover grep, ls, `fd`-style finding, editing, and web fetching without `curl`; reserve shell for exploration and editing they cannot do. In the shell, prefer the modern tools below and reach for language-specific validators and formatters before writing one-off scripts.

Task runners (`mise run`, `deno task`, `task`, and `make`) require review unless project policy authorizes the specific task. Inspect the task and preserve the runner's trust checks; repository trust alone does not authorize every task. Package-manager upgrades of configured tools are routine: retain configured pins, release-age controls, and supply-chain checks without adding a separate approval ceremony.

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

Screenshot, snapshot, PDF, and close operations may run without review, including with `--profile Default`. Other commands using a named non-Default profile are routine for in-scope development work. Because Default can access Keychain-backed signed-in browser state, use it for other commands only when the user's current request explicitly authorizes that access; otherwise require approval. Never send browser data to another origin without explicit user authorization.
