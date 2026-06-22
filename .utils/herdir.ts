#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env=HOME --allow-run=herdr

import { Command } from "@cliffy/command";
import { bold, brightGreen, cyan, red, yellow } from "@std/fmt/colors";
import { dirname, fromFileUrl, join, normalize } from "@std/path";
import { parse as parseYaml, stringify as stringifyYaml } from "@std/yaml";

export type SplitDirection = "right" | "down";

export interface PanePreset {
  name?: string;
  path: string;
  split: SplitDirection;
  ratio?: number;
}

export interface TabPreset {
  name?: string;
  path: string;
  panes: PanePreset[];
}

export interface WorkspacePreset {
  name?: string;
  path: string;
  tabs: TabPreset[];
}

export interface SessionPreset {
  name: string;
  workspaces: WorkspacePreset[];
}

export interface HerdirManifest {
  sessions: SessionPreset[];
}

export interface StoredSessionConfig {
  workspaces?: StoredWorkspace[];
}

export interface StoredWorkspace {
  id?: string;
  custom_name?: string | null;
  identity_cwd?: string;
  tabs?: StoredTab[];
}

export interface StoredTab {
  custom_name?: string | null;
  layout?: unknown;
  root_pane?: number;
  panes?: Record<string, StoredPane>;
}

export interface StoredPane {
  cwd?: string;
}

export interface StoredSession {
  name: string;
  config?: StoredSessionConfig;
}

export type EnsureStepType = "session" | "workspace" | "tab" | "pane";

export interface EnsureStep {
  type: EnsureStepType;
  session: string;
  workspacePath?: string;
  workspaceName?: string;
  tabPath?: string;
  tabName?: string;
  panePath?: string;
  paneName?: string;
  split?: SplitDirection;
  ratio?: number;
}

export interface HerdrRunner {
  runJson(args: string[]): Promise<unknown>;
}

const log = {
  info: (m: string) => console.log(`${bold(cyan("[INFO]"))} ${m}`),
  warn: (m: string) => console.log(`${bold(yellow("[WARN]"))} ${m}`),
  error: (m: string) => console.error(`${bold(red("[ERROR]"))} ${red(m)}`),
  success: (m: string) => console.log(`${bold(brightGreen("[OK]"))} ${m}`),
};

const TOOL_DIR = dirname(fromFileUrl(import.meta.url));
const DEFAULT_MANIFEST = join(TOOL_DIR, "herdir.yaml");
const DEFAULT_SNAPSHOT_DIR = join(TOOL_DIR, "assets", "herdir-snapshots");

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function asString(
  value: unknown,
  field: string,
  required = true,
): string | undefined {
  if (typeof value === "string" && value.trim() !== "") return value;
  if (!required && value == null) return undefined;
  throw new Error(`${field} must be a non-empty string`);
}

function asOptionalRatio(value: unknown, field: string): number | undefined {
  if (value == null) return undefined;
  if (typeof value !== "number" || value <= 0 || value >= 1) {
    throw new Error(`${field} must be a number greater than 0 and less than 1`);
  }
  return value;
}

function asSplit(value: unknown, field: string): SplitDirection {
  if (value == null) return "right";
  if (value === "right" || value === "down") return value;
  throw new Error(`${field} must be right or down`);
}

export function expandHome(path: string, home: string): string {
  if (path === "~") return home;
  if (path.startsWith("~/")) return join(home, path.slice(2));
  return path;
}

export function normalizePresetPath(path: string, home: string): string {
  return normalize(expandHome(path, home));
}

