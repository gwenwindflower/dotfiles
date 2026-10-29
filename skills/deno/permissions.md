# Permissions

Permissions in `deno.json` are documentation: a reader should tell at a glance what each task touches. Grant the narrowest set the code needs.

## Scoped flags

Scope every flag to paths, hosts, commands, or variables:

```json
"tasks": {
  "fetch-feed": "deno run --allow-net=api.example.com --allow-write=./out cli.ts fetch-feed",
  "build": "deno run --allow-read=. --allow-write=./dist cli.ts build",
  "release": "deno run --allow-read --allow-run=git,gh --allow-env=HOME,GITHUB_TOKEN cli.ts release"
}
```

- `--allow-run` always names the binaries. A bare `--allow-run` is equivalent to full access, since a subprocess escapes the sandbox.
- `--allow-env` names the variables when the set is known.
- `-A` / `--allow-all` is reserved for dependencies that genuinely need everything, such as Playwright launching a browser. Add a one-line note in the README saying why.
- Shebangs carry the same scoped flags: `#!/usr/bin/env -S deno run --allow-read=.`.

## Permission sets

`deno.json` can name permission sets and load them with `-P` (the `default` set) or `-P=<name>`. Use them when several tasks share a long flag list.

```json
{
  "permissions": {
    "default": { "read": ["."] },
    "fetch": { "read": ["."], "net": ["api.example.com"], "write": ["./out"] }
  },
  "tasks": {
    "run": "deno run -P cli.ts",
    "fetch": "deno run -P=fetch cli.ts fetch"
  }
}
```

- The feature is experimental and prints a warning on every run. Prefer scoped flags in single-task projects, where a set adds nothing.
- A `test.permissions` block in `deno.json` makes `deno test` refuse to run without `-P` or explicit flags, so test tasks pass `-P` too.
- Flags passed alongside `-P` add to the set.
