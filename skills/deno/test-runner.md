# Multi-suite test runner

A runner that discovers every `test:*` task in `deno.json`, runs each as a suite, and reports across all of them in compact, verbose, or plain output. It ships as [assets/test.ts](assets/test.ts), with no dependency beyond `@std/fmt/colors`.

Add it when a project splits tests into several tasks with different permissions and plain `deno test` output turns into a wall. One or two test files don't need it.

The dotfiles repo's `.utils/scripts/test.ts` is the canonical copy and runs against about twenty suites. Improve it there, then copy it to `skills/deno/assets/test.ts`.

## Setup

1. Copy `assets/test.ts` into the project's `scripts/` directory.
2. Add the import and wire the runner and suites in `deno.json`. Each suite gets only the permissions its files need:

   ```json
   {
     "imports": {
       "@std/fmt/colors": "jsr:@std/fmt@^1/colors"
     },
     "tasks": {
       "test": "deno run --allow-read --allow-run=deno scripts/test.ts",
       "test:unit": "deno test --allow-read unit_test.ts",
       "test:io": "deno test --allow-read --allow-write io_test.ts",
       "test:net": "deno test --allow-read --allow-net=api.example.com net_test.ts"
     }
   }
   ```

3. Run it:

   ```bash
   deno task test           # all suites, compact
   deno task test -v        # full deno test output per suite
   deno task test io        # suites whose label contains "io"
   deno task test:io        # one suite directly, without the runner
   ```

Adding a suite is adding a `test:<label>` task; the runner needs no edit.

## Behavior

- **Discovery:** every task starting with `test:` except `test:run` becomes a suite, labeled with the part after the prefix. Positional arguments filter by label substring; no match exits 1.
- **Execution:** suites run serially through `deno task <name>`, so each pays its own startup cost. Use `deno test --watch` for a tight inner loop.
- **Output mode:** `-v` or `--verbose` prints each suite's full output under a header. Otherwise a TTY gets a spinner and progress bar with one line per suite, and a non-TTY (CI) gets one plain line per suite.
- **Results:** counts come from regex parsing of the `N passed | M failed` summary and `... FAILED` lines in `parseOutput`. A suite that exits non-zero with no parsable results counts as one process-error failure. The exit code is 1 when any suite fails.
- **Header:** shows the `deno.json` `name` with its JSR scope stripped, or `deno` when there is no name.

## Customizing

- Spinner frames, bar glyphs, and widths are constants at the top of the file.
- Suite matching is `label.includes(filter)` in `main`.
- A project with custom test reporters updates the regexes in `parseOutput`.