export function parseManifestYaml(text: string, home: string): HerdirManifest {
  const root = parseYaml(text);
  if (!isRecord(root)) throw new Error("manifest must be a YAML object");
  const rawSessions = root.sessions;
  if (!Array.isArray(rawSessions)) {
    throw new Error("manifest.sessions must be a list");
  }

  const sessions = rawSessions.map((rawSession, sessionIndex) => {
    const prefix = `sessions[${sessionIndex}]`;
    if (!isRecord(rawSession)) throw new Error(`${prefix} must be an object`);
    const name = asString(rawSession.name, `${prefix}.name`)!;
    if (!Array.isArray(rawSession.workspaces)) {
      throw new Error(`${prefix}.workspaces must be a list`);
    }

    const workspaces = rawSession.workspaces.map((rawWorkspace, wsIndex) => {
      const wsPrefix = `${prefix}.workspaces[${wsIndex}]`;
      if (!isRecord(rawWorkspace)) {
        throw new Error(`${wsPrefix} must be an object`);
      }
      const path = normalizePresetPath(
        asString(rawWorkspace.path, `${wsPrefix}.path`)!,
        home,
      );
      const name = asString(rawWorkspace.name, `${wsPrefix}.name`, false);
      const rawTabs = Array.isArray(rawWorkspace.tabs)
        ? rawWorkspace.tabs
        : [{ path }];

      const tabs = rawTabs.map((rawTab, tabIndex) => {
        const tabPrefix = `${wsPrefix}.tabs[${tabIndex}]`;
        if (!isRecord(rawTab)) {
          throw new Error(`${tabPrefix} must be an object`);
        }
        const tabPath = normalizePresetPath(
          asString(rawTab.path, `${tabPrefix}.path`, false) ?? path,
          home,
        );
        const tabName = asString(rawTab.name, `${tabPrefix}.name`, false);
        const rawPanes = Array.isArray(rawTab.panes) ? rawTab.panes : [];

        const panes = rawPanes.map((rawPane, paneIndex) => {
          const panePrefix = `${tabPrefix}.panes[${paneIndex}]`;
          if (!isRecord(rawPane)) {
            throw new Error(`${panePrefix} must be an object`);
          }
          const panePath = normalizePresetPath(
            asString(rawPane.path, `${panePrefix}.path`, false) ?? tabPath,
            home,
          );
          return {
            name: asString(rawPane.name, `${panePrefix}.name`, false),
            path: panePath,
            split: asSplit(rawPane.split, `${panePrefix}.split`),
            ratio: asOptionalRatio(rawPane.ratio, `${panePrefix}.ratio`),
          };
        });

        return { name: tabName, path: tabPath, panes };
      });

      return { name, path, tabs };
    });

    return { name, workspaces };
  });

  return { sessions };
}

function namesMatch(wanted: string | undefined, actual?: string | null) {
  return wanted === undefined || wanted === (actual ?? undefined);
}

function panePaths(tab: StoredTab): string[] {
  return Object.values(tab.panes ?? {})
    .map((pane) => pane.cwd)
    .filter((path): path is string => typeof path === "string");
}

export function findStoredWorkspace(
  config: StoredSessionConfig | undefined,
  preset: WorkspacePreset,
): StoredWorkspace | undefined {
  return config?.workspaces?.find((workspace) =>
    normalize(workspace.identity_cwd ?? "") === preset.path &&
    namesMatch(preset.name, workspace.custom_name)
  );
}

export function findStoredTab(
  workspace: StoredWorkspace | undefined,
  preset: TabPreset,
): StoredTab | undefined {
  return workspace?.tabs?.find((tab) =>
    namesMatch(preset.name, tab.custom_name) &&
    panePaths(tab).some((path) => normalize(path) === preset.path)
  );
}

export function hasStoredPane(
  tab: StoredTab | undefined,
  preset: PanePreset,
): boolean {
  if (!tab) return false;
  return panePaths(tab).some((path) => normalize(path) === preset.path);
}

function paneCoveredByCreatedTab(
  storedTab: StoredTab | undefined,
  tab: TabPreset,
  pane: PanePreset,
): boolean {
  return !storedTab && pane.path === tab.path;
}

