# hk

hk is an option for project hooks and checks alongside prek. Keep the project's chosen runner; the `_tool` template uses prek. hk guidance comes from [hk-configure and hk-debug](https://github.com/jdx/hk/tree/main/skills).

## Configuration

Start with `hk --version`, project tool declarations, and the selected config. `HK_FILE` replaces the candidate list; a relative value is searched upward. Otherwise, at each directory level hk checks `hk.local.pkl`, `.config/hk.local.pkl`, `hk.pkl`, `.config/hk.pkl`, then legacy `hk.toml`, `hk.yaml`, `hk.yml`, and `hk.json`. The first existing file wins. Follow local overrides' `amends` chains before editing shared config.

`hk config sources` reports layer precedence; `hk config dump` reports merged settings. Neither identifies the selected project file. Use `hk config explain <setting>` to trace an unexpected setting, including relevant `HK_*` overrides.

Preserve hook structure and pinned Pkl versions unless upgrading is in scope. Keep `Config.pkl` and `Builtins.pkl` imports on the same version. For an authorized setup, `hk init` generates imports matching the installed version; hook installation is separate (`hk install`).

`hk builtins` lists check definitions; linter executables come from the project's tool setup. Extend the existing mapping. Custom steps use `glob`, `check`, optional `fix`, and `{{files}}` for selected paths. Respect monorepo `dir` and `workspace_indicator` choices. Use `depends` for ordering dependencies; independent steps can run concurrently.

## Verification and diagnosis

Capture the failing invocation and distinguish config errors, excluded steps, missing executables, and linter failures. Read the first substantive error from the step.

1. Run `hk validate` for Pkl and schema errors.
2. Preview the relevant hook and file selection with `hk run pre-commit --plan --why <step>` or `hk check --all --why <step>`. `--why` implies a plan; `--json` makes it machine-readable.
3. Compare selected files against `glob`, `exclude`, `dir`, workspace indicators, profiles, conditions, and skip settings. Check and pre-commit hooks can have different steps and fix/stash settings; an all-files success does not verify the staged snapshot.
4. Run the targeted check, for example `hk check --check --step <step> path/to/file.ts`. `--check` selects check commands even when a hook enables fixes; custom check commands can still write files. Use `hk fix` when corrections are intended and inspect the diff.

For missing executables, inspect `prefix`, working directory, and the project tool environment. Fix linter errors in code or config and rerun the original scope; skipping a hook does not fix its cause.

For partially staged files, inspect both `git diff` and `git diff --cached`. hk may stash unstaged work, run fixers, stage output, then restore the unstaged changes. If restoration fails, preserve the recovery message and index/worktree; resolve the conflict without dropping stashes or resetting files.

Use installed CLI help and the pinned schema for version-sensitive behavior. References: [configuration](https://hk.jdx.dev/configuration), [hook lifecycle](https://hk.jdx.dev/hooks), [CLI](https://hk.jdx.dev/cli/).
