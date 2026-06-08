#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-run=chezmoi,brew,pnpm,uv
/**
 * packy — declarative package manifest tool for chezmoi's packages.yaml.
 *
 * Manifest-first: add/remove flow through packy so the YAML stays the source of
 * truth. Drift detection (diff) and upgrades (upgrade) never mutate the manifest
 * — live state of the underlying package manager is read-only input.
 *
 * Managers (current OS gates which are usable):
 *   formula  Homebrew formulae    (darwin)
 *   cask     Homebrew casks       (darwin)
 *   tap      Homebrew taps        (darwin)
 *   pnpm     pnpm global packages (darwin + linux)
 *   uv       uv tools             (darwin)
 *
 * Profiles: core, personal, work. Current profile comes from `chezmoi data .profile`.
 * `add` defaults to the current profile; `--profile` overrides and triggers an
 * implicit move when the package is already tracked in a different slot.
 *
 * Run via `deno task packy` from .utils, or the `packy` fish wrapper.
 */

import { parseArgs } from "@std/cli/parse-args";
import {
  bold,
  brightGreen,
  cyan,
  green,
  magenta,
  red,
  yellow,
} from "@std/fmt/colors";
import { join } from "@std/path";
import { parse as parseYaml, stringify as stringifyYaml } from "@std/yaml";

// ── Types ──────────────────────────────────────────────────────────────

export const MANAGERS = ["formula", "cask", "tap", "pnpm", "uv"] as const;
export type Manager = (typeof MANAGERS)[number];

export const PROFILES = ["core", "personal", "work"] as const;
export type Profile = (typeof PROFILES)[number];

export type Os = "darwin" | "linux";

export type ProfileMap = Partial<Record<Profile, string[]>>;

export interface OsPackages {
  homebrew?: {
    taps?: ProfileMap;
    formulae?: ProfileMap;
    casks?: ProfileMap;
  };
  pnpm?: ProfileMap;
  uv?: ProfileMap;
}

export interface PackagesData {
  darwin?: OsPackages;
  linux?: OsPackages;
}

export interface ChezmoiData {
  profile?: Profile;
  chezmoi: { os: Os; sourceDir: string };
  packages?: PackagesData;
}

interface Ctx {
  data: ChezmoiData;
  os: Os;
  profile: Profile;
  packagesFile: string;
  dryRun: boolean;
  verbose: boolean;
}

// ── Logging ────────────────────────────────────────────────────────────

const log = {
  info: (m: string) => console.log(`${bold(cyan("[INFO]"))} ${m}`),
  warn: (m: string) => console.log(`${bold(yellow("[WARN]"))} ${m}`),
  error: (m: string) => console.error(`${bold(red("[ERROR]"))} ${red(m)}`),
  success: (m: string) =>
    console.log(`${bold(brightGreen("[OK]"))} ${green(m)}`),
  step: (m: string) => console.log(`${bold(magenta(`==> ${m}`))}`),
};

// ── Pure helpers (tested in packy_test.ts) ────────────────────────────

/** Effective set on this machine = core baseline + current profile's extras. */
export function getEffective(
  map: ProfileMap | undefined,
  profile: Profile,
): string[] {
  const core = map?.core ?? [];
  if (profile === "core") return [...core];
  return [...core, ...(map?.[profile] ?? [])];
}

/** Union across every profile slot. Used for cross-OS subset checks. */
export function getAllSlots(map: ProfileMap | undefined): string[] {
  if (!map) return [];
  return Object.values(map).flat();
}

/** Items appearing in more than one profile slot. */
export function findDupes(
  map: ProfileMap | undefined,
): Array<{ item: string; slots: Profile[] }> {
  const itemToSlots = new Map<string, Profile[]>();
  for (const [slot, items] of Object.entries(map ?? {})) {
    for (const item of items as string[]) {
      const arr = itemToSlots.get(item) ?? [];
      arr.push(slot as Profile);
      itemToSlots.set(item, arr);
    }
  }
  return [...itemToSlots.entries()]
    .filter(([, slots]) => slots.length > 1)
    .map(([item, slots]) => ({ item, slots }));
}

