---
name: bun-development
description: Use when editing files in a Bun project (bun.lock or bun.lockb at the root, "packageManager":"bun..." in package.json, or imports from bun:*) or running bun/bunx commands. Covers Bun-native APIs, bun:test, bun build --compile, the Bun-optimized tsconfig, and full-stack HTML imports with Bun.serve routes.
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

For HTML entrypoints and route-based handlers (`import page from "./index.html"` → `serve({ routes })`), see [full-stack HTML](fullstack-html.md). That's the recommended shape for any app that serves both HTML and APIs.

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

- [Bun docs](https://bun.sh/docs) · [HTML & static bundling](https://bun.com/docs/bundler/html-static) · [Full-stack](https://bun.com/docs/bundler/fullstack)
- [Elysia](https://elysiajs.com/) · [Hono](https://hono.dev/) — Bun-friendly server frameworks
