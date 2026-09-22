const decoder = new TextDecoder();
const skillDir = decodeURIComponent(new URL("../", import.meta.url).pathname);
const buildScript = decodeURIComponent(
  new URL("./build.ts", import.meta.url).pathname,
);
const templatePath = await resolveTemplatePath();

async function resolveTemplatePath(): Promise<string> {
  for (
    const relativePath of [
      "../exact_assets/template.html",
      "../assets/template.html",
    ]
  ) {
    const path = decodeURIComponent(
      new URL(relativePath, import.meta.url).pathname,
    );
    try {
      await Deno.stat(path);
      return path;
    } catch (error) {
      if (!(error instanceof Deno.errors.NotFound)) throw error;
    }
  }
  throw new Error("template.html not found");
}

function assertIncludes(actual: string, expected: string): void {
  if (!actual.includes(expected)) {
    throw new Error(`expected output to include ${JSON.stringify(expected)}`);
  }
}

function assertExcludes(actual: string, expected: string): void {
  if (actual.includes(expected)) {
    throw new Error(`expected output to exclude ${JSON.stringify(expected)}`);
  }
}

interface BuildResult {
  success: boolean;
  stderr: string;
  html: string;
}

async function runBuild(markdown: string): Promise<BuildResult> {
  const tempDir = await Deno.makeTempDir({
    prefix: "markdown-interactive-docs-",
  });
  const sourcePath = `${tempDir}/queue.md`;
  const outputPath = `${tempDir}/dist/queue.html`;

  try {
    await Deno.writeTextFile(sourcePath, markdown);
    const result = await new Deno.Command(Deno.execPath(), {
      args: [
        "run",
        `--allow-read=${skillDir},${tempDir}`,
        `--allow-write=${tempDir}`,
        buildScript,
        sourcePath,
        "-t",
        templatePath,
        "-o",
        outputPath,
      ],
      stdout: "piped",
      stderr: "piped",
    }).output();

    return {
      success: result.success,
      stderr: decoder.decode(result.stderr),
      html: result.success ? await Deno.readTextFile(outputPath) : "",
    };
  } finally {
    await Deno.remove(tempDir, { recursive: true });
  }
}

async function build(markdown: string): Promise<string> {
  const result = await runBuild(markdown);
  if (!result.success) throw new Error(result.stderr);
  return result.html;
}

async function buildFailure(markdown: string): Promise<string> {
  const result = await runBuild(markdown);
  if (result.success) throw new Error("expected build to fail");
  return result.stderr;
}

Deno.test("named tiers render filters and tiered items", async () => {
  const html = await build(`---
title: Platform work queue
eyebrow: Q3 planning
footer: Platform operations
---

# Platform work queue

Planned work grouped by urgency.

## Tiers: Urgency

1. **Immediate** — Resolve before other work.
2. **Soon** — Complete in the current cycle.
3. **Backlog** — Revisit when capacity permits.

## Reliability — Active work

### API — Platform

#### OPS-142 — Restore request tracing [t1] [Owner: API]

Trace requests across service boundaries.
`);

  assertIncludes(html, `<div class="tiers">`);
  assertIncludes(html, `<span class="lbl">Urgency</span>`);
  assertIncludes(html, `aria-label="Filter by Urgency"`);
  assertIncludes(html, `data-tier="1"`);
  assertIncludes(html, `<span class="tier-badge t1">`);
});

Deno.test("documents can omit tiers", async () => {
  const html = await build(`---
title: Incident runbook
eyebrow: Operations
footer: Acme reliability
---

# Incident runbook

Steps for coordinating a service incident.

## Response — First actions

### Coordination — Incident lead

#### COMMS-1 — Open the incident channel

Create one shared place for updates and decisions.
`);

  assertIncludes(html, `<h1>Incident runbook</h1>`);
  assertExcludes(html, `<div class="tiers">`);
  assertExcludes(html, `aria-label="Filter by`);
});

Deno.test("internal tags exclude leaves and heading subtrees", async () => {
  const html = await build(`---
title: Release plan
eyebrow: Q3 launch
footer: Acme platform
---

# Release plan

Visible introduction.

Private planning note. #internal

## Delivery — Public milestones

### Application — Platform

#### REL-1 — Publish the release candidate

- Keep this public.
- Hide this bullet. #internal

##### Internal checklist #internal

- Secret child item.

##### Acceptance criteria

- Public child item.

#### REL-2 — Private follow-up #internal

Secret item body.

#### REL-3 — Announce availability

Public item body.

## Internal appendix #internal

### Hidden block

#### Hidden item

Secret appendix content.

## Contacts

Escalation contacts remain public.
`);

  assertIncludes(html, "Visible introduction.");
  assertIncludes(html, "Keep this public.");
  assertIncludes(html, `<section class="item-group">`);
  assertIncludes(html, `<h5>Acceptance criteria</h5>`);
  assertIncludes(html, "Public child item.");
  assertIncludes(html, "Announce availability");
  assertIncludes(html, "Escalation contacts remain public.");
  assertExcludes(html, "Private planning note.");
  assertExcludes(html, "Hide this bullet.");
  assertExcludes(html, "Internal checklist");
  assertExcludes(html, "Secret child item.");
  assertExcludes(html, "Private follow-up");
  assertExcludes(html, "Secret item body.");
  assertExcludes(html, "Internal appendix");
  assertExcludes(html, "Secret appendix content.");
  assertExcludes(html, "#internal");
});

Deno.test("list headers must use h5 headings", async () => {
  const error = await buildFailure(`---
title: Dashboard guide
eyebrow: Reference
footer: Acme analytics
---

# Dashboard guide

## Explore — Dashboards

### Navigation — Viewer

#### DB-1 — Read a dashboard

- **Work with dashboards**
- Open a dashboard and understand what you are looking at.
`);

  assertIncludes(error, "list headers must use `##### Heading`");
});
