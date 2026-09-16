# Agent configuration intent

Claude Code, Codex, and OpenCode should provide the same practical capabilities where their harnesses permit it. Their configs are authored independently with platform-native controls; parity means equivalent observable behavior and safety boundaries, not matching settings or generated entries.

## Contract layers

Every capability distinguishes three controls:

1. **Sandbox access** — what a local process can technically reach.
2. **Approval policy** — what can happen automatically, what requires review, and what is blocked.
3. **Agent guidance** — what the agent should choose within its technical permissions.

A domain allowed by the sandbox is not automatically trusted content. A command approved by policy is not automatically the right action.

## Shared operating policy

- Routine inspection and project-native edit, test, format, and build loops proceed within the task's authority. Classify the actual operation and target, including scripts invoked by task runners; a trusted executable name is insufficient.
- Keep permission, sandbox, trust, and install-script approvals unchanged while solving unrelated problems. Change these surfaces only when the user requests that configuration work directly. Report a blocked resource and seek scoped access; do not disable a safeguard or reshape a command to avoid review.
- Separate task authorization from harness approval. Prior user authorization remains valid, but a native review gate may still run; automatic review is not necessarily a question shown to the user. A host execution exception grants technical access only for its documented purpose.
- Keep credential values out of output and artifacts. Authenticate through the owning tool or integration. Treat publishing, shared-state changes, production targets, and destructive operations according to their capability boundary, even through an otherwise allowed CLI.

The foundation owns these cross-cutting rules and harness semantics. Capability docs own command intent, targets, exceptions, and verification; native configs own executable patterns. These docs are the configuration contract, not an automatically loaded global prompt. Universal behavioral guidance is rendered from `.chezmoitemplates/agents/`; do not copy the entire command inventory into root context.

## Evidence

- Claude Code has the broadest configuration surface and is the first inventory source, not the canonical implementation.
- Behavior represented across multiple agents is the strongest evidence of shared intent.
- A capability present in one agent still belongs here when it is useful beyond that harness.
- Harness-only mechanics belong in platform notes unless they express a shared user-facing goal.
- Unknown or partial parity is recorded directly instead of hidden behind similar-looking config entries.

## Configuration surfaces

| Platform | Primary config | Supporting surfaces |
| --- | --- | --- |
| Claude Code | `symsources/claude/settings.json` | `dot_claude/exact_hooks/`, `dot_claude/exact_agents/`, `dot_claude/CLAUDE.md.tmpl` |
| Codex | `symsources/codex/config.toml` | `dot_codex/rules/`, `dot_codex/hooks.json`, `dot_codex/exact_agents/`, `dot_codex/AGENTS.md.tmpl` |
| OpenCode | `symsources/opencode/opencode.jsonc` | `private_dot_config/opencode/`, `private_dot_config/opencode/exact_agents/`, `private_dot_config/opencode/tui.jsonc` |
| Shared | `.chezmoitemplates/agents/` | `dot_agents/exact_skills/`, `dot_agents/exact_rules/` |

## Platform notes

### Harness comparison

| Control | Claude Code | Codex | OpenCode 1.x |
| --- | --- | --- | --- |
| Configuration | JSON settings at user, project, local, and managed scopes; hooks and agent definitions add controls | TOML user and trusted project layers, CLI overrides, managed constraints, hooks, and execution rules | JSONC global/project config and agent overrides; installed version is 1.18.20 |
| Command decisions | `permissions.allow`/`ask`/`deny`; deny takes precedence over ask, then allow; `autoMode` supplies classifier guidance | `prefix_rule` over argument tokens; strongest match wins: `forbidden` > `prompt` > `allow`; unmatched commands retain contextual policy | Ordered `permission.bash` patterns; last match wins, so catch-all ask precedes exceptions |
| Active approval posture | `defaultMode = auto`, sandbox auto-allow, explicit operation gates, and classifier soft-deny guidance | `approval_policy = on-request`, `approvals_reviewer = auto_review`; a review can be resolved automatically | Bash asks by default except matching allows/denies; this is not a global all-tool ask default |
| Process containment | Native Bash filesystem/network sandbox; explicit host exclusions for selected commands | Beta `workspace-winnie` profile extending `:workspace`, with scoped roots and the network proxy enabled | No process filesystem or network sandbox is supplied by this config; shell runs with host access |
| Sensitive files | `Read`/`Edit` denies protect file tools and merge into the Bash sandbox; excluded host commands lose that process boundary | Explicit profile secret denies apply within otherwise writable roots; minimal/toolchain reads are enumerated | `read`/`edit` denies protect file tools; they do not establish shell containment |
| Host exceptions | `sandbox.excludedCommands` skips containment but retains permission evaluation | An execution-rule `allow` authorizes matching host execution; it is broader than allowing a sandboxed build | Shell is already on the host; `external_directory` is a tool access gate, not an OS boundary |

