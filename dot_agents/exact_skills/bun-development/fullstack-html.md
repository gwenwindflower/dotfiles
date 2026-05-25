# Full-Stack HTML and `Bun.serve` Routes

Bun's bundler treats HTML files as first-class entrypoints. Import an HTML file in server code and pass it to `Bun.serve({ routes })`; Bun scans `<script>` and `<link>` tags, bundles JS/TS/JSX/CSS, content-hashes assets, and rewrites the HTML to reference the built artifacts. The same `routes` object mixes HTML entrypoints and API handlers, so a single `serve()` call is a complete full-stack app.

## Routes object

```typescript
import { serve } from "bun";
import { Database } from "bun:sqlite";
import homepage from "./public/index.html";
import dashboard from "./public/dashboard.html";

const db = new Database("app.db");

serve({
  routes: {
    "/": homepage,
    "/dashboard": dashboard,

    "/api/users": {
      async GET() {
        return Response.json(db.query("SELECT * FROM users").all());
      },
      async POST(req) {
        const { name, email } = await req.json();
        const row = db
          .query("INSERT INTO users (name, email) VALUES (?, ?) RETURNING *")
          .get(name, email);
        return Response.json(row, { status: 201 });
      },
    },

    "/api/users/:id": async req => {
      const user = db.query("SELECT * FROM users WHERE id = ?").get(req.params.id);
      return user
        ? Response.json(user)
        : Response.json({ error: "Not found" }, { status: 404 });
    },
  },

  development: { hmr: true, console: true },
});
```

- HTTP method handlers: `GET`, `POST`, `PUT`, `DELETE`, etc. A bare function handles any method.
- Dynamic segments: `:paramName` → `req.params.paramName`.
- Wildcards: `/*`.

## HTML transformation

Input HTML written for the bundler:

```html
<link rel="stylesheet" href="./reset.css" />
<link rel="stylesheet" href="./styles.css" />
<script type="module" src="./my-app.tsx"></script>
```

Becomes:

```html
<link rel="stylesheet" href="/index-[hash].css" />
<script type="module" src="/index-[hash].js"></script>
```

All asset paths (`<img>`, `<picture>`, `<video>`, `<audio>`, `<source>`, local `href`) resolve relative to the HTML file and get content-hashed.

## Quick dev server (no server code)

For prototypes — just point `bun` at HTML:

```bash
bun ./index.html              # SPA: single file is fallback for all paths
bun ./index.html ./about.html # MPA: each file mounted at its slug
bun ./**/*.html               # glob; routes derived from longest common prefix
bun ./index.html --console    # stream browser console to terminal
```

Interactive keys while the dev server runs: `o⏎` open browser, `c⏎` clear console, `q⏎` or `Ctrl+C` quit.

## Development vs production

`development: { hmr, console }` in `Bun.serve`:

- SourceMap headers, no minification, re-bundle per request, HMR, browser console streamed to terminal.

`development: false` (runtime production mode):

- In-memory caching, lazy bundle on first `.html` hit, `Cache-Control` + `ETag`, minification.

`bun build` (ahead-of-time, recommended for production):

```bash
bun build --target=bun --production --outdir=dist ./src/server.ts
```

Bun detects HTML imports in server code and emits a manifest the bundled `Bun.serve()` uses to serve assets — no runtime bundling needed.

For pure-static deploys (no server code), bundle the HTML directly:

```bash
bun build ./index.html --minify --outdir=dist
bun build ./index.html --minify --outdir=dist --env=PUBLIC_*
```

Standalone single-file HTML with everything inlined:

```bash
bun build --compile --target=browser ./index.html --outdir=dist
```

## `bunfig.toml` for static/full-stack

```toml
[serve.static]
plugins = ["bun-plugin-tailwind"]
env = "PUBLIC_*"
```

- `plugins` — array of plugin module specifiers; loaded for both the dev server and HTML routes inside `Bun.serve`.
- `env` — glob of env var names to inline at build time as `process.env.NAME` (literal references only; `import.meta.env` is not rewritten). `PUBLIC_*` is the conventional safe scope.

Runtime equivalent for `bun build`:

```typescript
await Bun.build({
  entrypoints: ["./index.html"],
  outdir: "./dist",
  env: "PUBLIC_*",
  minify: true,
});
```

## Tailwind

```bash
bun add tailwindcss bun-plugin-tailwind
```

```toml
# bunfig.toml
[serve.static]
plugins = ["bun-plugin-tailwind"]
```

Reference once — pick one of:

```html
<link rel="stylesheet" href="tailwindcss" />
```

```css
@import "tailwindcss";
```

```typescript
import "tailwindcss";
```

## Custom plugin

```typescript
import type { BunPlugin } from "bun";

const plugin: BunPlugin = {
  name: "json5-loader",
  setup(build) {
    build.onLoad({ filter: /\.json5$/ }, async args => {
      const text = await Bun.file(args.path).text();
      return { contents: `export default ${JSON.stringify(text)};`, loader: "js" };
    });
  },
};

export default plugin;
```

```toml
[serve.static]
plugins = ["./plugins/json5-loader.ts"]
```

## HTMLRewriter at build time

`Bun.build` accepts plugins (the CLI `bun build` does not yet). Pair with the built-in `HTMLRewriter` to preprocess HTML:

```typescript
await Bun.build({
  entrypoints: ["./index.html"],
  outdir: "./dist",
  minify: true,
  plugins: [
    {
      name: "lowercase-html",
      setup({ onLoad }) {
        const rewriter = new HTMLRewriter().on("*", {
          element(el) { el.tagName = el.tagName.toLowerCase(); },
        });
        onLoad({ filter: /\.html$/ }, async args => ({
          contents: rewriter.transform(await Bun.file(args.path).text()),
          loader: "html",
        }));
      },
    },
  ],
});
```

## Gotchas

- HTML-as-route imports require running on Bun — `node` can't resolve the `.html` import.
- `bun build` CLI doesn't accept plugins yet; use `Bun.build` programmatically when you need them.
- Only `process.env.NAME` literal accesses are inlined — destructuring or dynamic lookups stay runtime.
- In Claude Code's sandbox, the dev server's file watching and bundler temp dirs hit the same `confstr` darwin temp path issue as `bun install` — long-running `bun ./index.html` is user-side, not agent-side.