export function buildEnsurePlan(
  manifest: HerdirManifest,
  storedSessions: Map<string, StoredSessionConfig | undefined>,
): EnsureStep[] {
  const steps: EnsureStep[] = [];

  for (const session of manifest.sessions) {
    const config = storedSessions.get(session.name);
    if (!config) steps.push({ type: "session", session: session.name });

    for (const workspace of session.workspaces) {
      const storedWorkspace = findStoredWorkspace(config, workspace);
      if (!storedWorkspace) {
        steps.push({
          type: "workspace",
          session: session.name,
          workspacePath: workspace.path,
          workspaceName: workspace.name,
        });
      }

      for (const tab of workspace.tabs) {
        const storedTab = findStoredTab(storedWorkspace, tab);
        if (!storedTab) {
          steps.push({
            type: "tab",
            session: session.name,
            workspacePath: workspace.path,
            workspaceName: workspace.name,
            tabPath: tab.path,
            tabName: tab.name,
          });
        }

        for (const pane of tab.panes) {
          if (
            !paneCoveredByCreatedTab(storedTab, tab, pane) &&
            !hasStoredPane(storedTab, pane)
          ) {
            steps.push({
              type: "pane",
              session: session.name,
              workspacePath: workspace.path,
              workspaceName: workspace.name,
              tabPath: tab.path,
              tabName: tab.name,
              panePath: pane.path,
              paneName: pane.name,
              split: pane.split,
              ratio: pane.ratio,
            });
          }
        }
      }
    }
  }

  return steps;
}

export async function readStoredSessions(
  sessionsDir: string,
  names: string[],
): Promise<Map<string, StoredSessionConfig | undefined>> {
  const sessions = new Map<string, StoredSessionConfig | undefined>();
  for (const name of names) {
    const file = join(sessionsDir, name, "session.json");
    try {
      sessions.set(name, JSON.parse(await Deno.readTextFile(file)));
    } catch (err) {
      if (err instanceof Deno.errors.NotFound) {
        sessions.set(name, undefined);
        continue;
      }
      throw new Error(`${file}: ${(err as Error).message}`);
    }
  }
  return sessions;
}

export async function readStoredSession(
  sessionsDir: string,
  name: string,
): Promise<StoredSessionConfig> {
  const file = join(sessionsDir, name, "session.json");
  try {
    return JSON.parse(await Deno.readTextFile(file));
  } catch (err) {
    if (err instanceof Deno.errors.NotFound) {
      throw new Error(`session not found: ${name}`);
    }
    throw new Error(`${file}: ${(err as Error).message}`);
  }
}

function compactHome(path: string, home: string): string {
  const normalizedHome = normalize(home);
  const normalizedPath = normalize(path);
  if (normalizedPath === normalizedHome) return "~";
  if (normalizedPath.startsWith(`${normalizedHome}/`)) {
    return `~/${normalizedPath.slice(normalizedHome.length + 1)}`;
  }
  return normalizedPath;
}

function paneIdValue(value: unknown): string | undefined {
  if (typeof value === "number") return String(value);
  if (typeof value === "string") return value;
}

interface LayoutPane {
  id: string;
  split?: SplitDirection;
  ratio?: number;
}

function splitFromLayoutValue(value: unknown): SplitDirection {
  if (typeof value !== "string") return "right";
  const lower = value.toLowerCase();
  if (lower.includes("vertical") || lower.includes("down")) return "down";
  return "right";
}

function collectLayoutPanes(
  layout: unknown,
  inherited?: { split?: SplitDirection; ratio?: number },
): LayoutPane[] {
  if (!isRecord(layout)) return [];
  if ("Pane" in layout) {
    const id = paneIdValue(layout.Pane);
    return id ? [{ id, ...inherited }] : [];
  }

  const splitNode = isRecord(layout.Split) ? layout.Split : undefined;
  if (!splitNode) return [];

  const split = splitFromLayoutValue(
    splitNode.direction ?? splitNode.axis ?? splitNode.orientation,
  );
  const ratio = typeof splitNode.ratio === "number"
    ? splitNode.ratio
    : undefined;
  const first = splitNode.first ?? splitNode.left ?? splitNode.top ??
    splitNode.a;
  const second = splitNode.second ?? splitNode.right ?? splitNode.bottom ??
    splitNode.b;
  const fallbackChildren = Object.entries(splitNode)
    .filter(([key]) =>
      !["direction", "axis", "orientation", "ratio"].includes(key)
    )
    .map(([, value]) => value)
    .filter(isRecord);
  const children = [first, second].filter(Boolean);
  const nodes = children.length > 0 ? children : fallbackChildren;

  return nodes.flatMap((node, index) =>
    collectLayoutPanes(node, index === 0 ? inherited : { split, ratio })
  );
}

