# Importing skills from GitHub

```bash
rei skills add <github-tree-url>             # one-shot install
rei skills add -t <github-tree-url>          # track in lockfile for future pulls
rei skills add -tp <github-tree-url>         # also auto-prefix by inferred org/user
rei skills add -t <url> -p <prefix>          # explicit prefix
```

URLs may point at one skill or a directory of many — auto-detected. Prefixed install renames each dir to `<prefix>_<name>`. Re-adding a tracked skill just bumps `synced_at`.

## Pulling tracked skills

```bash
rei skills pull [name] [--check|--dry-run]
rei skills pull --prefix-change=rename|parallel|abort
```

Pull fetches the remote and merges into source with **divergence protection**: locally-edited files are kept; the remote version lands as `<file>_1.md` for diff/merge. There is no `--force` — resolve `_1` files at your pace.
