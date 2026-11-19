# Searching Issues

Both trackers run server-side semantic/hybrid search — one well-phrased query replaces rounds of varied keyword guessing. For a duplicate check or "are there issues about X?" question, run the semantic path on the tracker the project plans in (Linear for Lightdash) before concluding anything is missing. Add GitHub when the project tracks issues there, or when the task spans a Linear↔GitHub sync ([github-sync](github-sync.md)).

Phrase queries as natural-language problem statements ("value labels missing on grouped bar charts"), not keyword soup. If a first query misses, rephrase once from the user's perspective (symptom, not implementation term) before falling back to lexical filters.

## GitHub: `gh search issues --search-type`

```sh
gh search issues "value labels missing on grouped bar charts" \
  --search-type hybrid --repo lightdash/lightdash --limit 10 \
  --json number,title,state,url
```

- `--search-type hybrid` (keyword + semantic) is the default choice; `semantic` for pure natural-language matching; omit for lexical.
- Semantic/hybrid caveats: issues only (no PRs or discussions), relevance-ranked (`--sort`/`--order` unavailable), single page of results, ~10 req/min. Quoted phrases and pure-filter queries silently fall back to lexical.
- Scope with repeated `--repo` flags or `--owner`; standard filters (`--state`, `--label`, `--author`) still apply.
- PRs and discussions are outside the semantic index — search those lexically (`gh search prs`) when relevant.

## Linear: hybrid and semantic via `linear-cli api query`

`linear-cli search issues` is a substring match over title/description only — fine for exact strings, blind to phrasing. Real relevance search goes through the GraphQL escape hatch. Both queries below are verified working.

**`searchIssues`** — hybrid (full-text + vector), issues only, supports the full `IssueFilter` and `includeComments`:

```sh
linear-cli --profile lightdash api query -o json 'query($t: String!) {
  searchIssues(term: $t, first: 10) {
    nodes { identifier title url state { name } }
    totalCount
  }
}' -v t="value labels missing on grouped bar charts"
```

**`semanticSearch`** — pure semantic, reaches projects, initiatives, and documents as well as issues. Results are a flat object with a `type` discriminator and one populated field per hit (not a union spread):

```sh
linear-cli --profile lightdash api query -o json 'query($q: String!) {
  semanticSearch(query: $q, maxResults: 10) {
    results {
      type
      issue { identifier title url state { name } }
      project { name url }
      document { title url }
    }
  }
}' -v q="users confused by overlapping chart labels"
```

- Default to `searchIssues` for duplicate checks (filters + comment search); use `semanticSearch` when phrasing is uncertain or non-issue types matter.
- Search family rate limit is ~30 req/min.
- Set `--profile` to the workspace being searched ([linear](linear.md)); hits from another workspace's teams mean the profile is wrong.
- `linear-cli` reads run inside the agent sandbox; writes go to the harness reviewer.