function orderedPaneIds(tab: StoredTab): LayoutPane[] {
  const fromLayout = collectLayoutPanes(tab.layout);
  if (fromLayout.length > 0) return fromLayout;

  const ids = Object.keys(tab.panes ?? {}).sort((a, b) =>
    Number(a) - Number(b)
  );
  return ids.map((id) => ({ id }));
}

function tabRootPaneId(tab: StoredTab): string | undefined {
  const root = paneIdValue(tab.root_pane);
  if (root) return root;
  return orderedPaneIds(tab)[0]?.id;
}

function panePathById(tab: StoredTab, id: string): string | undefined {
  return tab.panes?.[id]?.cwd;
}

function snapshotTab(
  tab: StoredTab,
  workspacePath: string,
  home: string,
): Record<string, unknown> | undefined {
  const rootId = tabRootPaneId(tab);
  const rootPath = rootId ? panePathById(tab, rootId) : undefined;
  const path = rootPath ?? Object.values(tab.panes ?? {})[0]?.cwd ??
    workspacePath;
  if (!path) return undefined;

  const output: Record<string, unknown> = {};
  if (tab.custom_name) output.name = tab.custom_name;
  output.path = compactHome(path, home);

  const panes = orderedPaneIds(tab)
    .filter(({ id }) => id !== rootId)
    .map(({ id, split, ratio }) => {
      const cwd = panePathById(tab, id);
      if (!cwd) return undefined;
      const pane: Record<string, unknown> = {
        path: compactHome(cwd, home),
      };
      if (split) pane.split = split;
      if (ratio != null) pane.ratio = ratio;
      return pane;
    })
    .filter((pane): pane is Record<string, unknown> => Boolean(pane));

  if (panes.length > 0) output.panes = panes;
  return output;
}

export function snapshotSessionManifest(
  sessionName: string,
  config: StoredSessionConfig,
  home: string,
): Record<string, unknown> {
  const workspaces = (config.workspaces ?? [])
    .map((workspace) => {
      if (!workspace.identity_cwd) return undefined;
      const workspacePath = workspace.identity_cwd;
      const output: Record<string, unknown> = {};
      if (workspace.custom_name) output.name = workspace.custom_name;
      output.path = compactHome(workspacePath, home);

      const tabs = (workspace.tabs ?? [])
        .map((tab) => snapshotTab(tab, workspacePath, home))
        .filter((tab): tab is Record<string, unknown> => Boolean(tab));
      if (tabs.length > 0) output.tabs = tabs;
      return output;
    })
    .filter((workspace): workspace is Record<string, unknown> =>
      Boolean(workspace)
    );

  return { sessions: [{ name: sessionName, workspaces }] };
}

export function renderSnapshotYaml(snapshot: Record<string, unknown>): string {
  return stringifyYaml(snapshot, { indent: 2, lineWidth: -1 });
}

function snapshotFilename(sessionName: string): string {
  const safe = sessionName.replace(/[^A-Za-z0-9._-]+/g, "-").replace(
    /^-+|-+$/g,
    "",
  );
  return `${safe || "session"}.yaml`;
}

