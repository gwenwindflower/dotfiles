#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-run=chezmoi,yq,brew,pnpm,uv
/**
 * packy — snapshot, diff, lint, or update package managers tracked in chezmoi's packages.yaml.
 *
 * Reads state from `chezmoi data` (which merges packages.yaml + chezmoi.toml +
 * built-in vars). Writes packages.yaml via yq so the apt comment block and
 * surrounding formatting survive round-trips. Each leaf is profile-keyed
 * (core + personal/work); save prunes core to live and writes the residual to
 * the current profile's slot, leaving other slots untouched.
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

// ── Types ──────────────────────────────────────────────────────────────

export const MANAGERS = ["homebrew", "pnpm", "uv"] as const;
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
	managers: Manager[];
	dryRun: boolean;
	verbose: boolean;
}

type Subcommand = "save" | "diff" | "lint" | "update";

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

/**
 * Compute new (core, profile) lists with core pruning. `core` is the always-on
 * baseline per arch — if something is uninstalled locally, it leaves core too
 * (other machines must treat that as the new baseline). Items still live but
 * not in core go into the current profile slot. When profile === core,
 * `profileItems` is null and core absorbs everything live.
 */
export function computeSplit(
	oldCore: string[],
	live: string[],
	profile: Profile,
): { core: string[]; profileItems: string[] | null } {
	if (profile === "core") {
		return { core: [...live], profileItems: null };
	}
	const liveSet = new Set(live);
	const newCore = oldCore.filter((x) => liveSet.has(x));
	const coreSet = new Set(newCore);
	const newProfile = live.filter((x) => !coreSet.has(x));
	return { core: newCore, profileItems: newProfile };
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

// ── Live-state readers ─────────────────────────────────────────────────

async function brewTaps() {
	return (await runOutput(["brew", "tap"])).split("\n").filter(Boolean).sort();
}
async function brewFormulae() {
	return (await runOutput(["brew", "list", "-1", "--installed-on-request"]))
		.split("\n")
		.filter(Boolean)
		.sort();
}
async function brewCasks() {
	return (await runOutput(["brew", "list", "--cask", "-1"]))
		.split("\n")
		.filter(Boolean)
		.sort();
}
async function pnpmGlobals() {
	const out = await runOutput(["pnpm", "ls", "-g", "--depth=0", "--json"]);
	const data = JSON.parse(out);
	return Object.keys(data?.[0]?.dependencies ?? {}).sort();
}
async function uvTools() {
	const out = await runOutput(["uv", "tool", "list"]);
	// Tool lines start with the name; bin lines start with "- ".
	const tools = new Set<string>();
	for (const line of out.split("\n")) {
		if (!/^[a-zA-Z0-9]/.test(line)) continue;
		tools.add(line.split(/\s+/)[0]);
	}
	return [...tools].sort();
}

// ── yq writes ──────────────────────────────────────────────────────────

/**
 * Replace the YAML list at `path` (e.g., ".packages.darwin.homebrew.taps.core")
 * with `items`. Done as `path = []` then per-item `+= [...]` so yq preserves
 * surrounding YAML (the apt comment block, in particular).
 */
async function yqSetList(file: string, path: string, items: string[]) {
	await runOutput(["yq", "eval", `${path} = []`, "-i", file]);
	for (const item of items) {
		await runOutput([
			"yq",
			"eval",
			`${path} += [${JSON.stringify(item)}]`,
			"-i",
			file,
		]);
	}
}

interface ListChange {
	path: string;
	coreItems: string[];
	profileItems: string[] | null;
}

function planChange(
	saved: ProfileMap | undefined,
	live: string[],
	profile: Profile,
	path: string,
): ListChange {
	const { core, profileItems } = computeSplit(saved?.core ?? [], live, profile);
	return { path, coreItems: core, profileItems };
}

async function applyChanges(
	file: string,
	changes: ListChange[],
	profile: Profile,
) {
	for (const c of changes) {
		await yqSetList(file, `${c.path}.core`, c.coreItems);
		if (c.profileItems !== null) {
			await yqSetList(file, `${c.path}.${profile}`, c.profileItems);
		}
	}
}

async function withTempCopy<T>(
	file: string,
	fn: (tempFile: string) => Promise<T>,
): Promise<{ tempFile: string; result: T }> {
	const tempFile = await Deno.makeTempFile({
		prefix: "packy-",
		suffix: ".yaml",
	});
	await Deno.copyFile(file, tempFile);
	const result = await fn(tempFile);
	return { tempFile, result };
}

async function finalizeWrite(
	tempFile: string,
	target: string,
	label: string,
	dryRun: boolean,
	verbose: boolean,
) {
	if (verbose) {
		console.log();
		console.log(await Deno.readTextFile(tempFile));
		console.log();
	}
	if (dryRun) {
		await Deno.remove(tempFile);
		console.log(
			`${bold(cyan("󰐪 [DRY RUN]"))} ${bold(brightGreen(label))} — packages.yaml not updated`,
		);
		return;
	}
	await Deno.rename(tempFile, target);
	log.success(`Updated ${label} in ${target}`);
}

// ── Diff + dedup display ───────────────────────────────────────────────

function printDiff(label: string, current: string[], saved: string[]): number {
	const { added, removed } = diffLists(current, saved);
	if (added.length === 0 && removed.length === 0) return 0;
	console.log(`${bold(label)}:`);
	for (const x of added) console.log(`  ${green(`+ ${x}`)}`);
	for (const x of removed) console.log(`  ${red(`- ${x}`)}`);
	console.log();
	return added.length + removed.length;
}

function reportDupes(label: string, map: ProfileMap | undefined): boolean {
	const dupes = findDupes(map);
	if (dupes.length === 0) return true;
	console.log(`${bold(label)} duplicated across profile slots:`);
	for (const { item, slots } of dupes) {
		console.log(`  ${yellow("!")} ${yellow(item)} — in: ${slots.join(", ")}`);
	}
	return false;
}

// ── Per-manager ops ────────────────────────────────────────────────────

function isApplicable(mgr: Manager, os: Os): boolean {
	if (mgr === "pnpm") return true;
	return os === "darwin"; // homebrew, uv
}

async function check(mgr: Manager): Promise<boolean> {
	const bins: Record<Manager, string> = {
		homebrew: "brew",
		pnpm: "pnpm",
		uv: "uv",
	};
	try {
		await runOutput([bins[mgr], "--version"]);
		return true;
	} catch {
		log.error(`${bins[mgr]} not found in PATH`);
		return false;
	}
}

// homebrew

async function homebrewSave(ctx: Ctx) {
	const [taps, formulae, casks] = await Promise.all([
		brewTaps(),
		brewFormulae(),
		brewCasks(),
	]);
	log.info(
		`homebrew: ${taps.length} taps, ${formulae.length} formulae, ${casks.length} casks`,
	);
	const hb = ctx.data.packages?.[ctx.os]?.homebrew;
	const changes: ListChange[] = [
		planChange(
			hb?.taps,
			taps,
			ctx.profile,
			`.packages.${ctx.os}.homebrew.taps`,
		),
		planChange(
			hb?.formulae,
			formulae,
			ctx.profile,
			`.packages.${ctx.os}.homebrew.formulae`,
		),
	];
	if (ctx.os === "darwin") {
		changes.push(
			planChange(
				hb?.casks,
				casks,
				ctx.profile,
				`.packages.${ctx.os}.homebrew.casks`,
			),
		);
	}
	const { tempFile } = await withTempCopy(ctx.packagesFile, (tmp) =>
		applyChanges(tmp, changes, ctx.profile),
	);
	await finalizeWrite(
		tempFile,
		ctx.packagesFile,
		`${ctx.os}.homebrew`,
		ctx.dryRun,
		ctx.verbose,
	);
}

async function homebrewDiff(ctx: Ctx) {
	const [taps, formulae, casks] = await Promise.all([
		brewTaps(),
		brewFormulae(),
		brewCasks(),
	]);
	log.info(
		`homebrew: ${taps.length} taps, ${formulae.length} formulae, ${casks.length} casks`,
	);
	const hb = ctx.data.packages?.[ctx.os]?.homebrew;
	let total = 0;
	total += printDiff("Taps", taps, getEffective(hb?.taps, ctx.profile));
	total += printDiff(
		"Formulae",
		formulae,
		getEffective(hb?.formulae, ctx.profile),
	);
	if (ctx.os === "darwin") {
		total += printDiff("Casks", casks, getEffective(hb?.casks, ctx.profile));
	}
	if (total === 0) log.success("homebrew: no differences");
	else log.info(`homebrew: ${total} change(s)`);
}

async function homebrewUpdate(_ctx: Ctx, dryRun: boolean) {
	if (dryRun) {
		log.info(
			"[DRY RUN] would run: brew update; brew upgrade; brew upgrade --cask; brew autoremove; brew cleanup",
		);
		return;
	}
	for (const cmd of [
		["brew", "update"],
		["brew", "upgrade"],
		["brew", "upgrade", "--cask"],
		["brew", "autoremove"],
		["brew", "cleanup"],
	]) {
		log.info(`${cmd.join(" ")}...`);
		if (!(await runInteractive(cmd))) {
			log.warn(`${cmd.join(" ")} returned non-zero — continuing`);
		}
	}
}

function homebrewLint(ctx: Ctx): boolean {
	const hb = ctx.data.packages?.darwin?.homebrew;
	const tapsOk = reportDupes("Taps", hb?.taps);
	const formOk = reportDupes("Formulae", hb?.formulae);
	const casksOk = reportDupes("Casks", hb?.casks);
	const ok = tapsOk && formOk && casksOk;
	if (ok)
		log.success("homebrew lint passed — no duplicates across profile slots");
	else
		log.info(
			"Promote shared items to core, or remove duplicates from the secondary slot.",
		);
	return ok;
}

// pnpm

async function pnpmSave(ctx: Ctx) {
	const globals = await pnpmGlobals();
	log.info(`pnpm: ${globals.length} globals`);
	const change = planChange(
		ctx.data.packages?.[ctx.os]?.pnpm,
		globals,
		ctx.profile,
		`.packages.${ctx.os}.pnpm`,
	);
	const { tempFile } = await withTempCopy(ctx.packagesFile, (tmp) =>
		applyChanges(tmp, [change], ctx.profile),
	);
	await finalizeWrite(
		tempFile,
		ctx.packagesFile,
		`${ctx.os}.pnpm`,
		ctx.dryRun,
		ctx.verbose,
	);
}

async function pnpmDiff(ctx: Ctx) {
	const globals = await pnpmGlobals();
	log.info(`pnpm: ${globals.length} globals`);
	const saved = getEffective(ctx.data.packages?.[ctx.os]?.pnpm, ctx.profile);
	const total = printDiff("pnpm globals", globals, saved);
	if (total === 0) log.success("pnpm: no differences");
	else log.info(`pnpm: ${total} change(s)`);
}

async function pnpmUpdate(_ctx: Ctx, dryRun: boolean) {
	if (dryRun) {
		log.info("[DRY RUN] would run: pnpm update -g");
		return;
	}
	log.info("pnpm update -g...");
	await runInteractive(["pnpm", "update", "-g"]);
}

function pnpmLint(ctx: Ctx): boolean {
	const darwinOk = reportDupes(
		"darwin pnpm globals",
		ctx.data.packages?.darwin?.pnpm,
	);
	const linuxOk = reportDupes(
		"linux pnpm globals",
		ctx.data.packages?.linux?.pnpm,
	);

	const darwinAll = new Set(getAllSlots(ctx.data.packages?.darwin?.pnpm));
	const linuxAll = getAllSlots(ctx.data.packages?.linux?.pnpm);
	const missing = linuxAll.filter((g) => !darwinAll.has(g));
	let subsetOk = true;
	if (missing.length > 0) {
		subsetOk = false;
		log.warn(
			`pnpm: linux globals not present in darwin (${missing.length} issue(s))`,
		);
		for (const g of missing) console.log(`  ${yellow(`! ${g}`)}`);
		log.info("Either install on darwin and re-run save, or drop from linux.");
	}

	const ok = darwinOk && linuxOk && subsetOk;
	if (ok) {
		log.success(
			`pnpm lint passed — ${linuxAll.length} linux globals all in darwin, no duplicates`,
		);
	}
	return ok;
}

// uv

async function uvSave(ctx: Ctx) {
	const tools = await uvTools();
	log.info(`uv: ${tools.length} tools`);
	const change = planChange(
		ctx.data.packages?.darwin?.uv,
		tools,
		ctx.profile,
		`.packages.${ctx.os}.uv`,
	);
	const { tempFile } = await withTempCopy(ctx.packagesFile, (tmp) =>
		applyChanges(tmp, [change], ctx.profile),
	);
	await finalizeWrite(
		tempFile,
		ctx.packagesFile,
		`${ctx.os}.uv`,
		ctx.dryRun,
		ctx.verbose,
	);
}

async function uvDiff(ctx: Ctx) {
	const tools = await uvTools();
	log.info(`uv: ${tools.length} tools`);
	const saved = getEffective(ctx.data.packages?.darwin?.uv, ctx.profile);
	const total = printDiff("uv tools", tools, saved);
	if (total === 0) log.success("uv: no differences");
	else log.info(`uv: ${total} change(s)`);
}

async function uvUpdate(_ctx: Ctx, dryRun: boolean) {
	if (dryRun) {
		log.info("[DRY RUN] would run: uv tool upgrade --all");
		return;
	}
	log.info("uv tool upgrade --all...");
	await runInteractive(["uv", "tool", "upgrade", "--all"]);
}

function uvLint(ctx: Ctx): boolean {
	const ok = reportDupes("uv tools", ctx.data.packages?.darwin?.uv);
	if (ok) log.success("uv lint passed — no duplicates across profile slots");
	return ok;
}

// ── Dispatch ───────────────────────────────────────────────────────────

interface ManagerOps {
	save: (ctx: Ctx) => Promise<void>;
	diff: (ctx: Ctx) => Promise<void>;
	update: (ctx: Ctx, dryRun: boolean) => Promise<void>;
	lint: (ctx: Ctx) => boolean;
}

const managerOps: Record<Manager, ManagerOps> = {
	homebrew: {
		save: homebrewSave,
		diff: homebrewDiff,
		update: homebrewUpdate,
		lint: homebrewLint,
	},
	pnpm: { save: pnpmSave, diff: pnpmDiff, update: pnpmUpdate, lint: pnpmLint },
	uv: { save: uvSave, diff: uvDiff, update: uvUpdate, lint: uvLint },
};

async function dispatch(
	ctx: Ctx,
	subcommand: "save" | "diff" | "update",
): Promise<boolean> {
	let ok = true;
	for (const mgr of ctx.managers) {
		if (!isApplicable(mgr, ctx.os)) {
			if (ctx.verbose) log.info(`Skipping ${mgr} (no ${ctx.os} section)`);
			continue;
		}
		if (!(await check(mgr))) {
			log.warn(`Skipping ${mgr} (dependency check failed)`);
			ok = false;
			continue;
		}
		console.log();
		log.step(`── ${mgr}: ${subcommand} ──`);
		try {
			if (subcommand === "update") {
				await managerOps[mgr].update(ctx, ctx.dryRun);
			} else {
				await managerOps[mgr][subcommand](ctx);
			}
		} catch (err) {
			const msg = err instanceof Error ? err.message : String(err);
			log.error(`${mgr} ${subcommand} failed: ${msg}`);
			ok = false;
		}
	}
	return ok;
}

function dispatchLint(ctx: Ctx): boolean {
	let ok = true;
	for (const mgr of ctx.managers) {
		ok = managerOps[mgr].lint(ctx) && ok;
	}
	return ok;
}

// ── CLI ────────────────────────────────────────────────────────────────

function printHelp() {
	console.log(`Manage multi-tool package state in chezmoi's packages.yaml.

Usage: packy [OPTIONS] [SUBCOMMAND]

Subcommands:
  save        Capture current state into core + current profile (default)
  diff        Compare current state against core + current profile
  lint        Cross-profile dedup; linux pnpm ⊂ darwin pnpm
  update      Run upgrades for each manager, then save the new state

Options:
  -h, --help                Show this help
  -d, --dry-run             Show what would happen without writing or upgrading
  -v, --verbose             Print full package lists / extra detail
  -m, --manager <name>      Limit to one manager: homebrew, pnpm, uv

Managers:
  homebrew    taps, formulae, casks (darwin-only; linux uses apt)
  pnpm        global packages (both OSes)
  uv          tools (darwin-only)

Profiles:
  Every leaf is profile-keyed: core / personal / work.
  Current profile comes from \`chezmoi data .profile\`.
  save writes to core + current profile only. core is pruned to live —
  if you uninstall something locally, it leaves core (the per-arch baseline).
  Other profile slots are never touched; promote between profiles by hand.

Examples:
  packy                       # Save all managers, then lint
  packy diff                  # Show every change vs packages.yaml
  packy update                # Upgrade all, snapshot result, lint
  packy update -m pnpm        # Just upgrade pnpm globals + save
  packy save -m homebrew      # Snapshot only homebrew state
  packy diff -m uv -v         # Verbose diff for uv tools only`);
}

const VALID_SUBCOMMANDS = ["save", "diff", "lint", "update"] as const;

export async function main(args: string[] = Deno.args): Promise<number> {
	const parsed = parseArgs(args, {
		boolean: ["help", "dry-run", "verbose"],
		string: ["manager"],
		alias: { h: "help", d: "dry-run", v: "verbose", m: "manager" },
	});

	if (parsed.help) {
		printHelp();
		return 0;
	}

	const sub = (parsed._[0] as string | undefined) ?? "save";
	if (!(VALID_SUBCOMMANDS as readonly string[]).includes(sub)) {
		log.error(`Unknown subcommand: ${sub}`);
		console.error(`  Supported: ${VALID_SUBCOMMANDS.join(", ")}`);
		console.error("Try: packy --help");
		return 2;
	}
	const subcommand = sub as Subcommand;

	let managers: Manager[];
	if (parsed.manager) {
		if (!(MANAGERS as readonly string[]).includes(parsed.manager)) {
			log.error(`Unknown manager: ${parsed.manager}`);
			console.error(`  Supported: ${MANAGERS.join(", ")}`);
			return 2;
		}
		managers = [parsed.manager as Manager];
	} else {
		managers = [...MANAGERS];
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
	const profile = (data.profile ?? "core") as Profile;
	if (!(PROFILES as readonly string[]).includes(profile)) {
		log.error(
			`Unknown profile: ${profile} (expected one of ${PROFILES.join(", ")})`,
		);
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

	log.info(`Profile: ${profile} (${data.chezmoi.os})`);

	const ctx: Ctx = {
		data,
		os: data.chezmoi.os,
		profile,
		packagesFile,
		managers,
		dryRun: parsed["dry-run"] ?? false,
		verbose: parsed.verbose ?? false,
	};

	if (subcommand === "lint") {
		return dispatchLint(ctx) ? 0 : 1;
	}

	let ok = await dispatch(ctx, subcommand);

	if (subcommand === "update") {
		console.log();
		log.step("Snapshotting post-update state...");
		ctx.data = await loadChezmoiData();
		ok = (await dispatch({ ...ctx }, "save")) && ok;
	}

	// Auto-lint after any state-changing op (refresh data so we lint what we
	// just wrote, not the pre-save state). Always covers every manager,
	// regardless of the -m filter.
	if (subcommand === "save" || subcommand === "update") {
		console.log();
		log.step("Running lint check...");
		ctx.data = await loadChezmoiData();
		dispatchLint({ ...ctx, managers: [...MANAGERS] });
	}

	return ok ? 0 : 1;
}

if (import.meta.main) {
	Deno.exit(await main());
}
