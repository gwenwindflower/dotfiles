# provision-repo

Reconcile GitHub Issue labels and Discussion categories for a Supermodel Labs
repo against a manifest. Fixes cosmetic drift in place (colors, descriptions,
emojis) and remaps GitHub's default labels onto the manifest where intent lines
up. **Never deletes** — anything not in the manifest is reported as "extra."

## Source

- `provision-repo.ts` (tool, manifest, GraphQL helpers all inline)
- No tests — it talks to a live GitHub API.

## Run

```fish
GITHUB_TOKEN=ghp_... ./provision-repo.ts <repo-name>
```

Org is hardcoded to `supermodellabs`. Token needs `repo` scope (labels write)
and `read:discussion` (category audit).

## Behavior

- **Labels** (REST, fully writable): creates missing, updates color/description
  on name match, remaps known GitHub defaults (`documentation` → `type: docs`,
  etc.) when the target slot is empty.
- **Discussion categories** (GraphQL, read-only): GitHub's public GraphQL has
  no category create/update mutation, so the tool audits only — drift surfaces
  as a printed report for manual fixup in **Settings → Discussions**.

## Permissions

Kept tight: `--allow-net=api.github.com --allow-env=GITHUB_TOKEN`. No disk
access — the manifest is in-source.

## Editing the manifest

Edit the constant tables at the top of `provision-repo.ts` to evolve the org
standard. There's intentionally only one — this is the source of truth for
every Supermodel Labs repo.
