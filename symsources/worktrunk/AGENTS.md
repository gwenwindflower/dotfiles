# Worktrunk Config

Source for `~/.config/worktrunk/config.toml`. It is symlinked, so edits here are live — no `chezmoi apply` needed.

Load the `worktrunk` skill for hook types, template variables, and `wt step copy-ignored` mechanics. This file records only what that skill doesn't cover.

## Worktree population

`pre-start` runs a two-step pipeline: `wt step copy-ignored`, then `depop`.

The split follows one rule — **copy what nothing can regenerate, install what a package manager owns.** Reflink makes copying free, so the exclude list is only `.venv/` and `venv/`: virtualenvs bake absolute paths into `pyvenv.cfg` and script shebangs, so they break at a new path, and `uv sync` rebuilds them faster than a copy would.

The pipeline is `pre-start` rather than `post-start` because the `switch-shift` and `switch-keep` aliases launch agents via `--execute`, which must land on installed deps.

`depop` is a cargo path install from `~/dev/depop`, deliberately absent from `packages.yaml` like `livery` and `wtherdr`. Fresh machines have no dependency sync until it is built.

### Hook failure semantics

Verified, and narrower than the docs' "failure aborts the operation": a failing `pre-start` step still creates the worktree but **cancels `--execute`**. A missing binary therefore costs the agent launch silently, which is why the `depop` step is guarded by a `command -v` check.

## Reflink

`wt step copy-ignored` clones via copy-on-write, so copies share disk blocks until modified. Measured on APFS: a 200MB clone consumed **0 KB in 40ms**, against 200MB in 117ms for a real copy.

- Plain `cp` does **not** clone on APFS. `-c` is required, and it fails loudly instead of falling back, which makes it a usable capability probe. On Linux use `cp --reflink=auto` for silent fallback or `=always` to fail loudly.
- **`du` cannot see block sharing.** It counts logical blocks per file, so N cloned worktrees report N× the disk they actually occupy. Measure with `df` free-space deltas.

This is why copying `target/`, `node_modules/`, and `.ck` embedding indexes is correct rather than wasteful. It also makes symlinking them to dodge disk cost a bad trade: reflink already gets the space back, while a symlink adds cross-worktree shared mutable state that concurrent agent installs can corrupt.
