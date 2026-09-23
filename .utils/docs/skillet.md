# skillet

Curates the dotfiles skill library on top of `gh skill`. gh fetches upstream skills and resolves refs; skillet diffs each upstream skill against the version last distilled into our spines and records baselines. The distilling itself is agent work, described in `skills/agent-context-engineering/upstream-fold.md`.

Run it anywhere through the `skillet` fish function, or `deno task skillet` from `.utils/`.

| Command | Does |
| --- | --- |
| `skillet check` | Lists entries in `skills/upstream.toml` that changed upstream or were never distilled; exits 1 when any need work |
| `skillet diff <skill>` | Fetches baseline and current into a temp dir, prints the diff with gh metadata removed, the target files and any other upstreams sharing them, both paths, and the exact `accept` command |
| `skillet accept <skill> [--commit <sha>]` | Records the commit (default: current upstream) and its tree SHA as the entry's baseline |
| `skillet save <skill>... [-n]` | Copies deployed skills from `~/.agents/skills` into `skills/`, stripping gh's `github-*` metadata keys |

## Manifest

```toml
[[context-search.upstream]]   # one array per spine; keep spines sorted
repo = "tobi/qmd"             # owner/name
skill = "qmd"                 # gh skill name; unique across the whole manifest
files = ["qmd.md"]            # spine-relative docs this upstream folds into; one baseline covers all
# pin = "v2.8.3"              # optional tag or commit; default is gh's resolution
baseline = "facd35e0…"        # written by accept: upstream commit last distilled
tree = "cfe2aef5…"            # written by accept: skill folder tree SHA, the change signal
```

`accept` edits the manifest as text, so comments and ordering survive.

## Behavior worth knowing

- `gh skill install --dir` still writes a top-level entry into `~/.agents/.skill-lock.json`, which the fresh-machine replay would install. skillet snapshots the lock's bytes before every fetch and restores them after.
- Change detection compares the upstream skill folder's tree SHA, so commits elsewhere in the upstream repo never register as changes.
- A pinned fetch records the full commit as `github-ref`; an unpinned one records `refs/tags/…` or `refs/heads/…`, which skillet resolves to a commit with `gh api`.
- Temp dirs from `diff` are left in place for the agent to read; everything else cleans up after itself.

## Tests

`deno task test:skillet` covers manifest parsing and validation, baseline edits that preserve comments, gh metadata parsing and stripping, and status classification. Fetching is exercised live, not mocked.