/** Set diff: items added (in current not saved) and removed (in saved not current). */
export function diffLists(
  current: string[],
  saved: string[],
): { added: string[]; removed: string[] } {
  const savedSet = new Set(saved);
  const currentSet = new Set(current);
  return {
    added: current.filter((x) => !savedSet.has(x)),
    removed: saved.filter((x) => !currentSet.has(x)),
  };
}

// ── Add / remove planning ─────────────────────────────────────────────

export type AddAction = "added" | "no-op" | "moved" | "kept";

export interface AddPlan {
  action: AddAction;
  /** Source profile when action is "moved" or "kept". */
  from?: Profile;
  /** Updated map; equal to input when action is "no-op" or "kept". */
  newMap: ProfileMap;
}

/**
 * Plan a manifest update for `add`. Install is handled separately by the caller.
 *
 *  - Already in `target` → no-op.
 *  - Already in another slot + explicit target → "moved".
 *  - Already in another slot + implicit target → "kept" (manifest untouched
 *    to avoid surprise profile changes when the user only meant to confirm
 *    tracking; caller prints a hint about --profile).
 *  - Not present → "added" into `target`.
 */
export function planAdd(
  map: ProfileMap | undefined,
  pkg: string,
  target: Profile,
  explicitTarget: boolean,
): AddPlan {
  const result: ProfileMap = {};
  for (const p of PROFILES) result[p] = [...(map?.[p] ?? [])];

  if (result[target]!.includes(pkg)) {
    return { action: "no-op", newMap: result };
  }

  let from: Profile | undefined;
  for (const p of PROFILES) {
    if (p === target) continue;
    if (result[p]!.includes(pkg)) {
      from = p;
      break;
    }
  }

  if (from && !explicitTarget) {
    return { action: "kept", from, newMap: result };
  }

  if (from) result[from] = result[from]!.filter((x) => x !== pkg);
  result[target] = [...result[target]!, pkg].sort();

  return from
    ? { action: "moved", from, newMap: result }
    : { action: "added", newMap: result };
}

export type RemoveAction = "removed" | "not-tracked";

export interface RemovePlan {
  action: RemoveAction;
  from?: Profile;
  newMap: ProfileMap;
}

export function planRemove(
  map: ProfileMap | undefined,
  pkg: string,
): RemovePlan {
  const result: ProfileMap = {};
  for (const p of PROFILES) result[p] = [...(map?.[p] ?? [])];

  for (const p of PROFILES) {
    if (result[p]!.includes(pkg)) {
      result[p] = result[p]!.filter((x) => x !== pkg);
      return { action: "removed", from: p, newMap: result };
    }
  }
  return { action: "not-tracked", newMap: result };
}

// ── Subprocess helpers ─────────────────────────────────────────────────

async function runOutput(cmd: string[]): Promise<string> {
  const { code, stdout, stderr } = await new Deno.Command(cmd[0], {
    args: cmd.slice(1),
    stdout: "piped",
    stderr: "piped",
  }).output();
  if (code !== 0) {
    const err = new TextDecoder().decode(stderr).trim();
    throw new Error(`${cmd.join(" ")} exited ${code}${err ? `: ${err}` : ""}`);
  }
  return new TextDecoder().decode(stdout);
}

async function runInteractive(cmd: string[]): Promise<boolean> {
  const { success } = await new Deno.Command(cmd[0], {
    args: cmd.slice(1),
    stdout: "inherit",
    stderr: "inherit",
  }).output();
  return success;
}

// ── Data loading ───────────────────────────────────────────────────────

export async function loadChezmoiData(): Promise<ChezmoiData> {
  const out = await runOutput(["chezmoi", "data"]);
  return JSON.parse(out);
}

// ── Manager specs ──────────────────────────────────────────────────────

interface ManagerSpec {
  /** Path into the chezmoi data root to the per-profile map for this manager. */
  yamlPath: (os: Os) => string[];
  supports: (os: Os) => boolean;
  bin: string;
  listInstalled: () => Promise<string[]>;
  install: (pkg: string) => Promise<boolean>;
  uninstall: (pkg: string) => Promise<boolean>;
  upgradeAll: (dryRun: boolean) => Promise<void>;
}

async function readPnpmGlobals(): Promise<string[]> {
  const out = await runOutput(["pnpm", "ls", "-g", "--depth=0", "--json"]);
  const data = JSON.parse(out);
  return Object.keys(data?.[0]?.dependencies ?? {}).sort();
}

