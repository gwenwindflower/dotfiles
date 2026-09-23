# qmd

`qmd` searches local markdown collections: notes, docs, wikis, transcripts, and the girlOS vault. Search it before the web when the answer may already be in indexed files.

The loop is always search, retrieve, answer. Snippets are leads; fetch the document before stating facts, decisions, or quotes, and cite the `#docid` or path.

```bash
qmd search "merchant support interviews" -n 5
qmd multi-get "#abc123,#def432" --format md
```

## Pick the mode

- **`qmd search`** is BM25 lexical search. Use it for exact titles, names, symbols, rare phrases, or a verbatim quote. It's the fallback when model-backed commands fail.
- **`qmd query`** is the default for ideas described indirectly. Write the structured fields yourself instead of passing the user's sentence and relying on the built-in expander:

  ```bash
  qmd query $'intent: Find the note on metrics as instruments, not OKR mechanics.\nlex: cockpit instruments OKR Goodhart\nvec: data informed not metric driven product judgment\nhyde: A note argues metrics are useful like cockpit instruments but must not replace judgment.'
  ```

  | Field | Holds |
  | --- | --- |
  | `intent:` | What to find and what to avoid; always include it |
  | `lex:` | Exact terms, aliases, titles, and rare words expected in the source |
  | `vec:` | The idea paraphrased in source-like wording |
  | `hyde:` | A description of the document that would answer the request |

  Write `intent:` plus at least one of `lex:` or `vec:`. Add `--format json --explain` to inspect ranking.

- Scope with `-c <collection>` (repeatable) when results drift into the wrong corpus; `qmd collection list`, `qmd ls`, and `qmd status` show what's indexed.

## Retrieve

```bash
qmd get "#abc123"
qmd get "#abc123:120:40"                  # 40 lines from line 120
qmd get qmd://notes/idea.md:200           # line 200 to end
qmd multi-get 'concepts/{a.md,b.md}' --format md
qmd multi-get 'sources/podcast-2025-*.md' -l 80
```

- Output is line-numbered and headed with the `#docid` and `qmd://` path.
- Slice with the `:from:count` suffix or `--from`/`-l`, never by piping through `sed`, `head`, or `tail`; piping breaks docid resolution and the header.
- Each search hit carries a `:line` anchor; feed it straight into `qmd get path:line:<n>`.
- `--full-path` on `search` and `query` swaps `qmd://` URIs for on-disk paths, for handing results to other tools.

## Keep the index fresh

Maintaining the index is part of using the tool:

- `qmd status` shows per-collection age. When expected content is missing or the index is more than a few days old, run `qmd update` then `qmd embed` (fills only missing vectors) before trusting results.
- When `models.embed` in `~/.config/qmd/index.yml` changes, run `qmd embed -f`; vectors don't carry across models and stale-model search degrades silently.
- `qmd doctor` diagnoses config, model cache, GPU, and vector fingerprints; run it before changing configuration when a model-backed command fails.
- Adding collections (`qmd collection add`) is setup work; do it only on request.

Use the CLI, not the qmd MCP server.
