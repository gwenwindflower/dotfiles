---
name: mine-session-knowledge
description: Mine recorded agent session history for hard-won knowledge that was never captured — repeated investigations, corrected mistakes, decisions that live only in chat — and turn the gaps into project docs, rules, or skills via an authoring subagent. Use when asked to mine, harvest, or audit session logs for capturable knowledge, or to find documentation gaps from agent history. Skip for capturing only the current session (use capture-context) or plain history lookup (use agentsview-finding-history).
---

# Mining Session Knowledge

Sweep the AgentsView archive for knowledge agents paid to learn but never
wrote down, then capture each gap as the right durable artifact. The
deliverable is captured context, not a report of interesting history.

Load `agentsview-finding-history` for search mechanics (modes, windows,
citation format); this skill covers what to look for and what to do with it.

## Gap Signals

A gap is knowledge that recurs, cost real effort, and has no durable home.
Probe for these shapes:

| Signal | Looks like in history | Probe style |
| --- | --- | --- |
| Repeated rediscovery | Same error, path hunt, or "where does X live" exploration in 2+ sessions | FTS on exact error strings and paths; hybrid on the topic |
| User corrections | User re-teaching an agent ("we use X not Y", "we already have a tool for that") | FTS on the correction's key terms, scoped per project |
| Unwritten decisions | Decision plus rationale settled in conversation, no spec/ADR/doc artifact | Hybrid on the decision subject, `--scope top` |
| Re-derived workflows | Multi-step procedure (deploy, debug recipe, setup) worked out from scratch again | Hybrid on the workflow's goal |
| Environment quirks | Sandbox blocks, tool flags, version pins, config paths learned through failure | FTS on the tool name plus failure vocabulary |

`agentsview projects` shows where the session volume is — mine busy
projects first unless the user scoped the sweep.

## Workflow

1. **Scope.** Default to `--since 30d` across all projects; honor any
   project, topic, or window the user named. State the scope before mining.
2. **Mine.** Run bounded probes per signal category (8–12 probes total).
   Triage from inline context; deep-dive only hits that show real cost —
   long tool-call runs, multiple sessions, visible user frustration.
3. **Verify the gap.** Before proposing, confirm the knowledge is not
   already captured; search the project's AGENTS.md and docs, the skill
   list, and rules. Already captured but repeatedly missed is a different
   finding — propose a discoverability fix (sharper description, index
   entry) instead of a duplicate artifact.
4. **Classify.** Pick the capture target:

   | Finding shape | Capture as |
   | --- | --- |
   | Convention or workflow that always applies, one project | Project AGENTS.md entry or project rule |
   | Convention that always applies, every project | User-level rule fragment |
   | How a system works, one project | Project `docs/` file plus index entry |
   | Triggerable workflow useful across projects | Skill |
   | Decision plus rationale | ADR or DONE.md entry in the owning project |

5. **Propose.** Present the candidate list once — finding, evidence
   citations (session id + ordinal range), target, and cost evidence —
   and let the user pick. One gate, not a question per finding.
6. **Build.** For each approved capture, hand off to an authoring
   subagent, then review its output before it lands.

## Handoff Brief

Each authoring subagent gets one finding and must receive:

- The finding stated as current-state knowledge, plus the evidence windows
  (quoted excerpts — the subagent cannot search the archive itself).
- The target path and artifact type from the classification table.
- Which authoring skill to load — `agent-skills` for skills,
  `agent-context-engineering` for docs, rules, and AGENTS.md entries.
- The current-state rule: write what is true now; no "we discovered",
  no session references, no history framing in the artifact.

The coordinator reviews and commits; subagents never `git add` or commit.

## Guardrails

- Every proposed finding cites sessions and ordinals; no vibes-based gaps.
- Express cost as observed evidence ("re-derived across 3 sessions,
  ~40 tool calls each"); never invent token estimates.
- Never capture secrets, credentials, PII, or speculation the sessions
  did not confirm.
- Bounded sweeps: cap at 5–8 proposed captures per run and list leftover
  leads as follow-ups rather than continuing to dig.
- Corrections outrank conclusions — something the user had to say twice
  is a stronger capture candidate than something an agent figured out once.
