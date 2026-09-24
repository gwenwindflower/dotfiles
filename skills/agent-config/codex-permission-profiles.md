# Codex permission profiles

Use this reference when changing Codex sandbox access, approval behavior, execution rules, or reviewer policy. Permission profiles are beta; refresh the official docs and the source files below before editing real config.

Source references (rust-v0.156.1):

- Unsandboxed execution gate: <https://github.com/openai/codex/blob/rust-v0.156.1/codex-rs/core/src/tools/sandboxing.rs>
- Rule decisions: <https://github.com/openai/codex/blob/rust-v0.156.1/codex-rs/core/src/exec_policy.rs>
- Reviewer prompt and default policy: <https://github.com/openai/codex/tree/rust-v0.156.1/codex-rs/prompts/templates/guardian>

## Model boundary

Permission profiles use `default_permissions` and `[permissions.<name>]`. Legacy sandboxing uses `sandbox_mode` and `[sandbox_workspace_write]`. If any loaded layer sets `sandbox_mode`, or the user passes `--sandbox`, Codex uses legacy sandboxing instead of `default_permissions`.

Approvals decide when an action needs review. The profile decides what sandboxed commands can read, write, and reach. Execution rules decide whether a command runs sandboxed, runs on the host, goes to review, or is blocked.

## Deny entries disable host execution

A profile with any filesystem `deny` entry, including `":root" = "deny"`, never runs a command outside the sandbox. `unsandboxed_execution_allowed()` returns false whenever the profile has a denied read, so:

- `prefix_rule` `allow` rules run sandboxed instead of on the host.
- Escalations (`sandbox_permissions = "require_escalated"`) fall back to a sandboxed attempt.
- Nothing that needs the host works: SSH agent sockets, EventKit, Chrome, nested Seatbelt, or writes outside the grants.

Pick one per profile:

| Choice | Profile shape | Credential protection |
| --- | --- | --- |
| Host commands work | `":root" = "read"`, no `deny` entries, purpose-listed writes | Reviewer policy and guidance; credential stores are readable to sandboxed commands |
| Full containment | `deny` entries for credential stores and secret globs | Enforced by the sandbox; every host need must be granted inside it or given up |

The dotfiles profile `dev` takes the first choice.

## Filesystem rules

Values are `read`, `write`, and `deny` (`none` is an alias for `deny`). More specific paths override broader ones, so a `read` entry inside a `write` grant makes that subtree read-only; for identical paths, `deny` beats `write`, and `write` beats `read`. Glob keys work only with `deny`; a glob with `read` or `write` is ignored.

| Path | Meaning |
| --- | --- |
| `:root` | Filesystem root |
| `:minimal` | Platform and runtime paths common tools need; on macOS it also makes `/tmp`, `/private/tmp`, and `/var/tmp` writable |
| `:workspace_roots` | Session roots plus profile-defined roots (alias `:project_roots`) |
| `:tmpdir` | `$TMPDIR` when available |
| `:slash_tmp` | `/tmp` when available |
| `~/path` | Home-relative path |
| `/absolute/path` | Absolute path |

The built-in `:workspace` profile keeps `.git`, `.agents`, and `.codex` read-only inside each workspace root. Linked worktrees also keep their Git common dir in the main checkout, outside the roots. Git metadata writes therefore run on the host through execution rules.

Keep directories that host `PATH` lookups resolve into (mise shims and installs, uv tools and pythons, `~/.deno/bin`, Mason, bun globals) and trust files (mise `trusted-configs`) read-only. A sandboxed write there turns into code the next host command runs.

## Network rules

Set `features.network_proxy = true` to enforce profile domain rules. `network.enabled = true` permits networking but does not start the proxy; without the proxy, the domain table does not restrict egress. With it, unlisted hosts go to the reviewer. Unix-socket entries must be absolute paths: the proxy refuses to start on a `~/...` entry and every sandboxed command fails.

| Pattern | Meaning |
| --- | --- |
| `example.com` | Exact host only |
| `*.example.com` | Subdomains only |
| `**.example.com` | Apex and subdomains |
| `*` | All public destinations |

Deny rules narrow allow rules. Allowlist local literals such as `localhost` and `127.0.0.1` exactly, and set `allow_local_binding = true` only for local servers. Network profiles cover sandboxed commands only; MCP servers, connectors, browser tools, web search, and approved escalations have separate controls.

## Execution rules and review

`prefix_rule` decisions, strongest wins (`forbidden` > `prompt` > `allow`):

