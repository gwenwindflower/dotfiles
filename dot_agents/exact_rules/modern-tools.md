# Modern CLI Tools

Prefer modern alternatives to classic Unix tools when available — they're faster, have cleaner syntax, and better defaults. Built-in tools (Grep, Read, Edit) already use these under the hood; do the same in raw Bash.

## Replacements

`grep::rg`, `find::fd`, `rm::rip`, `cat::bat`, `ls::lsd`, `sed::sd`, `ps::procs`. Also `pnpm`/`pnpx` over `npm`/`npx` for Node projects (better cache reuse), `which -a` over `which` (lists every match in PATH).

`rg`, `fd`, `rip` are top priority — always use over the classic. The rest are quality-of-life; classic tools are fine for quick checks.

For `pnpm`, *always* use `pnpm` (and `pnpx` / `pnpm dlx`), even if a skill references `npm` (or `npx`) commands. The system is not set up for vanilla `npm`, and at this point in time there's almost nothing that won't work the same or better with `pnpm`.

`rip` deletes to `/tmp/graveyard-$USER`; `rip -u` undoes the last removal. Safer than `rm -rf`.

## Built-ins first

Not exhaustive. When a built-in tool (Read, Grep, Edit, Glob) covers the need, reach for that before shell — they're safer and don't fight the sandbox. Drop to Bash only when no built-in fits.
