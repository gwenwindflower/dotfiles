# Deno Tools Patterns Reference

Patterns for both single-file utilities and Cliffy CLIs. Pick what fits — don't import a framework for a script that doesn't need one.

## Argv parsing

### `@std/cli/parse-args` (lightweight)

For single-purpose scripts with a handful of flags:

```typescript
import { parseArgs } from "@std/cli/parse-args";

const flags = parseArgs(Deno.args, {
  string: ["output"],
  boolean: ["verbose"],
  default: { output: "./out", verbose: false },
  alias: { o: "output", v: "verbose" },
});
// flags.output: string, flags.verbose: boolean
```

No help text, no subcommands — but zero overhead.

### Cliffy `Command` (multi-command CLIs)

```typescript
import { Command } from "@cliffy/command";

const cli = new Command()
  .name("mytool")
  .version("0.1.0")
  .description("What the tool does");

cli
  .command("build")
  .description("Build the project")
  .option("-o, --output <path:string>", "Output directory", { default: "./dist" })
  .option("-w, --watch [watch:boolean]", "Watch mode")
  .example("Basic", "mytool build")
  .action(async ({ output, watch }) => {
    await doBuild(output, watch);
  });

await cli.parse(Deno.args);
```

#### Option types

Cliffy infers TypeScript types from the annotation:

```typescript
.option("-p, --port <port:number>", "Port number")        // number
.option("-n, --name <name:string>", "Name")                // string
.option("-v, --verbose [verbose:boolean]", "Verbose mode") // boolean | undefined
.option("-t, --tags <tags:string[]>", "Tags list")         // string[]
```

`<required>` must be provided; `[optional]` may be omitted; `{ default: value }` removes the `| undefined` from the inferred type.

#### Nested commands

```typescript
const db = new Command()
  .description("Database operations")
  .command("migrate", "Run migrations").action(async () => { /* ... */ })
  .command("seed", "Seed data").action(async () => { /* ... */ });

cli.command("db", db);
```

#### Global options

```typescript
const cli = new Command()
  .globalOption("-q, --quiet [quiet:boolean]", "Suppress output")
  .action(function () { this.showHelp(); });
```

#### Lazy imports for heavy deps

When a subcommand depends on something heavy (Playwright, Puppeteer, large npm packages), dynamic-import it inside the action so unrelated commands stay fast:

```typescript
cli
  .command("scrape")
  .description("Scrape data (requires Chrome)")
  .action(async ({ output }) => {
    const { scrape } = await import("./commands/scrape.ts");
    await scrape(output);
  });
```

Critical when the dep reads env vars or spawns processes at import time.

#### Error handling

```typescript
.action(async (options) => {
  try {
    await doWork(options);
  } catch (err) {
    console.error(`❌ ${(err as Error).message}`);
    Deno.exit(1);
  }
});
```

## Module structure

### `import.meta.main` guard

Lets the file be imported by tests without executing the script body:

```typescript
export async function run(args: string[]): Promise<number> {
  // ...returns exit code
}

if (import.meta.main) {
  Deno.exit(await run(Deno.args));
}
```

Returning an exit code from `run` (rather than calling `Deno.exit` inside it) keeps the function testable.

### Separating logic from I/O

```typescript
// lib/transform.ts — pure, no Deno.* calls
export function transform(input: string): string { /* ... */ }

// cli.ts — does the I/O
import { transform } from "./lib/transform.ts";
const input = await Deno.readTextFile(Deno.args[0]);
console.log(transform(input));
```

Tests target `lib/` directly. The CLI shell stays so thin it barely needs testing.

## Testing

### Basic `Deno.test`

```typescript
import { assertEquals, assertThrows } from "@std/assert";
import { transform } from "./transform.ts";

Deno.test("transform uppercases input", () => {
  assertEquals(transform("hi"), "HI");
});

Deno.test("transform throws on empty", () => {
  assertThrows(() => transform(""), Error, "empty");
});
```

### BDD style

If existing tests use it, match the style:

```typescript
import { describe, it } from "@std/testing/bdd";
import { assertEquals } from "@std/assert";

describe("transform", () => {
  it("uppercases input", () => {
    assertEquals(transform("hi"), "HI");
  });
});
```

### Test steps for sub-cases

```typescript
Deno.test("parser", async (t) => {
  await t.step("parses key=value", () => { /* ... */ });
  await t.step("ignores blank lines", () => { /* ... */ });
});
```

### Async tests

`Deno.test` accepts async functions natively — no special wrapper:

```typescript
Deno.test("reads file", async () => {
  const text = await Deno.readTextFile("./fixture.txt");
  assertEquals(text.trim(), "expected");
});
```

Tests that touch the filesystem need `--allow-read` in the test task.

### Snapshot testing

```typescript
import { assertSnapshot } from "@std/testing/snapshot";

Deno.test("renders correctly", async (t) => {
  await assertSnapshot(t, render(input));
});
```

Run with `deno test -- --update` to refresh snapshots.

### Mocking and spies

```typescript
import { spy, stub } from "@std/testing/mock";

const consoleSpy = spy(console, "log");
try {
  doThing();
  assertEquals(consoleSpy.calls.length, 1);
} finally {
  consoleSpy.restore();
}
```

Always `restore()` in a `finally` block — leaked stubs poison later tests.

### Fixtures

Keep test fixtures in `tests/fixtures/` and read them with `import.meta.resolve` so paths work regardless of CWD:

```typescript
const fixturePath = new URL("./fixtures/sample.json", import.meta.url);
const data = JSON.parse(await Deno.readTextFile(fixturePath));
```

## deno.json task integration

```json
{
  "tasks": {
    "cli":    "deno run --allow-all cli.ts",
    "build":  "deno run --allow-read=. --allow-write=./dist cli.ts build",
    "deploy": "deno run --allow-all cli.ts deploy",
    "test":   "deno test --allow-read=.",
    "check":  "deno check cli.ts",
    "fmt":    "deno fmt --check",
    "lint":   "deno lint"
  }
}
```

Pass extra flags through tasks with `--`: `deno task build -- --watch --output ./custom`.

## npm interop

```json
{
  "imports": { "handlebars": "npm:handlebars@^4.7.8" },
  "nodeModulesDir": "auto"
}
```

Set `"nodeModulesDir": "auto"` when an npm package reads its own files from disk (templates, assets, partials). Without it, packages using `__dirname` or `fs.readFileSync` relative to install path will fail.

## Shebang for direct execution

```typescript
#!/usr/bin/env -S deno run --allow-read=.
```

Then `chmod +x script.ts` and run as `./script.ts`. Keep the embedded permission flags as tight as the script actually needs.