| Decision | Effect |
| --- | --- |
| No match | Runs sandboxed without review. A sandbox failure returns to the model, which can escalate; the escalation goes to the reviewer |
| `allow` | Runs on the host without review, only when every segment of a compound command matches an allow (and the profile has no `deny` entries) |
| `prompt` | Goes to the reviewer (`approvals_reviewer = "auto_review"`); after approval it still runs sandboxed unless the model also requested escalation |
| `forbidden` | Blocked; the justification is returned to the agent |

So a rule is needed only when the default is wrong:

- `allow` for routine host commands.
- `prompt` for reviewed commands that would otherwise succeed sandboxed or run through an `allow`.
- `forbidden` for commands the user runs or nobody runs.

Commands that cannot work sandboxed reach the reviewer through escalation without a rule. There is no per-command route to a person while auto-review is on.

Rules match literal tokens at fixed positions, with single-token unions (`["git", ["add", "commit"]]`); a union cannot hold a token sequence. Every rule can carry `match`/`not_match` examples, which are checked when the file loads.

## Auto-review policy

`[auto_review] policy` replaces the whole built-in security policy, which is the upstream `policy.md` inserted into `policy_template.md`. AGENTS.md reaches the reviewer as trusted user instructions, not as policy. The dotfiles config holds a fork: the upstream file with its `## Environment Profile` replaced and three sections appended (`Routine work`, `Requested-only actions`, `Never allowed`) ported from `docs/agent-review-policy.md`. A comment above `[auto_review]` records the release tag the fork is based on.

Refresh the fork on every Codex upgrade:

1. Read the recorded tag and the installed version (`codex --version`; tags are `rust-v<version>`).
2. Diff upstream between them: `gh api "repos/openai/codex/compare/rust-v<old>...rust-v<new>" --jq '.files[] | select(.filename | test("templates/guardian/policy")) | .patch'`. The files have moved before, so a missing result means locating them at the new tag first.
3. Fold changes to the upstream risk sections into the fork verbatim; keep our environment profile and appended sections.
4. Check `policy_template.md` for a changed `{{ tenant_policy_config }}` contract, and `config/src/config_toml.rs` for a renamed `[auto_review]` key.
5. Update the tag comment, load the config with a temp `CODEX_HOME` (`codex features list`), and commit.

## Claude mapping

| Claude setting | Codex equivalent |
| --- | --- |
| `sandbox.filesystem.allowWrite` / `denyWrite` | `write` / `read` entries in `[permissions.<name>.filesystem]` |
| `permissions.deny` for `Read(...)` | `deny` entries, which also disable host execution (see above) |
| `sandbox.network.allowedDomains` | `"domain" = "allow"` with `features.network_proxy = true` |
| `sandbox.network.allowUnixSockets` | absolute paths in `[permissions.<name>.network.unix_sockets]` |
| `sandbox.excludedCommands` + `permissions.allow` | `prefix_rule` `allow` |
| `sandbox.excludedCommands` without an allow | `prefix_rule` `prompt`, or no rule when the sandboxed attempt fails |
| `permissions.ask` | `forbidden` with a hand-off justification |
| `autoMode` prose | `[auto_review] policy` |

## Managed requirements

Use `requirements.toml` or cloud-managed requirements for organization constraints. `allowed_permission_profiles` is a complete allowlist, including built-ins added later, and a managed `guardian_policy_config` overrides `[auto_review] policy`. Every allowed custom profile must be defined in a loaded config or requirements source; names must not start with `:` or reuse reserved table names such as `filesystem`.

## Verification

In the dotfiles repo, add a probe to `.utils/agency.toml` and run `agency` from a host terminal; it performs steps 2 and 3 for every probe (`.utils/docs/agency.md`). By hand:

1. Load the config with a temp home: copy `symsources/codex/config.toml` to `$TMPDIR/<dir>/config.toml` and run `CODEX_HOME=$TMPDIR/<dir> codex features list`.
2. Probe the profile with `codex sandbox -P <profile> -- <cmd>` under the same temp home. It runs outside Claude's sandbox, because Seatbelt cannot nest. `codex sandbox` always sandboxes, so it checks grants, not rules.
3. Validate rules together: `codex execpolicy check -r <file> -r <file> <cmd…>` prints the strongest decision.
4. Start a fresh Codex session after changing loaded keys. If behavior still looks legacy, check loaded layers for `sandbox_mode` or `--sandbox`.
