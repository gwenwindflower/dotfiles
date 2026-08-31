# Linear ↔ GitHub Issue Sync

Sync is configured per Linear-team↔GitHub-repo pair. **Creation flows one way: GitHub → Linear.** A new GitHub issue creates a synced Linear copy; creating a Linear issue never creates a GitHub issue — Linear-born issues exist only in Linear unless someone files a GitHub counterpart that then syncs. Once a pair exists, **edits are bidirectional**: changes to mirrored fields on either side propagate to the other. Only issues created after sync setup are synced — older GitHub issues enter via the importer. A synced issue shows a banner at the top in Linear with sync status and any sync errors; check it before assuming a change propagated.

## Creating issues on a synced pair

Because creation only flows GitHub → Linear, any issue the customer should see — which is nearly all of them — **starts as a GitHub issue**: the public issue is how the customer sees their problem is understood and can follow it to resolution. A Linear-only issue requires a real justification, like a security vulnerability that can't be public; customer details are never one. Abstract them from the public body, let the sync create the Linear twin, then add customer specifics on the Linear side only if they shape the work.

The integration posts the Linear twin's link as a comment on the GitHub issue, asynchronously. After creating, retrieve it — polling until it appears:

```sh
until gh api repos/<owner>/<repo>/issues/<n>/comments --jq '.[].body' \
  | rg -o 'https://linear\.app/\S+'; do sleep 10; done
```

Then report both sides to the user: the GitHub issue, its Linear twin, and what lives on one side only (customer context added in Linear; anything on GitHub that isn't mirrored). If Linear ends up holding substantive content GitHub doesn't, flag it explicitly.

## What mirrors

Two-way on a synced pair: title, description, open/closed state, labels, assignee (only for users who connected their GitHub account in Linear), sub-issues, and comments in the synced thread. Everything else is Linear-private: priority, projects, cycles, milestones, customer requests, and all comments outside the synced thread. GitHub Projects statuses don't sync either — only open/closed maps to Linear workflow states.

State mapping: Linear unstarted/started ↔ GitHub open; completed ↔ closed. Canceling in Linear closes the GitHub issue (observed as "closed as not planned"). This cascade includes automation: workspace rules like stale auto-close act on the public GitHub issue with the sync's identity — on an OSS repo, that's the project publicly closing community reports.

## Public vs private surfaces

Everything that mirrors is public on GitHub the moment it syncs. Comments live in two independent spaces in the Linear UX:

- **The synced thread** — a GitHub-specific comment space under the sync banner. GitHub comments land here, and replies into it (`parentId` on the thread root via the API) publish back to GitHub: this space is bidirectional and fully public.
- **Regular Linear comments** — everything else on the issue. These never sync; internal discussion, agent briefs, and customer context are top-level comments, always.

Post into the synced thread only when the task is explicitly to answer the GitHub reporter, which is rare.

PR linking is a separate feature from issue sync: magic words (`fixes ENG-123` in a PR title/description, or the issue ID in the branch name) attach the PR to the Linear issue and drive status automation (In Progress on open, Done on merge). A PR closing the GitHub side with `fixes #N` reaches Linear indirectly through state sync. Non-closing references use `ref ENG-123` / `part of ENG-123`.

## Managing a synced pair

- **Close on the tracker you're in; verify the counterpart followed.** State sync is reliable but not instant, and failures surface only in the Linear banner. A closed Linear issue with an open GitHub twin is a dangling public issue.
- **Never delete a synced issue** — orphan behavior on the other side is undocumented. Cancel (Linear) or close (GitHub) instead, with a reason.
- **Sweep for duplicates when closing.** Nothing auto-detects duplicates across the pair, and since Linear-born issues have no GitHub twin, a GitHub filing that duplicates existing Linear work simply becomes a second, unconnected Linear issue. Before closing or marking done, run a semantic pass on both trackers ([searching](searching.md)) for siblings — mark Linear duplicates as such (which closes their GitHub twins), and link related-but-distinct issues so the connection survives.
- **Unlinking** (remove the GitHub attachment from the Linear issue's overflow menu) stops sync without closing either side — both then need manual management. Unlink deliberately and note it on both issues; a silently unlinked pair reads as synced and drifts.
- **Sub-issues sync, hierarchy may not:** a synced sub-issue whose parent isn't synced arrives parentless on the other side. Check hierarchy after syncing structured work.
- **GitHub Enterprise Server has no issue sync** (magic words only).

## Unverified edges

Linear's docs don't specify these — verify empirically before relying on one: GitHub "closed as not planned" → which Linear state; Duplicate-state close reason on GitHub; transfer of a GitHub issue to a non-synced repo; the exact bot identity of Linear-authored comments on GitHub.
