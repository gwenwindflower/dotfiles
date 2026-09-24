# Development workflows

Routine feedback loops run in the sandbox without review, while installs, host administration, publishing, and infrastructure changes reach a reviewer or the user.

## Expected behavior

- Inspect files, processes, versions, repository state, and structured data with normal read-only tools.
- Run project-native formatters, linters, type checks, tests, builds, and development servers.
- Use the project's chosen runtime and package manager, including their normal caches and dependency stores.
- Prefer configured language servers and formatters that activate from project signals rather than globally rewriting files.
- Send commands that deploy, destroy infrastructure, alter system state, bypass safety checks, or publish externally to review or the user.

## Safety boundary

Command families are placed by purpose, not because a binary is globally trusted. A task can publish or destroy data regardless of its name, so a task runner's actual script decides its level. Trust changes, cache relocation, and checksum bypasses are never upgrade steps. Production and sensitive infrastructure scopes follow the environment names in [the review policy](../agent-review-policy.md#environment). Deletion levels live in [workspace access](workspace.md#levels).

## Levels

| Family | Level | Notes |
| --- | --- | --- |
| Inspection, format, lint, typecheck, test, and build loops | `sandboxed` | Caches and package stores are granted in [workspace access](workspace.md#paths-by-purpose). |
| Project dependency installs | `sandboxed` | Lifecycle scripts stay sandboxed. |
| Task runners (`mise run`, `deno task`, `make`, `npm`/`aube run`) | `sandboxed` | An unsandboxed retry is `review-open` after the task definition is inspected; release-shaped tasks are `review-request-open`. |
| Configured upgrades (`brew update`/`upgrade`, `mise up`, `uv tool upgrade`, `uv python upgrade`, `rustup update`, `deno upgrade`, `cargo install-update`) and project `mise install` | `open` | They write `PATH` directories, which no sandbox may. Pins, cooldowns, and checksum checks stay on. |
| New global installs and uninstalls (`brew install`, `uv tool install`, `cargo install`, `mise use -g`) | `review-open` | They fail in the sandbox for the same reason and reach review. A tool the user named is routine. |
| Process inspection (`ps`, `pgrep`) | `open` | Codex also runs `lsof` and read-only `docker` subcommands on the host. |
| Raw registry publishing, unpublish, yank, dist-tag, `docker push` | `deny` | Releases run through the reviewed project release task. |
| Project release task | `review-request-open` | |
| Deploys and infrastructure apply (`wrangler`/`fly`/`railway deploy`, `terraform apply`, `kubectl apply`) | `review-request-open` | Claude also denies `kubectl apply` to a `prod` namespace. |
| `terraform destroy`, `kubectl delete` | `deny` | |
| macOS host administration (`defaults write`/`delete`/`import`, `launchctl`, `killall`, `osascript`) | `review-request-open` | |
| `sudo` | `user-open` | |

## CI/CD

GitHub Actions is the only CI/CD system. The `github-actions-workflows` skill is the authoritative source for workflow patterns and loads whenever a workflow file is being edited; other skills link to it rather than restating its rules.

- `zizmor` audits workflows for template injection, excessive permissions, `pull_request_target` misuse, cache poisoning, and unpinned actions. It runs locally from the repo root and in CI with GitHub annotations.
- `pinact` pins every `uses:` reference to a full commit SHA with a version comment, and checks or updates those pins.
- Both run in every tool repository's `ci-audit` task and in the `audit` CI job, so a workflow change is not finished until they pass.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Sandbox grants; exclusions with allows for upgrades and process inspection; exclusions without allows for host administration; language-service plugins | Deploys and infrastructure calls fail on unlisted hosts and reach the classifier through the retry. |
| Codex | Profile grants; `command-safety.rules` allows upgrades and process inspection, prompts on deploys, infrastructure apply, and macOS preferences, and forbids deletion, publishing, and `sudo` | Families that fail in the sandbox, such as global installs, reach the reviewer through an escalation with no rule. |
| OpenCode | Bash pattern rules plus configured LSP and formatters | Closely covers the routine command families; arbitrary commands ask by default. |

## Verification

- A repository's standard format, lint, typecheck, test, and build commands run through a short feedback loop without review.
- A formatter without the relevant project configuration does not rewrite the project opportunistically.
- `mise up` runs on the host without review; `uv tool install <tool>` reaches review.
- Destructive infrastructure, raw publishing, and unsafe deletion commands are denied in both harnesses.
- Adding or changing global package-manager configuration is never an automatic recovery step.
