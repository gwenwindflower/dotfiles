# Migrating existing context into reishi

Use this recipe when moving from chezmoi-managed dotfiles, ad-hoc `~/.claude/skills`, or hand-curated `~/.agents/rules` into reishi as the new source of truth.

1. **Pick the canonical copy.** When two locations diverge (e.g. `~/.claude/skills/foo` vs `~/.agents/skills/foo`), reconcile *before* moving. Don't let `rei sync` adjudicate — it overwrites targets from source.
2. **Move into reishi source dirs**, preserving structure:
   - rules → `~/.config/reishi/rules/*.md`
   - skills → `~/.config/reishi/skills/<name>/`
   - per-project docs → `~/.config/reishi/docs/<project>/*.md`
3. **Stop the upstream system from managing those paths** (remove the chezmoi-tracked file, drop the symlink). Otherwise the next `chezmoi apply` clobbers reishi's targets.
4. **Link** agents and projects via `rei config link agent|project`.
5. **Validate** at least one skill (`rei skills validate <path>`) and run `rei rules compile` + `rei docs compile`.
6. **Dry-run first**: `rei sync --dry-run`.
7. **First real sync**, then spot-check the targets.

For skills originally pulled from GitHub, prefer re-adding via `rei skills add -tp <url>` over copying files in by hand — that records the lockfile entry so future `rei skills pull` works.

## Don't sync mid-migration

If source and target both have in-progress edits, `rei sync` overwrites one direction. Resolve first.
