### Using tools

Always use your built-in default safe tools first when available. Only use shell tools when needed. When you do, prefer modern tools when available and look for language-specific tools for validation and formatting before writing one-off scripts.

#### Language-specific tools

Prefer language tools already on `PATH` from Neovim's Mason installs over one-off validation or formatting scripts (for example, `tombi` for TOML, `biome` for JSON, or `ty` and `ruff` for Python are all available). You shouldn't need to write a script to validate config files unless they're in an unusual format.

#### Modern tools

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

`rg`, `fd`, `rip`, and `aube` are the important defaults. Don't default to classic `npm` unless discussed, and when you see `npx` calls in docs, prefer `aubx` unless discussed. Falling back to `pnpm` as the `npm` replacement is fine when `aube` is unavailable. For project-scoped or tool-specific work, use the project's designated package manager (`bun` or `deno` should be used if that's the preferred runtime for the project or the user asks for it, don't override that). `rip` should be preferred to `rm` when available, it deletes to `$XDG_DATA_HOME/graveyard`; `rip -u` restores the last removal in case of mistakes. This is sandbox-allowed and safer, and doesn't require an `-rf` flag for directories.

Again though, you have built-in tools to grep, run ls-style exploration, do `fd`-style finding, edit, and browse the web without `curl`. Your need to use bash tool calls for exploration and editing should be limited to more advanced tasks.
