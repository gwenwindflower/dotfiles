# Scripts and CLIs

## Picking the shape

| Shape | When |
| --- | --- |
| Single-file script | One job, no subcommands. `script.ts` with a shebang and `@std/cli/parse-args` for flags. |
| Multi-file utility | Logic worth extracting into `lib/` behind a thin entry point. Still no subcommands. |
| Cliffy CLI | Two or more subcommands, or typed options with generated help. |

Don't reach for Cliffy until there are subcommands; a script with three flags uses `parseArgs`.

## Project skeleton

Even a single script gets a `deno.json`:

```json
{
  "tasks": {
    "run": "deno run --allow-read=. script.ts",
    "test": "deno test --allow-read=.",
    "check": "deno check script.ts",
    "fmt": "deno fmt",
    "lint": "deno lint"
  },
  "imports": {
    "@std/cli": "jsr:@std/cli@^1",
    "@std/assert": "jsr:@std/assert@^1"
  }
}
```

A Cliffy CLI adds `"@cliffy/command": "jsr:@cliffy/command@^1"` and this layout:

```text
project/
├── cli.ts              # wires up commands
├── commands/
│   ├── build.ts        # export async function build(...)
│   └── deploy.ts
├── lib/                # pure helpers, the main test target
├── tests/fixtures/
└── deno.json
```

Pass extra flags through a task with `--`: `deno task build -- --watch`.

## Argv parsing

```typescript
import { parseArgs } from "@std/cli/parse-args";

const flags = parseArgs(Deno.args, {
  string: ["output"],
  boolean: ["verbose"],
  default: { output: "./out", verbose: false },
  alias: { o: "output", v: "verbose" },
});
```

## Entry points

Export a `run` that returns an exit code, and exit only inside the `import.meta.main` guard. Tests call `run` directly.

```typescript
export async function run(args: string[]): Promise<number> {
  // ...
  return 0;
}

if (import.meta.main) {
  Deno.exit(await run(Deno.args));
}
```

Keep `Deno.*` I/O in the entry point and pure transforms in `lib/`.

## Cliffy

```typescript
import { Command } from "@cliffy/command";

await new Command()
  .name("mytool")
  .version("0.1.0")
  .description("What the tool does")
  .globalOption("-q, --quiet", "Suppress output")
  .action(function () {
    this.showHelp();
  })
  .command("build", "Build the project")
  .option("-o, --output <path:string>", "Output directory", { default: "./dist" })
  .option("-w, --watch", "Watch mode")
  .action(async ({ output, watch }) => {
    const { build } = await import("./commands/build.ts");
    await build(output, watch);
  })
  .parse(Deno.args);
```

- Types come from the annotation (`<n:number>`, `<tags:string[]>`). `<required>` must be given, `[optional]` may be omitted, and `{ default }` drops `| undefined` from the inferred type.
- Nest a group by building a separate `Command` and mounting it: `cli.command("db", dbCommand)`.
- Dynamic-import heavy dependencies (Playwright, large npm packages) inside the action so other subcommands start fast. This matters most when the dependency reads env or spawns processes at import time.
- Catch errors in the action, print the message with context, and exit 1 rather than letting a stack trace reach the user.

## npm interop

Use npm only when no `@std/*` or JSR package fits; npm imports don't carry over to Ende.

```json
{
  "imports": { "handlebars": "npm:handlebars@^4" },
  "nodeModulesDir": "auto"
}
```

Set `"nodeModulesDir": "auto"` when a package reads its own files from disk (templates, partials, assets) through `__dirname` or `fs`; it fails without a real `node_modules`.

## Small gotchas

- Read stdin with `await new Response(Deno.stdin.readable).text()`.
- A shebang script needs `-S` to pass flags: `#!/usr/bin/env -S deno run --allow-read=.`, then `chmod +x`.
