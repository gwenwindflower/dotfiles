# agency

`agency` probes the agent permission configs in this repo and reports through the utils test runner. Each probe is one test, declared in `.utils/agency.toml`:

| Table | Checks | Passes when |
| --- | --- | --- |
| `[[sandbox]]` | Runs `cmd` with bash under `codex sandbox -P <profile>`, using the repo's `symsources/codex/config.toml` and the profile its `default_permissions` names | Exit 0 for `expect = "ok"`, nonzero for `expect = "deny"` |
| `[[rule]]` | The strongest `codex execpolicy check` decision for `cmd` across `dot_codex/rules/*.rules` | The decision equals `expect`: `allow`, `prompt`, `forbidden`, or `none` |

Claude Code has no offline equivalent of either check: its classifier and sandbox exclusions are observed in a live session.

## Running

```text
agency              # fish function: every probe, from the checkout you're in
agency -v           # full deno test output per probe
deno task test agency       # from .utils, through the shared runner
deno task test agency-rules # only rule checks
deno task test:agency-unit  # pure helpers, with no runtime permissions
deno task test:agency-sandbox-network # one probe group directly
```

The fish function probes the dotfiles checkout containing the current directory, so a worktree tests its own configs, and falls back to the chezmoi source. It sets `AGENCY_REQUIRE_HOST=1`.

The runner reports nine agency suites: unit tests, rule checks split by decision (`allow`, `none`, `prompt`, `forbidden`), and sandbox probes split by group (`reads`, `writes`, `network`, `integrations`). Rule and unit suites do not start a sandbox or create a temporary `CODEX_HOME`.

Sandbox probes need the host, because Seatbelt cannot nest inside another sandbox. Inside an agent's shell they are skipped with a warning, and `deno task test` stays green there. With `AGENCY_REQUIRE_HOST=1` they fail instead, so a green `agency` run always includes them. Rule cases run anywhere.

## Adding a probe

Add one table per behavior, named for the outcome rather than the command:

```toml
[[sandbox]]
name = "lightdash config is writable"
group = "writes"
expect = "ok"
cmd = "touch $HOME/.config/lightdash/.agency && rm $HOME/.config/lightdash/.agency"

[[rule]]
cmd = "gh secret set TOKEN"
expect = "prompt"
```

Write probes remove what they create, so a probe that wrongly succeeds leaves nothing behind. Rule commands are split like a shell would split plain words and quoted strings; they are never executed.

Every sandbox probe needs a `group`: `reads`, `writes`, `network`, or `integrations` (sockets, keychain, and connected tools). Rule suites select probes by `expect`.

## Code

- `agency.ts`: probe parsing and validation, command tokenizing, `codex` argument builders, and decision parsing, exported for tests.
- `agency_test.ts`: unit tests for those helpers.
- `agency_rules_test.ts`: one test per rule probe.
- `agency_sandbox_test.ts`: one test per sandbox probe, using a temporary `CODEX_HOME` holding the repo's config.
- `agency_test_support.ts`: shared Codex subprocess execution.
- `agency.toml`: the probes.