export async function writeSessionSnapshot(options: {
  sessionName: string;
  sessionsDir: string;
  snapshotDir: string;
  home: string;
}): Promise<string> {
  const config = await readStoredSession(
    options.sessionsDir,
    options.sessionName,
  );
  const snapshot = snapshotSessionManifest(
    options.sessionName,
    config,
    options.home,
  );
  const yaml = renderSnapshotYaml(snapshot);
  await Deno.mkdir(options.snapshotDir, { recursive: true });
  const outputPath = join(
    options.snapshotDir,
    snapshotFilename(options.sessionName),
  );
  await Deno.writeTextFile(outputPath, yaml);
  return outputPath;
}

function resultObject(payload: unknown): Record<string, unknown> {
  if (!isRecord(payload)) return {};
  const result = payload.result;
  return isRecord(result) ? result : payload;
}

export function jsonArray(payload: unknown, keys: string[]): unknown[] {
  const result = resultObject(payload);
  for (const key of keys) {
    const value = result[key];
    if (Array.isArray(value)) return value;
  }
  if (Array.isArray(payload)) return payload;
  return [];
}

function textField(obj: unknown, keys: string[]): string | undefined {
  if (!isRecord(obj)) return undefined;
  for (const key of keys) {
    const value = obj[key];
    if (typeof value === "string") return value;
  }
}

function nestedObject(payload: unknown, keys: string[]): unknown {
  const result = resultObject(payload);
  for (const key of keys) {
    const value = result[key];
    if (isRecord(value)) return value;
  }
  return result;
}

function workspaceId(workspace: unknown): string | undefined {
  return textField(workspace, ["workspace_id", "id"]);
}

function tabId(tab: unknown): string | undefined {
  return textField(tab, ["tab_id", "id"]);
}

function rootPaneId(tab: unknown): string | undefined {
  if (!isRecord(tab)) return undefined;
  const direct = textField(tab, ["root_pane", "root_pane_id", "pane_id"]);
  if (direct) return String(direct);
  const root = tab.root_pane;
  if (typeof root === "number") return String(root);
  if (typeof root === "string") return root;
  if (isRecord(root)) return textField(root, ["pane_id", "id"]);
}

function createdWorkspaceId(payload: unknown): string | undefined {
  return workspaceId(nestedObject(payload, ["workspace"]));
}

function createdTab(payload: unknown): {
  tabId?: string;
  rootPaneId?: string;
} {
  const tab = nestedObject(payload, ["tab"]);
  const root = nestedObject(payload, ["root_pane", "pane"]);
  return {
    tabId: tabId(tab),
    rootPaneId: rootPaneId(tab) ?? textField(root, ["pane_id", "id"]),
  };
}

function itemPath(item: unknown): string | undefined {
  return textField(item, ["cwd", "identity_cwd", "path"]);
}

function itemName(item: unknown): string | undefined {
  return textField(item, ["label", "name", "custom_name"]);
}

function matchesPathAndName(
  item: unknown,
  path: string | undefined,
  name: string | undefined,
): boolean {
  const actualPath = itemPath(item);
  const actualName = itemName(item);
  return (!path || Boolean(actualPath && normalize(actualPath) === path)) &&
    (!name || actualName === name);
}

class HerdrCli implements HerdrRunner {
  async runJson(args: string[]): Promise<unknown> {
    const output = await new Deno.Command("herdr", {
      args,
      stdout: "piped",
      stderr: "piped",
    }).output();
    const stderr = new TextDecoder().decode(output.stderr).trim();
    const stdout = new TextDecoder().decode(output.stdout).trim();
    if (!output.success) {
      throw new Error(`herdr ${args.join(" ")} failed: ${stderr || stdout}`);
    }
    if (!stdout) return {};
    return JSON.parse(stdout);
  }
}

async function runSessionJson(
  runner: HerdrRunner,
  session: string,
  args: string[],
): Promise<unknown> {
  return await runner.runJson(["--session", session, ...args]);
}

