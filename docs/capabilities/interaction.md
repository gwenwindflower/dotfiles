# Interaction

The three terminal interfaces should feel consistent enough that editing, submitting, navigating, and monitoring work do not depend on remembering a different interaction model for each agent.

## Expected behavior

- `return` inserts a newline in the composer; modified return submits.
- Common Vim-style and terminal navigation keys work where the harness exposes remapping.
- Parent and child sessions are easy to navigate during delegated work.
- Status surfaces show useful execution context such as model, reasoning, branch state, task progress, context use, limits, or approval posture.
- Completion and input-needed notifications reach the terminal environment.
- Themes and code presentation remain readable and consistent with the broader Catppuccin-based setup.

## Safety boundary

Interaction settings improve control and visibility but do not alter task authority. A convenient submit binding, notification, or session switch never implies approval for the underlying action.

## Platform implementations

| Platform | Mechanism | Coverage |
| --- | --- | --- |
| Claude Code | Keybindings, fullscreen TUI, status line command, Vim editor mode, notifications, and theme | Most context-sensitive keybinding model. |
| Codex | TUI keymaps, status line fields, desktop preferences, notifications, and themes | Covers composer, pager, list, desktop, and long-running task behavior. |
| OpenCode | TUI keymaps, child-session navigation, message navigation, and theme | Closely matches composer and navigation intent; status and notification surfaces differ. |

## Verification

- Multiline input and submission use the same mental model in each interface.
- Delegated child sessions can be reached and exited without losing the parent context.
- The active interface exposes enough state to understand what is running and whether approval is constrained.
