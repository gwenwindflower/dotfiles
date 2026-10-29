---
name: work-journal
description: Weekly work journals - cross-source research, impact filtering, review, cited Slack highlights, and a persistent ChatGPT Site archive.
---
# Work journal

Turn a week of Winnie's Lightdash work into a reviewed journal and a short Slack post. The journal is a curated account of what she contributed and what it enabled, not an activity log: readers should learn what moved, not how busy the week was.

## Stages

Each stage carries its own authorization: a drafting request does not authorize a Slack send or Site change, and last week's publication does not carry over. Run only the stages the current task names.

1. Preflight: confirm access and the Site handoff.
2. Research: one bounded worker per source, merged by the lead.
3. Draft and review with Winnie.
4. Linear capture of untracked work, when requested.
5. Site update, by Codex/ChatGPT.
6. Slack highlights.

## Preflight

Tool discovery is not authentication. Before research, probe every source the requested stages need (checks in [sources](sources.md)) and Site tooling (contract in [site](site.md)) with a small read-only call. Settle gaps with Winnie before research starts: name the source and the fix, and drop a source only with her agreement, since a roundup that quietly skips one misstates the week. Probes never mutate: no test message, no test deploy.

Only Codex/ChatGPT with working Sites tools touches the Site; any other agent hands that stage off and says so in preflight.

## Research

The reporting week is Monday–Friday in America/Chicago. Research reaches back eight days from the cutoff to catch work that straddled the weekend, but a published item must have been touched in the reporting week unless Winnie keeps it. Fix exact bounds before delegating so workers share one window. Never widen a sparse week silently; sparse is a finding.

Read existing drafts, reviewed copies, and journal state first. Reuse evidence that still stands and honor prior cuts. Scratch research lives in a dated `wip/` directory apart from publishable content.

Research is token-heavy, so delegate one read-only worker per source (Linear, GitHub, local git and sessions, Slack, calendar) with its source section, the bounds, Winnie's identity on that service, and an exclusive output file. Workers return compact evidence, coverage gaps, and open follow-ups; they never publish or create issues. Each candidate records the dated contribution, the objective or customer, the observed result, a proposed status, links, uncertainty, and corroborating artifacts. Reports record their queries and whether pagination completed; raw logs stay out of the main context. Without delegation, agree on a narrower or sequential run during preflight.

The lead merges duplicate workstreams and settles attribution and status against resulting artifacts. Two traps: an artifact's update time shows it changed, not that Winnie worked on it; and when she directs a bot or coworker, the delivery substantiates her contribution without making her the implementer.

## Selecting

Impact decides inclusion: customer or business outcomes, shipped improvements, and real progress on agreed initiatives. Investigations, customer working sessions, co-development, and concrete planning belong in the journal when they moved something. Routine support, queue coverage, standing meetings, 1:1s, offsites, and exploration without a deliverable stay out. A support-heavy week means filtering harder, not listing tickets.

Group by objective and lead with the outcome, not the request that prompted it. Identifying, scoping, implementing, and shipping are distinct contributions; credit the one Winnie made. Never invent metrics or infer resolution from advice given.

Status marks: ✅ completed (a recurring customer session counts once it has happened), ⚡ active implementation or investigation, 🔮 concrete planning that names the goal and the progress toward it without implying implementation. Slack takes 5–10 delivered or substantive in-progress items chosen by impact; planning-only items stay in the journal, and a quiet week is not padded.

Untracked branches and local-only ideas go to a separate triage list where Winnie decides what enters Linear and what stays private; significant work is not disqualified for lacking an issue. Issue work follows `project-management`; draft missing issues only when that stage is requested, after checking for existing ones.

## Review and delivery

[presentation](presentation.md) holds the editorial conventions and the Slack and Site formats.

- `draft.md` is the working copy. Winnie's `draft_reviewed*.md` siblings carry her feedback; a deletion there is a cut and stays cut in later passes. Keep a short list of exclusions and open decisions beside the draft.
- Publish only reviewed blurbs and citations, never research notes, session logs, or transcripts. Cite the resulting issue or PR when it exists and the thread for context or for work no artifact captured. Verify outcomes before assigning status.
- The Site keeps the full selected list and weekly history; the Slack post ends with the week's archive link so it stays useful after the landing page moves on.
- Close the run with handoff notes: week route, Site identity, deployment result, Slack permalink if sent, and pending work. Durable editorial preferences come back into this skill; weekly content and one-off cuts do not.
