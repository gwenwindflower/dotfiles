# prek

prek is a Rust reimplementation of pre-commit. In tool projects it runs on every commit through `prek.toml`; [mise](mise.md) sets which checks belong in hooks and which in mise tasks. The [LLM docs index](https://prek.j178.dev/llms.txt) links every page as markdown; check [Language Support](https://prek.j178.dev/reference/language-support/index.md) before relying on a hook `language`.

## Config

New setups use `prek.toml`. A repo that already has `.pre-commit-config.yaml` keeps it unless asked to convert; `prek util yaml-to-toml` does the conversion, and `prek install -f` replaces pre-commit's shims.

| `repo` | Holds |
| --- | --- |
| `"builtin"` | prek's offline Rust-native hooks; no network, no runtime install |
| `"local"` | Hooks defined in this repo, usually `language = "system"` over a mise-installed binary |
| `"meta"` | Config checks: `check-hooks-apply`, `check-useless-excludes`, `identity` |
| A URL | A remote hook repo pinned by `rev`; avoided in tool projects because it installs a runtime per machine |

```toml
[priorities]
lint = 10

[[repos]]
repo = "builtin"
hooks = [
  { id = "trailing-whitespace" },
  { id = "end-of-file-fixer" },
  { id = "check-toml" },
]

[[repos]]
repo = "local"

[[repos.hooks]]
id = "rumdl"
name = "rumdl"
language = "system"
entry = "rumdl check --no-cache"
types = ["markdown"]
priority = "lint"
```

Inline hook tables use TOML 1.1 multiline syntax. Switch to `[[repos.hooks]]` array-of-tables when a hook has many fields (`env`, `pass_filenames = false`, `priority`) or a parser in the toolchain rejects TOML 1.1.

- **Filtering**: `files` and `exclude` take a regex (`"\\.rs$"`) or a glob (`{ glob = "src/**/*.rs" }`, `{ glob = ["target/**", "dist/**"] }`). When `types`, `types_or`, or `exclude_types` don't match as expected, `prek util identify <path>` prints a file's tags.
- **Ordering**: lower `priority` runs earlier, and hooks sharing a priority run concurrently. The top-level `priorities` table names aliases that `priority` can use. Priorities apply within one config file only.
- **Other prek-only keys**: `env` per hook, `minimum_prek_version` to gate newer features, and `orphan = true` to cut a nested workspace project off from parent configs.

Built-in hooks: `trailing-whitespace`, `end-of-file-fixer`, `mixed-line-ending`, `fix-byte-order-marker`, `check-added-large-files`, `check-case-conflict`, `check-illegal-windows-names`, `check-merge-conflict`, `check-symlinks`, `destroyed-symlinks`, `detect-private-key`, `no-commit-to-branch`, `check-json`, `check-json5`, `check-jsonc`, `pretty-format-json`, `check-toml`, `check-yaml`, `check-xml`, `check-vcs-permalinks`, `file-contents-sorter`, `check-shebang-scripts-are-executable`, `check-executables-have-shebangs`. Hooks from `pre-commit/pre-commit-hooks` take the same Rust fast path automatically.

Monorepos use workspace mode: a nested `prek.toml` per project plus `.prekignore`, not one root config.

## Commands

| Command | Does |
| --- | --- |
| `prek validate-config` | Validates `prek.toml` or `.pre-commit-config.yaml` |
| `prek install --prepare-hooks` | Installs git shims (`pre-commit`, `commit-msg`, ...) and prepares hook environments; `mise run hooks:install` wraps it |
| `prek run` | Runs hooks on staged files |
| `prek run --all-files` | Runs hooks on the whole repo; the `lint:hooks` task |
| `prek run <hook-id>` | Runs one hook |
| `prek run --last-commit`, `--directory <dir>`, `--skip <hook>` | Narrows or skips the file selection |
| `prek run --dry-run` | Lists what would run |
| `prek list` | Lists discovered hooks and workspace projects |
| `prek update` | Bumps pinned `rev`s of remote repos |

`prek -C <dir>` runs any command against another directory.

## Debugging

- `prek run -vvv` shows hook selection and execution.
- `PREK_NO_FAST_PATH=1 prek run` compares a builtin fast-path hook with the standard path.
- `PREK_*` variables (`PREK_SKIP`, `PREK_HOME`, concurrency limits) are listed in the [environment variable reference](https://prek.j178.dev/reference/environment-variables/index.md).
