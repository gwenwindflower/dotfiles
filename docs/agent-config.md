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
- Separate task authorization from harness approval. Prior user authorization remains valid, but a native review gate may still run; automatic review is not necessarily a question shown to the user.
- Keep credential values out of output and artifacts. Authenticate through the owning tool or integration. Treat publishing, shared-state changes, production targets, and destructive operations according to their capability boundary, even through an otherwise allowed CLI.

The foundation owns these cross-cutting rules, the permission levels, and harness semantics. Capability docs assign command families to levels and own targets, exceptions, and verification. [The review policy](agent-review-policy.md) owns the prose both automatic reviewers apply. Native configs own executable patterns. Universal behavioral guidance is rendered from `.chezmoitemplates/agents/`; do not copy the command inventory into root context.

## Permission levels

Every command family sits at one level. The level decides where the command runs and who decides. It is expressed natively in each harness:

| Level | Runs | Decided by | Claude Code | Codex |
| --- | --- | --- | --- | --- |
| `sandboxed` | In the sandbox | Nobody; the sandbox bounds it | Sandbox auto-allow; no rule | No rule; `[permissions.dev]` grants cover it |
| `open` | Outside the sandbox | Nobody; a narrow carve-out | `sandbox.excludedCommands` + `permissions.allow` | `prefix_rule` `allow` |
| `review-open` | Outside, after review | Reviewer: approve in task scope, always when requested | `excludedCommands` with no allow → classifier; `autoMode.allow` | `prefix_rule` `prompt`, or an escalation → auto-review |
| `review-request-open` | Outside, after review | Reviewer: approve only when the current request names it | Same trigger; `autoMode.soft_deny` | Same trigger; a requested-only outcome rule |
| `user-open` | Outside, by the user | The user approves, or runs it | Content-scoped `permissions.ask` | `forbidden`, with a justification that hands the exact command to the user |
| `deny` | Never | Config; the user overrides it temporarily | `permissions.deny` + `autoMode.hard_deny` | `forbidden` + a never-allowed outcome rule |

These principles keep the configs small:

- **The sandbox is the allow.**
  - Sandboxed commands need grants, not rules. A Claude `Bash(...)` allow exists only to pair with an exclusion, because allows also approve unsandboxed retries.
  - Codex allows run unsandboxed and unreviewed, and only when every segment of a compound command matches.
- **Review needs a trigger.**
  - A reviewer sees only what leaves the sandbox: Claude excluded commands and sandbox-disabled retries, and Codex `prompt` rules and escalations.
  - Reviewer prose cannot gate a command that runs sandboxed. A `review-*` family is routed out on purpose, even when it would run fine inside.
  - Claude exclusions do not apply inside pipelines or `&&` chains, so host commands run bare, with output redirected to `$TMPDIR` rather than piped.
- **Grants are by purpose.** Workspace, caches, and tool state are listed once in [workspace access](capabilities/workspace.md); both sandboxes express that list. The directory list itself is kept tight:
  - No sandbox writes a directory a host `PATH` lookup resolves into (mise shims and installs, `~/.deno/bin`, `~/.bun/bin`, uv tools and pythons, `.rustup`, Mason).
  - No sandbox writes a trust surface (mise trust files, symlinked tool configs whose settings run code).
- **Credentials stay out of reach where the harness allows it.**
  - Claude read-denies credential stores in its sandbox.
  - Codex cannot: any profile `deny` entry keeps every command sandboxed, which would break the `open` and escalation paths. Its credential stores are readable to sandboxed commands and governed by the reviewer policy.
  - In both harnesses, logins and token changes are `user-open`, and credential dumps are `deny`.

## Configuration surfaces

| Platform | Primary config | Supporting surfaces |
| --- | --- | --- |
| Claude Code | `symsources/claude/settings.json` | `dot_claude/exact_hooks/`, `dot_claude/exact_agents/`, `dot_claude/CLAUDE.md.tmpl` |
| Codex | `symsources/codex/config.toml` | `dot_codex/rules/`, `dot_codex/hooks.json`, `dot_codex/exact_agents/`, `dot_codex/AGENTS.md.tmpl` |
| OpenCode | `symsources/opencode/opencode.jsonc` | `private_dot_config/opencode/`, `private_dot_config/opencode/exact_agents/`, `private_dot_config/opencode/tui.jsonc` |
| Shared | `.chezmoitemplates/agents/`, `docs/agent-review-policy.md` | `skills/` (installed by `gh skill`, not deployed by chezmoi), `dot_agents/exact_rules/` |

