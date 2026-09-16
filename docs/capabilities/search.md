# Local search

Agents find material by corpus-appropriate retrieval instead of broad file reads, with every index and embedding model kept on the workstation.

## Expected behavior

- Route a known literal to `rg` in any corpus. Route unknown wording, conceptual questions, and cross-file relationships to the indexed tool for the corpus: `zg` for code and mixed-content workspaces, `qmd` for markdown knowledge bases including girlOS, `agentsview` for recorded agent sessions.
- Run the indexed search before delegating discovery or reading files wholesale. A sufficient snippet counts as read.
- Query, status, and incremental refresh are routine. A workspace index is built on first use when its embedding model is already cached.
- Keep embeddings local. Remote embedding providers are never granted or allowed as a recovery step.

## Safety boundary

Index storage is workspace-local for `zg` (`<root>/.zvec-grep/`, globally gitignored) and home-local for `qmd` and `agentsview`. Dropping an index, rebuilding under a different model, or running `zg auth grant` are reviewed operations; rebuilding is cheap but drop is only requested cleanup.

Embedding model downloads need Hugging Face egress and a writable model cache. Neither is granted to sandboxed shells, so the first index for a new model runs in the user's terminal; agents report the download failure rather than adding domains or relocating the cache.

`zg` in `auto` mode uses the shared loopback daemon when it is running and otherwise works in-process. The daemon exposes only indexed search on its MCP endpoint by default; no harness registers it as an MCP server, so the CLI is the single agent surface.

## Corpus routing

| Corpus | Tool | Index location | Refresh |
| --- | --- | --- | --- |
| Code and mixed workspaces | `zg` | `<root>/.zvec-grep/` | Daemon watcher or `zg index`; direct mode never refreshes on query |
| Markdown knowledge bases, girlOS | `qmd` | `~/.cache/qmd/` | `qmd update` then `qmd embed` |
| Agent session history | `agentsview` | `$AGENTSVIEW_DATA_DIR` | Continuous capture; embeddings served by `llup` |

The default `zg` model for new indexes is `local/potion-code-16m-v2`, exported as `ZVEC_GREP_EMBEDDING`; an existing index keeps whatever model built it. `qmd` reads the Qwen3 GGUF that `llup` also serves for agentsview.

## Platform implementations

| Harness | Mechanism |
| --- | --- |
| Claude Code | Sandbox auto-allow covers `zg`, `qmd`, and `agentsview`; workspace writes cover the index. `~/.zvec-grep/**` is a proposed write root for daemon state; classifier guidance lists the personal CLIs. |
| Codex | `sandbox_workspace_write.writable_roots` includes `.zvec-grep`, and networking is enabled. `ZVEC_GREP_EMBEDDING` is set through `shell_environment_policy.set` because shell environment inheritance is restricted to core variables. |
| OpenCode | Explicit allows for `zg query`/`status`/`index`/`server status`, `qmd` read and search commands, and `agentsview session` search and messages; `zg index --drop` asks. |

Shared routing lives in `.chezmoitemplates/agents/rules/exploration.md`; tool detail lives in the `zvec-grep`, `qmd`, and `agentsview-finding-history` skills.

## Verification

- A hybrid `zg query` in an indexed repo returns ranked snippets from a sandboxed shell without a model download.
- `zg index` on an uncached model fails in the sandbox with a download error and succeeds from the user's terminal.
- `zg status --check-ready` distinguishes not configured, stale, and ready.
- A note search reaches girlOS through `qmd` and a decision lookup reaches the archive through `agentsview` from an unrelated project.