async function findLiveWorkspaceId(
  runner: HerdrRunner,
  session: string,
  workspace: WorkspacePreset,
): Promise<string | undefined> {
  const payload = await runSessionJson(runner, session, ["workspace", "list"]);
  const workspaces = jsonArray(payload, ["workspaces"]);
  const match = workspaces.find((item) =>
    matchesPathAndName(item, workspace.path, workspace.name)
  );
  return workspaceId(match);
}

async function findLiveTab(
  runner: HerdrRunner,
  session: string,
  workspaceIdValue: string,
  tab: TabPreset,
): Promise<{ tabId?: string; rootPaneId?: string }> {
  const payload = await runSessionJson(runner, session, [
    "tab",
    "list",
    "--workspace",
    workspaceIdValue,
  ]);
  const tabs = jsonArray(payload, ["tabs"]);
  const match = tabs.find((item) =>
    matchesPathAndName(item, tab.path, tab.name)
  );
  return { tabId: tabId(match), rootPaneId: rootPaneId(match) };
}

async function ensureWorkspace(
  runner: HerdrRunner,
  session: string,
  workspace: WorkspacePreset,
): Promise<string> {
  const existingId = await findLiveWorkspaceId(runner, session, workspace);
  if (existingId) return existingId;

  const args: string[] = [
    "workspace",
    "create",
    "--cwd",
    workspace.path,
    "--no-focus",
  ];
  if (workspace.name) args.push("--label", workspace.name);
  const payload = await runSessionJson(runner, session, args);
  const id = createdWorkspaceId(payload);
  if (!id) {
    throw new Error(`herdr did not return a workspace id for ${session}`);
  }
  return id;
}

async function ensureTab(
  runner: HerdrRunner,
  session: string,
  workspaceIdValue: string,
  tab: TabPreset,
): Promise<{ tabId?: string; rootPaneId: string }> {
  const existing = await findLiveTab(runner, session, workspaceIdValue, tab);
  if (existing.rootPaneId) {
    return { ...existing, rootPaneId: existing.rootPaneId };
  }

  const args: string[] = [
    "tab",
    "create",
    "--workspace",
    workspaceIdValue,
    "--cwd",
    tab.path,
    "--no-focus",
  ];
  if (tab.name) args.push("--label", tab.name);
  const payload = await runSessionJson(runner, session, args);
  const created = createdTab(payload);
  if (!created.rootPaneId) {
    throw new Error(`herdr did not return a root pane id for ${session}`);
  }
  return { tabId: created.tabId, rootPaneId: created.rootPaneId };
}

async function splitPane(
  runner: HerdrRunner,
  session: string,
  sourcePaneId: string,
  pane: PanePreset,
): Promise<void> {
  const args: string[] = [
    "pane",
    "split",
    sourcePaneId,
    "--direction",
    pane.split,
    "--cwd",
    pane.path,
    "--no-focus",
  ];
  if (pane.ratio != null) args.push("--ratio", String(pane.ratio));
  const payload = await runSessionJson(runner, session, args);
  const createdPane = nestedObject(payload, ["pane"]);
  const id = textField(createdPane, ["pane_id", "id"]);
  if (pane.name && id) {
    await runSessionJson(runner, session, ["pane", "rename", id, pane.name]);
  }
}

export async function ensureManifest(
  manifest: HerdirManifest,
  options: {
    sessionsDir: string;
    runner: HerdrRunner;
    dryRun?: boolean;
  },
): Promise<EnsureStep[]> {
  const sessionNames = manifest.sessions.map((session) => session.name);
  const stored = await readStoredSessions(options.sessionsDir, sessionNames);
  const plan = buildEnsurePlan(manifest, stored);
  if (options.dryRun || plan.length === 0) return plan;

  for (const session of manifest.sessions) {
    const config = stored.get(session.name);
    for (const workspace of session.workspaces) {
      const storedWorkspace = findStoredWorkspace(config, workspace);
      const workspaceIdValue = await ensureWorkspace(
        options.runner,
        session.name,
        workspace,
      );

      for (const tab of workspace.tabs) {
        const storedTab = findStoredTab(storedWorkspace, tab);
        const liveTab = await ensureTab(
          options.runner,
          session.name,
          workspaceIdValue,
          tab,
        );

        for (const pane of tab.panes) {
          if (
            !paneCoveredByCreatedTab(storedTab, tab, pane) &&
            !hasStoredPane(storedTab, pane)
          ) {
            await splitPane(
              options.runner,
              session.name,
              liveTab.rootPaneId,
              pane,
            );
          }
        }
      }
    }
  }

  return plan;
}

