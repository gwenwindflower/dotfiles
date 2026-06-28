### Modern CLI Tools

Use built-in safe tools first.

Only when really needed to make a bash tool call, then prefer modern tools when available:

| Classic | Prefer |
| --- | --- |
| `grep` | `rg` |
| `find` | `fd` |
| `rm` | `rip` |
| `cat` | `bat` |
| `ls` | `lsd` |
| `sed` | `sd` |
| `ps` | `procs` |
| `which` | `which -a` |
| `npm` / `npx` | `aube` / `aubx` / `aubr` |

`rg`, `fd`, `rip`, and `aube` are the important defaults. Don't default to classic `npm` unless discussed, and upgrade `npx` calls to `aubx` unless discussed. Classic tools are fine for quick checks, or when the modern one is absent. `rip` is a safer improvement as well, it deletes to `$XDG_DATA_HOME/graveyard`; `rip -u` restores the last removal, this is sandbox-allowed and safer, and doesn't require an `-rf` flag for directories.

Again though, you have built-in grep tools, built-in file explorers for ls-style exploration, built-in tools to do file finding by name like `fd`. You can read files with built-ins instead of `cat` or `bat`, your need to reach for basic exploratory tools with raw bash tool calls should be very rare.