## Platform notes

### Harness comparison

| Control | Claude Code | Codex | OpenCode 1.x |
| --- | --- | --- | --- |
| Configuration | JSON settings at user, project, local, and managed scopes; hooks and agent definitions add controls | TOML user and trusted project layers, CLI overrides, managed constraints, hooks, and execution rules | JSONC global/project config and agent overrides |
| Command decisions | `permissions.allow`/`ask`/`deny`; deny takes precedence over ask, then allow | `prefix_rule` over argument tokens; strongest match wins: `forbidden` > `prompt` > `allow`; unmatched commands run sandboxed without review | Ordered `permission.bash` patterns; last match wins, so catch-all ask precedes exceptions |
| Automatic review | `defaultMode = auto`; the classifier reads `autoMode` prose and CLAUDE.md. A content-scoped `ask` still prompts the user | `approval_policy = on-request`, `approvals_reviewer = auto_review`; the reviewer reads `[auto_review] policy` and treats AGENTS.md as user authorization. No per-command route to a person | No automatic reviewer |
| Process containment | Native Bash filesystem/network sandbox; `excludedCommands` run on the host | Permission profile `dev` (`default_permissions = "dev"`): read everywhere, scoped writes, domain-listed network through `network_proxy`, listed Unix sockets | No process sandbox from this config; shell runs with host access |
| Sensitive files | `Read`/`Edit` denies cover file tools and merge into the Bash sandbox; excluded commands lose the process boundary | No read denies (a `deny` entry disables host execution); reviewer policy governs credential reads. `.git`, `.agents`, and `.codex` inside workspace roots stay read-only | `read`/`edit` denies protect file tools only |
| Host exceptions | Excluded commands keep permission evaluation | An `allow` rule runs outside the sandbox with no review | Shell is already on the host |

Claude's `autoAllowBashIfSandboxed = true` substitutes containment for a whole-tool Bash ask; operation-specific asks and denies still apply. Read/Edit denies merge into its filesystem sandbox, and WebFetch domain rules combine with sandbox network lists. A `dangerouslyDisableSandbox` retry goes to the classifier in auto mode unless an allow rule matches it first. OpenCode's last-match behavior makes ordering significant, unlike Claude's decision precedence. Sources: [Claude permissions](https://code.claude.com/docs/en/permissions), [Claude sandbox](https://code.claude.com/docs/en/sandboxing), [OpenCode permissions](https://opencode.ai/docs/permissions/).

Codex runs the permission-profile system from the single `symsources/codex/config.toml`. The profile extends the built-in `:workspace` profile: `":root" = "read"`, `:tmpdir` and `:slash_tmp` writable, purpose-listed writes, and `read` entries that keep PATH and trust directories read-only inside those writes. The profile has no `deny` entries: Codex refuses to run anything outside the sandbox while one exists, including `allow` rules and escalations. Codex writes project trust, plugin, and hook state into the same file, so hand edits preserve those tables. When the profile blocks priority work, `sandbox_mode = "workspace-write"` in place of `default_permissions` is Codex's built-in fallback; start a fresh session after any change. [Codex configuration reference](https://developers.openai.com/codex/config-reference).

### Codex execution rules