async function readUvTools(): Promise<string[]> {
  const out = await runOutput(["uv", "tool", "list"]);
  // Tool lines start with the name; bin lines start with "- ".
  const tools = new Set<string>();
  for (const line of out.split("\n")) {
    if (!/^[a-zA-Z0-9]/.test(line)) continue;
    tools.add(line.split(/\s+/)[0]);
  }
  return [...tools].sort();
}

async function readBrewFormulae(): Promise<string[]> {
  const out = await runOutput([
    "brew",
    "list",
    "-1",
    "--installed-on-request",
  ]);
  return out.split("\n").filter(Boolean).sort();
}

async function readBrewCasks(): Promise<string[]> {
  const out = await runOutput(["brew", "list", "--cask", "-1"]);
  return out.split("\n").filter(Boolean).sort();
}

async function readBrewTaps(): Promise<string[]> {
  const out = await runOutput(["brew", "tap"]);
  return out.split("\n").filter(Boolean).sort();
}

const SPECS: Record<Manager, ManagerSpec> = {
  formula: {
    yamlPath: (os) => ["packages", os, "homebrew", "formulae"],
    supports: (os) => os === "darwin",
    bin: "brew",
    listInstalled: readBrewFormulae,
    install: (pkg) => runInteractive(["brew", "install", pkg]),
    uninstall: (pkg) => runInteractive(["brew", "uninstall", pkg]),
    upgradeAll: async (dryRun) => {
      if (dryRun) {
        log.info(
          "[DRY RUN] brew update; brew upgrade; brew autoremove; brew cleanup",
        );
        return;
      }
      for (
        const cmd of [
          ["brew", "update"],
          ["brew", "upgrade"],
          ["brew", "autoremove"],
          ["brew", "cleanup"],
        ]
      ) {
        log.info(`${cmd.join(" ")}...`);
        if (!(await runInteractive(cmd))) {
          log.warn(`${cmd.join(" ")} returned non-zero — continuing`);
        }
      }
    },
  },
  cask: {
    yamlPath: (os) => ["packages", os, "homebrew", "casks"],
    supports: (os) => os === "darwin",
    bin: "brew",
    listInstalled: readBrewCasks,
    install: (pkg) => runInteractive(["brew", "install", "--cask", pkg]),
    uninstall: (pkg) => runInteractive(["brew", "uninstall", "--cask", pkg]),
    upgradeAll: async (dryRun) => {
      if (dryRun) {
        log.info("[DRY RUN] brew upgrade --cask");
        return;
      }
      log.info("brew upgrade --cask...");
      if (!(await runInteractive(["brew", "upgrade", "--cask"]))) {
        log.warn("brew upgrade --cask returned non-zero — continuing");
      }
    },
  },
  tap: {
    yamlPath: (os) => ["packages", os, "homebrew", "taps"],
    supports: (os) => os === "darwin",
    bin: "brew",
    listInstalled: readBrewTaps,
    install: (pkg) => runInteractive(["brew", "tap", pkg]),
    uninstall: (pkg) => runInteractive(["brew", "untap", pkg]),
    upgradeAll: () => {
      log.info("taps have no upgrade step — skipping");
      return Promise.resolve();
    },
  },
  pnpm: {
    yamlPath: (os) => ["packages", os, "pnpm"],
    supports: () => true,
    bin: "pnpm",
    listInstalled: readPnpmGlobals,
    install: (pkg) => runInteractive(["pnpm", "add", "-g", pkg]),
    uninstall: (pkg) => runInteractive(["pnpm", "remove", "-g", pkg]),
    upgradeAll: async (dryRun) => {
      if (dryRun) {
        log.info("[DRY RUN] pnpm update -g");
        return;
      }
      log.info("pnpm update -g...");
      await runInteractive(["pnpm", "update", "-g"]);
    },
  },
  uv: {
    yamlPath: (os) => ["packages", os, "uv"],
    supports: (os) => os === "darwin",
    bin: "uv",
    listInstalled: readUvTools,
    install: (pkg) => runInteractive(["uv", "tool", "install", pkg]),
    uninstall: (pkg) => runInteractive(["uv", "tool", "uninstall", pkg]),
    upgradeAll: async (dryRun) => {
      if (dryRun) {
        log.info("[DRY RUN] uv tool upgrade --all");
        return;
      }
      log.info("uv tool upgrade --all...");
      await runInteractive(["uv", "tool", "upgrade", "--all"]);
    },
  },
};

