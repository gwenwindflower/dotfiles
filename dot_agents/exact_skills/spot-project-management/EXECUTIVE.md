# Executive

> [!NOTE]
> Speculative. Captures the intended shape of a higher-level orchestrator role for SPOT projects, before any of the supporting tooling is built. Read for direction; don't yet treat as load-bearing process.

The Executive is a higher-level role that sits above Manager. Where a Manager owns one Phase end-to-end (assemble team → close Objectives → close Phase), the Executive owns the *queue* — picks the next set of unblocked Phases, spawns a Manager per Phase across parallel sessions, monitors progress, decides when to fan out the next batch.

This is the only SPOT scenario where the worktrunk Agent Handoff pattern is the right tool: the Executive spawns separate agent sessions in tmux panes, one per Phase. Within each session, the Manager runs SPOT normally — Subagent teams via the platform's internal Agent tool, Phase trunk + Objective feature branches, `wt merge` at both levels.

## Trigger

User prompt to the Executive session, something like:

- "Clear the TODO list."
- "Spin up Managers for the next two unblocked Phases."
- "Drive Phases 4, 5, and 6 to DONE."

## Sketch of the flow

1. **Read state.** Executive reads `TODO.md`, identifies all unblocked Phases (Dependencies all in DONE), notes their priority/order. Reads `wt list` to see what's already in flight.
2. **Pick the batch.** Up to *N* Phases, where *N* defaults to the user's tmux pane count (or a user-configured cap, default 4). Higher-priority / longer-blocking Phases first.
3. **Spawn a Manager per Phase.** For each picked Phase, spawn a tmux pane via the worktrunk handoff pattern:

   ```bash
   tmux new-window -t spot -n phase-<n> "wt switch --create phase-<n>-<slug> -x <agent-cli> -- '<manager brief>'"
   ```

   The Manager brief is a focused prompt that names the Phase number, points at `SPEC.md` and the Phase's requirement IDs, and instructs the Manager to run the Phase per the standard SPOT workflow.

   Per-platform spawn syntax for `<agent-cli>`:

   - **Claude Code:** `claude` (no quoting needed)
   - **OpenCode:** `'opencode run'`
   - Other platforms: see the worktrunk skill's "Advanced: Agent Handoffs" section.

4. **Monitor.** Executive periodically runs `wt list` to track Phase trunk worktrees and their state — 🤖/💬 markers (where supported) for Subagent activity, working-tree state for who's mid-merge, default-branch relation for who's ready to close.
5. **Fan out the next batch.** As Phases close (`wt list` shows them gone from worktrees, DONE.md updated), pick the next unblocked Phases from the queue and spawn fresh Manager sessions.
6. **Close out.** When the queue is empty (no unblocked Phases left, all in-flight Phases done), report to the user.

## Out of scope right now

- Executive system prompt and identity (subagent type? top-level CLI invocation? scheduled job?)
- OpenCode equivalent of the tmux spawn (Zellij? OpenCode-native multi-session orchestration?)
- Cross-Phase coordination when Phases conflict mid-flight (spec touches, file overlap)
- Backpressure: what happens when a Manager hits a `#user` block and stalls — does Executive notify? wait? skip?
- Whether Executive should ever pre-create Phase trunks vs always letting the Manager do it from inside the spawned session

## Notes for future iteration

- The handoff pattern (`wt switch --create -x <agent-cli>`) creates the Phase trunk worktree as part of the spawn — the Manager picks up cold inside the worktree. This is cleaner than Executive pre-creating worktrees and Managers picking them up after.
- Executive should never spawn more Manager sessions than the user has visible panes — invisible Manager sessions are just abandoned work. Cap *N* deliberately.
- Phase pacing ("phase by phase" vs "move freely" — see the always-on `projects` rule) becomes Executive's pacing too. If the user says "phase by phase," Executive spawns one Manager, waits for close, asks before spawning the next. If "move freely," Executive fills the pane budget and refills as Phases land.
- The commit guard hook (`require-teammate-commit`) fires per Subagent. Executive should not have its own equivalent — it doesn't commit, only orchestrates.

This doc evolves as the role gets built. For now, it's the north star.
