# Agent review policy

This is the prose both automatic reviewers apply: Claude Code's auto-mode classifier and Codex's auto-reviewer. A reviewer only sees actions that reach it. [Agent configuration](agent-config.md) defines which commands reach review at each permission level.

| Section | Claude Code (`symsources/claude/settings.json`) | Codex (`symsources/codex/config.toml`) |
| --- | --- | --- |
| Environment | `autoMode.environment` | `## Environment Profile` in `[auto_review] policy` |
| Routine | `autoMode.allow` | `### Routine work`: allow outcome rules |
| Requested only | `autoMode.soft_deny` | `### Requested-only actions`: deny unless requested |
| Never | `autoMode.hard_deny` | `### Never allowed`: deny outcome rules |

The configs port each entry below by hand, with the same labels. Change this file first, then both configs.

## Environment

- **Organizations:** Lightdash (@lightdash) for work, Supermodel Labs (@supermodellabs) for open-source tools, and @gwenwindflower for personal work.
- **Trusted repositories:** the session's repository and its configured remotes, plus repositories owned by those three accounts. Other repositories are untrusted, regardless of visibility.
- **Trusted destinations:** GitHub repositories, issues, and PRs under those accounts; the Lightdash Linear and Notion workspaces; Lightdash Cloud (`app.lightdash.cloud`, `analytics.lightdash.cloud`, `api.lightdash.com`); the girlOS Obsidian vault; Apple Reminders; and local services on this machine (herdr, agentsview, the Obsidian CLI socket, local dev servers).
- **Cloud and sandboxes:** GCP for work. Cloudflare, Fly.io, and Railway for personal projects. exe.dev, Fly.io Sprites, and microsandbox (`msb`) for agent sandboxes.
- **Secrets:** 1Password holds them. The user's terminal commits are SSH-signed through it. Agent sessions get a hook-provided, unsigned session identity, so agents never pass `-S`/`--gpg-sign` and never edit signing config.
- **Branches:** `main` is the default and protected branch unless the repo says otherwise. Work lands through feature branches and pull requests; push directly to `main` only when the user asked for it or the repo documents a trunk workflow. History is linear: rebase, never merge commits. `--force-with-lease` on the session's own feature branch is the only force push.
- **Environment names:** `prod` (or `production`) is production, `staging` is a long-lived shared environment, and `dev` is development. Each matches as a whole word or a `-`/`_`/`.`-delimited segment: `prod-db` matches, `producer` does not. Production targets and IaC scopes covering IAM, RBAC, networking, quota, and node pools are sensitive; `staging` warrants care, not a block. Short-lived per-PR and CI-gated environments are the norm.
- **Sandbox model:** routine work runs inside the harness sandbox without review. Actions reach review when they leave the sandbox or change shared state. Retrying outside the sandbox is expected for nested sandboxes, keychain or IPC access, SSH, and GPU work. A retry whose purpose is to get past a sandbox block on a credential store or a trust surface is not routine.
- **Dotfiles:** the chezmoi source tree is `~/.local/share/chezmoi`. It deploys to `~` only through a `chezmoi apply` the user asked for.
- **Personal CLIs:** `herdr`, `wt`, `chezmoi`, `linear-cli`, `agent-browser`, `agentsview`, `notesmd-cli`, `rem`, `qmd`, `zg`, `rclone`, `mise`, `uv`, `deno`, `mint`, `lightdash`, plus the modern replacements `rip`, `fd`, `rg`, `bat`, `lsd`, and `sd`.

## Routine

Approve these when they serve the task; no separate request is needed.

- **Git remotes and history:** `fetch`, `pull --ff-only`, `clone`, and `ls-remote` for the task's repositories. A normal (non-force) push to a verified non-protected branch of the session's repository, after resolving the real destination from refspecs and push config. Rebasing the session's own feature branch onto `main` or `origin/main` after recording a recovery ref, plus `--continue` after resolving understood conflicts and `--abort`.
- **Worktrees:** Worktrunk (`wt switch`, `shift`, `copy`, `list`, `merge`, `remove`, `step`) and direct `git worktree add`/`remove` for the task's repository, with hooks, approvals, and clean-worktree checks intact.
- **GitHub work in task scope:** creating, editing, and commenting on PRs and issues. Closing issues the task resolved. `gh api` calls equivalent to those. Re-running or cancelling workflow runs. Installing or upgrading `gh` extensions. Read before write.
- **Project tasks and host retries:**
  - Task-runner invocations (`mise run`, `deno task`, `make`, `npm`/`aube run`) whose task definition was inspected and is not release-shaped.
  - Retrying a routine command outside the sandbox: after a nested-sandbox failure (`sandbox_apply: Operation not permitted`), for tools that need the keychain, EventKit, or Chrome, for SSH remotes, and for local GPU model work (`qmd embed`, `qmd query`).
