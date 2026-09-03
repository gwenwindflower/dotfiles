# CI annotations

GitHub turns two kinds of output into file-and-line annotations on a PR: workflow commands (`::error file=...,line=...::msg`) and problem matchers, which are regexes that turn a tool's plain output into those commands. Annotations are line-level; there is no hunk-level API.

## Problem matchers

Matchers live in `.github/matchers/<tool>.json` and are registered once per job before the tools run:

```yaml
- name: Register problem matchers
  run: |
    for matcher in .github/matchers/*.json; do
      echo "::add-matcher::${matcher}"
    done
```

The template carries `markdownlint.json` and `shellcheck.json`; language kits add their own (`rust.json` covers rustfmt diffs, cargo and clippy diagnostics, and test panics). A matcher has an `owner`, an optional default `severity`, and one or more `pattern` regexes with capture-group indexes for `file`, `line`, `column`, `severity`, `code`, and `message`. Multi-line diagnostics (cargo's `error: ...` followed by `--> src/x.rs:3:5`) use two patterns in sequence; the last one may set `loop: true` to match repeated lines.

Tools must print in the format the matcher expects: `shellcheck --format=gcc`, `cargo` in its default human format, `markdownlint-cli2` default output. Paths must be relative to the workspace root, which is why task scripts `cd` to `MISE_PROJECT_ROOT`.

## Native GitHub output

Some tools emit workflow commands themselves; use that instead of a matcher:

| Tool | Flag | Note |
| --- | --- | --- |
| zizmor | `--format github` | 10 annotations per step, so keep findings at zero |
| ruff | `--output-format github` | |
| biome | `--reporter github` | |
| golangci-lint | `--out-format github-actions` | |

## Limits

- 10 warning and 10 error annotations per step are shown; further ones are dropped. Fix rather than accumulate.
- Annotations attach to files in the diff; failures in files a PR did not touch show in the check summary only.
- Matchers stay registered for the rest of the job; `::remove-matcher owner=...::` clears one if a later step's output collides.
