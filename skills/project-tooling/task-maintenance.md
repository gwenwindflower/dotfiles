# Task maintenance

`gwenwindflower/_tool` collects reusable task behavior learned in projects. Changes flow back to the template and out to other tools; exact copies are not a goal when language or product contracts differ.

## Test ownership

- `_tool/template/tests/` owns neutral task regressions, using temporary repositories and fake external commands. Run them with `mise -C template run check`; template CI runs them on Linux and macOS.
- Projects own tests of their actual version hooks, packaging, publication, application installers, and task selection. Keep regression coverage for intentional local divergences.
- Change task behavior and its tests together. Before removing a local generic suite, verify equivalent coverage against the generalized upstream task and retain project-specific assertions.
- Bootstrap excludes `template/` and `.github/workflows/template.yml`. GitHub's template button copies them; manual bootstrap must remove them. Do not recreate the neutral suites in every project.

## Share improvements

For a reusable fix, upstream the implementation, regression coverage, and any declared tools, docs, or workflow wiring together. Consider the same for a useful generic task introduced by a project. Put language-specific patterns and their tests in this skill's language kit; keep application-specific code local. Record the source project and adaptation in the template ledger so later reviews can follow the decision.

When maintaining tasks, reviewing a significant upstream shift, or preparing a release after a long gap, read `_tool`'s recent history and compare relevant files. Adopt applicable fixes and evolve local integration tests. Record the reviewed upstream commit and intentional differences in the project's ledger. No periodic task is needed merely to compare unchanged files.

The `existing` bootstrap mode copies missing files and installs tools; it is not a read-only audit. Start with Git history and diffs, and use that mode only when its mutations are intended. Never overwrite a project's task files wholesale to match upstream.
