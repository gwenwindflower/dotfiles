# Exploration

Before kicking off expensive research — Explore agents, multi-call WebFetch, deep file crawls — check what's already available. Skills first, then docs sources the user has set up.

## Skills before Explore

If you've decided independently to run Explore or enter Plan Mode (i.e., the user didn't explicitly ask for it), look at the available Skills *first*. Sessions often end with research being captured into a Skill — your needed context may already be one load away. Token-intensive crawls are materially expensive; don't repeat work that's already preserved.

If no Skills look promising, proceed with research as planned — and capture the learning into a Skill or project context file at the end.

## Searching docs

Training data goes stale quickly for actively developed libraries. For syntax, version, or framework specifics, **always check the docs** instead of answering from memory. Idiomatic-language questions are fine to answer from training; "is this the right syntax in current Next.js?" is not.

Order of operations:

1. **Context7 CLI (`ctx7`)** — fastest path for popular tools and frameworks. Continually re-indexed.
    - `bunx ctx7 library <name> "<query>"` — resolve a library to a Context7 id
    - `bunx ctx7 docs <id> "<query>"` — semantic search within that library's docs
    - If `ctx7 whoami` shows logged-out, alert the user.
2. **WebFetch** the actual docs URL when you have one. Returns AI-friendly markdown when the site supports it.
3. **WebSearch** to locate docs, tutorials, or Q&A threads when you don't have a URL.
4. **`curl`** is a last resort. You have dedicated tools for this.

> [!IMPORTANT]
> Context7 also offers Agent Skills installation — **do not use it for that**. Use `rei` (the reishi CLI) instead. Context7's installer puts skills in an inaccessible location.
