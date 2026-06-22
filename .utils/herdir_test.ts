import { assertEquals } from "@std/assert";
import {
  buildEnsurePlan,
  ensureManifest,
  type HerdirManifest,
  type HerdrRunner,
  jsonArray,
  parseManifestYaml,
  renderSnapshotYaml,
  snapshotSessionManifest,
  type StoredSessionConfig,
  writeSessionSnapshot,
} from "./herdir.ts";

const HOME = "/Users/winnie";

function storedMap(
  entries: Record<string, StoredSessionConfig | undefined>,
): Map<string, StoredSessionConfig | undefined> {
  return new Map(Object.entries(entries));
}

Deno.test("parseManifestYaml expands paths and defaults tabs", () => {
  const manifest = parseManifestYaml(
    `
sessions:
  - name: testing_herdir
    workspaces:
      - path: ~/dev/example
`,
    HOME,
  );

  assertEquals(manifest, {
    sessions: [{
      name: "testing_herdir",
      workspaces: [{
        path: "/Users/winnie/dev/example",
        name: undefined,
        tabs: [{
          name: undefined,
          path: "/Users/winnie/dev/example",
          panes: [],
        }],
      }],
    }],
  });
});

Deno.test("parseManifestYaml defaults pane split settings", () => {
  const manifest = parseManifestYaml(
    `
sessions:
  - name: testing_herdir
    workspaces:
      - path: ~/dev/example
        tabs:
          - name: tests
            panes:
              - path: ~/dev/example/tests
`,
    HOME,
  );

  assertEquals(manifest.sessions[0].workspaces[0].tabs[0].panes[0], {
    name: undefined,
    path: "/Users/winnie/dev/example/tests",
    split: "right",
    ratio: undefined,
  });
});

Deno.test("buildEnsurePlan ignores matching layout and extras", () => {
  const manifest = parseManifestYaml(
    `
sessions:
  - name: testing_herdir
    workspaces:
      - path: ~/dev/example
        tabs:
          - name: codex
            path: ~/dev/example
`,
    HOME,
  );

  const plan = buildEnsurePlan(
    manifest,
    storedMap({
      testing_herdir: {
        workspaces: [{
          custom_name: null,
          identity_cwd: "/Users/winnie/dev/example",
          tabs: [
            {
              custom_name: "codex",
              panes: { "1": { cwd: "/Users/winnie/dev/example" } },
            },
            {
              custom_name: "extra",
              panes: { "2": { cwd: "/tmp/extra" } },
            },
          ],
        }, {
          custom_name: "extra-workspace",
          identity_cwd: "/tmp/extra",
          tabs: [],
        }],
      },
    }),
  );

  assertEquals(plan, []);
});

Deno.test("buildEnsurePlan creates missing workspace tab and pane", () => {
  const manifest = parseManifestYaml(
    `
sessions:
  - name: testing_herdir
    workspaces:
      - path: ~/dev/example
        tabs:
          - name: codex
            path: ~/dev/example
            panes:
              - path: ~/dev/example/server
                split: down
                ratio: 0.4
`,
    HOME,
  );

  const plan = buildEnsurePlan(
    manifest,
    storedMap({ testing_herdir: undefined }),
  );

  assertEquals(plan, [
    { type: "session", session: "testing_herdir" },
    {
      type: "workspace",
      session: "testing_herdir",
      workspacePath: "/Users/winnie/dev/example",
      workspaceName: undefined,
    },
    {
      type: "tab",
      session: "testing_herdir",
      workspacePath: "/Users/winnie/dev/example",
      workspaceName: undefined,
      tabPath: "/Users/winnie/dev/example",
      tabName: "codex",
    },
    {
      type: "pane",
      session: "testing_herdir",
      workspacePath: "/Users/winnie/dev/example",
      workspaceName: undefined,
      tabPath: "/Users/winnie/dev/example",
      tabName: "codex",
      panePath: "/Users/winnie/dev/example/server",
      paneName: undefined,
      split: "down",
      ratio: 0.4,
    },
  ]);
});

