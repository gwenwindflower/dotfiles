#!/usr/bin/env -S deno run --allow-read --allow-write --allow-run=git
import { parseArgs } from "@std/cli/parse-args";
import { join } from "@std/path";

export type ItchOptions = {
  name: string;
  worktrees: string[];
  commits: number;
  hasRemote: boolean;
  parent?: string;
};

export type Itch = {
  root: string;
  repo: string;
  origin?: string;
  worktrees: string[];
};

const DEFAULT_BRANCH = "main";
const NAME_PATTERN = /^[A-Za-z0-9._-]+$/;
const BRANCH_PATTERN = /^[A-Za-z0-9._-]+(\/[A-Za-z0-9._-]+)*$/;

const HELP = `itch: build a throwaway git repository to scratch on

Usage: deno task itch [options]

Options:
  -n, --name <name>        Repository directory name (default: repo)
  -w, --worktree <branch>  Add a sibling worktree on a new pushed branch; repeatable
  -c, --commits <n>        Commits on main (default: 2)
      --no-remote          Skip the bare origin; branches stay local
  -p, --parent <dir>       Directory to create the itch-* root in (default: system temp)
  -h, --help               Show this help

Prints the main worktree's path on stdout, so \`cd (deno task itch)\` lands in it.`;

/** Reads and validates itch's flags; errors name the flag at fault. */
export function parseItchArgs(args: string[]): ItchOptions {
  const parsed = parseArgs(args, {
    alias: { n: "name", w: "worktree", c: "commits", p: "parent", h: "help" },
    string: ["name", "worktree", "commits", "parent"],
    boolean: ["remote", "help"],
    collect: ["worktree"],
    negatable: ["remote"],
    default: { remote: true },
    unknown: (arg) => {
      if (arg.startsWith("-")) {
        throw new Error(`unknown option ${arg}; see --help`);
      }
      throw new Error(`unexpected argument ${arg}; see --help`);
    },
  });

  const name = parsed.name ?? "repo";
  if (!NAME_PATTERN.test(name)) {
    throw new Error(
      `--name ${name}: use letters, digits, dots, dashes, and underscores`,
    );
  }

  const commits = Number(parsed.commits ?? "2");
  if (!Number.isInteger(commits) || commits < 1) {
    throw new Error(
      `--commits ${parsed.commits}: expected a whole number of at least 1`,
    );
  }

  const worktrees = parsed.worktree.filter((branch): branch is string =>
    typeof branch === "string"
  );
  for (const branch of worktrees) {
    if (!BRANCH_PATTERN.test(branch) || branch.includes("..")) {
      throw new Error(`--worktree ${branch}: not a usable branch name`);
    }
    if (branch === DEFAULT_BRANCH) {
      throw new Error(
        `--worktree ${branch}: ${DEFAULT_BRANCH} is already checked out in the main worktree`,
      );
    }
  }
  const repeated = worktrees.find((branch, index) =>
    worktrees.indexOf(branch) !== index
  );
  if (repeated) throw new Error(`--worktree ${repeated}: given more than once`);

  const options: ItchOptions = {
    name,
    worktrees,
    commits,
    hasRemote: parsed.remote,
  };
  if (parsed.parent !== undefined) options.parent = parsed.parent;
  return options;
}

/** Where Worktrunk's default template puts a branch's worktree: beside the repo, `/` sanitized to `-`. */
export function siblingPath(
  root: string,
  name: string,
  branch: string,
): string {
  return join(root, `${name}.${branch.replaceAll("/", "-")}`);
}

async function git(cwd: string, ...args: string[]): Promise<string> {
  const output = await new Deno.Command("git", { args, cwd, stdin: "null" })
    .output();
  const decode = (bytes: Uint8Array) => new TextDecoder().decode(bytes).trim();
  if (!output.success) {
    throw new Error(
      `git ${args.join(" ")} failed in ${cwd}: ${
        decode(output.stderr) || `exit ${output.code}`
      }`,
    );
  }
  return decode(output.stdout);
}

async function commitFile(
  cwd: string,
  file: string,
  content: string,
  message: string,
) {
  await Deno.writeTextFile(join(cwd, file), content);
  await git(cwd, "add", file);
  await git(cwd, "commit", "--quiet", "-m", message);
}

const LOCAL_CONFIG: [string, string][] = [
  ["user.name", "itch"],
  ["user.email", "itch@localhost"],
  ["commit.gpgsign", "false"],
  ["tag.gpgsign", "false"],
];

/** Builds the repository, its optional bare origin, and its sibling worktrees under a fresh itch-* root. */
export async function createItch(options: ItchOptions): Promise<Itch> {
  const root = await Deno.makeTempDir({
    prefix: "itch-",
    ...(options.parent ? { dir: options.parent } : {}),
  });
  const repo = join(root, options.name);
  const origin = options.hasRemote ? join(root, "origin.git") : undefined;

  await git(root, "init", "--quiet", "-b", DEFAULT_BRANCH, repo);
  for (const [key, value] of LOCAL_CONFIG) {
    await git(repo, "config", "--local", key, value);
  }

  await commitFile(
    repo,
    "README.md",
    `# ${options.name}\n\nA scratch repository built by itch.\n`,
    "docs: add readme",
  );
  for (let index = 2; index <= options.commits; index += 1) {
    await commitFile(
      repo,
      `notes-${index}.md`,
      `Note ${index}\n`,
      `docs: add note ${index}`,
    );
  }

  if (origin) {
    await git(root, "init", "--quiet", "--bare", "-b", DEFAULT_BRANCH, origin);
    await git(repo, "remote", "add", "origin", origin);
    await git(repo, "push", "--quiet", "-u", "origin", DEFAULT_BRANCH);
    await git(repo, "remote", "set-head", "origin", DEFAULT_BRANCH);
  }

  const worktrees: string[] = [];
  for (const branch of options.worktrees) {
    const path = siblingPath(root, options.name, branch);
    await git(
      repo,
      "worktree",
      "add",
      "--quiet",
      "-b",
      branch,
      path,
      DEFAULT_BRANCH,
    );
    await commitFile(
      path,
      `${branch.replaceAll("/", "-")}.md`,
      `Work on ${branch}\n`,
      `feat: start ${branch}`,
    );
    if (origin) await git(path, "push", "--quiet", "-u", "origin", branch);
    worktrees.push(path);
  }

  return origin ? { root, repo, origin, worktrees } : { root, repo, worktrees };
}

async function main() {
  if (Deno.args.includes("--help") || Deno.args.includes("-h")) {
    console.log(HELP);
    return;
  }

  const itch = await createItch(parseItchArgs(Deno.args));
  const lines = [
    `itch: built ${itch.root}`,
    `  repo       ${itch.repo} (${DEFAULT_BRANCH})`,
  ];
  if (itch.origin) lines.push(`  origin     ${itch.origin}`);
  for (const worktree of itch.worktrees) lines.push(`  worktree   ${worktree}`);
  console.error(lines.join("\n"));
  console.log(itch.repo);
}

if (import.meta.main) {
  try {
    await main();
  } catch (error) {
    console.error(`itch: ${error instanceof Error ? error.message : error}`);
    Deno.exit(1);
  }
}
