# Research sources

## Preflight checks

Discover connectors, plugins, MCPs, and CLIs on each run rather than assuming an earlier run's tool names. Read tool schemas and CLI help, batch independent probes, and read every result before launching workers.

| Capability | Minimum read-only check |
| --- | --- |
| Linear | Authenticated identity, the Lightdash workspace named explicitly, one issue read or search; load `project-management` first |
| GitHub | `gh auth status` shows the expected login with read access to a known Lightdash repository |
| Local git | List repositories and worktrees under `/Users/winnie/dev/lightdash` and read one git log without touching refs |
| Agent sessions | Load `context-engineering`, read agentsview help and its newest indexed timestamp; if stale, confirm current session logs are readable |
| Slack | Resolve Winnie's user identity, run one bounded message search, read one thread, and confirm access to the destination channel |
| Google Calendar | Confirm the connected account and list a bounded event window in America/Chicago |
| Delegation | Confirm the harness can launch workers with the needed tools and return bounded reports |
| Site | Codex/ChatGPT with Sites tools, the existing project readable, source and deployment workflow available |

Identities: GitHub login `gwenwindflower`; Linear is the Lightdash workspace; calendar account `winnie@lightdash.com`; Slack destination is Lightdash `#analytics-engineering` (`C091T9LD2LC`), verified again before any send. Resolve other service IDs from the authenticated profile; an email or display name is not a query ID.

## Window handling

Research notes carry the window as a start-inclusive, end-exclusive timestamp interval. When an API takes only dates or indexes by artifact update time, fetch the boundary dates and filter each contribution back to the interval. Exhaust pagination or report the gap. A recently changed artifact is something to inspect, not evidence of work.

## Linear

Search issues Winnie created or was assigned, her comments, and linked work, then read comments and history to date the contribution and name her role. An issue someone else updated is not her accomplishment. Follow linked PRs before calling something unfinished, since issue status lags merged implementations. Record canonical issue URLs and IDs for citations. The pass is read-only, statuses included.

## GitHub

Research with `gh`: issues created, comments, reviews, authored PRs, and work coworkers or automation delivered at Winnie's direction. Search by interaction as well as authorship, and check comment and review timestamps against the window. Merge state and linked follow-ups are the evidence of outcome.

Global search misses PRs, so reconcile against local git and Slack links and never claim exhaustive totals from one query. A bot-authored docs PR can be Winnie's directed work; credit the direction or scoping, not the patch.

## Local projects and sessions

Inventory every repository under `/Users/winnie/dev/lightdash`, including nested repos and worktrees. Inspect dated commits across relevant refs, authorship and co-authorship, branch state, and linked PRs. Deduplicate commits shared across worktrees and leave teammate-only commits out. A local commit is not a shipped change.

Retrieve sessions through `context-engineering`, checking index freshness before trusting a quiet result; when stale, search accessible current logs by date and project rather than bypassing an access failure. Sessions supply intent, local progress, and artifact links, not proof that planned actions happened, so corroborate with git, issues, or delivered artifacts. Tooling-noise sessions such as approval reviews or commit-message generation are not accomplishments. Keep private experiments for Winnie's triage and never copy credentials or unrelated conversation into reports.

## Slack

Search Winnie's messages in the window and read candidate threads through their follow-ups, including ones others started. Look for work she helped finish, consequential troubleshooting, decisions, and artifacts produced. Follow automation responses through Linear, GitHub, and docs to the delivered artifact: a request followed by a merged PR is a different fact from an unanswered one.

Routine support is input, not output. Keep the substantive work that resulted, not every helpful reply, and call a suggested fix a resolution only with evidence it landed. Record canonical permalinks; the visible citation label is `Thread`.

## Calendar

Read full events, not list snippets. Drop canceled and declined events, personal blocks, OOO and busy placeholders, standing meetings, and 1:1s. Keep customer calls, demos, working sessions, and co-development that were real work.

An invitation proves scheduling, not attendance or outcome. Corroborate with Slack, issues, session notes, or Winnie, and leave uncertain attendance out.
