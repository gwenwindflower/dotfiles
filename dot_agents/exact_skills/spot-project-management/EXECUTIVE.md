# Executive

The Executive sits above Manager. Where a Manager owns one Phase end-to-end (assemble team → close Objectives → close Phase to main), the Executive owns the *queue*: pick unblocked Phases, spawn a Manager per Phase across parallel sessions, monitor progress via the workspace dashboard, gate Phase-trunk → main merges through a Reviewer, then fan out the next batch.

This is the **only** SPOT scenario where the worktrunk "Agent Handoff" pattern is the right tool — Subagents inside a Phase are still spawned as Agent Teams from within the Manager's session. The Executive's handoffs happen one level up, between sessions.

## The autonomy gradient

Executive runs the same loop along a spectrum of how much the user is in it:

- **Pure-autonomous** — runs unattended on a sandbox VM for hours, clears a sprint of unblocked Phases, asks for nothing. Reviewer gates every Phase before main. Caller wakes up to a series of merged PRs and a Phase queue closer to empty.
- **Interactive pairing** — Executive's job is to set up the herdr workspace, spawn Manager tabs the user can tab through, and keep the dashboard honest while the user pairs with whichever Manager they're focused on. The user may close some tabs themselves, accept Reviewer changes manually, or ask Executive to take over.
- **Anywhere in between** — most sessions float here. Executive runs whichever steps the user delegates and surfaces the rest.

The Executive's mechanics don't change across the gradient; only the user's level of presence does. Build the same workspace either way; let the user drive (or not).

## The unit relationship — Phase = Manager = Session

These three line up one-to-one:

| Unit | Owner | Surface |
| --- | --- | --- |
| **Phase** | Manager | One context-bounded chunk of TODO.md |
| **Manager** | One agent session | One herdr tab |
| **Objective** | One Subagent | A worktree spawned from inside the Manager via the platform's Agent tool |

A Manager's session is for *one* Phase. Once a Phase merges to main, the Manager is **done**. Don't reuse the session for the next Phase — Executive opens a fresh tab with a fresh Manager. The Phase boundary is also the context boundary: every Manager starts cold from `SPEC.md` + the Phase's requirement IDs, which is the whole point of the structure (see [running-phases](running-phases.md#phases-are-teams-objectives-are-agents)).

The Subagent layer doesn't change either: an Agent Team fans out *inside* the Manager's session, one Subagent per Objective, via the platform's internal Agent tool — same as a user-launched Manager (see [using-worktrunk#agent-teams](using-worktrunk.md#agent-teams-the-spot-default)). The Executive doesn't touch the Subagent layer at all.

## Manager starts look the same regardless of source

A Manager doesn't need to know whether its starting prompt came from an Executive handoff or from a user typing into a fresh session. The brief shape is identical: *"Finish this Phase. Use a team if it's multi-Objective and the Objectives aren't tiny."* User-initiated Manager sessions are extremely common — most days a user just opens a tab, points at a Phase, and goes. Executive is one way to get a Manager session running, not the canonical way.

## Trigger

User prompt to the Executive session, something like:

- "Clear the TODO list."
- "Spin up Managers for the next two unblocked Phases."
- "Drive Phases 4, 5, and 6 to DONE."
- "Set me up to pair on Phase 7."

## The workspace model — one workspace per project, one tab per Manager

