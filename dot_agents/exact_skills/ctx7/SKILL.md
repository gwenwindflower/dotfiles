---
name: context7-cli
description: Use the ctx7 CLI to fetch library documentation, manage AI coding skills, and configure Context7 MCP. Activate when the user mentions "ctx7" or "context7", needs current docs for any library, wants to install/search/generate skills, or needs to set up Context7 for their AI coding agent.
---

# ctx7 CLI

The Context7 CLI does three things: fetches up-to-date library documentation, manages AI coding skills, and sets up Context7 MCP for your editor. We do not use anything related to the last two, we only use the open semantic docs search tool via CLI.

> [!IMPORTANT]
> ctx7 has a bunch of functionality focused on installing and managing Agent Skills, we do *NOT* use this tool for managing skills, do not run these commands they will be blocked automatically. ctx7 is only for searching docs.

Make sure the CLI is up to date before running commands:

```bash
ctx7 --help
# if not available try brew first
brew install ctx7
# if on a system without brew, you're likely on a Linux dev sandbox
# skip global install and use pnpx
pnpx ctx7@latest <library | docs>
```

> [!IMPORTANT]
> Only use the CLI. It may encourage you to install the MCP server — do *NOT* do this. The MCP server adds a bunch of wasteful overhead and auto-loaded docs for the large swaths of the tool we don't use, and generally is slower and clunkier than using the CLI directly.

## Quick Reference

```bash
# Documentation
ctx7 library <name> <query>           # Step 1: resolve library ID
ctx7 docs <libraryId> <query>         # Step 2: fetch docs
```

## Common Mistakes

- We do not use any functionality that requires login or auth — searching docs is an open API, so we do not need to mess with login for anything, and do not have an account to login to
- Library IDs require a `/` prefix — `/facebook/react` not `facebook/react`
- Always run `ctx7 library` first — `ctx7 docs react "hooks"` will fail without a valid ID
