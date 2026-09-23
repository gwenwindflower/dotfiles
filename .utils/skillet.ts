#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env --allow-run=gh,git

import { Command } from "@cliffy/command";
import {
  bold,
  brightGreen,
  cyan,
  dim,
  green,
  magenta,
  red,
  yellow,
} from "@std/fmt/colors";
import { copy, exists } from "@std/fs";
import { basename, join, resolve } from "@std/path";
import { parse as parseToml } from "@std/toml";
import { parse as parseYaml } from "@std/yaml";

const decoder = new TextDecoder();

export const SOURCE_ROOT = resolve(import.meta.dirname ?? ".", "..");
export const SKILLS_DIR = join(SOURCE_ROOT, "skills");
export const MANIFEST_PATH = join(SKILLS_DIR, "upstream.toml");

const log = {
  info: (message: string) => console.log(`${bold(cyan("•"))} ${message}`),
  warn: (message: string) => console.log(`${bold(yellow("⚠"))} ${message}`),
  error: (message: string) =>
    console.error(`${bold(red("✗"))} ${red(message)}`),
  success: (message: string) =>
    console.log(`${bold(brightGreen("✓"))} ${green(message)}`),
  step: (message: string) => console.log(`${bold(magenta("◆"))} ${message}`),
};

export interface UpstreamEntry {
  spine: string;
  repo: string;
  skill: string;
  files: string[];
  baseline: string;
  tree: string;
  pin: string | undefined;
}

export interface SkillMetadata {
  repo: string;
  path: string;
  ref: string;
  tree: string;
}

export type UpstreamStatus = "new" | "changed" | "current";

export function parseManifest(text: string): UpstreamEntry[] {
  const data = parseToml(text) as Record<string, unknown>;
  const entries: UpstreamEntry[] = [];
  for (const [spine, table] of Object.entries(data)) {
    const upstream = (table as { upstream?: unknown })?.upstream;
    if (!Array.isArray(upstream)) {
      throw new Error(
        `${spine}: expected [[${spine}.upstream]] entries, one per upstream skill`,
      );
    }
    upstream.forEach((raw: Record<string, unknown>, index) => {
      const label = `${spine} upstream ${index + 1} (${raw.repo ?? "?"} ${
        raw.skill ?? "?"
      })`;
      const text = (key: string, required: boolean): string => {
        const value = raw[key];
        if (value === undefined && !required) return "";
        if (typeof value !== "string" || (required && value === "")) {
          throw new Error(`${label}: ${key} must be a non-empty string`);
        }
        return value;
      };
      const repo = text("repo", true);
      if (!/^[\w.-]+\/[\w.-]+$/.test(repo)) {
        throw new Error(`${label}: repo must be owner/name, got "${repo}"`);
      }
      const files = raw.files;
      if (
        !Array.isArray(files) || files.length === 0 ||
        files.some((f) => typeof f !== "string" || f === "")
      ) {
        throw new Error(
          `${label}: files must list at least one spine-relative doc, like ["qmd.md"]`,
        );
      }
      for (const file of files as string[]) {
        if (file.startsWith("/") || file.split("/").includes("..")) {
          throw new Error(
            `${label}: "${file}" must be a relative path inside the spine, like "qmd.md" or "ref/qmd.md"`,
          );
        }
      }
      const pin = text("pin", false);
      entries.push({
        spine,
        repo,
        skill: text("skill", true),
        files: files as string[],
        baseline: text("baseline", false),
        tree: text("tree", false),
        pin: pin === "" ? undefined : pin,
      });
    });
  }
  const seen = new Set<string>();
  for (const entry of entries) {
    if (seen.has(entry.skill)) {
      throw new Error(
        `skill ${entry.skill} appears more than once in upstream.toml; commands address entries by skill name`,
      );
    }
    seen.add(entry.skill);
  }
  return entries;
}

export function findEntry(
  entries: UpstreamEntry[],
  skill: string,
): UpstreamEntry {
  const entry = entries.find((e) => e.skill === skill);
  if (!entry) {
    const known = entries.map((e) => e.skill).join(", ") || "none";
    throw new Error(`no upstream entry for skill "${skill}" (known: ${known})`);
  }
  return entry;
}

