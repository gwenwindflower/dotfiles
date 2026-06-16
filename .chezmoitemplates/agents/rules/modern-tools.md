### Modern CLI Tools

Use built-in safe tools first. In shell, prefer modern tools when available:

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

`rg`, `fd`, `rip`, and `aube` are the important defaults. Classic tools are fine for quick checks when the modern one is absent. `rip` deletes to `$XDG_DATA_HOME/graveyard`; `rip -u` restores the last removal.
