---
name: notion-cli
description: Use the Notion CLI `ntn` for authenticated Notion API requests, pages, data sources, file uploads, and Notion Workers. Use when the user asks to run or script `ntn`, inspect Notion API endpoints, create or edit Notion content from the terminal, or deploy and operate Notion Workers.
allowed-tools:
  - WebFetch(domain:developers.notion.com)
  - Bash(ntn *)
---

# Notion CLI

`ntn` is the official Notion CLI. Prefer it over hand-written HTTP calls when the task can use CLI auth, endpoint discovery, inline request bodies, page Markdown commands, file uploads, or Workers commands.

Assume `ntn` is installed and authenticated when the user asks for Notion CLI work. Do not install, update, configure completions, run login flows, or inspect auth files. If a command fails because the CLI or auth is missing, report the exact command and error; the user fixes local setup.

## Docs

Load only what the task needs:

- [API requests](api-requests.md) — `ntn api`, inline body syntax, query params, endpoint discovery, debugging.
- [content commands](content-commands.md) — pages, data sources, file uploads, and when to drop to `ntn api`.
- [workers](workers.md) — scaffold, deploy, exec, syncs, env vars, OAuth, runs, logs, webhooks.
- [command reference](command-reference.md) — compact command and flag map.

Use official Markdown docs for drift checks:

```text
https://developers.notion.com/cli/get-started/overview.md
https://developers.notion.com/cli/reference/commands.md
https://developers.notion.com/llms.txt
```

## Defaults

- Use `--json` for machine parsing and `--plain` for shell scripts that need stable tab-separated fields.
- Use `-v` or `--verbose` when diagnosing CLI failures.
- Use `NOTION_WORKSPACE_ID=<id>` for a one-command workspace override.
- Use `--notion-version` or `NOTION_API_VERSION` only when the user needs a specific API version.
- For destructive commands, preserve CLI confirmations unless the user explicitly asks for unattended execution.
