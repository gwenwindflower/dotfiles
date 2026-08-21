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

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Explicit Bash allow/ask/deny rules and language-service plugins | Broadest command inventory; the sandbox supplies filesystem and network containment. |
| Codex | Sandboxed execution, automatic approval review, skills, and installed plugins | Evaluates commands in context rather than maintaining the same static command map. |
| OpenCode | Bash pattern rules plus configured LSP and formatters | Closely covers the routine command families; arbitrary commands ask by default. |

## Verification

- A repository's standard format, lint, typecheck, test, and build commands run through a short feedback loop.
- A formatter without the relevant project configuration does not rewrite the project opportunistically.
- Destructive infrastructure, broad permission changes, and unsafe deletion commands are denied or reviewed.
- Adding or changing global package-manager configuration is never an automatic recovery step.