The user-facing surface is a [herdr](https://github.com/ogulcancelik/herdr) workspace. Executive uses tabs (not panes) because tab-switching to a full-screen Manager session is the right ergonomics — Manager output is dense and panes shrink it pointlessly.

1. **One workspace per project.** Use the existing one if a workspace already exists for this repo; otherwise create one labeled with the project name and `--cwd` pointing at the repo root.
2. **One tab per Manager (per Phase).** Each Phase gets a fresh tab, labeled `phase-<n>-<slug>`. The tab's cwd is the Phase trunk worktree path, and the tab runs the platform's CLI (`claude`, `opencode run`, etc.) with the Manager brief.
3. **One Reviewer tab at Phase close.** When a Manager finishes, Executive opens a separate Reviewer tab in the same workspace to gate the merge to main (see [Reviewer flow](#reviewer-flow) below).
4. **Close tabs on merge.** When a Phase trunk merges to main, the Manager tab and any Reviewer tab for that Phase close. This is cleanest as a worktrunk `post-merge` hook (see [Tab cleanup hook](#tab-cleanup-hook)); falling back to the Executive closing tabs manually after `wt list` shows the worktree gone is fine.

## Spawning a Manager tab

The handoff is `wt switch --create -x <agent-cli>` wrapped in `herdr tab create` so the worktree, hooks, and Manager CLI all come up inside the tab:

```bash
# 1. Find or create the project workspace
herdr workspace list --format json | jq -r '.[] | select(.label == "<project>") | .id'
# (if empty) herdr workspace create --cwd <repo> --label "<project>" --no-focus

# 2. Open a tab for the Phase, then launch the Manager inside it
herdr tab create --workspace <ws-id> --label "phase-<n>-<slug>" --no-focus
herdr pane run <pane-id> "wt switch --create phase-<n>-<slug> -x <agent-cli> -- '<manager brief>'"

# 3. Watch it come up
herdr wait agent-status <pane-id> --status idle --timeout 60000
```

The Manager brief is a focused prompt that names the Phase number, points at `SPEC.md` and the Phase's requirement IDs, and tells the Manager to run the Phase per standard SPOT workflow. The Manager picks up cold inside the Phase trunk worktree; nothing about the brief changes whether it came from Executive or a user.

Per-platform spawn syntax for `<agent-cli>`:

- **Claude Code:** `claude`
- **OpenCode:** `'opencode run'`
- Other platforms: see the worktrunk skill's "Advanced: Agent Handoffs" section.

When the platform's herdr integration is installed (`herdr integration install claude` / `opencode`), agent-status markers — `working`, `blocked`, `idle`, `done` — show in the tab strip and feed `herdr wait agent-status`. Install the integration once per agent platform you orchestrate; it's a prerequisite for the monitoring step.

## Monitor

Periodically run `herdr tab list --workspace <ws-id>` and `wt list` to track:

- Which Manager tabs are `working` vs `blocked` vs `idle` (from herdr).
- Which Phase trunks are still in worktrees vs already merged (from `wt list`).
- Whether any tab is blocked on user input — surface those, the user is the only one who can unstick them.

`herdr pane read --source recent` on a specific tab is for diagnosis when something looks off; don't poll it as a heartbeat.

## Reviewer flow

When a Manager declares its Phase done (Phase trunk worktree exists, all Objectives merged in, `wt list` shows it `↑` to main), **do not merge directly.** The Manager is finished — its session stays inactive on the Phase trunk worktree for the moment, ready to be torn down. Executive spawns a separate Reviewer agent to gate the merge.

1. **Open a Reviewer tab** in the same workspace, labeled `review-phase-<n>-<slug>`, cwd at the Phase trunk worktree. Spawn the Reviewer agent (`reviewer` subagent in OpenCode, `reviewer` agent in Claude Code) with a brief: "Audit Phase trunk `phase-<n>-<slug>` against `SPEC.md` + the Phase's requirement IDs. Recommend merge, propose changes, or escalate to Medic."
2. **Wait on the Reviewer.** `herdr wait agent-status <pane-id> --status done` blocks until the Reviewer reports back.
3. **Branch on the Reviewer's verdict:**
   - **Pass with small fixes** — Reviewer made the final improvements and the tree is clean. Executive (or the user) runs `wt merge --no-squash` from the Phase trunk worktree to land it. Tab cleanup (see below) fires on merge.
   - **Pass clean** — same, no fixes needed.
   - **Propose changes** — Reviewer returned a structured list of issues. Executive closes the Reviewer tab, opens a **new Manager tab** (don't reuse the original Manager — same Phase, fresh context) with a brief: "Phase `<n>-<slug>` is back in flight. Address these Reviewer findings on the Phase trunk: <findings>. Close as usual when done." That Manager fans Subagents out again as needed, lands changes on the Phase trunk, and triggers another Reviewer pass.
   - **Escalate to Medic** — Reviewer found git-history damage it can't resolve. Reviewer's report names the Medic-shaped problem; Executive opens a Medic tab on the Phase trunk worktree, follows the Medic loop, then re-runs Reviewer.
4. **Loop until merged.** The Reviewer ↔ Manager loop continues until a Reviewer pass merges the Phase trunk to main. Don't bypass — every Phase trunk hits main through a Reviewer.

The Reviewer is **read-mostly** — it makes small final improvements itself (typo fix, missed lint, stray comment), but anything larger is a proposal-back-to-Manager. See the Reviewer subagent definition for the line between fix-it and propose-it.

## Tab cleanup hook

The cleanest way to clean up Manager and Reviewer tabs once their Phase trunk merges to main is a worktrunk `post-merge` hook that fires on Phase-level merges:

```toml
# .config/wt.toml — Executive-orchestrated projects
[post-merge]
close-tab = """
if [ {{ target }} = main ] && [ -n "$HERDR_PANE_ID" ]; then
    herdr tab close "$HERDR_TAB_ID"
fi
"""
```

The conditional ensures Objective-level merges (target = Phase trunk) don't close tabs — only Phase-level merges (target = main) do. The `HERDR_PANE_ID` / `HERDR_TAB_ID` env vars are set by herdr inside its panes; the conditional gracefully no-ops outside herdr (regular user shells, CI runs, etc.).

If the hook isn't wired up, Executive closes tabs manually after `wt list` shows the worktree gone:

```bash
herdr tab list --workspace <ws-id> --format json \
  | jq -r '.[] | select(.label | startswith("phase-<n>-")) | .id' \
  | xargs -I {} herdr tab close {}
```

This is a worktrunk-hook integration point worth pushing upstream — the conditional + env var contract is small and saves the Executive a polling loop. Document it in the worktrunk skill if it lands.

## Pacing

The user's Phase pacing preference (see the `projects` rule) becomes the Executive's pacing:

- **"Phase by phase"** — spawn one Manager tab, wait for Reviewer-passed merge, ask the user before spawning the next. Sequential.
- **"Move freely"** — fill a pane budget (default 4 tabs, configurable) and refill as Phases land. Several Managers in flight at once, each in their own tab. This is where the herdr dashboard earns its keep.

Never spawn more Manager tabs than the user has visible. Invisible Manager sessions are just abandoned work — the budget is *visible tabs*, not raw parallelism. If the user wants more, they widen the budget explicitly.

## Out of scope for Executive

- **Spawning Subagents.** That's Manager's job, inside its own session. Executive never reaches past the tab boundary into a Manager's Agent Team.
- **Editing specs.** Spec coordination across in-flight Phases is a Planner concern. If the Reviewer surfaces a real spec ambiguity, Executive escalates to Planner before re-spawning a Manager on the same Phase.
- **Cross-Phase conflict resolution.** When two parallel Phases touch the same file mid-flight, the second-to-land Manager handles the rebase per [running-phases](running-phases.md#parallel-phases-across-manager-sessions). Executive doesn't intervene mid-rebase.
- **Committing.** Executive orchestrates but never commits. No `require-teammate-commit` equivalent — there's nothing for Executive to commit.

## Open questions

- **Pure-autonomous mode without a TTY.** Herdr's socket API doesn't need a TTY, so `--no-session` headless workspaces are plausible — but no human pairing means the visible-tab cap is meaningless. Likely the right answer is a separate "headless executive" config that drops the workspace altogether and just spawns detached `wt switch --create -x` processes. Punt on this until the autonomous use case is real.
- **Reviewer ↔ Manager loop depth.** In practice three rounds is a lot; Executive should probably escalate to the user after N=3 with the cumulative diff between rounds. Tune as the loop sees real use.
- **OpenCode equivalent of `--agent`-like main-session brief.** Claude Code's `claude --agent reviewer` cleanly starts the Reviewer as the main session in a tab; OpenCode's `opencode run --agent <name>` does the same. Verify behavior matches expectations when the agent files land.

This doc evolves as the role gets used. The shape is stable; the cleanup hook and Reviewer-loop tuning are the most likely places to refine.
