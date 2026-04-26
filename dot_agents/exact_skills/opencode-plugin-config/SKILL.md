---
name: opencode-plugin-config
description: Author OpenCode plugins to automate actions tied to events (formatters after edits, pre-commit scripts, etc.). Use when adding or modifying OpenCode plugins. Skip for Claude Code automations (use claude-code-hooks-config).
---

# OpenCode Plugin Configuration

1. Fetch the latest docs: <https://opencode.ai/docs/plugins>
2. Refine the type of plugin you need to create: a hook that runs a script, a custom tool, a logger that prints structured output to the client interface, etc.
3. Determine scope: is this a user-level plugin (in `~/.opencode/plugins`) that would accelerate every project, or a project-level plugin with highly specific details (in `<project root>/.opencode/plugins`)?
4. Build the plugin in TypeScript with bun as the target runtime. Use bun for quick iteration and testing if necessary, before moving on to testing the integration with OpenCode.