function defaultHome(): string {
  const home = Deno.env.get("HOME");
  if (!home) throw new Error("HOME is not set");
  return home;
}

function defaultSessionsDir(home: string): string {
  return join(home, ".config", "herdr", "sessions");
}

function printPlan(plan: EnsureStep[]) {
  if (plan.length === 0) {
    log.success("All requested herdr base layouts already exist");
    return;
  }

  for (const step of plan) {
    switch (step.type) {
      case "session":
        log.info(`create session ${step.session}`);
        break;
      case "workspace":
        log.info(
          `create workspace ${step.session}:${
            step.workspaceName ?? step.workspacePath
          }`,
        );
        break;
      case "tab":
        log.info(
          `create tab ${step.session}:${step.tabName ?? step.tabPath}`,
        );
        break;
      case "pane":
        log.info(
          `split ${step.split} pane ${step.session}:${
            step.paneName ?? step.panePath
          }`,
        );
        break;
    }
  }
}

export async function main(args: string[] = Deno.args): Promise<number> {
  let exitCode = 0;
  const home = defaultHome();
  const cliArgs = args[0] === "--" ? args.slice(1) : args;

  const cli = new Command()
    .name("herdir")
    .version("0.1.0")
    .description("Ensure additive herdr session presets from YAML")
    .option("-m, --manifest <path:string>", "Preset manifest path", {
      default: DEFAULT_MANIFEST,
    })
    .option("--sessions-dir <path:string>", "Herdr session config directory", {
      default: defaultSessionsDir(home),
    })
    .option("-n, --dry-run", "Print planned changes without running herdr")
    .action(async (options) => {
      try {
        const manifestPath = normalizePresetPath(options.manifest, home);
        const manifest = parseManifestYaml(
          await Deno.readTextFile(manifestPath),
          home,
        );
        const sessionsDir = normalizePresetPath(options.sessionsDir, home);
        const plan = await ensureManifest(manifest, {
          sessionsDir,
          runner: new HerdrCli(),
          dryRun: options.dryRun,
        });

        printPlan(plan);
        if (options.dryRun) {
          log.warn("dry-run only; no herdr commands were run");
        } else if (plan.length > 0) {
          log.success(`Applied ${plan.length} additive change(s)`);
        }
      } catch (err) {
        log.error(err instanceof Error ? err.message : String(err));
        exitCode = 1;
      }
    })
    .command("snapshot <session:string>", "Write a YAML preset from a session")
    .option("--sessions-dir <path:string>", "Herdr session config directory", {
      default: defaultSessionsDir(home),
    })
    .option("-o, --output-dir <path:string>", "Snapshot output directory", {
      default: DEFAULT_SNAPSHOT_DIR,
    })
    .action(async (options, session: string) => {
      try {
        const sessionsDir = normalizePresetPath(options.sessionsDir, home);
        const snapshotDir = normalizePresetPath(options.outputDir, home);
        const outputPath = await writeSessionSnapshot({
          sessionName: session,
          sessionsDir,
          snapshotDir,
          home,
        });
        log.success(`Wrote ${outputPath}`);
        log.info(
          "Copy the branches you want into herdir.yaml, then edit down.",
        );
      } catch (err) {
        log.error(err instanceof Error ? err.message : String(err));
        exitCode = 1;
      }
    });

  await cli.parse(cliArgs);
  return exitCode;
}

if (import.meta.main) {
  Deno.exit(await main());
}