Codex selects `default_permissions = "workspace-winnie"`; legacy `sandbox_mode` and `sandbox_workspace_write` are absent. A legacy setting in another loaded layer or a `--sandbox` flag overrides profile selection, so check the session's effective permissions. Fresh sessions load config changes. `features.network_proxy = true` is required to enforce the domain rules; `network.enabled = true` alone does not constrain direct egress. Unix-socket entries use absolute paths. [Codex permission profiles](https://developers.openai.com/codex/permissions).

Claude's `autoAllowBashIfSandboxed = true` substitutes containment for a whole-tool Bash ask; operation-specific asks and denies still apply. Its classifier prose and hooks are separate controls from static rules. Read/Edit denies merge into its filesystem sandbox, and WebFetch domain rules combine with sandbox network lists. OpenCode's last-match behavior makes ordering significant, unlike Claude's decision precedence. Sources: [Claude permissions](https://code.claude.com/docs/en/permissions), [Claude sandbox](https://code.claude.com/docs/en/sandboxing), [OpenCode 1.x permissions](https://opencode.ai/docs/permissions/).

### Pattern boundaries

Codex rules are executable Starlark policy, not Markdown instructions. They match literal argument prefixes and unions at fixed positions, not arbitrary globbed suffixes. An `allow` can run outside the sandbox, so do not port Claude's routine build or interpreter allows into Codex rules. `prompt` routes to the configured reviewer; `forbidden` blocks the matching request. Restart after deployment. Sources: [Codex rules](https://developers.openai.com/codex/rules), [Codex permissions](https://developers.openai.com/codex/permissions).

`dot_codex/rules/` stays non-exact because Codex can write user approvals into `~/.codex/rules/default.rules`. Validate all maintained files together with `codex execpolicy check`, including inline `match`/`not_match` cases. Priority policies live in `command-safety.rules`, `git.rules`, `notes.rules`, and `reminders.rules`.

Prefix rules cannot enforce target-dependent policy or recognize flags at every position. For example, `git push --force` and `git push origin --force` differ, and `git -C path push` does not match a `git push` prefix. Canonical forms receive explicit gates; unmatched wrappers, absolute paths, global options, scripts, and API payloads still require contextual review. Never treat a non-match as authorization or claim these files are a complete command firewall.

### Claude Code permission patterns

A trailing ` *` in a `Bash(...)` rule matches either more characters or the end of the command after the last non-whitespace character, so one stem rule covers both the bare command and every argument form. `Bash(notesmd-cli create * -o *)` already matches `notesmd-cli create "Note" -o`; a second `Bash(notesmd-cli create * -o)` rule is redundant. Rules without a trailing wildcard (`Bash(pwd)`, `Bash(git remote -v)`) match only that exact command. A wildcard glued to a token (`--dry-run*`) matches that token with any suffix, which is how flags that take `=value` are covered.

## Capabilities

| Domain | Goal |
| --- | --- |
| [Workspace access](capabilities/workspace.md) | Work freely in the active project while protecting credentials and unrelated user state. |
| [Network access](capabilities/network.md) | Reach routine service and documentation endpoints without treating hosted content as inherently trusted. |
| [Development workflows](capabilities/development.md) | Run normal inspection, formatting, validation, test, and build loops with minimal friction. |
| [Git and worktrees](capabilities/git.md) | Inspect and change repositories safely, with clear ownership for commits, remotes, and parallel work. |
| [Delegation](capabilities/delegation.md) | Use specialized helpers without losing scope, context, or ownership boundaries. |
| [Context and extensions](capabilities/context.md) | Discover shared guidance and reusable capabilities through each platform's native mechanisms. |
| [Remote environments](capabilities/environments.md) | Run in disposable exe.dev, Sprite, or microsandbox environments that carry the same dotfiles and guidance as the workstation. |
| [Obsidian notes](capabilities/notes.md) | Read and capture in girlOS from any project; perform targeted task and note edits when explicitly requested. |
| [Tasks and Reminders](capabilities/tasks.md) | Give every macOS harness access to Obsidian Tasks and Apple Reminders for reliable reconciliation, organization, and scheduling. |
| [Local search](capabilities/search.md) | Route discovery to the indexed search tool for each corpus (code and mixed workspaces, markdown knowledge bases, agent session history) with index upkeep kept routine and local. |
| [Integrations](capabilities/integrations.md) | Use browsers, services, and artifact tools without embedding credentials or broad implicit authority. |
| [Session runtime](capabilities/session.md) | Give subprocesses stable environment, lifecycle, and state-reporting behavior. |
| [Interaction](capabilities/interaction.md) | Preserve a consistent terminal interaction model across different agent interfaces. |

