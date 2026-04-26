---
name: fish-shell
description: Idiomatic fish shell scripting and config: functions, completions, abbreviations, conf.d, argparse. Use when editing .fish files or anything under ~/.config/fish.
---

Fish is not bash. Different syntax (`test` over `[[ ]]`, `(cmd)` over `$(cmd)`), `string`/`math` builtins, scopes via `set -l/-g/-gx/-U`, and no `&&`/`||` — use `; and`/`; or` or chained commands.

## Repo layout

- Config root: `~/.config/fish/` (chezmoi source: `private_dot_config/fish/`)
- `functions/<name>.fish` — autoloaded on first use; filename must match function name
- `conf.d/*.fish` — sourced at startup; abbreviations, keybindings, env tweaks
- `completions/<cmd>.fish` — completion definitions
- `config.fish` — assembled from `.chezmoitemplates/fish/*.fish` fragments at chezmoi apply time. See [chezmoi skill](../chezmoi/SKILL.md) for the assembly model.

## Testing in this environment

You're in bash. Run fish via subshell: `fish -c "<commands>"`. New `.fish` files are picked up automatically by each new subshell after `chezmoi apply` — no reload needed. Shell side effects can be destructive, so prefer asking the user to test interactive features rather than self-validating.

## Jobs to be done

- [Write functions](writing-functions.md) — structure, argparse, help text, exit codes, common patterns, worked examples
- [Error handling patterns](error-handling-best-practices.md) — deeper error/recovery patterns
- [Custom logging with `logirl`](logirl-custom-logging-framework.md) — preferred for all structured messages
- [Interactive prompts with `gum`](charm-gum-shell-script-helper-cli.md) — confirms, inputs, choosers

## Fish vs bash quick reference

| Bash | Fish |
| --- | --- |
| `[[ ... ]]` | `test ...` |
| `$(command)` | `(command)` |
| `VAR=value` | `set VAR value` |
| `export VAR=value` | `set -gx VAR value` |
| `command -v cmd` | `type -q cmd` |
| `$((1+2))` | `math 1+2` |
| `${var:-default}` | `set -q var; or set var default` |
| `"${arr[@]}"` | `$arr` |
| `${#var}` | `string length $var` |
| `cmd1 && cmd2` | `cmd1; and cmd2` |
| `cmd1 \|\| cmd2` | `cmd1; or cmd2` |
| `source file` | `source file` or `. file` |

## External docs

[Fish shell docs](https://fishshell.com/docs/current/index.html) — fetch when something isn't covered locally.
