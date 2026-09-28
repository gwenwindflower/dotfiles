# rem

`rem` reads and writes Apple Reminders through EventKit on macOS. Each call finishes in well under a second, so the cost is the agent round trip: pass several IDs to one command and chain independent reads with `;` in one shell call. This reference matches rem 0.12; check `rem <command> --help` before relying on a flag.

EventKit is unreachable inside the sandbox, and the error reads `access denied` with Mach error 4099. Run `rem` outside the sandbox through the harness's own mechanism, and never read an access error as an empty list.

## Commands

| Command | Does |
| --- | --- |
| `rem today` | Incomplete reminders due today or overdue |
| `rem overdue` | Incomplete reminders past due |
| `rem upcoming --days N` | Reminders due in the next N days (default 7) |
| `rem list` (`ls`) | Reminders, filtered by `--list`, `--incomplete`, `--completed`, `--flagged`, `--due-before`, `--due-after`, `--search` |
| `rem search "<query>"` | Title and notes match, filtered by `--list` and `--incomplete` |
| `rem show <id>` (`get`) | One reminder's full record |
| `rem lists` | Every list; `--count` adds per-list totals |
| `rem stats` | Totals, overdue count, completion rate, per-list breakdown |
| `rem add "<title>"` | Creates a reminder |
| `rem update <id>` (`edit`) | Changes fields or moves the reminder to another list |
| `rem complete` (`done`), `rem uncomplete` | Sets status on one or more IDs |
| `rem flag`, `rem unflag` | Sets the flag on one or more IDs |
| `rem delete <id>...` (`rm`) | Deletes; prompts unless `--force` |
| `rem export`, `rem import <file>` | JSON or CSV out and in |
| `rem list-mgmt` (`lm`) | `create`, `rename`, and `delete` lists |

`rem list` lists reminders and `rem lists` lists lists. rem has no section commands; sections exist only in Reminders.app.

Interactive forms (`-i`, `rem interactive`, `rem delete -i`) need a TTY, so pass flags instead. `rem skills` installs rem's bundled agent skill; leave it alone, since skills here come from `gh skill`.

## Output and IDs

Every command takes `-o table|json|plain`. Use `-o json` whenever the output gets parsed and `-o plain` for a readable summary. `--no-color` or `NO_COLOR=1` strips color, and `REM_NO_UPDATE_CHECK=1` keeps the background update check out of scripted output.

- Reminder records use snake_case keys: `id`, `name`, `body` (the notes), `list_name`, `completed`, `flagged`, `priority`, `priority_label`, `due_date`, `remind_me_date`, `alarms`, `creation_date`, `modification_date`.
- List records from `rem lists` use PascalCase keys: `ID`, `Name`, `Count`, `Color`, `IsShared`, `SharedToMe`, `IsOwnedByMe`.
- Empty fields are omitted, so a missing `body` means no notes. Tags, URLs, recurrence, and location triggers are settable but may not show in JSON; check `rem show <id> -o json` on a record that has one before depending on a key.
- Datetimes are local wall-clock time with no offset (`2026-09-17T19:00:00`). Never reinterpret them as UTC.

`id` is the full UUID. Tables show its first 8 characters as the short ID, and any unique prefix works as an argument. Store full IDs and show short IDs to the user. `rem add -o json` returns the created record; capture its `id` before any follow-up write.

Commands address lists by name (`--list "Groceries"`), not by `ID`. Two lists with the same name in different accounts are ambiguous, so check `rem lists -o json` before any command that takes a name. `rem add` without `--list` lands in the system default list; name the list explicitly.

## Creating and editing

| Flag | Command | Sets |
| --- | --- | --- |
| `--list`, `-l` | add, update | List by name; on `update` it moves the reminder |
| `--due`, `-d` | add, update | Due date and time; `none` clears |
| `--remind-me`, `-r` | add, update | Alarm as `15m`, `1h`, `2d` before due, or an absolute time; `none` clears |
| `--silent` | add | Skips the automatic alarm at the due time |
| `--priority`, `-p` | add, update | `high`, `medium`, `low`, `none` |
| `--notes`, `-n` | add, update | Notes; replaces the whole body on `update` |
| `--url`, `-u` | add, update | The native URL field; `--url ""` clears |
| `--tags`, `-t` | add | Comma-separated native tags |
| `--add-tags`, `--remove-tags` | update | Comma-separated native tags |
| `--flagged` | add (`-F`), update | Flag on; `rem unflag` clears |
| `--repeat` | add, update | `daily`, `weekly`, `monthly`, `yearly`, `'weekly on mon,wed,fri'`; `none` clears |
| `--location`, `--radius`, `--on-leave` | add, update | Geofence alarm, on arrival by default; `--location none` clears |
| `--title`, `-t` | update | New title |

