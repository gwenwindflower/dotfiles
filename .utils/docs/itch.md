# itch

Build a throwaway git repository to scratch on: testing Claude Code mods, Worktrunk hooks, git aliases, or anything else that needs a real repo with a remote and sibling worktrees.

```fish
cd (deno task --config ~/.local/share/chezmoi/.utils/deno.json itch --worktree feat --worktree other)
```

stdout carries only the main worktree's path; the layout summary goes to stderr.

## Layout

```text
$TMPDIR/itch-XXXX/
  origin.git/   bare remote, HEAD on main
  repo/         main worktree on main, pushed, origin/HEAD set
  repo.feat/    sibling worktree per --worktree, one commit ahead of main, pushed with upstream
```

Siblings sit at Worktrunk's default path (`<repo>.<branch>`, `/` as `-`), so `wt list`, `wt switch`, and `wt remove` treat them as their own. Every commit uses a repo-local `itch` identity with signing off, so global signing config never blocks it.

## Options

| Flag | Default | Effect |
| --- | --- | --- |
| `-n`, `--name` | `repo` | Repository directory name |
| `-w`, `--worktree` | none | Sibling worktree on a new branch; repeatable |
| `-c`, `--commits` | `2` | Commits on main |
| `--no-remote` | remote on | Skip `origin.git`; branches stay local |
| `-p`, `--parent` | system temp | Where the `itch-*` root is created |

## Testing a mod

```fish
cd (deno task --config ~/.local/share/chezmoi/.utils/deno.json itch -w feat -w other)
claude --plugin-dir <mod folder>
```

The session's own worktree is `repo/`; `git -C ../repo.feat ...` targets a sibling.

## Extending

New project shapes are new options on `ItchOptions`, parsed and validated in `parseItchArgs` and built in `createItch`. Add a `createItch` test in `itch_test.ts` that checks the shape with real git.
