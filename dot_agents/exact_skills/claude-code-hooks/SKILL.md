---
name: claude-code-hooks
description: Configure Claude Code hooks in settings.json (PreToolUse, PostToolUse, SessionStart, Stop, etc.). Use when adding or debugging Claude Code hooks, or automating actions tied to Claude tool events. Skip for OpenCode automations (use opencode-plugin-config).
---

# Adding or Modifying Hooks for Claude Code

Hooks allow specific behaviors or scripts to trigger automatically after highly configurable events.

1. Review the general hooks guide: <https://code.claude.com/docs/en/hooks-guide>
2. Review the in-depth hooks configuration docs: <https://code.claude.com/docs/en/hooks>
3. Edit the project-level `.claude/settings.json`, either adding, editing, or expanding the `hooks` property to achieve the goal. It's important to do this at the project level, unless the user specifically asks you to add a system-wide hook at the user level (`~/.claude/settings.json`), which is less common.
4. Work with the user to trigger the target event(s) and confirm it's working as expected.