function applicableManagers(os: Os, filter?: Manager): Manager[] {
  const all = MANAGERS.filter((m) => SPECS[m].supports(os));
  return filter ? all.filter((m) => m === filter) : all;
}

// deno-lint-ignore no-explicit-any
function getMap(
  data: ChezmoiData,
  manager: Manager,
  os: Os,
): ProfileMap | undefined {
  const path = SPECS[manager].yamlPath(os);
  let node: any = data;
  for (const seg of path) {
    if (node == null) return undefined;
    node = node[seg];
  }
  return node as ProfileMap | undefined;
}

async function check(manager: Manager): Promise<boolean> {
  try {
    await runOutput([SPECS[manager].bin, "--version"]);
    return true;
  } catch {
    log.error(`${SPECS[manager].bin} not found in PATH`);
    return false;
  }
}

// ── YAML write ─────────────────────────────────────────────────────────

/**
 * Replace the per-profile map for `manager` at its yamlPath. Other branches of
 * the YAML tree are preserved. Refreshes ctx.data after a successful write so
 * subsequent ops in the same run see the new state.
 */
async function writeMap(
  ctx: Ctx,
  manager: Manager,
  newMap: ProfileMap,
  label: string,
) {
  const text = await Deno.readTextFile(ctx.packagesFile);
  const root = (parseYaml(text) ?? {}) as Record<string, unknown>;
  const path = SPECS[manager].yamlPath(ctx.os);
  // deno-lint-ignore no-explicit-any
  let node: any = root;
  for (let i = 0; i < path.length - 1; i++) {
    const seg = path[i];
    node[seg] ??= {};
    node = node[seg];
  }
  node[path[path.length - 1]] = newMap;

  const yamlOut = stringifyYaml(root, { indent: 2, lineWidth: -1 });
  if (ctx.verbose) {
    console.log();
    console.log(yamlOut);
    console.log();
  }
  if (ctx.dryRun) {
    log.info(`[DRY RUN] would update ${label} in ${ctx.packagesFile}`);
    return;
  }
  const tempFile = await Deno.makeTempFile({
    prefix: "packy-",
    suffix: ".yaml",
  });
  await Deno.writeTextFile(tempFile, yamlOut);
  await Deno.rename(tempFile, ctx.packagesFile);
  log.success(`Updated ${label}`);
  ctx.data = await loadChezmoiData();
}

// ── add ────────────────────────────────────────────────────────────────

async function addOne(
  ctx: Ctx,
  manager: Manager,
  pkg: string,
  target: Profile,
  explicitTarget: boolean,
): Promise<boolean> {
  const spec = SPECS[manager];
  const installed = await spec.listInstalled();
  if (!installed.includes(pkg)) {
    if (ctx.dryRun) {
      log.info(`[DRY RUN] would install ${pkg} via ${manager}`);
    } else {
      log.info(`Installing ${pkg} via ${manager}...`);
      if (!(await spec.install(pkg))) {
        log.error(`Install failed for ${pkg} — leaving manifest untouched`);
        return false;
      }
    }
  } else {
    log.info(`${pkg} already installed`);
  }

  const map = getMap(ctx.data, manager, ctx.os);
  const plan = planAdd(map, pkg, target, explicitTarget);

  switch (plan.action) {
    case "no-op":
      log.success(`${pkg} already tracked in ${target}`);
      return true;
    case "added":
      await writeMap(ctx, manager, plan.newMap, `${ctx.os}.${manager}`);
      log.success(`Tracked ${pkg} in ${target}`);
      return true;
    case "moved":
      await writeMap(ctx, manager, plan.newMap, `${ctx.os}.${manager}`);
      log.success(`Moved ${pkg}: ${plan.from} → ${target}`);
      return true;
    case "kept":
      log.info(
        `${pkg} is already tracked in ${plan.from} — manifest unchanged. ` +
          `Pass --profile ${target} to move it.`,
      );
      return true;
  }
}

