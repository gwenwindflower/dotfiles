# Testing

## Layout

- Tests sit next to the code as `<name>_test.ts`, which `deno test` discovers by default.
- Tests target exported pure functions; the entry point stays thin enough to need little testing. See entry points in [cli](cli.md).
- Each test task grants only what its files need. When suites need different permissions, split them into `test:<suite>` tasks and add the [test-runner](test-runner.md).
- Use `Deno.test` with `@std/assert`. Use `describe`/`it` from `@std/testing/bdd` only when the project's tests already do.

## Patterns

Group sub-cases with steps rather than many top-level tests:

```typescript
Deno.test("parser", async (t) => {
  await t.step("parses key=value", () => {/* ... */});
  await t.step("ignores blank lines", () => {/* ... */});
});
```

Resolve fixtures against the module so tests pass from any working directory:

```typescript
const fixture = new URL("./fixtures/sample.json", import.meta.url);
const data = JSON.parse(await Deno.readTextFile(fixture));
```

Split one test file across permission-scoped tasks with `--filter` on a naming convention:

```json
"test:rules-allow": "deno test --allow-read --filter '/ → allow$/' rules_test.ts",
"test:rules-deny": "deno test --allow-read --filter '/ → deny$/' rules_test.ts"
```

## Gotchas

- Snapshots from `@std/testing/snapshot` refresh with `deno test --allow-read --allow-write -- --update`; the flag goes after `--`, and writing snapshots needs write permission.
- Restore every `spy` or `stub` from `@std/testing/mock` in `finally`, or use `using` so it restores on scope exit. A leaked stub breaks later tests in the same file.
- Deno's sanitizers fail a test that leaves timers, open resources, or pending ops behind. Close files, clear intervals, and consume or cancel response bodies instead of disabling the sanitizer.
