# agent-browser

The CLI serves its own usage guides, matched to the installed version. Load the core guide before running any other `agent-browser` command:

```bash
agent-browser skills get core          # workflows, common patterns, troubleshooting
agent-browser skills get core --full   # plus the full command reference and templates
```

Load a specialized guide when the task leaves ordinary web pages:

| Task | Guide |
| --- | --- |
| Exploratory testing, QA, bug hunts | `agent-browser skills get dogfood` |
| Electron desktop apps (VS Code, Slack, Figma) | `agent-browser skills get electron` |
| Slack workspaces | `agent-browser skills get slack` |
| Record a HAR and derive an API client for a site | `agent-browser skills get derive-client` |

`agent-browser skills list` shows every guide the installed version ships. Browser binaries, sockets, sessions, and encryption state live under `~/.agent-browser`.

The observability dashboard runs on port 4848, independent of browser sessions. Session tabs, status, and streams are proxied through the dashboard origin, so session ports never need exposing.

## Running Electron apps: Slack example

Load the `core`, `electron`, and `slack` CLI guides first. A running Electron app must be quit and relaunched for the remote debugging flag to take effect; passing it to an already-running Slack process does not expose CDP.

```bash
osascript -e 'tell application "Slack" to quit'
open -a Slack --args --remote-debugging-port=9222
agent-browser --session slack-desktop connect 9222
agent-browser --session slack-desktop tab
agent-browser --session slack-desktop snapshot -i
```

The desktop webview reuses Slack's signed-in session. If the app already exposes a debugging port, connect directly without relaunching. Use `tab` to select the workspace webview when the app exposes multiple targets.
