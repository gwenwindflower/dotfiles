# Command Reference

Official source: <https://developers.notion.com/cli/reference/commands.md>

## Global Flags and Env

| Item | Use |
| --- | --- |
| `-v`, `--verbose` | Show source chains and full error details. |
| `--workers-config-file <path>` | Override Workers config lookup. |
| `-V`, `--version` | Print CLI version. |
| `-h`, `--help` | Print help. |
| `NOTION_WORKERS_CONFIG_FILE` | Same as `--workers-config-file`. |
| `NOTION_WORKSPACE_ID` | Select workspace and skip prompt. |

## API

```bash
ntn api <path>
ntn api ls
```

Use [API requests](api-requests.md) for inline body syntax.

## Pages

```bash
ntn pages get <page-id>
ntn pages get <page-id> --json
ntn pages create --parent page:<id> --content <markdown>
ntn pages edit <page-id> --content <markdown>
ntn pages edit <page-id> --allow-deleting-content
ntn pages trash <page-id>
```

`pages create` reads stdin when `--content` is omitted. Parent refs are `page:<id>`, `database:<id>`, or `data-source:<id>`.

## Data Sources

```bash
ntn datasources resolve <database-id>
ntn datasources query <data-source-id>
ntn datasources query <data-source-id> --limit 50
ntn datasources query <data-source-id> --start-cursor <cursor>
ntn datasources query <data-source-id> --sort "Priority desc"
ntn datasources query <data-source-id> --filter '<json>'
ntn datasources query <data-source-id> --filter-file filter.json
```

`--notion-version <version>` is also settable as `NOTION_API_VERSION`.

## Files

```bash
ntn files create < ./file.png
ntn files create --external-url https://example.com/file.png
ntn files create --json < ./file.png
ntn files create --plain < ./file.png
ntn files get <upload-id>
ntn files list
```

## Workers

Most Workers commands support `--json`, `--plain`, and `--worker-id <id>`.

```bash
ntn workers new [directory]
ntn workers deploy
ntn workers deploy --local-build
ntn workers deploy --no-git
ntn workers list
ntn workers get [worker-id]
ntn workers create --name <name>
ntn workers delete [worker-id]
ntn workers exec <key> -d '<json>'
ntn workers exec <key> --stream
ntn workers exec <key> --local
ntn workers capabilities list
ntn workers tui
```

Syncs:

```bash
ntn workers sync status [capability-key]
ntn workers sync trigger <key>
ntn workers sync pause <key>
ntn workers sync resume <key>
ntn workers sync state get <key>
ntn workers sync state reset <key>
```

Env, OAuth, runs, webhooks:

```bash
ntn workers env set KEY=value
ntn workers env list
ntn workers env unset KEY
ntn workers env pull
ntn workers env push
ntn workers oauth start <key>
ntn workers oauth token <key>
ntn workers oauth show-redirect-url
ntn workers runs list
ntn workers runs logs <run-id>
ntn workers webhooks list [worker-id]
```
