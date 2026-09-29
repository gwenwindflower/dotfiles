# Bootstrapping a project

Create a repository from the template, or audit an existing one against it.

## Interview

Settle these before touching anything. Propose real names; do not carry casual phrasing into the repo.

| Field | Default | Notes |
| --- | --- | --- |
| name | — | Repository and package name, kebab-case |
| binary | name | Installed executable, when it differs |
| owner | `gwenwindflower` | `supermodellabs` for agentic data tools |
| author | `Gwyneth Windflower` | Copyright holder |
| license | `GPL-3.0-or-later` | `AGPL-3.0-or-later` when the project mainly runs as a network service (hosted API, SaaS-style app); `FSL-1.1-ALv2` only on request |
| language | `rust` | Only kit available |
| description | — | One line; becomes the GitHub description and Cargo description |
| homebrew | off for Herdr plugins, on for standalone CLIs | Sets the `HOMEBREW_TAP` repo variable |

## New repository

```bash
bash ~/.agents/skills/project-workflows/scripts/bootstrap.sh new \
  --name <name> --owner gwenwindflower --description "<one line>" [--binary <bin>] [--author "<name>"]
```

The script creates the repo from the template with `gh`, clones it, fills every `{{...}}` and `@@...@@` placeholder it knows, installs the language kit, writes `mise.local.toml` disabling every declared tool (the core set is installed globally; delete a line to let mise own a tool), runs `mise trust && mise install` and `mise run hooks:install`, pins the workflows with `pinact run --update`, and prints what remains. Pass `--dry-run` to see the plan without creating anything.

Then, in order:

1. Fill the prose placeholders it lists (README tagline, quick start, AGENTS.md summary, SPEC.md goals). `docs/bootstrap.md` in the repo is the checklist; delete it when done.
2. Install the chosen license as `LICENSE` and delete the other option files, following the repo's `docs/bootstrap.md`. The template bundles GPL 3.0 and FSL; AGPL 3.0 comes verbatim from gnu.org. Set the same SPDX identifier in `Cargo.toml`, the Homebrew formula template, and the README notice. `LICENSE` is the only required community file. If the owner has a `.github` repository, ask whether to delete local community files such as `CONTRIBUTING.md` in favor of its defaults. Whether the project needs a `SECURITY.md` is a project decision, not a bootstrap step.
3. Commit and push `main`.
4. `mise run repo:settings --description "<one line>" --topics "<a,b>"` (add `--homebrew` for a standalone CLI), `mise run repo:labels`, and `mise run repo:environments`.
5. Load `spot-project-management` and turn `SPEC.md`, `specs/`, and `TODO.md` into the real plan. `specs/dev-release.md` is already real; prune it rather than restating it.
6. `mise run check`, then push a throwaway branch with a deliberate lint failure to confirm annotations land on the PR diff.
7. `mise run repo:rulesets` after CI has reported on `main` once.
8. `mise run release:rehearse`. Hand the `#user` steps back: the tap PAT when Homebrew is on, and `mise run release` itself.

## Existing repository

```bash
bash ~/.agents/skills/project-workflows/scripts/bootstrap.sh existing --dir . --name <name> --owner <owner> [--lang rust]
```

Nothing is overwritten. Files the template has and the repo lacks are copied in with placeholders filled; files both have are listed with a diff summary for you to reconcile by hand. Treat the report as the audit: work through it, keep intentional local differences, and adopt the rest.

Both modes exclude `template/` and `.github/workflows/template.yml`, which own `_tool`'s shared task tests. Existing mode preserves files already in the project; remove obsolete generic suites only after confirming equivalent upstream coverage. For a read-only comparison, use Git history and diffs first: this command also copies missing files and installs tools. See [task maintenance](task-maintenance.md).

## Language kits

`assets/<lang>/` holds real files the script copies and splices at the template's `LANG_TOOLS`, `LANG_TASKS`, `LANG_IGNORES`, and `LANG_HOOKS` markers. A kit must provide `build`, `lint:*` for semantic linters, `test:*`, the version hooks, and its formatter as a prek hook. Adapt the generated tasks to the language's conventional output paths, updating packaging and workflow artifact paths together. [rust](rust.md) describes the Rust kit and the Cargo contract. Adding a kit means adding a directory with the same shape, never editing the template.
