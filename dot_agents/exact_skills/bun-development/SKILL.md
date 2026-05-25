---
name: bun-development
description: Use when editing files in a Bun project (bun.lock or bun.lockb at the root, "packageManager":"bun..." in package.json, or imports from bun:*) or running bun/bunx commands. Covers Bun-native APIs, bun:test, bun build --compile, and the Bun-optimized tsconfig.
---

# Bun Development

> [!IMPORTANT]
> In Claude Code's sandbox, `bun` and `bunx` bypass `$TMPDIR` and hit a blocked darwin temp path (see `~/.claude/tmpdirs.md`). For one-off package execution use `pnpx`; for a JS runner prefer `pnpm`. Reach for `bun` only when the project mandates it, and expect `bun install`/`bun test` to need user-side execution outside the sandbox.

## Lockfile signals

Bun ≥ 1.1.45 writes text `bun.lock` by default; older projects have binary `bun.lockb`. Either at the repo root signals a Bun project. CI/reproducible installs: `bun install --frozen-lockfile`.

## Prefer Bun-native APIs

| Need | Use | Not |
| --- | --- | --- |
| Read/write files | `Bun.file(p).text()` / `Bun.write(p, data)` | `fs.readFile`/`writeFile` |
| HTTP server | `Bun.serve({ fetch })` (or Elysia, Hono) | Express, Fastify |
| SQLite | `import { Database } from "bun:sqlite"` | `better-sqlite3` |
| Password hash | `Bun.password.hash` / `.verify` | `bcrypt`, `argon2` |
| Hi-res time | `Bun.nanoseconds()` | `process.hrtime()` |
| Resolve module | `Bun.resolveSync(spec, dir)` | `require.resolve` |
| Env vars | `Bun.env.X` / `process.env.X` — `.env` auto-loaded | `dotenv` |

`node:*` modules work for compat — reach for them only when no Bun-native exists.

## Bun.serve

```typescript
const server = Bun.serve({
  port: 3000,
  fetch(req, server) {
    const url = new URL(req.url);
    if (url.pathname === "/ws" && server.upgrade(req)) return;
    return Response.json({ ok: true });
  },
  websocket: {
    open(ws) { ws.send("hi"); },
    message(ws, msg) { ws.send(`echo: ${msg}`); },
  },
  error(err) { return new Response(err.message, { status: 500 }); },
});
```

Returning `undefined` after `server.upgrade(req)` completes the WebSocket handshake.

## bun:test

Jest-compatible API, runs `.ts` natively with no transform:

```typescript
import { describe, it, expect, mock, spyOn, beforeAll } from "bun:test";

const mockFn = mock((x: number) => x * 2);
mockFn(5);
expect(mockFn).toHaveBeenCalledWith(5);

const spy = spyOn(obj, "method").mockReturnValue("stub");
```

CLI: `bun test`, `--watch`, `--coverage`, `--grep <pat>`, `--timeout <ms>`.

## Build and compile

```bash
# Bundle
bun build ./src/index.ts --outdir ./dist --target browser --minify --sourcemap

# Standalone binary (cross-compile)
bun build ./src/cli.ts --compile --outfile myapp
bun build ./src/cli.ts --compile --target=bun-linux-x64    --outfile myapp-linux
bun build ./src/cli.ts --compile --target=bun-darwin-arm64 --outfile myapp-mac
bun build ./src/cli.ts --compile --embed ./assets --outfile myapp
```

Programmatic:

```typescript
const result = await Bun.build({
  entrypoints: ["./src/index.ts"],
  outdir: "./dist",
  target: "browser",        // "browser" | "bun" | "node"
  minify: true,
  sourcemap: "external",
  splitting: true,
  format: "esm",
  external: ["react"],
  define: { "process.env.NODE_ENV": JSON.stringify("production") },
});
if (!result.success) console.error(result.logs);
```

## Full-stack HTML bundles

Bun ≥ 1.3.10 takes `.html` files as bundler entrypoints — it traces `<script type="module" src="./x.ts">`, `<link rel="stylesheet">`, CSS imported from JS/TS, and `url()` references inside CSS. Pair it with `--compile --target=browser` to emit one self-contained HTML with every asset inlined as a `data:` URI (woff2 fonts from `@fontsource/*` work out of the box). Replaces Vite + `vite-plugin-singlefile` for iframe widgets, MCP App resources, and other single-file SPAs.

```bash
bun build --compile --target=browser ./src/app.html --outfile ./dist/app.html
```

```html
<!-- src/app.html — the entry; Bun walks the graph from here -->
<!DOCTYPE html>
<link rel="stylesheet" href="./app.css">
<script type="module" src="./app.ts"></script>
<div id="root"></div>
```

```typescript
// src/app.ts — CSS imports fold into the same bundle
import "@fontsource/inter/400.css";
import "./component.css";
```

> [!CAUTION]
> Plain `bun build --html` (without `--compile --target=browser`) emits sibling JS/CSS chunks, not one file. The single-file behavior comes from `--compile --target=browser` against an HTML entry, added in Bun 1.3.10 (April 2026). No third-party inliner needed — `vite-plugin-singlefile`, `inline-source`, `posthtml-inline-assets` are all obsolete for this case.

## tsconfig baseline

```json
{
  "compilerOptions": {
    "lib": ["ESNext"],
    "target": "ESNext",
    "module": "Preserve",
    "moduleResolution": "bundler",
    "moduleDetection": "force",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "noEmit": true,
    "strict": true,
    "skipLibCheck": true,
    "jsx": "react-jsx",
    "types": ["bun"]
  }
}
```

Pair `"types": ["bun"]` with `@types/bun` as a devDependency. The legacy `bun-types` package is superseded.

## Watch vs hot

- `bun --watch <file>` restarts the process on change — short scripts.
- `bun --hot <file>` keeps the process alive and hot-swaps modules — long-running servers.

## Resources

- [Bun docs](https://bun.sh/docs)
- [Elysia](https://elysiajs.com/) · [Hono](https://hono.dev/) — Bun-friendly server frameworks