async function cmdAdd(
  ctx: Ctx,
  manager: Manager,
  pkgs: string[],
  target: Profile,
  explicitTarget: boolean,
): Promise<boolean> {
  if (!SPECS[manager].supports(ctx.os)) {
    log.error(`${manager} is not supported on ${ctx.os}`);
    return false;
  }
  if (!(await check(manager))) return false;

  let allOk = true;
  for (const pkg of pkgs) {
    console.log();
    log.step(`add ${manager} ${pkg}`);
    allOk = (await addOne(ctx, manager, pkg, target, explicitTarget)) && allOk;
  }
  return allOk;
}

// ── remove ─────────────────────────────────────────────────────────────

interface RemoveLocation {
  manager: Manager;
  profile: Profile;
}

function findInManifest(
  data: ChezmoiData,
  os: Os,
  pkg: string,
): RemoveLocation[] {
  const hits: RemoveLocation[] = [];
  for (const m of applicableManagers(os)) {
    const map = getMap(data, m, os);
    if (!map) continue;
    for (const p of PROFILES) {
      if ((map[p] ?? []).includes(pkg)) hits.push({ manager: m, profile: p });
    }
  }
  return hits;
}

async function removeOne(
  ctx: Ctx,
  manager: Manager,
  pkg: string,
): Promise<boolean> {
  const spec = SPECS[manager];
  const installed = await spec.listInstalled();
  if (installed.includes(pkg)) {
    if (ctx.dryRun) {
      log.info(`[DRY RUN] would uninstall ${pkg} via ${manager}`);
    } else {
      log.info(`Uninstalling ${pkg} via ${manager}...`);
      if (!(await spec.uninstall(pkg))) {
        log.warn(
          `Uninstall returned non-zero — proceeding with manifest update anyway`,
        );
      }
    }
  } else {
    log.info(`${pkg} not installed — untracking from manifest only`);
  }

  const map = getMap(ctx.data, manager, ctx.os);
  const plan = planRemove(map, pkg);
  if (plan.action === "not-tracked") {
    log.warn(`${pkg} was not tracked under ${manager}`);
    return true;
  }
  await writeMap(ctx, manager, plan.newMap, `${ctx.os}.${manager}`);
  log.success(`Untracked ${pkg} from ${plan.from}`);
  return true;
}

async function cmdRemove(
  ctx: Ctx,
  pkgs: string[],
  managerFilter?: Manager,
): Promise<boolean> {
  let allOk = true;
  for (const pkg of pkgs) {
    console.log();
    log.step(`remove ${pkg}`);
    const hits = findInManifest(ctx.data, ctx.os, pkg);
    const targetHits = managerFilter
      ? hits.filter((h) => h.manager === managerFilter)
      : hits;
    if (targetHits.length === 0) {
      log.error(
        `${pkg} not found in manifest${
          managerFilter ? ` under ${managerFilter}` : ""
        }`,
      );
      allOk = false;
      continue;
    }
    if (targetHits.length > 1 && !managerFilter) {
      const where = targetHits.map((h) => `${h.manager}/${h.profile}`).join(
        ", ",
      );
      log.error(
        `${pkg} is tracked in multiple managers (${where}). Pass -m to disambiguate.`,
      );
      allOk = false;
      continue;
    }
    if (!(await check(targetHits[0].manager))) {
      allOk = false;
      continue;
    }
    allOk = (await removeOne(ctx, targetHits[0].manager, pkg)) && allOk;
  }
  return allOk;
}

// ── list ───────────────────────────────────────────────────────────────

function cmdList(ctx: Ctx, managerFilter?: Manager): boolean {
  const managers = applicableManagers(ctx.os, managerFilter);
  for (const m of managers) {
    const map = getMap(ctx.data, m, ctx.os);
    console.log();
    log.step(`${ctx.os}.${m}`);
    if (!map) {
      console.log("  (nothing tracked)");
      continue;
    }
    let any = false;
    for (const p of PROFILES) {
      const items = map[p] ?? [];
      if (items.length === 0) continue;
      any = true;
      console.log(`  ${bold(p)}:`);
      for (const item of items) console.log(`    ${item}`);
    }
    if (!any) console.log("  (nothing tracked)");
  }
  return true;
}

// ── diff ───────────────────────────────────────────────────────────────