export function sharedFileSources(
  entries: UpstreamEntry[],
  entry: UpstreamEntry,
): { skill: string; file: string }[] {
  return entries.flatMap((other) =>
    other === entry || other.spine !== entry.spine
      ? []
      : other.files.filter((f) => entry.files.includes(f)).map((file) => ({
        skill: other.skill,
        file,
      }))
  );
}

export function setBaseline(
  text: string,
  skill: string,
  values: { baseline: string; tree: string },
): string {
  const lines = text.split("\n");
  const starts = lines.flatMap((line, i) =>
    /^\[\[[\w-]+\.upstream\]\]$/.test(line.trim()) ? [i] : []
  );
  const skillLine = new RegExp(
    `^skill\\s*=\\s*"${skill.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}"\\s*$`,
  );
  for (const [n, start] of starts.entries()) {
    let end = n + 1 < starts.length ? starts[n + 1] : lines.length;
    const nextTable = lines.slice(start + 1, end).findIndex((l) =>
      l.trim().startsWith("[")
    );
    if (nextTable !== -1) end = start + 1 + nextTable;
    if (!lines.slice(start, end).some((l) => skillLine.test(l.trim()))) {
      continue;
    }

    const block = lines.slice(start, end);
    for (const key of ["baseline", "tree"] as const) {
      const line = `${key} = "${values[key]}"`;
      const at = block.findIndex((l) =>
        new RegExp(`^${key}\\s*=`).test(l.trim())
      );
      if (at !== -1) {
        block[at] = line;
      } else {
        let last = block.length - 1;
        while (last > 0 && block[last].trim() === "") last--;
        block.splice(last + 1, 0, line);
      }
    }
    return [...lines.slice(0, start), ...block, ...lines.slice(end)].join("\n");
  }
  throw new Error(`no upstream entry for skill "${skill}" in upstream.toml`);
}

function frontmatter(
  text: string,
): { lines: string[]; end: number } | undefined {
  const lines = text.split("\n");
  if (lines[0] !== "---") return undefined;
  const end = lines.indexOf("---", 1);
  return end === -1 ? undefined : { lines, end };
}

