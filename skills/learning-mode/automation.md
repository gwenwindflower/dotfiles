# Learning mode automation

Optional project automation uses the name `learning-mode-auto` for both hooks and plugins. It provides reminders after commits; it does not enable learning mode or start an exercise.

Only configure automation when the user asks. Load `agent-config` and check the target agent's current hook or plugin documentation before implementing it.

## Reminder contract

Send this as agent context, never as a user-authored prompt:

> [learning-mode-auto] A commit completed. If learning mode is enabled for this session, follow its offer rules and consider an exercise about the committed work. If the mode is off, the user declined an offer, or two exercises are complete, stay silent. Wait for acceptance before starting an exercise.

The agent owns conversational state: the latest on/off request, declines, and completed exercises. Hook invocations are not exercise offers or completions. An `off` request overrides queued reminders.

## Platform integration

| Agent | Integration |
| --- | --- |
| Claude Code | Project hook at `.claude/hooks/learning-mode-auto.sh`, registered for `PostToolUse` in `.claude/settings.json`; send the reminder through supported additional-context output |
| OpenCode | Project plugin at `.opencode/plugins/learning-mode-auto.ts`, exported as `LearningModeAutoPlugin`; use a supported agent-context channel, never append to the user's input |

Parse structured tool input and check the tool result before identifying a completed commit. Do not match arbitrary output text for `git commit`. If the platform cannot deliver agent context without impersonating user input, leave automation unconfigured and use the session mode directly.

Verify the integration with the mode off, on, turned off after a queued reminder, declined, and at its completion limit. Only the enabled, eligible session should produce an offer.
