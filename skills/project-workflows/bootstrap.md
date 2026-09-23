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
| language | `rust` | Only kit available |
| description | — | One line; becomes the GitHub description and Cargo description |
| homebrew | off for Herdr plugins, on for standalone CLIs | Sets the `HOMEBREW_TAP` repo variable |

## New repository

```bash
bash ~/.agents/skills/project-workflows/scripts/bootstrap.sh new \
  --name <name> --owner gwenwindflower --description "<one line>" [--binary <bin>] [--author "<name>"]
```

The script creates the repo from the template with `gh`, clones it, fills every `{{...}}` and `@@...@@` placeholder it knows, installs the language kit, writes `mise.local.toml` disabling every declared tool (the core set is installed globally; delete a line to let mise own a tool), runs `mise trust && mise install` and `mise run hooks:install`, pins the workflows with `pinact run -update`, and prints what remains. Pass `--dry-run` to see the plan without creating anything.

Then, in order:

1. Fill the prose placeholders it lists (README tagline, quick start, AGENTS.md summary, SPEC.md goals). `docs/bootstrap.md` in the repo is the checklist; delete it when done.
2. Commit and push `main`.
3. `mise run repo:settings --description "<one line>" --topics "<a,b>"` (add `--homebrew` for a standalone CLI) and `mise run repo:labels`.
4. Load `spot-project-management` and turn `SPEC.md`, `specs/`, and `TODO.md` into the real plan. `specs/dev-release.md` is already real; prune it rather than restating it.
5. `mise run check`, then push a throwaway branch with a deliberate lint failure to confirm annotations land on the PR diff.
6. `mise run repo:rulesets` after CI has reported on `main` once.
7. `mise run release:rehearse`. Hand the `#user` steps back: `<owner>/.github` community files, the tap PAT when Homebrew is on, and `mise run release` itself.

## Existing repository

```bash
bash ~/.agents/skills/project-workflows/scripts/bootstrap.sh existing --dir . --name <name> --owner <owner> [--lang rust]
```

Nothing is overwritten. Files the template has and the repo lacks are copied in with placeholders filled; files both have are listed with a diff summary for you to reconcile by hand. Treat the report as the audit: work through it, keep intentional local differences, and adopt the rest.

## Language kits

`assets/<lang>/` holds real files the script copies and splices at the template's `LANG_TOOLS`, `LANG_TASKS`, `LANG_IGNORES`, and `LANG_HOOKS` markers. A kit must provide `build` (binary at `dist/bin/<binary>`), `lint:*` for semantic linters, `test:*`, the version hooks, and its formatter as a prek hook. [rust](rust.md) describes the Rust kit and the Cargo contract. Adding a kit means adding a directory with the same shape, never editing the template.
