# Naming

Names are how meaning travels through code, configs, commits, and handoffs. A vague label picked at scoping time ripples everywhere downstream — every reader inherits the confusion, and the cost compounds.

## Names carry the meaning, not comments

Naming and structure are how you avoid needing comments. A comment that explains *what* a function, variable, section, or file does is a naming gap. A comment that explains *why* a group of things sits together is a structure gap. Strengthen the name or the boundary first; reach for a comment only when neither can.

Applies to everything readable later: function names, identifiers, file names, section headers in config files, command names, flag names, requirement labels, Phase titles.

## Don't echo the user's throwaway terms

When a user says "the foo thing", "that whatchamacallit", or "the new pipe-flowery", they're labeling the concept in their head — not blessing a name for the artifact. Don't carry that wording into anything durable.

The right move:

1. Understand the purpose of what's being built.
2. Propose a name that reflects it, fits surrounding conventions, and reads cleanly out of context.
3. Confirm with the user before committing it to a spec, file, function, requirement ID, Phase title, package, command, or flag.
4. Once agreed, use it consistently — no drift across the agent chain.

For in-conversation chatter or one-shot scratch scripts, the user's term is fine. For anything an agent will read later, propose properly.

## What "good" looks like

- **Reflects purpose, not implementation.** `auth-token-rotator` beats `cron-script-3`.
- **Describes what it *is*, not what motivated it.** `photo-upload-handler` beats `q3-mobile-launch-handler` — names should hold up after the launch is forgotten. The historical reason a thing was added belongs in commits and DONE, not in the name.
- **Reads out of context.** A future reader without today's conversation should still get it.
- **Specific.** `handler`, `manager`, `service`, `helper`, `thing` rarely survive review — say what it actually does.
- **Matches surrounding conventions.** New style only when intended.

## In multi-agent work

Names *are* the contract that crosses agent boundaries. A vague Objective produces a vaguely-aimed subagent; a drifting requirement label fragments search and breaks references; a misleading commit subject taxes every future reader of the log. Catch bad names at scoping, not at review — by review they've already shipped through three handoffs and started shaping code. See [projects](projects.md) for the SPOT roles and artifacts this most often shows up in.
