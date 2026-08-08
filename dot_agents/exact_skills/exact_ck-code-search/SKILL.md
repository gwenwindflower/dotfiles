---
name: ck-code-search
description: Search code by meaning with ck — semantic, hybrid, and grep-compatible search with a local embedding index. Use when the user mentions ck, asks to search code by concept ("find the auth logic", "where is error handling"), or when exact keywords are unknown and grep/rg keeps missing. Codebases only — for markdown notes, docs, or Obsidian vaults use qmd; for past agent sessions use agentsview.
---

# ck Code Search

`ck` fuses lexical (BM25/grep) precision with embedding-based recall. Fully offline; the index lives in `.ck/` and builds automatically on the first `--sem`/`--hybrid` search (delta-updates after). No pre-indexing step needed.

ck is for **source code**. For markdown knowledge bases (notes, docs, Obsidian vaults) use `qmd`; for searching past agent sessions use `agentsview`.

```text
ck [FLAGS] "PATTERN" [PATH...]
```

## Picking a mode

| Mode | Use for | Threshold |
| --- | --- | --- |
| `ck "regex"` (default) | Exact strings, symbol names, regex — grep-compatible, fastest | — |
| `ck --sem "concept"` | Concepts when terminology varies: "error handling", "connection pooling" | 0.0–1.0, default 0.6 |
| `ck --hybrid "query"` | Concept + keyword must both appear; when `--sem` is too noisy | ~0.01–0.05, start at 0.02 |

> [!WARNING]
> Hybrid uses RRF scoring — max score per result is ~0.016 per rank list. A semantic-style `--threshold 0.6` on `--hybrid` returns **zero results**. Use `--threshold 0.02` and calibrate with `--scores`.

Semantic queries should describe what the code does with specific concepts ("database connection pool"), not vague words ("code") or identifiers — use default mode for identifiers.

## Flags that matter for agents

- `--topk N` (alias `--limit`) — semantic/hybrid default to 10 results, max 100
- `--full-section` — return whole functions/classes (tree-sitter chunks), not just matching lines
- `--scores` — show relevance scores; use to calibrate thresholds
- `--jsonl` — one JSON object per line, built for agent parsing; `--json` for a single array
- `--no-snippet` / `--snippet-length N` — trim output when only locations matter
- grep-alikes: `-i`, `-w`, `-v`, `-n`, `-l`, `-L`, `-c`, `-A/-B/-C N`, `-r`, `--exclude PATTERN`, `--no-ignore`

Exit codes match grep: 0 matches, 1 none, 2 error.

## Index management

Corpus upkeep is your job when you use ck:

- **Content changed?** Nothing to do — every `--sem`/`--hybrid` search delta-indexes changed files first.
- **Embedding model changed?** `ck --switch-model <name> --force` — a full re-embed; old vectors are unusable with a new model. Verify with `ck --status`.

Other commands, rarely needed:

- `ck --status` — index health
- `ck --index [PATH]` — build/update explicitly (first index of ~1M LOC takes ~2 min)
- `ck --clean` — drop the index (safe; rebuilds on next search)
- `ck --inspect FILE` — show how a file was chunked
- Models (ONNX via fastembed, ck-managed cache — not shareable with GGUF tools): nomic-v1.5 is our default (8K context, suits large functions); bge-small is ck's fast factory default; jina-code understands programming concepts best
- `.ckignore` — excludes files from indexing, same syntax as `.gitignore`

## Recipes

```bash
ck --sem --full-section "user authentication" src/   # whole functions, not fragments
ck --hybrid --threshold 0.02 --scores "sql injection" src/
ck --sem --jsonl --topk 5 --no-snippet "retry logic" .  # locations only, parseable
ck -n "TODO" .                                       # plain grep-style
```

Docs: <https://beaconbay.github.io/ck/> · CLI reference at `/ck/reference/cli.html`