Deno.test("buildEnsurePlan creates only a missing pane inside an existing tab", () => {
  const manifest = parseManifestYaml(
    `
sessions:
  - name: testing_herdir
    workspaces:
      - path: ~/dev/example
        tabs:
          - name: codex
            path: ~/dev/example
            panes:
              - path: ~/dev/example/server
`,
    HOME,
  );

  const plan = buildEnsurePlan(
    manifest,
    storedMap({
      testing_herdir: {
        workspaces: [{
          identity_cwd: "/Users/winnie/dev/example",
          tabs: [{
            custom_name: "codex",
            panes: { "1": { cwd: "/Users/winnie/dev/example" } },
          }],
        }],
      },
    }),
  );

  assertEquals(plan, [{
    type: "pane",
    session: "testing_herdir",
    workspacePath: "/Users/winnie/dev/example",
    workspaceName: undefined,
    tabPath: "/Users/winnie/dev/example",
    tabName: "codex",
    panePath: "/Users/winnie/dev/example/server",
    paneName: undefined,
    split: "right",
    ratio: undefined,
  }]);
});

Deno.test("buildEnsurePlan treats a missing tab root as covering same-path pane", () => {
  const manifest = parseManifestYaml(
    `
sessions:
  - name: testing_herdir
    workspaces:
      - path: ~/dev/example
        tabs:
          - name: codex
            path: ~/dev/example
            panes:
              - path: ~/dev/example
`,
    HOME,
  );

  const plan = buildEnsurePlan(
    manifest,
    storedMap({
      testing_herdir: {
        workspaces: [{
          identity_cwd: "/Users/winnie/dev/example",
          tabs: [],
        }],
      },
    }),
  );

  assertEquals(plan, [{
    type: "tab",
    session: "testing_herdir",
    workspacePath: "/Users/winnie/dev/example",
    workspaceName: undefined,
    tabPath: "/Users/winnie/dev/example",
    tabName: "codex",
  }]);
});

Deno.test("jsonArray reads common herdr response shapes", () => {
  assertEquals(jsonArray({ result: { workspaces: [1, 2] } }, ["workspaces"]), [
    1,
    2,
  ]);
  assertEquals(jsonArray({ tabs: ["a"] }, ["tabs"]), ["a"]);
  assertEquals(jsonArray(["x"], ["sessions"]), ["x"]);
});

Deno.test("snapshotSessionManifest distills stored session JSON", () => {
  const snapshot = snapshotSessionManifest("testing_herdir", {
    workspaces: [{
      custom_name: "api",
      identity_cwd: "/Users/winnie/dev/example",
      tabs: [{
        custom_name: "codex",
        root_pane: 1,
        layout: {
          Split: {
            direction: "Vertical",
            ratio: 0.4,
            first: { Pane: 1 },
            second: { Pane: 2 },
          },
        },
        panes: {
          "1": { cwd: "/Users/winnie/dev/example" },
          "2": { cwd: "/Users/winnie/dev/example/server" },
        },
      }],
    }],
  }, HOME);

  assertEquals(snapshot, {
    sessions: [{
      name: "testing_herdir",
      workspaces: [{
        name: "api",
        path: "~/dev/example",
        tabs: [{
          name: "codex",
          path: "~/dev/example",
          panes: [{
            path: "~/dev/example/server",
            split: "down",
            ratio: 0.4,
          }],
        }],
      }],
    }],
  });
});

Deno.test("renderSnapshotYaml emits editable herdir YAML", () => {
  const yaml = renderSnapshotYaml({
    sessions: [{
      name: "testing_herdir",
      workspaces: [{ path: "~/dev/example" }],
    }],
  });

  assertEquals(
    yaml,
    `sessions:
  - name: testing_herdir
    workspaces:
      - path: ~/dev/example
`,
  );
});

