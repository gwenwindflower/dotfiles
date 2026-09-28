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
