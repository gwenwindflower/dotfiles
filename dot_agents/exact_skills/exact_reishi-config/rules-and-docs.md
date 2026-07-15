# Rules and docs

## Rules

```bash
rei rules list
rei rules compile                            # writes <rules.source>/AGENTS.md
rei rules move|remove <name>
rei rules sync [--check|--dry-run] [--agents=...] [--method=...]
```

Rules are flat — no subdirs. Compile produces a single source artifact that sync ships to agents with `compile = true`.

## Docs

```bash
rei docs list [project]
rei docs compile [project]                   # writes <docs.source>/<project>/<index_filename>
rei docs sync [project] [--target <path>] [--stdout|--dry-run]
rei docs move <project> <old> <new>
rei docs remove <project> [<fragment>]       # without fragment: prompted project removal
```

The compiled index orders fragments by frontmatter `priority` desc, then alphabetically. Description source: frontmatter `description` > first paragraph > first heading. Past `token_budget`, fragments are omitted with a notice line.
