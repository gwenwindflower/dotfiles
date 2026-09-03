---
name: bootstrap-tool
description: Create a new OSS dev-tool repository from the gwenwindflower/_tool template, or bring an existing tool repository in line with it. Use when starting a CLI or tool project, when asked to bootstrap, scaffold, or provision a tool repo, or to audit a repo against the template baseline. Dispatches to mise-projects, releasing-tools, github-actions-workflows, gitignore, and spot-project-management.
---

# Bootstrap a tool

One entry point from zero to a releasable tool. The template (`gwenwindflower/_tool`) carries everything language-neutral: GitHub surfaces, mise-driven CI and release build, the human-gated release pipeline, repo provisioning tasks, SPOT planning files, and the agent hub. A language kit from this skill's `assets/` adds the toolchain. Rust is the only kit today.

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
~/.agents/skills/bootstrap-tool/scripts/bootstrap.sh new \
  --name <name> --owner gwenwindflower --description "<one line>" [--binary <bin>] [--author "<name>"]
```

The script creates the repo from the template with `gh`, clones it, fills every `{{...}}` and `@@...@@` placeholder it knows, installs the language kit, refreshes tool pins (`pinact run -update`, `mise use --pin`), runs `mise trust && mise install`, and prints what remains. Pass `--dry-run` to see the plan without creating anything.

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
~/.agents/skills/bootstrap-tool/scripts/bootstrap.sh existing --dir . --name <name> --owner <owner> [--lang rust]
```

Nothing is overwritten. Files the template has and the repo lacks are copied in with placeholders filled; files both have are listed with a diff summary for you to reconcile by hand. Treat the report as the audit: work through it, keep intentional local differences, and adopt the rest.

## What the template guarantees

- `mise run check` is the local gate and the only place a check is defined; CI runs the same tasks. See `mise-projects`.
- Releases go through `mise run release` from a clean `main`; `release:rehearse` is the dry run. See `releasing-tools`.
- Every `uses:` is SHA-pinned with a version comment; `mise run ci-audit` runs zizmor and pinact. See `github-actions-workflows`.
- prek hooks guard every commit (file hygiene on staged files, Conventional Commit subjects); `.config/wt.toml` guards `wt merge` with `lint:*` and `release:check`. One definition per check: formatters and validators live in `prek.toml`, semantic checks in mise tasks.
- The version has one source of truth read through `version:read`; kits provide `read`, `write`, `files`, and optionally `verify`.
- Release archives are `<name>-<target>-v<version>.tgz` with Rust-style target triples for every language.

## Language kits

`assets/<lang>/` holds real files the script copies and splices at the template's `LANG_TOOLS`, `LANG_TASKS`, `LANG_IGNORES`, and `LANG_HOOKS` markers. A kit must provide `build` (binary at `dist/bin/<binary>`), `lint:*` for semantic linters, `test:*`, the version hooks, and its formatter as a prek hook. `references/rust.md` describes the Rust kit and the Cargo contract. Adding a kit means adding a directory with the same shape, never editing the template.

## Related skills

| Need | Skill |
| --- | --- |
| Task and toolchain design, mise behaviors | `mise-projects` |
| Release philosophy, distribution per language, Homebrew tap | `releasing-tools` |
| Editing or auditing workflows, runner and action versions | `github-actions-workflows` |
| Extra ignore rules for a tool or language | `gitignore` |
| Specs, Phases, running the first Phase | `spot-project-management` |
| Herdr plugin manifest, installer, runtime | `rust-herdr-plugins` |
