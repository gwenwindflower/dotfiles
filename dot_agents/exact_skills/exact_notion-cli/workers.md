# Workers

Official sources:

- <https://developers.notion.com/workers/get-started/overview.md>
- <https://developers.notion.com/workers/get-started/quickstart.md>
- <https://developers.notion.com/cli/reference/commands.md>

Notion Workers are TypeScript programs that export a `Worker` instance and register capabilities: syncs, tools, and webhooks.

## Quick Workflow

```bash
ntn workers new my-worker
cd my-worker
ntn workers deploy
ntn workers exec sayHello -d '{"name":"World"}'
```

`workers deploy` creates a new worker when `workers.json` is missing and updates the existing worker otherwise. `--name <name>` is required when creating and forbidden when updating. Use `--local-build` to build locally instead of in the cloud.

## Worker Resolution

Commands that target a worker resolve the ID in this order:

1. `--worker-id` or positional `<worker-id>`.
2. `workerId` in `workers.json`.

If neither is available, the command exits with an error. Use `--workers-config-file <path>` or `NOTION_WORKERS_CONFIG_FILE` to choose a config file.

## Core Commands

```bash
ntn workers list --json
ntn workers get [worker-id]
ntn workers create --name "Worker name"
ntn workers delete [worker-id]
ntn workers capabilities list
ntn workers tui
```

Preserve the delete confirmation unless the user explicitly asks for `--yes`.

Run a capability:

```bash
ntn workers exec <key> -d '{"input":"value"}'
ntn workers exec <key> --stream
ntn workers exec <key> --local --dotenv .env
```

If `-d/--data` is omitted, `exec` reads JSON from stdin.

## Syncs

```bash
ntn workers sync status [capability-key]
ntn workers sync status --no-watch
ntn workers sync trigger <key>
ntn workers sync trigger <key> --preview
ntn workers sync trigger <key> --context '<json>'
ntn workers sync pause <key>
ntn workers sync resume <key>
ntn workers sync state get <key>
ntn workers sync state reset <key>
```

`--preview` invokes without writing to the target. `--context` passes the cursor from a previous preview's `nextContext`.

## Environment Variables

Values are encrypted remotely and write-only from the CLI; list shows keys only.

```bash
ntn workers env set API_KEY=value OTHER=value
ntn workers env list
ntn workers env unset API_KEY
ntn workers env pull --file .env
ntn workers env pull --no-file
ntn workers env push --file .env
```

Do not print pulled secrets. Be careful with `.env` files in repos and sandbox-denied paths.

## OAuth, Runs, and Webhooks

```bash
ntn workers oauth start <key>
ntn workers oauth token <key> --plain
ntn workers oauth show-redirect-url

ntn workers runs list
ntn workers runs logs <run-id>

ntn workers webhooks list [worker-id]
```

`oauth token` is intended for debugging; treat its output as a secret.
