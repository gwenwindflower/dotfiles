# git-wash

Classify stale remote branches by deletion confidence, rank uncertain branches for review, then preview or delete a selected target. The generated manifest binds every branch to its repository, remote, and observed SHA; washing stops if any identity or SHA no longer matches.

## Generate a mess list

```fish
deno task git-wash list /path/to/repo
```

Git Wash resolves GitHub from the selected remote. Pass an explicit repository when the remote URL is ambiguous or a different GitHub repository should supply metadata:

```fish
deno task git-wash list /path/to/repo --remote upstream --github-repo lightdash/lightdash
```

The default `git-wash/` output contains `manifest.json`, review reports for `tier1.json` through `tier3.json`, `test.json` with up to ten of the oldest Tier 1 branches, and an agent-authored `reviews.json` sidecar. Re-running `list` preserves reviews only while the repository, branch name, and SHA remain unchanged.

| Target | Meaning |
| --- | --- |
| `tier1` | Tip is reachable from the default branch or exactly matches a PR merged into it |
| `tier2` | Every unique non-merge commit has a patch-equivalent commit on the default branch |
| `tier3` | Stale with no landing evidence; requires individual review |
| `test` | Up to ten of the oldest Tier 1 branches |
| `reviewed` | Tier 3 branches explicitly recommended for deletion in a complete `reviews.json` |

The default stale threshold is 90 days, measured from the tip commit timestamp. The default branch, protected branches, heads of open PRs, and branches inside the threshold remain marked `keep` in `manifest.json`.

## Review Tier 3 with agents

Tier 3 branches include a `reviewPriority` object. Higher scores indicate stronger retention signals, and `tier3.json` sorts them from most likely to keep to most likely to drop. Every score contribution appears in `signals`; the raw unique-commit, author, diff, containment, age, PR, and bot evidence remains available for direct inspection. Ranking guides review and never upgrades a branch's deletion tier.

Fan out disjoint branch lists to review agents. Each agent inspects the branch, its commits and diff, related PRs or issues, and current repository behavior, then returns branch-keyed entries for the coordinator to merge into `reviews.json`. Conflicting reviews must be resolved explicitly.

```json
{
  "version": 1,
  "repository": {
    "slug": "lightdash/lightdash",
    "remote": "origin",
    "remoteUrl": "git@github.com:lightdash/lightdash.git"
  },
  "manifestGeneratedAt": "2026-08-20T00:00:00.000Z",
  "branches": {
    "docs/old-guide": {
      "sha": "0123456789abcdef0123456789abcdef01234567",
      "recommendation": "delete",
      "confidence": "high",
      "summary": "The guide was replaced by the current configuration reference.",
      "evidence": [
        "PR #1234 closed after the replacement landed in PR #1250.",
        "The branch contains no documentation absent from the current site."
      ],
      "reviewer": "tier3-review-01"
    }
  }
}
```

`recommendation` accepts `keep`, `delete`, or `human-review`; `confidence` accepts `high`, `medium`, or `low`. An absent branch is pending. `wash reviewed --execute` requires every Tier 3 branch to resolve to `keep` or `delete`; pending and `human-review` branches stop execution.

## Wash branches

Washing previews by default:

```fish
deno task git-wash wash /path/to/repo test
deno task git-wash wash /path/to/repo tier1
deno task git-wash wash /path/to/repo reviewed
```

After reviewing the matching JSON report, opt into deletion explicitly:

```fish
deno task git-wash wash /path/to/repo test --execute
deno task git-wash wash /path/to/repo reviewed --execute
```

Deletion uses a force-with-lease expectation for each recorded SHA. A moved branch, different repository root, different remote URL, stale review, or incomplete reviewed target stops the full run before any branch is deleted.

## Snapshot remote branches

Create a portable backup before washing:

```fish
git-wash snapshot /path/to/repo
```

Git Wash mirror-clones the configured remote into a temporary directory, creates and verifies `git-wash/<repo>_branch-backup.bundle`, reports how many remote branches it contains, then removes the mirror clone. It refuses to overwrite an existing bundle and removes an incomplete bundle if creation or verification fails.
