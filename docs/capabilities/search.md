# Local search

Agents find material by corpus-appropriate retrieval instead of broad file reads, with every index and embedding model kept on the workstation.

## Expected behavior

- Route a known literal to `rg` in any corpus. Route unknown wording, conceptual questions, and cross-file relationships to the indexed tool for the corpus: `zg` for code and mixed-content workspaces, `qmd` for markdown knowledge bases including girlOS, `agentsview` for recorded agent sessions.
- Run the indexed search before delegating discovery or reading files wholesale. A sufficient snippet counts as read.
- Query, status, and incremental refresh are routine. A workspace index is built on first use when its embedding model is already cached.
- Keep embeddings local. Remote embedding providers are never granted or allowed as a recovery step.

## Safety boundary

Index storage is workspace-local for `zg` (`<root>/.zvec-grep/`, globally gitignored) and home-local for `qmd` and `agentsview`. Rebuilding an index is cheap; dropping one is requested cleanup only.

Hugging Face is in neither domain list, so the first index for a new embedding model runs in the user's terminal. Agents report the download failure rather than adding the host or relocating the cache.

`zg` in `auto` mode uses the shared loopback daemon when it is running and otherwise works in-process. The daemon exposes only indexed search on its MCP endpoint by default; no harness registers it as an MCP server, so the CLI is the single agent surface.

## Corpus routing

| Corpus | Tool | Index location | Refresh |
| --- | --- | --- | --- |
| Code and mixed workspaces | `zg` | `<root>/.zvec-grep/` | Daemon watcher or `zg index`; direct mode never refreshes on query |
| Markdown knowledge bases, girlOS | `qmd` | `~/.cache/qmd/` | `qmd update` then `qmd embed` |
| Agent session history | `agentsview` | `$AGENTSVIEW_DATA_DIR` | Continuous capture; embeddings served by `llup` |

The default `zg` model for new indexes is `local/potion-code-16m-v2`, exported as `ZVEC_GREP_EMBEDDING`; an existing index keeps whatever model built it. `qmd` reads the Qwen3 GGUF that `llup` also serves for agentsview.

## Levels

| Family | Level | Notes |
| --- | --- | --- |
| `zg` query, status, and index | `sandboxed` | Workspace writes cover `.zvec-grep/`; `~/.zvec-grep` holds daemon state. |
| `zg index --drop` | `sandboxed` | Guidance keeps it to requested cleanup; no reviewer sees it. |
| `zg install`, `zg auth grant` | `review-request-open` | Trust surfaces; see [workspace access](workspace.md#levels). |
| `qmd` search, `update`, and collection reads | `sandboxed` | `~/.cache/qmd` is writable. |
| `qmd embed`, `qmd query`, `qmd vsearch` | `open` | They load models on the GPU, which both sandboxes block. |
| `agentsview` search and session reads | `sandboxed` | Both sandboxes grant write on `~/.local/share/agentsview`. |

Raw `sqlite3` reads of the agentsview or Codex databases open them with `file:<path>?mode=ro&immutable=1` so the read takes no lock and needs no write access beside the database.

## Platform implementations

| Harness | Mechanism |
| --- | --- |
| Claude Code | Sandbox grants cover `zg`, `qmd`, and `agentsview`; `qmd embed`, `query`, and `vsearch` are excluded with an allow. |
| Codex | Profile grants cover the same paths; `services.rules` allows the GPU `qmd` commands. `ZVEC_GREP_EMBEDDING` and `AGENTSVIEW_DATA_DIR` come through `shell_environment_policy.set`, because shell environment inheritance is restricted to core variables. |
| OpenCode | Explicit allows for `zg query`/`status`/`index`/`server status`, `qmd` read and search commands, and `agentsview session` search and messages; `zg index --drop` asks. |

Shared routing lives in `.chezmoitemplates/agents/rules/exploration.md`; tool detail lives in the `context-search` skill.

## Verification

- A hybrid `zg query` in an indexed repo returns ranked snippets from a sandboxed shell without a model download.
- `zg index` on an uncached model fails in the sandbox with a download error and succeeds from the user's terminal.
- `zg status --check-ready` distinguishes not configured, stale, and ready.
- A note search reaches girlOS through `qmd` and a decision lookup reaches the archive through `agentsview` from an unrelated project, sandboxed in both harnesses.