function printDiff(
  label: string,
  current: string[],
  tracked: string[],
): number {
  const { added, removed } = diffLists(current, tracked);
  if (added.length === 0 && removed.length === 0) return 0;
  console.log(`${bold(label)}:`);
  for (const x of added) {
    console.log(`  ${green(`+ ${x}`)}  (installed, not tracked)`);
  }
  for (const x of removed) {
    console.log(`  ${red(`- ${x}`)}  (tracked, not installed)`);
  }
  console.log();
  return added.length + removed.length;
}

async function cmdDiff(ctx: Ctx, managerFilter?: Manager): Promise<boolean> {
  const managers = applicableManagers(ctx.os, managerFilter);
  let totalChanges = 0;
  let allOk = true;
  for (const m of managers) {
    if (!(await check(m))) {
      allOk = false;
      continue;
    }
    console.log();
    log.step(`${ctx.os}.${m}`);
    try {
      const installed = await SPECS[m].listInstalled();
      const tracked = getEffective(getMap(ctx.data, m, ctx.os), ctx.profile);
      const count = printDiff(m, installed, tracked);
      if (count === 0) log.success(`${m}: in sync`);
      totalChanges += count;
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      log.error(`${m} diff failed: ${msg}`);
      allOk = false;
    }
  }
  if (totalChanges > 0) {
    console.log();
    log.info("Reconcile with:");
    log.info(
      "  + installed, not tracked → packy add -m <mgr> <pkg> (track it) or packy remove <pkg> (uninstall it)",
    );
    log.info(
      "  - tracked, not installed → packy sync (install all missing) or packy remove <pkg> (untrack it)",
    );
  }
  return allOk;
}

// ── check ──────────────────────────────────────────────────────────────

function reportDupes(label: string, map: ProfileMap | undefined): boolean {
  const dupes = findDupes(map);
  if (dupes.length === 0) return true;
  console.log(`${bold(label)} duplicated across profile slots:`);
  for (const { item, slots } of dupes) {
    console.log(`  ${yellow("!")} ${yellow(item)} — in: ${slots.join(", ")}`);
  }
  return false;
}

function cmdCheck(ctx: Ctx, managerFilter?: Manager): boolean {
  let ok = true;
  const managers = MANAGERS.filter(
    (m) => !managerFilter || m === managerFilter,
  );
  for (const m of managers) {
    for (const os of ["darwin", "linux"] as const) {
      if (!SPECS[m].supports(os)) continue;
      const map = getMap(ctx.data, m, os);
      ok = reportDupes(`${os}.${m}`, map) && ok;
    }
  }

  // pnpm: linux ⊆ darwin so that any linux-installable global is also part of
  // the darwin install set.
  if (!managerFilter || managerFilter === "pnpm") {
    const darwinAll = new Set(getAllSlots(getMap(ctx.data, "pnpm", "darwin")));
    const linuxAll = getAllSlots(getMap(ctx.data, "pnpm", "linux"));
    const missing = linuxAll.filter((g) => !darwinAll.has(g));
    if (missing.length > 0) {
      log.warn(
        `pnpm: linux globals not present in darwin (${missing.length} issue(s))`,
      );
      for (const g of missing) console.log(`  ${yellow(`! ${g}`)}`);
      log.info(
        "Add to darwin via `packy add -m pnpm <pkg>`, or remove from linux.",
      );
      ok = false;
    }
  }

  if (ok) log.success("check passed");
  return ok;
}

// ── upgrade ────────────────────────────────────────────────────────────

async function cmdUpgrade(ctx: Ctx, managerFilter?: Manager): Promise<boolean> {
  const managers = applicableManagers(ctx.os, managerFilter);
  let allOk = true;
  for (const m of managers) {
    if (!(await check(m))) {
      allOk = false;
      continue;
    }
    console.log();
    log.step(`upgrade ${m}`);
    try {
      await SPECS[m].upgradeAll(ctx.dryRun);
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      log.error(`${m} upgrade failed: ${msg}`);
      allOk = false;
    }
  }
  return allOk;
}

// ── sync ───────────────────────────────────────────────────────────────

