# Development workflows

Routine feedback loops should run without repeated approval prompts while destructive, administrative, and externally consequential commands remain gated.

## Expected behavior

- Inspect files, processes, versions, repository state, and structured data with normal read-only tools.
- Run project-native formatters, linters, type checks, tests, builds, and development servers.
- Use the project's chosen runtime and package manager, including their normal caches and dependency stores.
- Prefer configured language servers and formatters that activate from project signals rather than globally rewriting files.
- Require review for commands that deploy, destroy infrastructure, alter system state, bypass safety checks, or publish externally.

## Safety boundary

Command families are approved by purpose, not because a binary is globally trusted. A routine subcommand may be automatic while destructive or configuration-changing subcommands remain ask or deny.

## Command intent

| Operation | Shared policy |
| --- | --- |
| Inspection and feedback | Run tools such as `rg`, `fd`, `git diff`, `cargo test`, `go test`, `uv run pytest`, and project-configured formatting within scope. A `--help` flag on an otherwise consequential command is not proof it is read-only. |
| Task runners | Review `mise run`, `make`, `deno task`, and `task` globally; project policy may authorize specific tasks after inspection. Keep native trust and script approvals intact. A task can publish or destroy data regardless of its name. |
| Dependencies and global tools | Use the designated package manager and normal stores. Upgrades of configured tools (`uv tool upgrade`, `mise up`/`upgrade`, and equivalent package-manager upgrades) are routine; preserve pins, cooldowns, and supply-chain checks. Trust changes, cache relocation, and checksum bypasses are not upgrade steps. |
| Deletion and host administration | Prefer recoverable `rip` for authorized deletion; do not use `rip -d` to purge the graveyard, `rm -rf`, `sudo rm`, disk-overwriting `dd`/`mkfs`, or recursive mode 777. |
| Publishing and infrastructure | Review the concrete release/deploy/apply target and artifact. `terraform destroy` and `kubectl delete` are blocked by existing command policy; IAM, RBAC, networking, quota, and node-pool changes are sensitive even without a production name. |

`dot_codex/rules/command-safety.rules` expresses canonical destructive and raw-publishing prohibitions plus review gates for deployment, infrastructure apply, and chezmoi apply. It grants no host build permissions. Explicitly requested releases run through reviewed project tasks with their checks and confirmations intact. Production classification and arbitrary runner contents stay in guidance/contextual review; prefix matching cannot identify every target or option position.

Environment names follow one convention: `prod` is production, `staging` is a long-lived staging environment, and `dev` is a development environment, each matched as a whole word or a hyphen, underscore, or dot-delimited segment (`prod-db` matches, `producer` does not). Projects outside the user's control may spell them `production` and `development`. Anything matching production is a sensitive target: deploys, deletes, and infrastructure changes there are denied or reviewed. Long-lived environments are the exception; per-PR and CI-gated environments are the norm, and a project that deviates says so in its own docs.

## CI/CD

GitHub Actions is the only CI/CD system. The `github-actions-workflows` skill is the authoritative source for workflow patterns and loads whenever a workflow file is being edited; other skills link to it rather than restating its rules.

- `zizmor` audits workflows for template injection, excessive permissions, `pull_request_target` misuse, cache poisoning, and unpinned actions. It runs locally from the repo root and in CI with GitHub annotations.
- `pinact` pins every `uses:` reference to a full commit SHA with a version comment, and checks or updates those pins.
- Both run in every tool repository's `ci-audit` task and in the `audit` CI job, so a workflow change is not finished until they pass.
- Release workflows and publication require explicit task authority. Agents may run the trusted project release task when requested; raw package/release publishing commands are blocked to preserve the pipeline's checks.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Explicit Bash allow/ask/deny rules and language-service plugins | Broadest command inventory; the sandbox supplies filesystem and network containment. |
| Codex | Sandboxed execution, automatic approval review, scoped `.rules`, skills, and plugins | Narrow destructive/publishing gates supplement contextual review; routine builds retain sandbox containment. |
| OpenCode | Bash pattern rules plus configured LSP and formatters | Closely covers the routine command families; arbitrary commands ask by default. |

## Verification

- A repository's standard format, lint, typecheck, test, and build commands run through a short feedback loop.
- A formatter without the relevant project configuration does not rewrite the project opportunistically.
- Destructive infrastructure, broad permission changes, and unsafe deletion commands are denied or reviewed.
- Adding or changing global package-manager configuration is never an automatic recovery step.
