# mise projects

mise owns build/runtime dependencies (`[tools]`) and the command surface (tasks). Development tools use `PATH`; contributors can uncomment individual tools in `mise.toml` before `mise trust && mise install`. Discovery is `mise tasks`; the local gate is `mise run check`. CI runs the same tasks, so a task definition is the only place a check lives; [CI practices](ci/practices.md) covers the CI side.

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
- **Multiple task invocations need `:::`.** Use `mise run lint ::: test`; without the separator, `test` is an argument to `lint`. Quote commands containing `:::` in YAML, and validate the exact CI invocation locally.
- **`confirm` prompts, defaults to no, and reads the tty.** Use it for every step that leaves the machine (push, publish). It cannot be piped past, which is the point.
- **`#USAGE arg "[tag]" env="TAG"`** declares an argument with an environment fallback. A pipeline resolves a value once, exports it, and every step reads the same one. Flags: `#USAGE flag "--topics <list>"` arrives as `$usage_topics`; boolean flags arrive as `true`.
- **Sandbox policies belong on TOML tasks.** For zizmor, use `allow_write = ["~/.cache/zizmor"]`: it restricts other writes while permitting the online audit cache. A bare `deny_write = true` blocks that cache. Keep network access available for online audits. Direct tool invocations bypass mise task policies; validate both offline hooks and authenticated online audits.
- **`quiet = true`** suppresses the task banner; use it on tasks whose stdout is consumed by other scripts (`version:read`, `version:next`).
- **Development tools are opt-in.** Only build or runtime dependencies are active in `mise.toml`. Comment linters, formatters, release tooling, and other development-only binaries under `[tools]`; contributors uncomment the tools they need and run `mise install`, keeping those opt-ins uncommitted. Rust comes from rustup on `PATH`, declared by `rust-toolchain.toml`.
- **CI opts in explicitly.** Put active development-tool declarations in `mise.ci.toml` and set `MISE_ENV: ci` at workflow level in every workflow that uses mise. The base config still supplies build/runtime dependencies. Keep the commented development entries and CI versions aligned. Projects without CI do not need this overlay.
- **Tools float on `latest`.** Release cooldowns belong to each machine's global mise config. Pin a version only when the project requires it, documenting the constraint beside the declaration.
- **`latest` needs a rotating CI cache key.** See [CI caching](ci/practices.md#caching).
- **Local config is not an installation guard.** Do not generate or ship `mise.local.toml` disabling project tools: plugin clones do not carry it. During alignment, remove obsolete `disable_tools` settings and examples, preserving unrelated local settings. Keep the filenames gitignored for other local customization. Never use `@system` as a substitute.

## Hooks and merge gates

Three runners, one definition each. Together they are the project's local CI, so a solo project can land work with `wt merge` and save PRs for remote-dependent changes.

| Moment | Runner | Runs | Never runs |
| --- | --- | --- | --- |
| Every `git commit`, any tool | prek (`prek.toml`) | File hygiene, formatters, config validators, `commit-msg` Conventional Commit check, on staged files | Tests, clippy, anything whole-repo |
| `mise run check` and CI | mise tasks | `lint:hooks` (`prek run --all-files`), `lint:*` semantic linters, `version:check`, `test:*` | — |
| `wt merge` (`.config/wt.toml`) | worktrunk | One `pre-merge` gate after the rebase: `release:check` into the default branch, `check` into any other (a stacked parent) | Formatters or file checks, or a separate lint hook (`check` already runs `lint:*`) |

Worktrunk hooks fire only inside `wt merge`, so prek is the only guard on agent commits. `mise run hooks:install` wires prek into a clone; the bootstrap does it.

Every hook is `language = "system"` over a binary on `PATH` (shellcheck, zizmor, rumdl, rustfmt) or a prek builtin. CI installs development binaries through its mise overlay; Rust supplies rustfmt. A remote hook with its own `language` (node, python) makes prek download that runtime and install the hook on every fresh machine and every CI run, outside the toolchain cache. Markdown lint is rumdl for that reason: one static binary, `rumdl check --no-cache` in the hook, `.rumdl.toml` for config (`rumdl import` converts a markdownlint file), markdownlint rule IDs and inline `<!-- markdownlint-disable -->` comments honored.

## Layout

```text
mise.toml            tools, one-liners, pipelines, aliases
mise.ci.toml         development tools enabled by MISE_ENV=ci
mise-tasks/
  version/           read, write, files, verify (kit hooks); check, next, bump, sync (neutral)
  release/           _default, preflight, commit, notes, create, rehearse, package, formula
  repo/              settings, labels, rulesets, environments
  ci-audit/          pinact
tests/*.sh           project contract suites that call task scripts directly by path
```

`_default` in a group directory is the group's bare task (`mise run release`).

## Checklist for a new task

1. Does an existing task already wrap this? Extend it.
2. One command → `mise.toml`; logic → script with `#MISE description=`.
3. Standalone-safe: the `cd` line, `set -euo pipefail`, siblings by path.
4. Side effects that leave the machine get `confirm`.
5. Add it to the right `depends` group (`check`, `ci-audit`, `release:check`) or CI never runs it.
6. `shellcheck` clean; the prek shellcheck hook covers every file with a shell shebang.
7. Change behavior and regression tests together; consider upstreaming reusable tasks with their tests. Shared suites live in `_tool/template/tests/`, while project contracts stay local. See [task maintenance](task-maintenance.md).
