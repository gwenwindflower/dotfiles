# Naming

Names are the contract that crosses agent boundaries. A vague label picked at scoping time ripples through specs, handoffs, commits, and code — every downstream agent inherits the confusion, and the cost compounds. A misnamed Phase is a rocket pointing slightly off-axis: small at the start, miles wide by the time the work lands.

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
- **Reads out of context.** A future agent without today's conversation should still get it.
- **Specific.** `handler`, `manager`, `service`, `helper`, `thing` rarely survive review — say what it actually does.
- **Matches surrounding conventions.** New style only when intended.

## Why it matters across agents

In multi-agent work names *are* the contract. A vague Objective produces a vaguely-aimed subagent. A drifting requirement label fragments search and breaks references. A misleading commit subject taxes every future reader of the log. Catch bad names at scoping, not at review — by review they've already shipped through three handoffs and started shaping code.
