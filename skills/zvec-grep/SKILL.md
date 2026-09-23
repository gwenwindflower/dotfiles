---
name: zvec-grep
description: zg hybrid lexical and semantic search over code and mixed workspaces, plus index setup. For unknown wording or flow and architecture questions; exact identifiers use rg, markdown uses qmd.
allowed-tools: Bash(zg:*)
---

# zvec-grep

`zg` fuses BM25 full-text search and vector search over a per-workspace index at `<root>/.zvec-grep/`, with structural extraction for C, C++, Go, Java, JS/TS, Python, and Rust, heading-aware chunks for markdown, and plain chunks for everything else text. It also wraps ripgrep with the same ignore rules. Output is agent-oriented markdown by default.

## Route the question

| You have | Use |
| --- | --- |
| An exact identifier, path, error string, config key, or regex | `rg` (or `zg query --rg <pattern>` to match the index's ignore rules) |
| A concept, paraphrase, or "where does X happen" with unknown wording | `zg query "<question>"` |
| A relationship, chronology, data or control flow, or cross-file comparison | `zg query` with several query groups, then `rg` on the anchors it surfaces |
| A "does anything relevant exist" check | One focused `zg query`; stop if the top hits are irrelevant |

Search before broad file reads or delegating discovery. A snippet that answers the question counts as read; open the file only for detail the snippet lacks.

## Check readiness first

```bash
zg status --check-ready
```

| Status | Meaning | Do |
| --- | --- | --- |
| Not configured | No index in this workspace | `zg index` (see Indexing) |
| Stale or refreshing | Files changed since the last refresh | Query with `--refresh wait` when accuracy matters |
| Ready | Index matches the tree | Query |

Direct mode never refreshes on query. If `zg server status` reports the daemon stopped, run `zg index` after substantial edits or a branch switch before trusting results.

## Query craft

```bash
zg query "where incoming webhooks are validated"                 # hybrid, top 7
zg query "retry policy for warehouse queries" --limit 12 --preview short
zg query --hybrid "how dashboards are scheduled" --fts "SchedulerClient" --vector "cron-like recurring delivery of saved charts" --fuse
zg query "chart export" -t ts -g '!**/*.test.ts' --symbol-type function --prefer-symbol
zg query "migration that added org roles" --modified-after 2026-06-01
```

- The positional query is hybrid. Add `--fts` groups for symbols and rare terms you expect verbatim, `--vector` groups for paraphrase, and `--fuse` to rank everything in one list. Write the groups yourself; nothing expands the query for you.
- Results are grouped per query and keep each group's rank. A hit in several groups is a strong lead.
- `--preview none` is the default in agent output; ask for `short` or `full` only when you will act on the text without opening the file.
- Filters: `-g`/`--iglob` paths, `-t`/`-T` ripgrep types, `--modified-after`/`--modified-before`, `--symbol-type module|class|interface|function|value|alias`.
- `--human` switches to terminal-friendly output with full previews; leave it off in agent runs.

## Indexing

```bash
zg index                                    # new index with $ZVEC_GREP_EMBEDDING (local/potion-code-16m-v2)
zg index --embedding local/jina-embeddings-v2-base-code   # higher quality, slower build
zg index -g '!**/fixtures/**' -g '!**/*.snap'             # narrow a large repo; filters persist in the manifest
zg index --rebuild                          # same model, from scratch
zg index --drop --yes                       # remove the index; only on request
```

- New indexes take the model from `--embedding`, then `ZVEC_GREP_EMBEDDING`, then `zg config`. An existing index keeps its stored model; switching models means `--rebuild` with `--embedding`.
- Scanning honors `.gitignore` and skips dependencies, build output, lock files, hidden paths, `.git`, and `.zvec-grep`. Add `--hidden`, `--no-ignore`, or `--ignore-file` deliberately. `.zvec-grep/` is in the global gitignore.
- Local models download on first use to `~/.zvec-grep/models` from Hugging Face. Sandboxed shells cannot fetch or store them: a `MODEL2VEC_DOWNLOAD_FAILED` or "Unable to prepare huggingface model cache" error means the first index for that model runs in the user's terminal. Report it; do not add domains, move the cache, or retry.
- Large monorepos: build once with the potion model, keep the daemon running for incremental refresh, and scope with `-g`/`-t` rather than indexing generated code.

### Models

| Model | Runtime | When |
| --- | --- | --- |
| `local/potion-code-16m-v2` | Model2Vec, CPU | Default; fastest build and query on code, no GPU benefit |
| `local/jina-embeddings-v2-base-code` | ONNX, CPU | Better semantic recall on code when build time is acceptable |
| `local/embeddinggemma-300m`, `local/qwen3-embedding-0.6b` | llama.cpp, Metal | Prose-heavy mixed workspaces |
| `qwen/*` | Remote DashScope | Never without an explicit request; sends workspace text off-machine |

Remote models need `zg auth grant` or `--allow-remote`; treat both as reviewed configuration changes.

## Modes and the daemon

`--mode auto` (default) uses the shared daemon on `127.0.0.1:7999` when it is running and otherwise runs in-process. The daemon holds loaded models, watches indexed workspaces, and refreshes in the background on query.

```bash
zg server status --check-ready
zg server on                                # start on loopback; survives the session
zg server off
```

Start it when a session will run many queries or the workspace is large. Restart it after changing embedding environment variables; it inherits its runtime at launch. The daemon's MCP endpoint is not registered with any harness; use the CLI.

## Pitfalls

- A stale index in direct mode returns confident, wrong locations. Check status after big diffs.
- `zg query` has no root argument; run it from inside the workspace. `zg index` and `zg status` accept a root path.
- Do not fold `--rg` output and indexed output into one claim without saying which was exhaustive.
- Do not switch models per query; the model is an index property.
- Do not drop or rebuild an index to fix a query problem; refine the query groups first.
