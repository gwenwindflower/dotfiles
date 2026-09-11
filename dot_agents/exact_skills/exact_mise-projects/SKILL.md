---
name: mise-projects
description: Design and maintain mise-managed projects, where mise.toml declares the toolchain and owns the task list and mise-tasks/ holds scripted tasks. Use when adding or editing mise tasks, choosing tool versions, wiring CI to mise, or deciding what belongs in mise.toml versus a task script.
---

# mise projects

mise owns two things in a project: the toolchain (`[tools]`) and the command surface (tasks). Onboarding is `mise trust && mise install`; discovery is `mise tasks`; the local gate is `mise run check`. CI installs mise with `jdx/mise-action` and runs the same tasks, so a task definition is the only place a check lives.

## Where a task lives

| Weight | Home | Shape |
| --- | --- | --- |
| One command, a pipeline, an alias | `mise.toml` | `[tasks.name]` with `run`, `depends`, `alias` |
| Anything with logic or arguments | `mise-tasks/<group>/<name>` | Bash with a `#MISE` header; the directory becomes the `group:` prefix |

Task scripts run standalone. Open each with:

```bash
cd "${MISE_PROJECT_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
```

Scripts compose by calling siblings through their paths (`mise-tasks/version/read`), never through `mise run`, so tests can invoke them with no mise in the loop. Reserve `mise run` for pipelines, where it is also what fires `confirm` gates.

## Naming

Group by prefix and alias the everyday ones: `lint:*`, `test:*`, `version:*`, `release:*`, `repo:*`, `ci-audit:*`, `dev:*`, plus bare `build`, `check`, `install`, `fmt`. A wildcard in `depends` or `mise run 'lint:*'` runs the whole group, and a group with no members is an error, so every project ships at least one `lint:` and one `test:` task.

Every task carries a `description`; `mise tasks` is the discovery surface, so the README documents workflows, not the task list.

## Behaviors that shape the design

- **`depends` runs in parallel.** Order-sensitive steps go in a sequential `run` array.
- **`confirm` prompts, defaults to no, and reads the tty.** Use it for every step that leaves the machine (push, publish). It cannot be piped past, which is the point.
- **`#USAGE arg "[tag]" env="TAG"`** declares an argument with an environment fallback. A pipeline resolves a value once, exports it, and every step reads the same one. Flags: `#USAGE flag "--topics <list>"` arrives as `$usage_topics`; boolean flags arrive as `true`.
- **`deny_net` and `deny_write` work only on TOML tasks.** mise warns and ignores them in `#MISE` file headers. Apply them to third-party tools that should never write to the checkout (`zizmor .`, manifest validators); skip them for anything that needs the network or a cache.
- **`quiet = true`** suppresses the task banner; use it on tasks whose stdout is consumed by other scripts (`version:read`, `version:next`).
- **Tools float on `latest` behind a cooldown.** `[settings] minimum_release_age = "3d"` in `mise.toml` keeps every machine and CI on the newest release older than three days, so security fixes arrive without a bump commit and a compromised day-zero release never installs. Pin a version only when the project needs that version, and say why in `mise.toml`.
- **`latest` needs a rotating CI cache key.** `jdx/mise-action` keys its cache on the hash of the mise config files and never re-saves on a hit, so a floating toolchain would reinstall every moved tool on every run. `ci.yml` writes `MISE_CACHE_WEEK` from `date +%G-%V` and passes `cache_key: "{{default}}-{{env.MISE_CACHE_WEEK}}"`.
- **`MISE_TRUSTED_CONFIG_PATHS: ${{ github.workspace }}`** at workflow level lets CI trust the checkout without a separate step.
- **`mise.local.toml` is the per-machine layer.** Gitignored, loaded after `mise.toml`, trusted with the directory. A contributor skips project tools already on `PATH` with `[settings] disable_tools = ["prek", "rust"]`: the setting is scoped to that directory, `mise install` skips those tools, tasks fall through to `command -v`, and `mise use` still writes to `mise.toml`. Ship `mise.local.toml.example` showing it. Never pin a tool to `@system`; it is deprecated, and the rust backend hands it to rustup, which fails.
- **`cache: false`** on `jdx/mise-action` in any workflow that publishes artifacts. The cache holds the installed toolchain and skips verification on a hit; a poisoned entry would reach users.

## Hooks and merge gates

Three runners, one definition each:

| Moment | Runner | Runs | Never runs |
| --- | --- | --- | --- |
| Every `git commit`, any tool | prek (`prek.toml`) | File hygiene, formatters, config validators, `commit-msg` Conventional Commit check, on staged files | Tests, clippy, anything whole-repo |
| `mise run check` and CI | mise tasks | `lint:hooks` (`prek run --all-files`), `lint:*` semantic linters, `version:check`, `test:*` | — |
| `wt merge` (`.config/wt.toml`) | worktrunk | `lint:*` before the squash, `release:check` after the rebase | Formatters or file checks |

Worktrunk hooks fire only inside `wt merge`, so prek is the only guard on agent commits. `mise run hooks:install` wires prek into a clone; the bootstrap does it.

Every hook is `language = "system"` over a binary mise installs (shellcheck, zizmor, rumdl, rustfmt) or a prek builtin. A remote hook with its own `language` (node, python) makes prek download that runtime and install the hook on every fresh machine and every CI run, outside the toolchain cache. Markdown lint is rumdl for that reason: one static binary, `rumdl check --no-cache` in the hook, `.rumdl.toml` for config (`rumdl import` converts a markdownlint file), markdownlint rule IDs and inline `<!-- markdownlint-disable -->` comments honored.

## Layout

```text
mise.toml            tools, one-liners, pipelines, aliases
mise-tasks/
  version/           read, write, files, verify (kit hooks); check, next, bump, sync (neutral)
  release/           _default, preflight, commit, notes, create, rehearse, package, formula
  repo/              settings, labels, rulesets
  ci-audit/          pinact
tests/*.sh           shell suites that call task scripts directly by path
```

`_default` in a group directory is the group's bare task (`mise run release`).

## Checklist for a new task

1. Does an existing task already wrap this? Extend it.
2. One command → `mise.toml`; logic → script with `#MISE description=`.
3. Standalone-safe: the `cd` line, `set -euo pipefail`, siblings by path.
4. Side effects that leave the machine get `confirm`.
5. Add it to the right `depends` group (`check`, `ci-audit`, `release:check`) or CI never runs it.
6. `shellcheck` clean; the prek shellcheck hook covers every file with a shell shebang.
