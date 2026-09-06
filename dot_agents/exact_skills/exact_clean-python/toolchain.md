# Astral Toolchain

uv owns Python versions, environments, dependencies, and tool installs. ruff owns linting and formatting. ty owns type checking. All three read `pyproject.toml`.

## Python versions

- Prefer uv-managed Python. Install with `uv python install 3.14`; keep patch versions current with `uv python upgrade` (all) or `uv python upgrade 3.14`.
- Pin per project with `uv python pin 3.14`, which writes `.python-version`. Pin the user default with `uv python pin --global 3.14`, which writes `~/.config/uv/.python-version`.
- Set `requires-python` to the version you actually target (usually the latest stable). Do not widen it speculatively.

## Project setup

```toml
[project]
name = "spool"
version = "0.1.0"
description = "Ordered replay of event logs"
readme = "README.md"
requires-python = ">=3.14"
dependencies = ["httpx>=0.28"]

[project.scripts]
spool = "spool.cli:main"

[build-system]
requires = ["uv_build>=0.9"]
build-backend = "uv_build"

[dependency-groups]
dev = ["pytest>=9", "pytest-asyncio>=1", "ruff", "ty"]

[tool.ruff]
target-version = "py314"
line-length = 100

[tool.ruff.lint]
select = ["ALL"]
preview = true
ignore = [
  "D203",   # conflicts with D211
  "D213",   # conflicts with D212
  "COM812", # handled by the formatter
]

[tool.ruff.lint.pydocstyle]
convention = "google"

[tool.ruff.lint.per-file-ignores]
"tests/**" = ["S101", "D", "PLR2004"]

[tool.ruff.format]
docstring-code-format = true

[tool.ty.environment]
python-version = "3.14"

[tool.ty.rules]
possibly-unresolved-reference = "error"
```

- `select = ["ALL"]` with `preview = true` is the default. Ruff's newer rules are style and structure oriented and catch the problems this skill cares about. Ignore individual rules with a one-line reason, never whole categories.
- Keep `ignore` short. If a rule fires constantly, fix the code or the design before silencing the rule.
- ty treats warnings as failures by default (`terminal.error-on-warning`). Leave that on; promote rules you care about to `"error"` in `[tool.ty.rules]`.
- Use `# noqa: RULE` and `# ty: ignore[rule]` only with a trailing reason, and only where the checker is wrong.

## Daily commands

| Task | Command |
| --- | --- |
| Create or sync the environment | `uv sync` |
| Add a runtime or dev dependency | `uv add httpx` / `uv add --dev pytest` |
| Run anything in the environment | `uv run pytest`, `uv run ruff check`, `uv run ty check` |
| Lint, fix, and format | `uv run ruff check --fix && uv run ruff format` |
| Install a local CLI for development | `uv tool install . --reinstall` |
| Upgrade installed tools | `uv tool upgrade ruff` / `uv tool upgrade --all` |
| One-off tool run | `uvx ty check` |
| Lock without syncing | `uv lock` |

- Commit `uv.lock`. Use `uv run --frozen` in CI so the lockfile is the contract.
- Single-file scripts use PEP 723 inline metadata (`# /// script`) and run with `uv run script.py`. Add dependencies with `uv add --script script.py httpx`.

## CI with Astral actions

```yaml
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: astral-sh/setup-uv@v10
        with:
          enable-cache: true
      - run: uv python install
      - run: uv sync --frozen
      - uses: astral-sh/ruff-action@v4
        with:
          args: check
      - uses: astral-sh/ruff-action@v4
        with:
          args: format --check --diff
      - run: uv run --frozen ty check
      - run: uv run --frozen pytest
```

- `setup-uv` installs uv and caches its store. `uv python install` reads `.python-version`. Verify current major versions on the Marketplace before pinning; the `github-actions-workflows` skill has the standard CI layout.
- ty has no dedicated action. Run it through `uv run` so the version comes from the lockfile.
- Publishing: `uv build` then `uv publish` with trusted publishing. The `releasing-tools` skill covers the release pipeline.