Codex rules are executable Starlark policy, not Markdown instructions. They match literal argument prefixes and unions at fixed positions, not globbed suffixes. `allow` runs outside the sandbox without review, so it is reserved for the `open` level; `prompt` routes to the auto-reviewer; `forbidden` blocks and returns its justification to the agent. Sources: [Codex rules](https://developers.openai.com/codex/rules), [Codex permissions](https://developers.openai.com/codex/permissions).

`dot_codex/rules/` stays non-exact because Codex writes user approvals into `~/.codex/rules/default.rules`. The files split by capability:

- `command-safety.rules`: deletion, publishing, credentials, infrastructure, and host administration.
- `git.rules`: git, gh, and Worktrunk.
- `services.rules`: personal and service CLIs.
- `notes.rules`: the notes vault.
- `reminders.rules`: Reminders.

Validate them together with `codex execpolicy check`, including every inline `match`/`not_match` case.

Prefix rules cannot enforce target-dependent policy or recognize flags at every position. `git push origin --force` differs from `git push --force`, `git -C path push` does not match a `git push` prefix, and a script with `$(…)` substitution is one opaque command. Canonical forms get explicit rules. Commands that fail in the sandbox, such as every SSH `git push`, reach the reviewer through escalation, and its prose covers what prefixes cannot. Never treat a non-match as authorization.

### Automatic reviewer policy

[The review policy](agent-review-policy.md) is the single source for both reviewers. Each config ports it section for section.

- **Claude:** `autoMode.environment`, `allow`, `soft_deny`, and `hard_deny` take one entry per policy bullet, in the form `Label: text`.
  - `"$defaults"` in `allow`, `soft_deny`, and `hard_deny` keeps Anthropic's built-in rules; `environment` replaces them.
  - The built-in allow treats a normal push to any branch of the session's repository as ordinary, and allow entries override `soft_deny`. So "push to `main` only on request" is guidance in Claude and a reviewer rule in Codex; repository rulesets are the hard guard.
  - `autoMode` is read only from user, managed, or `--settings` scope.
- **Codex:** `[auto_review] policy` replaces the whole built-in security policy, so the config holds a fork of upstream [`policy.md`](https://github.com/openai/codex/blob/main/codex-rs/prompts/templates/guardian/policy.md).
  - Its `## Environment Profile` is replaced with ours.
  - The upstream risk sections are kept verbatim.
  - Our routine, requested-only, and never-allowed sections are appended as outcome rules.
  - A comment above the table records the Codex release tag the fork is based on.

Refresh the Codex fork on every Codex upgrade; the `agent-config` skill has the procedure.

### Claude Code permission patterns

<!-- markdownlint-disable MD038 -->
A trailing ` *` in a `Bash(...)` rule matches either more characters or the end of the command after the last non-whitespace character, so one stem rule covers both the bare command and every argument form. `Bash(notesmd-cli create * -o *)` already matches `notesmd-cli create "Note" -o`; a second `Bash(notesmd-cli create * -o)` rule is redundant. Rules without a trailing wildcard (`Bash(pwd)`, `Bash(git remote -v)`) match only that exact command. A wildcard glued to a token (`--dry-run*`) matches that token with any suffix, which is how flags that take `=value` are covered.
<!-- markdownlint-enable MD038 -->

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
| [Local search](capabilities/search.md) | Route discovery to the indexed search tool for each corpus with index upkeep kept routine and local. |
| [Integrations](capabilities/integrations.md) | Use browsers, services, and artifact tools without embedding credentials or broad implicit authority. |
| [Session runtime](capabilities/session.md) | Give subprocesses stable environment, lifecycle, and state-reporting behavior. |
| [Interaction](capabilities/interaction.md) | Preserve a consistent terminal interaction model across different agent interfaces. |

## Changing agent configuration

Every permission change follows one loop. The `agent-config` skill carries the harness mechanics for steps 4 and 5.

1. **Find the need:** a blocked path, host, or socket, a command at the wrong level, or reviewer prose that misfires. Session history (`agentsview`) shows real friction.
2. **Update the contract:**
   - Assign the family a level in its capability doc.
   - Add paths or hosts to the tables in [workspace access](capabilities/workspace.md) or [network access](capabilities/network.md).
   - Reviewer behavior changes go in [the review policy](agent-review-policy.md).
3. **Add a probe** to `.utils/agency.toml`: a `[[sandbox]]` probe for a grant or block, a `[[rule]]` case for a Codex decision. Cover the safety boundary as well as the useful path.
4. **Express it in each harness's native config:** `symsources/claude/settings.json`, `symsources/codex/config.toml`, and `dot_codex/rules/*.rules`. Don't add translation machinery just to make the configs resemble one another. Record deliberate differences and missing enforcement in the capability doc.
5. **Run `agency`** from a host terminal. It must pass, including the sandbox probes. Agents ask the user to run it, since it cannot run inside an agent's sandbox. See [agency](../.utils/docs/agency.md).
6. **Commit;** the user applies: `chezmoi apply` for `dot_codex/rules`, and a fresh session in each harness for everything. Claude classifier decisions and exclusion behavior are confirmed in that fresh session, since `agency` cannot probe them.

## Verification and coverage

- **`agency`:** covers Codex profile reads, writes, sockets, network, keychain access, and rule decisions.
- **Claude:** `jq` and the schemastore schema check settings shape. Classifier decisions, exclusion matching, and ask rules need a live session.
- **Schemas:** `tombi` reports two known upstream schema errors for integer agent limits.
- **Not covered by any check:** live reviewer decisions in either harness, and app IPC (Obsidian, EventKit, Chrome).