Deno.test("writeSessionSnapshot writes session YAML to output dir", async () => {
  const dir = await Deno.makeTempDir();
  try {
    const sessionsDir = `${dir}/sessions`;
    const snapshotDir = `${dir}/snapshots`;
    await Deno.mkdir(`${sessionsDir}/testing_herdir`, { recursive: true });
    await Deno.writeTextFile(
      `${sessionsDir}/testing_herdir/session.json`,
      JSON.stringify({
        workspaces: [{
          identity_cwd: "/Users/winnie/dev/example",
          tabs: [{
            panes: { "1": { cwd: "/Users/winnie/dev/example" } },
          }],
        }],
      }),
    );

    const outputPath = await writeSessionSnapshot({
      sessionName: "testing_herdir",
      sessionsDir,
      snapshotDir,
      home: HOME,
    });

    assertEquals(outputPath, `${snapshotDir}/testing_herdir.yaml`);
    assertEquals(
      await Deno.readTextFile(outputPath),
      `sessions:
  - name: testing_herdir
    workspaces:
      - path: ~/dev/example
        tabs:
          - path: ~/dev/example
`,
    );
  } finally {
    await Deno.remove(dir, { recursive: true });
  }
});

class FakeRunner implements HerdrRunner {
  calls: string[][] = [];
  constructor(private responses: unknown[]) {}

  runJson(args: string[]): Promise<unknown> {
    this.calls.push(args);
    return Promise.resolve(this.responses.shift() ?? {});
  }
}

Deno.test("ensureManifest dry-run returns the plan without herdr calls", async () => {
  const dir = await Deno.makeTempDir();
  try {
    const manifest: HerdirManifest = {
      sessions: [{
        name: "testing_herdir",
        workspaces: [{
          path: "/Users/winnie/dev/example",
          tabs: [{ path: "/Users/winnie/dev/example", panes: [] }],
        }],
      }],
    };
    const runner = new FakeRunner([]);
    const plan = await ensureManifest(manifest, {
      sessionsDir: dir,
      runner,
      dryRun: true,
    });

    assertEquals(plan.map((step) => step.type), [
      "session",
      "workspace",
      "tab",
    ]);
    assertEquals(runner.calls, []);
  } finally {
    await Deno.remove(dir, { recursive: true });
  }
});

Deno.test("ensureManifest creates missing workspace tab and pane additively", async () => {
  const dir = await Deno.makeTempDir();
  try {
    const manifest = parseManifestYaml(
      `
sessions:
  - name: testing_herdir
    workspaces:
      - path: ~/dev/example
        tabs:
          - name: codex
            path: ~/dev/example
            panes:
              - path: ~/dev/example/server
                split: down
`,
      HOME,
    );
    const runner = new FakeRunner([
      { result: { workspaces: [] } },
      { result: { workspace: { id: "1" } } },
      { result: { tabs: [] } },
      { result: { tab: { id: "1:1" }, root_pane: { pane_id: "1-1" } } },
      { result: { pane: { pane_id: "1-2" } } },
    ]);

    const plan = await ensureManifest(manifest, {
      sessionsDir: dir,
      runner,
    });

    assertEquals(plan.map((step) => step.type), [
      "session",
      "workspace",
      "tab",
      "pane",
    ]);
    assertEquals(runner.calls, [
      [
        "--session",
        "testing_herdir",
        "workspace",
        "list",
      ],
      [
        "--session",
        "testing_herdir",
        "workspace",
        "create",
        "--cwd",
        "/Users/winnie/dev/example",
        "--no-focus",
      ],
      [
        "--session",
        "testing_herdir",
        "tab",
        "list",
        "--workspace",
        "1",
      ],
      [
        "--session",
        "testing_herdir",
        "tab",
        "create",
        "--workspace",
        "1",
        "--cwd",
        "/Users/winnie/dev/example",
        "--no-focus",
        "--label",
        "codex",
      ],
      [
        "--session",
        "testing_herdir",
        "pane",
        "split",
        "1-1",
        "--direction",
        "down",
        "--cwd",
        "/Users/winnie/dev/example/server",
        "--no-focus",
      ],
    ]);
  } finally {
    await Deno.remove(dir, { recursive: true });
  }
});
