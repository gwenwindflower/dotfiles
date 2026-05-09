# Responding to Sandbox Failures

> [!IMPORTANT]
> Only applies inside a sandboxed environment. Outside the sandbox, the same errors are normal permissions issues — handle them with the user as you would any other access problem.

A sandbox blocks a tool from a path it expects to write (a cache, log file, lockfile), a host it expects to reach, or an env var it expects to read. The right reflex is to **surface the gap**, not route around it. Same pattern when the Edit tool fails — see [edit-failures](edit-failures.md).

## Why this matters

Working around a sandbox block hides a real configuration gap. The same friction will recur in every future session, and the workaround can be subtly wrong: routing logs to `$TMPDIR` loses them on reboot; pointing a cache at a per-session dir defeats caching; setting a tool's "alternate" config path silently diverges from the user's real setup. The user's sandbox config is the source of truth — a block is a signal to update it, not bypass it.

## Hard rules

- **Don't invent flag/env workarounds to bypass a sandbox block.** `--log-file`, `--cache-dir`, `XDG_CACHE_HOME`, `TMPDIR`, `HOME=`, etc. are not "fixes" — they're hacks that mask the gap.
- **Don't relocate a tool's cache, store, or state directory** to a sandbox-writable path just to make a command pass.
- **Don't disable a tool's logging, telemetry, or safety features** purely to dodge a write or network attempt.
- **Don't retry the same blocked operation** hoping a different invocation slips through.

## What to do instead

1. Stop. Identify exactly what was blocked: which path, host, or env var, and which tool needed it.
2. Explain the block to the user in one short message. Offer two paths:
    - **Update the sandbox** — name the specific path or host that should be added to the allowlist, and why it's safe (or not). Long-term fix; preferred when the access is benign and recurring.
    - **Run it yourself** — give the user the exact command(s) to run outside the sandbox, then continue from their result. Right when the access is sensitive, one-off, or the sandbox shouldn't grow to accommodate it.
3. Wait for the user to choose. Don't proceed on assumption.

## Tool-provided overrides

Some tools have first-class config knobs that are *meant* to be set per-project — `PREK_HOME`, `CARGO_TARGET_DIR`, project-local `.tool-versions`, etc. These can be legitimate, but only use them with **explicit user buy-in for this project**, and prefer setting them in a checked-in config file (so the choice is visible) rather than as a one-shot env var on a single command. If you're not sure whether the override is conventional or a hack, ask.

## Network blocks

Same pattern for network: if a tool tries to reach a host the sandbox doesn't allow, surface it. Don't reach for `--offline`, `--no-network`, vendored mirrors, or alternative registries to dodge the block. The user may want the host added, may want to run it themselves, or may want to reconsider the dependency entirely.

## Package manager specifics

Package managers raise the stakes — they have global stores, checksums, and signature verification that protect every project on the machine. Bypassing those to get past a sandbox block can contaminate the user's system in ways that destroy machines, get them fired, or compromise other projects.

**Always** stop and ask before:

- rebuilding a global store or cache
- relocating a global store or cache to a different path
- changing global settings in a package manager's config
- bypassing built-in checksum or signature verification

Local rebuilds are a different story — wiping `node_modules` to recover from a broken install is fine. The line is whether the action affects state shared across projects or the system at large.

When the user asks you to add new dependencies, think ahead about what else you'll need so they can add them in one go, rather than hitting the same friction repeatedly. Briefly explain why non-obvious packages are needed (for shadcn/ui or Zod no explanation needed; ancillary integration libraries should be justified).