## Changing agent configuration

- Start from the capability and expected behavior, then inspect every applicable platform.
- Separate sandbox access, approval posture, and guidance before choosing settings.
- Prefer each harness's native mechanism; do not add translation machinery solely to make configs resemble one another.
- Record deliberate differences and missing enforcement in the relevant capability file.
- Verify both the useful path and its safety boundary with a realistic task.
- Update these docs only when intended behavior changes; mechanical config edits do not need documentation churn.

## Policy placement

| Owner | Shared decision |
| --- | --- |
| [Workspace](capabilities/workspace.md) and [network](capabilities/network.md) | Use the beta Codex profile with tested filesystem and proxy boundaries. Keep OpenCode's lack of an OS sandbox explicit. |
| [Workspace](capabilities/workspace.md) | Dotfiles deploy only through the user. Dry runs use the flags-first `chezmoi --dry-run --no-pager <cmd>` form and are routine; `chezmoi apply`, `update`, `init`, `state`, `manage`, and `unmanage` are ask-level everywhere, and automatic review approves an apply only on an explicit user request made after the changes. |
| [Development](capabilities/development.md) and [context](capabilities/context.md) | `gh skill` owns external skills; routine install/update/search is allowed, destructive replacement is reviewed. Configured package-manager upgrades are routine. Task runners need global review with specific project authority. |
| [Git](capabilities/git.md) and [integrations](capabilities/integrations.md) | Ordinary pushes and guarded merges include trunk workflows on main. Block forced cleanup and remote ref deletion. Publish only through reviewed project release tasks on explicit request; confidential project material follows repo-local policy. |
| [Notes](capabilities/notes.md) and [tasks](capabilities/tasks.md) | Individual requested changes are routine across projects. Review batches as a change set. Vault administration is manual-only. |
| [Local search](capabilities/search.md) and [development](capabilities/development.md) | Querying and refreshing local indexes is routine; dropping an index or granting remote embedding is reviewed. Model downloads happen outside the sandbox. |
| [Context](capabilities/context.md) and [session](capabilities/session.md) | OpenCode uses native global/project AGENTS.md discovery. Preserve deliberate environment filtering and helper ownership. |

A project allow cannot override a matching global ask in Claude or a global prompt in Codex: their strongest matching decision wins. OpenCode's later project rules can specialize global asks. Claude/Codex therefore use contextual review and shared guidance for task runners, with no blanket runner allow or hard global runner ask; trusted project policy can authorize specific tasks. This is a behavioral boundary, not a guaranteed per-invocation prompt. Native runner trust, task authorization, and harness policy remain distinct controls.

## Verification and coverage

The beta profile passes host-launched `codex sandbox` checks with the configured default: workspace writes succeed, synthetic `.env` reads/writes are denied, Git/Rust/Go/Deno/uv run, and normal Zsh/Fish startup works. With the proxy enabled, the npm registry responds and an unlisted host receives CONNECT 403. Toolchain access includes Apple's Command Line Tools and Go's normal telemetry state. Writable skill metadata targets the real chezmoi manifest, not its unsupported symlink root.

These are local CLI smoke checks, not evidence of a fresh app session or live Obsidian IPC. Codex's rule suite checks canonical operations and non-matches; all maintained files are evaluated together. `tombi` still reports the two already-documented upstream schema errors for integer agent limits; Codex loads the config successfully.

The shared Git contract is rendered from `.chezmoitemplates/agents/rules/git.md`. Claude's classifier guidance, native command rules, and capability docs distinguish routine changes from forced cleanup, vault administration, batches, and raw publication. CLI pattern checks establish matching behavior; fresh-session classifier decisions and app integration still need live observation.