async function cmdSync(ctx: Ctx, managerFilter?: Manager): Promise<boolean> {
  if (!ctx.data.profile) {
    log.warn(
      "No profile set in chezmoi data — syncing 'core' baseline only. " +
        "Set a profile to include personal/work extras.",
    );
  }

  const managers = applicableManagers(ctx.os, managerFilter);
  let allOk = true;
  let totalInstalled = 0;
  let totalFailed = 0;

  for (const m of managers) {
    if (!(await check(m))) {
      allOk = false;
      continue;
    }
    console.log();
    log.step(`sync ${m}`);
    try {
      const installed = await SPECS[m].listInstalled();
      const tracked = getEffective(getMap(ctx.data, m, ctx.os), ctx.profile);
      const { removed: missing } = diffLists(installed, tracked);

      if (missing.length === 0) {
        log.success(`${m}: in sync`);
        continue;
      }

      log.info(`${missing.length} to install: ${missing.join(", ")}`);
      for (const pkg of missing) {
        if (ctx.dryRun) {
          log.info(`[DRY RUN] would install ${pkg} via ${m}`);
          continue;
        }
        log.info(`Installing ${pkg} via ${m}...`);
        if (await SPECS[m].install(pkg)) {
          totalInstalled++;
        } else {
          log.error(`Install failed for ${pkg}`);
          totalFailed++;
          allOk = false;
        }
      }
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      log.error(`${m} sync failed: ${msg}`);
      allOk = false;
    }
  }

  console.log();
  if (ctx.dryRun) {
    log.info("[DRY RUN] no packages installed");
  } else if (totalInstalled === 0 && totalFailed === 0) {
    log.success("Already in sync — nothing to install");
  } else {
    log.success(`Installed ${totalInstalled} package(s)`);
    if (totalFailed > 0) log.warn(`${totalFailed} install(s) failed`);
  }
  return allOk;
}

// ── CLI ────────────────────────────────────────────────────────────────

function printHelp() {
  console.log(
    `Declaratively manage chezmoi's packages.yaml across package managers.

Usage:
  packy add     | a   <pkg>... -m <mgr> [--profile <p>]
  packy remove  | rm  <pkg>... [-m <mgr>]
  packy list    | ls  [-m <mgr>]
  packy diff    | d   [-m <mgr>]
  packy check   | c   [-m <mgr>]
  packy upgrade | up  [-m <mgr>]
  packy sync    | s   [-m <mgr>]

Subcommands:
  add       (a)   Install (if missing) and track package(s) under the target profile
  remove    (rm)  Uninstall (if present) and untrack package(s)
  list      (ls)  Show tracked packages for the current OS
  diff      (d)   Show drift between manifest and live state (no writes)
  check     (c)   Cross-profile dedup; linux pnpm ⊂ darwin pnpm
  upgrade   (up)  Run upgrade commands for each manager (no manifest writes)
  sync      (s)   Install any tracked packages missing from the system (no uninstall, no manifest writes)

Options:
  -h, --help                Show this help
  -d, --dry-run             Preview without writing or running install/uninstall
  -v, --verbose             Show extra detail (e.g. full YAML on write)
  -m, --manager <name>      formula, cask, tap, pnpm, uv
  -p, --profile <name>      Override the add target (default: current profile)

Managers:
  formula   Homebrew formulae    (darwin)
  cask      Homebrew casks       (darwin)
  tap       Homebrew taps        (darwin)
  pnpm      pnpm global packages (darwin + linux)
  uv        uv tools             (darwin)

Profiles:
  core, personal, work — current profile comes from \`chezmoi data .profile\`.
  add without --profile only ever adds to the current profile or no-ops if the
  package is already tracked there. If it's tracked in a different profile and
  --profile isn't passed, add warns and leaves the manifest alone. Passing
  --profile moves the entry between slots and prints a notice.

Examples:
  packy add -m pnpm '@agentclientprotocol/claude-agent-acp'
  packy a -m formula gh
  packy add -m cask --profile personal obsidian
  packy rm '@aredotna/cli'
  packy d -m pnpm
  packy upgrade -m formula
  packy sync`,
  );
}

const SUBCOMMANDS = [
  "add",
  "remove",
  "list",
  "diff",
  "check",
  "upgrade",
  "sync",
] as const;
type Subcommand = (typeof SUBCOMMANDS)[number];