export function parseSkillMetadata(skillMd: string): SkillMetadata {
  const fm = frontmatter(skillMd);
  const data = fm
    ? parseYaml(fm.lines.slice(1, fm.end).join("\n")) as Record<string, unknown>
    : {};
  const meta = (data?.metadata ?? {}) as Record<string, unknown>;
  const field = (key: string): string => {
    const value = meta[key];
    if (typeof value !== "string" || value === "") {
      throw new Error(
        `SKILL.md has no metadata.${key}; it was not installed by gh skill`,
      );
    }
    return value;
  };
  const url = field("github-repo");
  return {
    repo: url.replace(/^https:\/\/github\.com\//, "").replace(/\.git$/, ""),
    path: field("github-path"),
    ref: field("github-ref"),
    tree: field("github-tree-sha"),
  };
}

export function refName(ref: string): string {
  return ref.replace(/^refs\/(tags|heads)\//, "");
}

export function upstreamStatus(
  entry: UpstreamEntry,
  fetchedTree: string,
): UpstreamStatus {
  if (entry.baseline === "") return "new";
  return entry.tree === fetchedTree ? "current" : "changed";
}

export function stripGhMetadata(skillMd: string): string {
  const fm = frontmatter(skillMd);
  if (!fm) return skillMd;
  const head = fm.lines.slice(0, fm.end).filter((l) =>
    !/^\s+github-[\w-]+:/.test(l)
  );
  const kept = head.filter((l, i) =>
    !(l === "metadata:" && !/^\s/.test(head[i + 1] ?? ""))
  );
  return [...kept, ...fm.lines.slice(fm.end)].join("\n");
}

async function run(
  cmd: string,
  args: string[],
  okCodes = [0],
  cwd?: string,
): Promise<string> {
  const out = await new Deno.Command(cmd, {
    args,
    cwd,
    stdout: "piped",
    stderr: "piped",
  }).output();
  if (!okCodes.includes(out.code)) {
    throw new Error(
      `${cmd} ${args.join(" ")} failed (exit ${out.code}): ${
        decoder.decode(out.stderr).trim()
      }`,
    );
  }
  return decoder.decode(out.stdout);
}

function lockPath(): string {
  return join(Deno.env.get("HOME") ?? "~", ".agents", ".skill-lock.json");
}

async function fetchSkill(
  entry: UpstreamEntry,
  dir: string,
  pin?: string,
): Promise<{ dir: string; meta: SkillMetadata }> {
  // gh skill writes a top-level lock entry even for --dir installs; the lock replay would install it.
  const lock = lockPath();
  const before = await exists(lock) ? await Deno.readFile(lock) : undefined;
  try {
    const args = [
      "skill",
      "install",
      entry.repo,
      entry.skill,
      "--dir",
      dir,
      "--force",
    ];
    if (pin) args.push("--pin", pin);
    await run("gh", args);
  } finally {
    if (before) await Deno.writeFile(lock, before);
  }
  for await (const child of Deno.readDir(dir)) {
    const skillMd = join(dir, child.name, "SKILL.md");
    if (child.isDirectory && await exists(skillMd)) {
      return {
        dir: join(dir, child.name),
        meta: parseSkillMetadata(await Deno.readTextFile(skillMd)),
      };
    }
  }
  throw new Error(
    `gh installed ${entry.repo} ${entry.skill} but no SKILL.md landed in ${dir}`,
  );
}

async function resolveCommit(meta: SkillMetadata): Promise<string> {
  if (/^[0-9a-f]{40}$/.test(meta.ref)) return meta.ref;
  return (await run("gh", [
    "api",
    `repos/${meta.repo}/commits/${refName(meta.ref)}`,
    "--jq",
    ".sha",
  ])).trim();
}

async function loadManifest(): Promise<
  { text: string; entries: UpstreamEntry[] }
> {
  const text = await Deno.readTextFile(MANIFEST_PATH);
  return { text, entries: parseManifest(text) };
}

async function checkCommand(): Promise<number> {
  const { entries } = await loadManifest();
  let pending = 0;
  for (const entry of entries) {
    const tmp = await Deno.makeTempDir({ prefix: "skillet-check-" });
    try {
      const { meta } = await fetchSkill(entry, tmp, entry.pin);
      const status = upstreamStatus(entry, meta.tree);
      const where = `${entry.repo} ${entry.skill} @ ${refName(meta.ref)}`;
      if (status === "current") {
        log.success(`${entry.skill}: current ${dim(where)}`);
      } else {
        pending++;
        log.warn(
          `${entry.skill}: ${
            status === "new" ? "never distilled" : "upstream changed"
          } ${dim(where)}`,
        );
      }
    } finally {
      await Deno.remove(tmp, { recursive: true });
    }
  }
  if (pending > 0) {
    log.info(
      `run ${
        bold("skillet diff <skill>")
      } for each, fold into its files, then ${bold("skillet accept <skill>")}`,
    );
  }
  return pending > 0 ? 1 : 0;
}

async function diffCommand(skill: string): Promise<number> {
  const { entries } = await loadManifest();
  const entry = findEntry(entries, skill);
  const root = await Deno.makeTempDir({ prefix: `skillet-${skill}-` });
  const next = await fetchSkill(entry, join(root, "new"), entry.pin);
  const commit = await resolveCommit(next.meta);
  const oldDir = join(root, "old", basename(next.dir));
  if (entry.baseline) {
    await fetchSkill(entry, join(root, "old"), entry.baseline);
  } else {
    await Deno.mkdir(oldDir, { recursive: true });
  }
  log.step(
    `${entry.repo} ${entry.skill}: ${
      entry.baseline ? entry.baseline.slice(0, 8) : "(never distilled)"
    } → ${commit.slice(0, 8)}`,
  );
  log.info(
    `folds into: ${
      entry.files.map((f) => `skills/${entry.spine}/${f}`).join(", ")
    }`,
  );
  for (const { skill: other, file } of sharedFileSources(entries, entry)) {
    log.info(
      `${file} also carries ${other}; keep its content unless this diff supersedes it`,
    );
  }
  log.info(`old: ${oldDir}`);
  log.info(`new: ${next.dir}`);
  if (upstreamStatus(entry, next.meta.tree) === "current") {
    log.success("no upstream changes since the baseline");
    return 0;
  }
  for (const dir of [oldDir, next.dir]) {
    const skillMd = join(dir, "SKILL.md");
    if (await exists(skillMd)) {
      await Deno.writeTextFile(
        skillMd,
        stripGhMetadata(await Deno.readTextFile(skillMd)),
      );
    }
  }
  const name = basename(next.dir);
  console.log(
    await run(
      "git",
      [
        "diff",
        "--no-index",
        "--no-color",
        join("old", name),
        join("new", name),
      ],
      [0, 1],
      root,
    ),
  );
  log.info(
    `after folding, record this version: ${
      bold(`skillet accept ${skill} --commit ${commit}`)
    }`,
  );
  return 0;
}

async function acceptCommand(skill: string, commit?: string): Promise<number> {
  const { text, entries } = await loadManifest();
  const entry = findEntry(entries, skill);
  const tmp = await Deno.makeTempDir({ prefix: "skillet-accept-" });
  try {
    const { meta } = await fetchSkill(entry, tmp, commit ?? entry.pin);
    const baseline = commit ?? await resolveCommit(meta);
    await Deno.writeTextFile(
      MANIFEST_PATH,
      setBaseline(text, skill, { baseline, tree: meta.tree }),
    );
    log.success(
      `${skill}: baseline ${baseline.slice(0, 8)} (tree ${
        meta.tree.slice(0, 8)
      }) recorded in skills/upstream.toml`,
    );
  } finally {
    await Deno.remove(tmp, { recursive: true });
  }
  return 0;
}

async function saveCommand(names: string[], dryRun: boolean): Promise<number> {
  const deployedRoot = join(Deno.env.get("HOME") ?? "~", ".agents", "skills");
  let failed = 0;
  for (const name of names) {
    const deployed = join(deployedRoot, name);
    const saved = join(SKILLS_DIR, name);
    if (!await exists(join(deployed, "SKILL.md"))) {
      log.error(`${name} is not a deployed skill (no ${deployed}/SKILL.md)`);
      failed = 1;
      continue;
    }
    if (dryRun) {
      log.info(`would replace skills/${name} with ${deployed}`);
      continue;
    }
    if (await exists(saved)) await Deno.remove(saved, { recursive: true });
    await copy(deployed, saved);
    for await (const junk of Deno.readDir(saved)) {
      if (junk.name === ".DS_Store") await Deno.remove(join(saved, junk.name));
    }
    const skillMd = join(saved, "SKILL.md");
    await Deno.writeTextFile(
      skillMd,
      stripGhMetadata(await Deno.readTextFile(skillMd)),
    );
    log.success(`saved ${name} to skills/${name}`);
  }
  return failed;
}

export async function main(args: string[] = Deno.args): Promise<number> {
  let code = 0;
  const cli = new Command()
    .name("skillet")
    .description(
      "Curate the dotfiles skill library. gh skill fetches upstream skills; skillet diffs them against the version last distilled into our spines (skills/upstream.toml) and saves deployed edits back to source.",
    )
    .action(function () {
      this.showHelp();
    })
    .command(
      "check",
      "List upstream skills that changed since their baseline. Exits 1 when any need distilling.",
    )
    .action(async () => {
      code = await checkCommand();
    })
    .command(
      "diff <skill:string>",
      "Fetch the baseline and current upstream versions and print their diff, with both paths kept for reading.",
    )
    .action(async (_opts, skill) => {
      code = await diffCommand(skill);
    })
    .command(
      "accept <skill:string>",
      "Record the upstream version just distilled as the new baseline.",
    )
    .option(
      "--commit <sha:string>",
      "Commit to record, as printed by diff. Defaults to the current upstream version.",
    )
    .action(async ({ commit }, skill) => {
      code = await acceptCommand(skill, commit);
    })
    .command(
      "save <skills...:string>",
      "Copy deployed skills from ~/.agents/skills back into skills/, stripping gh metadata.",
    )
    .option("-n, --dry-run", "Show what would be replaced without writing.")
    .action(async ({ dryRun }, ...skills) => {
      code = await saveCommand(skills, dryRun ?? false);
    });
  try {
    await cli.parse(args);
  } catch (error) {
    log.error(error instanceof Error ? error.message : String(error));
    return 1;
  }
  return code;
}

if (import.meta.main) {
  Deno.exit(await main());
}
