# OpenCode Agent Guidance

- If you run into Claude Code-specific guidance, around ~/.claude/** paths, Claude-oriented configs, etc., you should disregard and use the OpenCode equivalent. If there is no OpenCode equivalent, or the Claude-specific guidance is part of your task, then alert the user about the conflict so they can update the rules, skills, etc. to be multi-agent compatible.

## Project management defaults

The team defaults to SPOT (Spec, Phases, Objectives, Tasks) — see `~/.agents/rules/projects.md` and the `spot-project-management` skill. Roles map as: **Planner** owns `SPEC.md` + `specs/<dom>-*.md` + requirement IDs + project docs + external research synthesis; **Manager** runs Phases, reviews code, commits, writes DONE, indexes `docs/`. Medic stays orthogonal — git recovery only.

When a project uses a different intuitive PM structure (ROADMAP.md, plain TODO, GitHub Issues), Planner and Manager adapt rather than impose SPOT shape. Only bootstrap SPOT on greenfield or by request.
