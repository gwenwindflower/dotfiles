# Custom Test Runner

A discoverable, multi-suite test runner with three output modes (compact / verbose / plain). Use it when a project has enough test files that `deno test` produces a wall of output, or when per-file permission scoping splits tests across multiple `test:*` tasks.

The runner ships as an asset: [`assets/test.ts`](assets/test.ts) (~330 lines, no external deps beyond `@std/fmt/colors`). Copy it into the project's `scripts/` directory.

## When to use it

- The project has 5+ test files, each needing different `--allow-*` flags
- You want a clean overview when running locally and structured output in CI
- You want to filter which suites run (`deno task test sync` → only `test:sync*` suites)

For a project with one or two test files, plain `deno test` is fine. Don't add the runner until you feel the friction.

## Setup

1. Copy `assets/test.ts` (target path `~/.claude/skills/deno-tools/assets/test.ts`, chezmoi source `dot_agents/skills/deno-tools/assets/test.ts`) into the project's `scripts/` directory.

2. Add `@std/fmt` to imports in `deno.json`:

   ```json
   "imports": {
     "@std/fmt/colors": "jsr:@std/fmt@^1/colors"
   }
   ```

3. Wire the runner and per-suite tasks in `deno.json`. The runner discovers any task starting with `test:`:

   ```json
   "tasks": {
     "test":      "deno run --allow-read --allow-run=deno scripts/test.ts",
     "test:unit": "deno test --allow-read unit_test.ts",
     "test:io":   "deno test --allow-read --allow-write io_test.ts",
     "test:net":  "deno test --allow-read --allow-net=api.example.com net_test.ts"
   }
   ```

4. Run it:

   ```bash
   deno task test           # compact, all suites
   deno task test -v        # verbose
   deno task test io        # filter to suites whose label includes "io"
   ```

## How it works

1. **Discovery** — reads `deno.json`, picks out every `test:*` task. Adding a new suite is just adding a new task; no runner edit needed.
2. **Execution** — spawns `deno task <name>` for each suite, captures stdout/stderr.
3. **Parsing** — extracts `N passed | M failed` summaries and any `... FAILED` test names from the output.
4. **Output** — three modes auto-selected:
   - **Compact** (TTY, default): spinner per suite, progress bar, one-line result.
   - **Verbose** (`-v`): full `deno test` output with section headers per suite.
   - **Plain** (non-TTY, e.g. CI): no animation, one line per suite.

Exit code is 1 if any suite has failed tests or process-level errors.

## Customizing

- **Header label** — pulled from the `name` field in `deno.json` (with any JSR scope stripped). Falls back to `"deno"` if absent.
- **Spinner / bar / colors** — constants at the top of the file. Easy to swap for project branding.
- **Suite filter** — the matching is `label.includes(filter)`. Change to startsWith, regex, etc. as needed.
- **Output parsing regexes** — at `parseOutput`. The current pair handles standard `deno test` output; if you customize reporters, update accordingly.

## Tradeoffs

- **No parallelism.** Suites run serially. This is intentional — interleaved output is hard to read, and most Deno test suites are fast enough that serial total time is fine. If a project genuinely needs parallel suites, swap the loop in `main` for `Promise.all`.
- **Spawn overhead.** Each suite is a fresh `deno task` invocation, so cold-start cost is per-suite, not amortized. For tight inner loops, drop the runner and use `deno test --watch` directly.
- **Output parsing is regex-based.** Resilient to current Deno output but not future-proof. If `deno test` changes its summary format, `parseOutput` is the one place to update.
