# Worktrunk config

Worktrunk reads two TOML files with the same shape. The user file holds personal preferences for every repo; the project file holds a repo's shared hooks and is untrusted until the user approves it.

| File | Scope | Trust |
| --- | --- | --- |
| `~/.config/worktrunk/config.toml` | Every repo; per-repo overrides under `[projects."<host>/<owner>/<repo>"]` | Trusted |
| `<repo>/.config/wt.toml` | One repo, checked in | Each command needs approval |
| `~/.config/worktrunk/approvals.toml` | Approved project commands | Written by `wt config approvals add` |

The user file is a chezmoi symlink to `symsources/worktrunk/config.toml` in the dotfiles repo, so edit it there; `wt` writes through the same symlink. Propose user-config changes before making them. `wt config show` prints both files, their resolved paths, and the current project's identifier for `[projects]` keys.

Precedence, highest first: `--config-set '<toml>'`, `WORKTRUNK_*` env vars (`commit.generation.command` is `WORKTRUNK_COMMIT__GENERATION__COMMAND`), a matching `[projects]` entry, then the global key. Scalars replace; hooks, aliases, and `step.copy-ignored.exclude` accumulate across every layer.

## The user config

`symsources/worktrunk/config.toml` is the source of truth. What it sets up:

- **Commit generation**: `[commit.generation]` pipes the prompt to headless `claude -p` on Sonnet. `template-append` adds the conventional-commit, trailer, and `Co-Authored-By` rules.
- **`[list] summary = true`**: LLM branch summaries in `wt list --full` and the switch picker.
- **`[step.copy-ignored] exclude`**: skips virtualenvs, which break at a new path. Everything else reflink-clones for free.
- **Aliases** `shift` and `copy`: carry uncommitted changes into the worktree `wt switch` lands on (see [worktrunk](../project-management/worktrunk.md#creating-and-switching) in `project-management`).
- **`pre-start` pipeline** on every new worktree, in order: `wt step copy-ignored`, then `trunks` (grants Codex git access to the worktree), then `depop` dependency sync (skipped with a warning when `depop` is missing). It is `pre-start` so an agent launched with `-x` lands on installed dependencies.
- **`post-start` / `post-remove`**: add and drop the worktree in zoxide.

Don't repeat these hooks in a project's `.config/wt.toml`.

## Hooks

| Event | Blocking `pre-` | Background `post-` | Fires on |
| --- | --- | --- | --- |
| switch | `pre-switch` | `post-switch` | Every `wt switch`, including create and no-op; `pre-switch` runs in the source worktree |
| create | `pre-start` | `post-start` | Once, when `wt switch` creates a worktree |
| commit | `pre-commit` | `post-commit` | `wt step commit`, `wt step squash`, and the commit inside `wt merge` |
| merge | `pre-merge` | `post-merge` | `wt merge`, after the rebase; `post-merge` runs in the target's worktree |
| remove | `pre-remove` | `post-remove` | `wt remove` and `wt merge` cleanup; `post-remove` runs in the primary worktree |

- A failing `pre-*` hook aborts the operation. `post-*` hooks run detached, with output under `.git/wt/logs/`.
- Within `wt merge` the blocking order is `pre-commit`, `pre-merge`, `pre-remove`.
- Worktrunk hooks are not git hooks. They fire only through `wt` commands, so prek still guards every plain `git commit`.
- Prefer `post-start` for slow setup unless `-x` or a later hook needs the result first.
- User and project hooks both run. For `pre-*`, user commands run first and a failure skips the project's. For `post-*`, the two sources run in parallel with no ordering, so commands that depend on each other belong in one source.

Tool projects gate `wt merge` with one project `pre-merge` hook after the rebase: `mise run release:check` into the default branch, `mise run check` into any other. [project-tooling/mise.md](../project-tooling/mise.md#hooks-and-merge-gates) owns that pattern.

### Forms

```toml
pre-start = "npm ci"              # one command

[post-start]                      # a table: commands run concurrently
server = "npm run dev"
watch = "npm run watch"

[[pre-merge]]                     # a pipeline: blocks run in order,
lint = "cargo clippy"             # keys within a block run concurrently,

[[pre-merge]]                     # and a failing step stops the rest
test = "cargo test"
```

A top-level hook key must come before the first table header, as in any TOML file.

### Template variables

Commands are minijinja templates. Variables are shell-escaped automatically, so never wrap `{{ ... }}` in quotes.

| Variable | Value |
| --- | --- |
| `branch`, `worktree_path`, `worktree_name`, `commit`, `upstream` | The branch the operation acts on: the destination for switch and create, the source for merge and remove |
| `base`, `base_worktree_path` | Where a switch came from, or the `--base` of a create |
| `target`, `target_worktree_path` | The merge target, or where a removal lands |
| `repo`, `repo_path`, `primary_worktree_path`, `default_branch`, `remote` | Repo-wide constants |
| `hook_type`, `hook_name`, `cwd`, `args` | The running hook and the tokens forwarded after `--` |
| `vars.<key>` | Per-branch values from `wt config state vars` |

- An undefined variable is an error. Guard optional ones with `{% if upstream %}...{% endif %}` or `| default('x')`; `branch` is unset in a detached worktree.
- Filters: `sanitize` (`/` to `-`), `hash_port` (a stable port in 10000-19999), `sanitize_db`, `basename`, `dirname`.
- Every hook also receives all variables as JSON on stdin, for logic a template can't express.
- Branch on `{{ target }}` to give one hook different behavior per merge target.

Test with `wt hook show --expanded`, `wt hook <type> --dry-run`, and `wt hook <type> [name]`; `user:` and `project:` prefixes filter by source.

## Approvals

Project hooks, project aliases, and a project `template-append` run only after the user approves each command. Approval re-prompts whenever a command's template changes or the repo moves; declining skips every project command for that run.

An agent that hits an approval prompt stops and asks the user to run `wt config approvals add` interactively. Never pass `--yes` to the blocked command or to `wt config approvals add`: both let project code run with nobody reading it, which is the user's decision. `wt config approvals list --format=json` reports `no_commands`, `approval_required`, or `approved` without prompting.

## Aliases

`[aliases]` entries run as `wt <name>`, resolved after built-ins and before `wt-<name>` executables on `PATH`. They share the hook template engine.

- `{{ args }}` is the positional arguments, shell-escaped and space-joined.
- `--KEY=VALUE` binds `{{ KEY }}` when the template uses it and otherwise forwards into `args`. Tokens after `--` always forward.
- `[[aliases.<name>]]` blocks form a pipeline with the same rules as hooks.
- An alias runs in a subshell. Only the directory change from a nested `wt switch`, `wt merge`, or `wt remove` reaches the caller's shell.
- An alias body renders once, at dispatch. To hand a template to a nested `wt` command (`wt step for-each`, `-x`), wrap it in `'{% raw %}{{ branch }}{% endraw %}'` so each worktree renders its own value.
- `wt config alias show <name>` prints the template and `wt config alias dry-run <name> [-- args]` prints the rendered command.

## Commit message generation

`[commit.generation] command` receives the prompt on stdin and prints the message. `wt step commit`, `wt step squash`, and the squash in `wt merge` all use it. Without it, messages fall back to changed file names.

- `template-append` adds rules without replacing the built-in prompt. The user fragment renders as `<user-guidance>`; a project's `.config/wt.toml` may set its own, which renders as `<project-guidance>` after it and needs approval.
- `[commit] stage` sets the default staging mode (`all`, `tracked`, `none`) for commit, squash, and merge.
- `wt step commit --dry-run` runs the LLM and prints the message without committing.
- If generation fails, pipe a prompt to the configured command directly (`echo hi | <command>`) to see the tool's own error.

## State and markers

Per-repo state lives in `.git`: git config keys under `worktrunk.state.*` and logs under `.git/wt/logs/`. `wt config state get` shows all of it.

- **Markers**: `wt config state marker set <text> [--branch b]` and `clear` set the last Status cell in `wt list`. The Claude Code plugin sets 🤖 on each prompt and 💬 when Claude waits, and clears the marker at session end. Codex and OpenCode sessions have no plugin, so their worktrees show no marker.
- **Vars**: `wt config state vars set key=value [--branch b]` stores per-branch values that hooks read as `{{ vars.key }}`. JSON values allow dot access.
- **Default branch**: `wt config state default-branch` reads the cached value; `clear` re-detects it.
- **Logs and caches**: `wt config state logs get|clear` and `wt config state cache clear`.

The Claude Code plugin also routes Claude Code's own worktree creation and removal through `wt switch --create` and `wt remove`, and adds `/wt-switch-create` to start a task in a fresh worktree.
