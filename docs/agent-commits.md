# Agent-focused commit style

This repo carries configuration and guidance for several coding agents at once, so commit scopes name the agent surface, not just the file type.

## Types

Rules, skills, agent definitions, and hooks are load-bearing: they change what agents do. Treat them as code under conventional commits, not as documentation. `feat`, `fix`, `refactor`, and `chore` all apply; `docs` is for prose that only explains, such as `docs/` and README-style text.

## Scopes

| Change | Scope | Example |
| --- | --- | --- |
| Shared across agents | `agents/<sub-scope>` | `feat(agents/skills): add zvec-grep skill`, `refactor(agents/rules): tighten writing rule`, `chore(agents/config): allow rumdl` |
| One agent only | `<agent name>` | `fix(claude): move chezmoi inside ask list`, `feat(codex): keep both sandbox systems as swappable config sources` |

Sub-scopes in use: `rules` (`.chezmoitemplates/agents/rules/`), `skills` (`dot_agents/exact_skills/`), `config` (harness permission and settings files across platforms), `agents` (agent definitions), `hooks`. Pick the one that names what changed; add a new sub-scope only when none fits.

A change to one harness's own files uses that agent's name as the whole scope: `claude`, `codex`, `opencode`, `herdr`. When the same change lands in several harness configs, it is `agents/config`.

Everything else in the repo keeps the ordinary scopes (`fish`, `nvim`, `brew`, `chezmoi`, and so on). When in doubt, `git log --oneline` has current examples.