const SUBCOMMAND_ALIASES: Record<string, Subcommand> = {
  a: "add",
  rm: "remove",
  ls: "list",
  d: "diff",
  c: "check",
  up: "upgrade",
  s: "sync",
};

export async function main(args: string[] = Deno.args): Promise<number> {
  const parsed = parseArgs(args, {
    boolean: ["help", "dry-run", "verbose"],
    string: ["manager", "profile"],
    alias: {
      h: "help",
      d: "dry-run",
      v: "verbose",
      m: "manager",
      p: "profile",
    },
  });

  if (parsed.help) {
    printHelp();
    return 0;
  }
  if (parsed._.length === 0) {
    printHelp();
    return 2;
  }

  const subInput = String(parsed._[0]);
  const sub = SUBCOMMAND_ALIASES[subInput] ?? subInput;
  if (!(SUBCOMMANDS as readonly string[]).includes(sub)) {
    log.error(`Unknown subcommand: ${subInput}`);
    console.error(`  Supported: ${SUBCOMMANDS.join(", ")}`);
    console.error("Try: packy --help");
    return 2;
  }
  const subcommand = sub as Subcommand;
  const pkgs = parsed._.slice(1).map(String);

  let managerFilter: Manager | undefined;
  if (parsed.manager) {
    if (!(MANAGERS as readonly string[]).includes(parsed.manager)) {
      log.error(`Unknown manager: ${parsed.manager}`);
      console.error(`  Supported: ${MANAGERS.join(", ")}`);
      return 2;
    }
    managerFilter = parsed.manager as Manager;
  }

  let data: ChezmoiData;
  try {
    data = await loadChezmoiData();
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    log.error(`chezmoi data failed: ${msg}`);
    return 1;
  }

  if (data.chezmoi.os !== "darwin" && data.chezmoi.os !== "linux") {
    log.error(`Unsupported OS: ${data.chezmoi.os}`);
    return 1;
  }
  const currentProfile = (data.profile ?? "core") as Profile;
  if (!(PROFILES as readonly string[]).includes(currentProfile)) {
    log.error(`Unknown profile: ${currentProfile}`);
    return 1;
  }
  const packagesFile = join(
    data.chezmoi.sourceDir,
    ".chezmoidata",
    "packages.yaml",
  );
  try {
    await Deno.lstat(packagesFile);
  } catch {
    log.error(`packages.yaml not found at: ${packagesFile}`);
    return 1;
  }

  let targetProfile = currentProfile;
  let explicitProfile = false;
  if (parsed.profile) {
    if (!(PROFILES as readonly string[]).includes(parsed.profile)) {
      log.error(`Unknown profile: ${parsed.profile}`);
      console.error(`  Supported: ${PROFILES.join(", ")}`);
      return 2;
    }
    targetProfile = parsed.profile as Profile;
    explicitProfile = true;
  }

  log.info(`Profile: ${currentProfile} (${data.chezmoi.os})`);

  const ctx: Ctx = {
    data,
    os: data.chezmoi.os,
    profile: currentProfile,
    packagesFile,
    dryRun: parsed["dry-run"] ?? false,
    verbose: parsed.verbose ?? false,
  };

  let ok = true;
  switch (subcommand) {
    case "add":
      if (!managerFilter) {
        log.error("packy add requires -m <manager>");
        return 2;
      }
      if (pkgs.length === 0) {
        log.error("packy add requires one or more package names");
        return 2;
      }
      ok = await cmdAdd(
        ctx,
        managerFilter,
        pkgs,
        targetProfile,
        explicitProfile,
      );
      break;
    case "remove":
      if (pkgs.length === 0) {
        log.error("packy remove requires one or more package names");
        return 2;
      }
      ok = await cmdRemove(ctx, pkgs, managerFilter);
      break;
    case "list":
      ok = cmdList(ctx, managerFilter);
      break;
    case "diff":
      ok = await cmdDiff(ctx, managerFilter);
      break;
    case "check":
      ok = cmdCheck(ctx, managerFilter);
      break;
    case "upgrade":
      ok = await cmdUpgrade(ctx, managerFilter);
      break;
    case "sync":
      ok = await cmdSync(ctx, managerFilter);
      break;
  }

  return ok ? 0 : 1;
}

if (import.meta.main) {
  Deno.exit(await main());
}