- Short flags collide across commands: `-t` is `--tags` on `add` but `--title` on `update`, and `-f` is `--force` on `update` and `delete` but `--format` on `export`. Write long flags in scripts.
- `--notes` on `update` replaces the entire body. Read the current `body` first and send it back with the change.
- Pass priority as a word. JSON `priority` uses Apple's inverted scale (1 is highest, 0 is none), so read `priority_label` instead.
- Tags and flags go through Apple's private ReminderKit API. When it's unavailable, rem still writes the reminder, drops the tag or flag, and warns on stderr; check stderr and re-read.
- A `#word` in a title becomes a native tag and stays in the title text, on `add` and on `update --title`. Pure numbers like `#42` stay plain text. Strip or keep hashtags on purpose when a title comes from another system.
- `--location` takes decimal `lat,lng` only; rem does no geocoding. Ask for the coordinates of personal places rather than guessing. Geofences fire only when Location Services is on for Reminders.
- `--remind-me` and `--location` manage separate alarms, and clearing one keeps the other.

## Dates

A reminder has one date: the due date, set with `--due`. Reminders has no start or scheduled date, and the alarm (`remind_me_date`) is separate from the due date.

- `--due` on `add` attaches an alarm at the due time. `--silent` skips it and `--remind-me` moves it. Never pass `--remind-me 0m` to turn notifications on; they're already on.
- Forms without a time get one. `today`, `tomorrow`, weekday names, `next week` (next Monday), and month-day forms (`mar 15`) resolve to 9:00 AM. `eod` is 5:00 PM today, `eow` is 5:00 PM next Friday (skipping today if it's Friday), `this week` is Sunday 11:59 PM, and `next month` is the 1st at 9:00 AM.
- A bare time (`5pm`, `17:00`) means today, or tomorrow once that time has passed.
- Other accepted forms: `now`, `in 3 days`, `2 hours ago`, `monday 2pm`, `next fri at 3:30pm`, `tomorrow at 3:30pm`, `2026-02-15`, `2026-02-15 14:30`, `02/15/2026`, `Feb 15, 2026`, and `15 Feb 2026`.
- No `--due` form is guaranteed to stay date-only, and `--silent` removes the alarm without removing the time. A date-only reminder made in Reminders.app reads back as `T00:00:00` with no alarms. Read the result with `rem show <id> -o json` when the difference matters.
- Resolve relative phrases against `date` output, never memory. When the exact day matters, compute the ISO date and pass that. `--due-before` and `--due-after` take the same grammar.

## Recipes

```bash
echo "== OVERDUE =="; rem overdue -o plain; echo "== TODAY =="; rem today -o plain; echo "== NEXT 3 DAYS =="; rem upcoming --days 3 -o plain
rem add "Buy oat milk" --list Groceries --due "2026-10-02 17:00" --silent -o json | jq -r '.id'
rem list --list Chores --incomplete -o json | jq -r '.[] | "\(.id[0:8]) \(.name)"'
rem show "$reminder_id" -o json | jq '{name, list_name, due_date, remind_me_date, body}'
rem complete "$first_id" "$second_id"
rem update "$reminder_id" --due none
```

## Moving between lists

`rem update <id> --list "<name>"` moves a reminder and keeps its ID. A move to or from a shared list (`IsShared` or `SharedToMe` in `rem lists -o json`) copies the reminder into the target and deletes the original, so the ID changes and collaborators see both actions. rem prompts before that move and errors without a TTY unless given `--force`. Confirm with the user first, pass `--force`, then re-resolve the ID from the stderr warning or `rem list --list "<name>" -o json`.

## Safety

- Individual changes are routine when requested: create, edit, complete or reopen, change dates, move between established lists, and delete the named reminder. Confirm identity with `rem show <id> -o json` before editing or deleting, since a prefix or title match can hit the wrong record.
- Review a batch (several reminders, a loop, or an import) as one change set before running it, listing each ID and field change.
- `rem delete` prompts; pass `--force` only for reminders the user named. Before a deletion that loses data worth keeping, export it with `rem export --list <name> --format json --output-file <path>`. An export doesn't capture every Apple field, so treat it as a record, not a guaranteed restore.
- `rem import` creates new reminders every time. It is not an upsert, and replaying an export duplicates everything. Run `--dry-run` first; `--list` sends every item to one list.
- `rem list-mgmt` changes run only on explicit request. `rem list-mgmt delete` removes every reminder in the list.
