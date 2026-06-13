# scrape-github-stars

One-shot scrape of a GitHub user's curated stars lists. GitHub's REST and
GraphQL APIs don't expose star list membership ([community#8293][issue]), so
this walks the web UI via `agent-browser` (Playwright) and dumps every list's
contents to CSV for manual curation.

[issue]: https://github.com/orgs/community/discussions/8293

## Source

- `scrape-github-stars.ts` (tool)
- `scrape-github-stars_test.ts` (tests for the pure parsing helpers)

## Run

```fish
deno task scrape-stars [--user <login>] [--out <csv>] [--only <slug>] [--fresh] [--dry-run]
```

Outputs:

- `./github-stars.csv` — `list,name,url,description,language`
- `./github-stars.progress.json` — resume state (delete with `--fresh`)

## Test

```fish
deno task test:stars
```

## Notes

- Session label `gh-stars-scrape` keeps the agent-browser context isolated
  across runs.
- Per-page delays are randomized in 4–9s to avoid rate-limit signals.
- Uses `--allow-run=agent-browser,gh` — the `gh` shell-out is only for
  resolving the default user from `gh api user` when `--user` is omitted.