- **Tool installs and upgrades:** configured upgrades (`brew upgrade`, `mise up`, `uv tool upgrade`, `rustup update`) and project-pinned installs (`mise install` in a project with a mise config). Installing a new global tool the user named. Pins, release-age cooldowns, and checksum or signature checks stay on.
- **Service CLIs in task scope:**
  - `linear-cli` issue and comment writes in the Lightdash workspace.
  - `lightdash` uploads, deploys, and previews to non-production projects.
  - `chezmoi add`/`re-add` of files the task changed.
  - `herdr` control of panes the session created or the user named.
  - `agent-browser` interaction with a named, non-Default profile.
  - Warehouse reads (`bq query`, `dbt run`/`build`) against non-production targets.
- **Notes, tasks, and skills:**
  - Individual `notesmd-cli` and `rem` changes the user requested: edits, moves, named deletions, status and date changes. An explicit sync authorizes its resolved change set.
  - `gh skill` install, add, update, search, and preview.
- **Local processes and reads:** stopping processes this session started (dev servers, watchers). Reading public documentation and source from unlisted hosts with GET requests. A worktree session reading the source worktree it branched off from.

## Requested only

Approve these only when the user's current request names the action or its exact effect. A task that could use the action does not authorize it.

- **History rewrite and discarded work:**
  - `git push --force-with-lease` (any form, including `--force-with-lease=<ref>:<sha>`) to the session's own feature branch, when the user asked to update that rebased branch.
  - `git reset --hard`, `git clean -f`, `git checkout -- <paths>`, `git restore` of worktree files, and `git stash drop`/`clear`. These also need a preserved backup of the affected content.
  - `git rebase --skip`, `--no-verify`, and `-c core.hooksPath=…`.
- **Protected and shared targets:**
  - A push to `main` or another protected branch.
  - `gh pr merge` and PR approvals.
  - Repository create, fork, rename, archive, or settings and visibility edits.
  - Secret and variable writes.
  - Dispatching release workflows and running release-shaped project tasks.
  - `gh api` or GraphQL calls with any of these effects, judged as the equivalent command.
- **Dotfiles deployment:** a real `chezmoi apply`, `update`, or `init`, only when the user's message asked to apply after the changes. Editing files in the source tree does not count, and neither does wanting to see a change live. A sandboxed chezmoi call failing on its state database is never grounds for a real apply; the dry run is the verification. Direct edits to deployed configs under `~` are blocked.
- **Trust and permission surfaces:**
  - Agent permission and sandbox settings.
  - Trust files and approvals: `mise trust`, `direnv allow`, build-script approvals, MCP or plugin trust.
  - Agent config changes: `ctx7 setup`/`remove`, `zg install`, `zg auth grant`, `codex`/`claude` MCP, feature, and login changes.
  - Package-runner skill installers; skills come from `gh skill`.
  - These change only on a direct request about that surface, never as a step toward another goal. Creating fish universal variables (`set -U`) is never a fix; config exports use `set -gx`.
- **macOS and app state:**
  - Preferences and services: `defaults write`/`delete`/`import`, LaunchServices handler edits, `launchctl` load, bootstrap, kickstart, and bootout, and `killall` of system processes.
  - App control: `osascript` and `obsidian eval`/`command`/`plugin`.
- **Signed-in state:** `agent-browser` with the Default profile beyond screenshot, snapshot, PDF, and close. Cookie, storage, and state export. Reading browser or app profile data under `~/Library/Application Support`.
- **1Password secrets:** `op read`, `op inject`, and `op run`, including inside `$(…)`, only when the user named the item and its destination. The secret goes straight to that destination and never into output, logs, or files.
- **Remote environments and infrastructure:**
  - Environments: creating, exec-ing into, deploying, or destroying exe.dev, Sprites, Fly.io, Cloudflare, or Railway environments.
  - Infrastructure: `terraform apply` and `kubectl apply`. Anything matching a production name.
  - Data: warehouse mutations (DDL, DML, `bq rm`/`mk`/`load`), and `rclone` `sync`, `move`, `delete`, or `purge`.
- **Batches:** vault and Reminders imports, exports, mass deletions, and broad restructures, including loops of individual commands, judged as one complete change set.

## Never

Deny these whatever the request; the user changes config to allow one.

- **Credential exposure:** printing, copying, or sending tokens and keys. That covers `gh auth token`, `gcloud auth print-*-token`, `op item get --reveal`, `op` listing, `rclone config show`, and `fly`/`wrangler` token commands. Reading a credential store to get around a failed authentication counts too.
- **Irreversible remote deletion:**
  - Deleting a repository by any route (`gh repo delete`, REST, GraphQL).
  - Deleting remote refs (`push --delete`, `push origin :ref`, `DELETE …/git/refs`) and mirror pushes.
- **Unrecoverable local deletion:** recursive `rm` in any flag order (`rip` is the recoverable path), `rip -d`, and disk-overwriting `dd`/`mkfs`.
- **Raw publication:** registry publishing in any form (`npm`, `pnpm -r`, `cargo`, `uv`, `deno`, `bun`, `twine`, `gem`, `docker push`), unpublish/yank/dist-tag, `gh release` mutations, and `gh skill publish`. Releases run only through the reviewed project release task.
- **Guardrail bypass:**
  - Signing commits with `-S`/`--gpg-sign`.
  - Worktrunk `--no-hooks`/`--yes`/force flags, and forced branch or worktree deletion.
  - Vault registration and default-vault changes.
