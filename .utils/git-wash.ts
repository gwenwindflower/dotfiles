#!/usr/bin/env -S deno run --allow-read --allow-write --allow-run=git,gh

import { Command } from "@cliffy/command";
import {
  bold,
  brightGreen,
  cyan,
  green,
  magenta,
  red,
  yellow,
} from "@std/fmt/colors";
import { join, resolve } from "@std/path";

const decoder = new TextDecoder();
const DAY_SECONDS = 86_400;
const MANIFEST_VERSION = 2;
const REVIEWS_VERSION = 1;

export interface ProgressReporter {
  info(message: string): void;
  step(message: string): void;
}

const log = {
  info: (message: string) => console.log(`${bold(cyan("•"))} ${message}`),
  warn: (message: string) => console.log(`${bold(yellow("⚠"))} ${message}`),
  error: (message: string) =>
    console.error(`${bold(red("✗"))} ${red(message)}`),
  success: (message: string) =>
    console.log(`${bold(brightGreen("✓"))} ${green(message)}`),
  step: (message: string) => console.log(`${bold(magenta("◆"))} ${message}`),
};

function branchCount(count: number): string {
  return `${count} ${count === 1 ? "branch" : "branches"}`;
}

export type Tier = "tier1" | "tier2" | "tier3";
export type Classification = Tier | "keep";
export type WashTarget = Tier | "test" | "reviewed";

export interface RemoteBranch {
  name: string;
  sha: string;
  committedAt: number;
  author: string;
}

export interface PullRequestEvidence {
  number: number;
  branch: string;
  state: "OPEN" | "CLOSED" | "MERGED";
  baseBranch: string;
  headSha: string;
  url: string;
}

export interface ReviewSignal {
  kind: string;
  weight: number;
  detail: string;
}

export interface BranchReviewMetrics {
  uniqueCommitCount: number;
  uniqueAuthorCount: number;
  changedFileCount: number;
  additions: number;
  deletions: number;
  containedByBranches: string[];
  botAuthored: boolean;
}

export interface ReviewPriority extends BranchReviewMetrics {
  score: number;
  unclampedScore: number;
  signals: ReviewSignal[];
}

export interface ClassifiedBranch extends RemoteBranch {
  tipAgeDays: number;
  tier: Classification;
  reason: string;
  pullRequest: Omit<PullRequestEvidence, "branch"> | null;
  reviewPriority: ReviewPriority | null;
}

export interface GitWashManifest {
  version: 2;
  repository: {
    root: string;
    remote: string;
    remoteUrl: string;
    slug: string;
    defaultBranch: string;
  };
  criteria: { staleDays: number };
  generatedAt: string;
  branches: ClassifiedBranch[];
  test: string[];
}

export type ReviewRecommendation = "keep" | "delete" | "human-review";
export type ReviewConfidence = "high" | "medium" | "low";

export interface BranchReview {
  sha: string;
  recommendation: ReviewRecommendation;
  confidence: ReviewConfidence;
  summary: string;
  evidence: string[];
  reviewer: string;
}

export interface GitWashReviews {
  version: 1;
  repository: {
    slug: string;
    remote: string;
    remoteUrl: string;
  };
  manifestGeneratedAt: string;
  branches: Record<string, BranchReview>;
}

export interface CommandResult {
  code: number;
  stdout: string;
  stderr: string;
}

export type CommandRunner = (
  command: string,
  args: string[],
  cwd: string,
) => Promise<CommandResult>;

export const runCommand: CommandRunner = async (command, args, cwd) => {
  const result = await new Deno.Command(command, {
    args,
    cwd,
    stdout: "piped",
    stderr: "piped",
  }).output();
  return {
    code: result.code,
    stdout: decoder.decode(result.stdout),
    stderr: decoder.decode(result.stderr),
  };
};

async function checkedCommand(
  runner: CommandRunner,
  command: string,
  args: string[],
  cwd: string,
  displayCommand?: string,
): Promise<string> {
  const result = await runner(command, args, cwd);
  if (result.code !== 0) {
    const detail = result.stderr.trim() || result.stdout.trim() ||
      "unknown error";
    throw new Error(
      `${displayCommand ?? `${command} ${args.join(" ")}`} failed: ${detail}`,
    );
  }
  return result.stdout.trim();
}

function nonemptyLines(value: string): string[] {
  return value.split("\n").map((line) => line.trim()).filter(Boolean);
}

async function removeFileIfPresent(path: string): Promise<void> {
  try {
    await Deno.remove(path);
  } catch (error) {
    if (!(error instanceof Deno.errors.NotFound)) throw error;
  }
}

export interface GitHubRemote {
  host: string;
  slug: string;
  specifier: string;
}

export function parseGitHubRemote(remoteUrl: string): GitHubRemote {
  let host: string;
  let pathname: string;
  const scpMatch = remoteUrl.match(/^(?:[^@]+@)?([^:]+):(.+)$/);

  if (scpMatch && !remoteUrl.includes("://")) {
    [, host, pathname] = scpMatch;
  } else {
    let parsed: URL;
    try {
      parsed = new URL(remoteUrl);
    } catch {
      throw new Error(
        `could not resolve a GitHub repository from remote URL: ${remoteUrl}`,
      );
    }
    host = parsed.hostname;
    pathname = parsed.pathname;
  }

  const slug = pathname.replace(/^\/+|\/+$/g, "").replace(/\.git$/, "");
  if (!host || !/^[^/]+\/[^/]+$/.test(slug)) {
    throw new Error(
      `could not resolve a GitHub repository from remote URL: ${remoteUrl}`,
    );
  }

  return {
    host,
    slug,
    specifier: host === "github.com" ? slug : `${host}/${slug}`,
  };
}

export function isFunctionallyMerged(
  cherryOutput: string,
  uniqueMergeCommits: string,
): boolean {
  const patches = nonemptyLines(cherryOutput);
  return !uniqueMergeCommits.trim() && patches.length > 0 &&
    patches.every((line) => line.startsWith("- "));
}

function cappedLogWeight(
  value: number,
  multiplier: number,
  cap: number,
): number {
  if (value < 1) return 0;
  return Math.min(cap, Math.ceil(Math.log2(value + 1) * multiplier));
}

export function rankTierThreeBranch(
  branch: ClassifiedBranch,
  metrics: BranchReviewMetrics,
): ReviewPriority {
  const signals: ReviewSignal[] = [{
    kind: "baseline",
    weight: 50,
    detail: "Tier 3 starts at a neutral retention score",
  }];
  const addSignal = (kind: string, weight: number, detail: string) => {
    if (weight !== 0) signals.push({ kind, weight, detail });
  };

  addSignal(
    "unique-commits",
    cappedLogWeight(metrics.uniqueCommitCount, 5, 25),
    `${metrics.uniqueCommitCount} commits are not reachable from the default branch`,
  );
  addSignal(
    "multiple-authors",
    Math.min(15, Math.max(0, metrics.uniqueAuthorCount - 1) * 5),
    `${metrics.uniqueAuthorCount} authors contributed unique commits`,
  );
  addSignal(
    "diff-size",
    cappedLogWeight(metrics.changedFileCount, 2, 10),
    `${metrics.changedFileCount} files differ with ${metrics.additions} additions and ${metrics.deletions} deletions`,
  );

  const ageWeight = branch.tipAgeDays >= 730
    ? -20
    : branch.tipAgeDays >= 365
    ? -10
    : branch.tipAgeDays >= 180
    ? -5
    : 0;
  addSignal(
    "old-tip",
    ageWeight,
    `tip commit is ${branch.tipAgeDays} days old`,
  );
  if (branch.pullRequest?.state === "CLOSED") {
    addSignal(
      "closed-pr",
      -20,
      `PR #${branch.pullRequest.number} closed without merging`,
    );
  }
  if (metrics.containedByBranches.length > 0) {
    addSignal(
      "contained-tip",
      -25,
      `tip is reachable from ${metrics.containedByBranches.join(", ")}`,
    );
  }
  if (metrics.botAuthored) {
    addSignal(
      "bot-author",
      -20,
      `tip author appears automated: ${branch.author}`,
    );
  }

  const unclampedScore = signals.reduce(
    (score, signal) => score + signal.weight,
    0,
  );
  return {
    ...metrics,
    score: Math.max(0, Math.min(100, unclampedScore)),
    unclampedScore,
    signals,
  };
}

export function classifyBranches(input: {
  branches: RemoteBranch[];
  defaultBranch: string;
  protectedBranches: Set<string>;
  mergedBranches: Set<string>;
  functionallyMergedBranches: Set<string>;
  pullRequests: PullRequestEvidence[];
  staleDays: number;
  now?: number;
}): ClassifiedBranch[] {
  if (!Number.isInteger(input.staleDays) || input.staleDays < 1) {
    throw new Error("stale days must be a positive integer");
  }

  const now = input.now ?? Date.now() / 1000;
  const pullRequestsByBranch = new Map<string, PullRequestEvidence[]>();
  for (const pullRequest of input.pullRequests) {
    const branchPullRequests = pullRequestsByBranch.get(pullRequest.branch) ??
      [];
    branchPullRequests.push(pullRequest);
    pullRequestsByBranch.set(pullRequest.branch, branchPullRequests);
  }

  return input.branches.map((branch) => {
    const tipAgeDays = Math.floor((now - branch.committedAt) / DAY_SECONDS);
    const pullRequests = pullRequestsByBranch.get(branch.name) ?? [];
    const openPullRequest = pullRequests.find(({ state }) => state === "OPEN");
    const exactMergedPullRequest = pullRequests.find((
      { state, baseBranch, headSha },
    ) =>
      state === "MERGED" && baseBranch === input.defaultBranch &&
      headSha === branch.sha
    );
    const mergedPullRequest = pullRequests.find(({ state }) =>
      state === "MERGED"
    );
    const closedPullRequest = pullRequests.find(({ state }) =>
      state === "CLOSED"
    );

    let tier: Classification = "keep";
    let reason: string;
    let pullRequest: Omit<PullRequestEvidence, "branch"> | null = null;
    const withoutBranch = (
      evidence: PullRequestEvidence,
    ): Omit<PullRequestEvidence, "branch"> => {
      const { branch: _branch, ...pullRequestEvidence } = evidence;
      return pullRequestEvidence;
    };

    if (branch.name === input.defaultBranch) {
      reason = "default branch";
    } else if (input.protectedBranches.has(branch.name)) {
      reason = "protected branch";
    } else if (openPullRequest) {
      reason = `open PR #${openPullRequest.number}`;
      pullRequest = withoutBranch(openPullRequest);
    } else if (tipAgeDays < input.staleDays) {
      reason = `tip commit is ${tipAgeDays} days old`;
    } else if (input.mergedBranches.has(branch.name)) {
      tier = "tier1";
      reason = `merged into ${input.defaultBranch}`;
      pullRequest = exactMergedPullRequest
        ? withoutBranch(exactMergedPullRequest)
        : null;
    } else if (exactMergedPullRequest) {
      tier = "tier1";
      reason =
        `PR #${exactMergedPullRequest.number} merged this branch tip into ${input.defaultBranch}`;
      pullRequest = withoutBranch(exactMergedPullRequest);
    } else if (input.functionallyMergedBranches.has(branch.name)) {
      tier = "tier2";
      reason = `commits patch-equivalent in ${input.defaultBranch}`;
      pullRequest = mergedPullRequest ? withoutBranch(mergedPullRequest) : null;
    } else {
      tier = "tier3";
      if (
        mergedPullRequest &&
        mergedPullRequest.baseBranch !== input.defaultBranch
      ) {
        reason =
          `merged PR #${mergedPullRequest.number} targeted ${mergedPullRequest.baseBranch}; review unlanded commits`;
        pullRequest = withoutBranch(mergedPullRequest);
      } else if (mergedPullRequest) {
        reason =
          `branch advanced after merged PR #${mergedPullRequest.number}; review unlanded commits`;
        pullRequest = withoutBranch(mergedPullRequest);
      } else if (closedPullRequest) {
        reason =
          `closed PR #${closedPullRequest.number}; review unlanded commits`;
        pullRequest = withoutBranch(closedPullRequest);
      } else {
        reason = "no PR; review unlanded commits";
      }
    }

    return {
      ...branch,
      tipAgeDays,
      tier,
      reason,
      pullRequest,
      reviewPriority: null,
    };
  });
}

export function createManifest(input: {
  repositoryRoot: string;
  remote: string;
  remoteUrl: string;
  slug: string;
  defaultBranch: string;
  staleDays: number;
  generatedAt?: string;
  rows: ClassifiedBranch[];
}): GitWashManifest {
  const branches = [...input.rows].sort((left, right) =>
    left.committedAt - right.committedAt || left.name.localeCompare(right.name)
  );
  const test = branches
    .filter(({ tier }) => tier === "tier1")
    .slice(0, 10)
    .map(({ name }) => name);

  return {
    version: MANIFEST_VERSION,
    repository: {
      root: input.repositoryRoot,
      remote: input.remote,
      remoteUrl: input.remoteUrl,
      slug: input.slug,
      defaultBranch: input.defaultBranch,
    },
    criteria: { staleDays: input.staleDays },
    generatedAt: input.generatedAt ?? new Date().toISOString(),
    branches,
    test,
  };
}

function parseRemoteBranches(value: string, remote: string): RemoteBranch[] {
  return nonemptyLines(value).flatMap((line) => {
    const [ref, sha, committedAt, author = "unknown"] = line.split("\t");
    if (!ref || !sha || !committedAt) {
      throw new Error(`could not parse remote branch record: ${line}`);
    }
    const prefix = `${remote}/`;
    if (!ref.startsWith(prefix)) return [];
    const name = ref.slice(prefix.length);
    if (name === "HEAD") return [];
    return [{ name, sha, committedAt: Number(committedAt), author }];
  });
}

interface GhRepository {
  nameWithOwner: string;
  defaultBranchRef: { name: string };
}

interface GhPullRequest {
  number: number;
  headRefName: string;
  headRefOid: string;
  baseRefName: string;
  state: "OPEN" | "CLOSED" | "MERGED";
  isCrossRepository: boolean;
  url: string;
}

interface GhApiPullRequest {
  number: number;
  head: {
    ref: string;
    sha: string;
    repo: { full_name: string } | null;
  };
  base: {
    ref: string;
    repo: { full_name: string };
  };
  html_url: string;
}

export async function generateManifest(options: {
  repoPath: string;
  remote?: string;
  githubRepository?: string;
  staleDays?: number;
  fetch?: boolean;
  runner?: CommandRunner;
  reporter?: ProgressReporter;
}): Promise<GitWashManifest> {
  const runner = options.runner ?? runCommand;
  const remote = options.remote ?? "origin";
  const staleDays = options.staleDays ?? 90;
  options.reporter?.step(`Inspecting repository at ${options.repoPath}`);
  const repositoryRoot = await checkedCommand(
    runner,
    "git",
    ["rev-parse", "--show-toplevel"],
    options.repoPath,
  );
  const remoteUrl = await checkedCommand(
    runner,
    "git",
    ["remote", "get-url", remote],
    repositoryRoot,
  );
  const githubRemote = parseGitHubRemote(remoteUrl);
  const explicitRepository = options.githubRepository?.split("/");
  if (
    explicitRepository && explicitRepository.length !== 2 &&
    explicitRepository.length !== 3
  ) {
    throw new Error("GitHub repository must be owner/repo or host/owner/repo");
  }
  const githubHost = explicitRepository?.length === 3
    ? explicitRepository[0]
    : githubRemote.host;
  const repositorySpecifier = explicitRepository
    ? githubHost === "github.com"
      ? explicitRepository.slice(-2).join("/")
      : `${githubHost}/${explicitRepository.slice(-2).join("/")}`
    : githubRemote.specifier;

  const repository = JSON.parse(
    await checkedCommand(
      runner,
      "gh",
      [
        "repo",
        "view",
        repositorySpecifier,
        "--json",
        "nameWithOwner,defaultBranchRef",
      ],
      repositoryRoot,
    ),
  ) as GhRepository;
  if (!repository.defaultBranchRef?.name || !repository.nameWithOwner) {
    throw new Error(
      "GitHub did not return a repository slug and default branch",
    );
  }
  const expectedSlug = repositorySpecifier.split("/").slice(-2).join("/");
  if (repository.nameWithOwner.toLowerCase() !== expectedSlug.toLowerCase()) {
    throw new Error(
      `selected remote resolves to ${expectedSlug}, but GitHub returned ${repository.nameWithOwner}`,
    );
  }
  options.reporter?.info(
    `${repository.nameWithOwner} · default ${repository.defaultBranchRef.name} · remote ${remote}`,
  );

  if (options.fetch !== false) {
    options.reporter?.step(`Fetching and pruning ${remote}`);
    await checkedCommand(
      runner,
      "git",
      ["fetch", "--prune", remote],
      repositoryRoot,
    );
  }

  options.reporter?.step("Reading remote branch history");
  const refs = await checkedCommand(
    runner,
    "git",
    [
      "for-each-ref",
      "--format=%(refname:short)%09%(objectname)%09%(committerdate:unix)%09%(authorname)",
      `refs/remotes/${remote}`,
    ],
    repositoryRoot,
  );
  const mergedRefs = await checkedCommand(
    runner,
    "git",
    [
      "branch",
      "-r",
      "--merged",
      `${remote}/${repository.defaultBranchRef.name}`,
      "--format=%(refname:short)",
    ],
    repositoryRoot,
  );
  const branches = parseRemoteBranches(refs, remote);
  options.reporter?.info(`${branchCount(branches.length)} found`);
  options.reporter?.step("Checking GitHub protections and pull requests");
  const protectedBranches = new Set(nonemptyLines(
    await checkedCommand(
      runner,
      "gh",
      [
        "api",
        "--paginate",
        ...(githubHost === "github.com" ? [] : ["--hostname", githubHost]),
        `repos/${repository.nameWithOwner}/branches?protected=true`,
        "--jq",
        ".[].name",
      ],
      repositoryRoot,
    ),
  ));
  const openPullRequestPages = JSON.parse(
    await checkedCommand(
      runner,
      "gh",
      [
        "api",
        "--paginate",
        "--slurp",
        "--method",
        "GET",
        ...(githubHost === "github.com" ? [] : ["--hostname", githubHost]),
        `repos/${repository.nameWithOwner}/pulls`,
        "-f",
        "state=open",
        "-f",
        "per_page=100",
      ],
      repositoryRoot,
    ),
  ) as GhApiPullRequest[][];
  const openPullRequests: GhPullRequest[] = openPullRequestPages.flat().map(
    (pullRequest) => ({
      number: pullRequest.number,
      headRefName: pullRequest.head.ref,
      headRefOid: pullRequest.head.sha,
      baseRefName: pullRequest.base.ref,
      state: "OPEN",
      isCrossRepository: pullRequest.head.repo?.full_name !==
        pullRequest.base.repo.full_name,
      url: pullRequest.html_url,
    }),
  );
  const historicalPullRequests = JSON.parse(
    await checkedCommand(
      runner,
      "gh",
      [
        "pr",
        "list",
        "--repo",
        repository.nameWithOwner,
        "--state",
        "all",
        "--limit",
        "10000",
        "--json",
        "number,headRefName,headRefOid,baseRefName,state,isCrossRepository,url",
      ],
      repositoryRoot,
    ),
  ) as GhPullRequest[];
  const pullRequestsByNumber = new Map(
    historicalPullRequests.map((
      pullRequest,
    ) => [pullRequest.number, pullRequest]),
  );
  for (const pullRequest of openPullRequests) {
    pullRequestsByNumber.set(pullRequest.number, pullRequest);
  }
  const rawPullRequests = [...pullRequestsByNumber.values()];

  const mergedBranches = new Set(
    nonemptyLines(mergedRefs).map((ref) => ref.replace(`${remote}/`, "")),
  );
  const pullRequests = rawPullRequests
    .filter(({ isCrossRepository }) => !isCrossRepository)
    .map(({ number, headRefName, headRefOid, baseRefName, state, url }) => ({
      number,
      branch: headRefName,
      headSha: headRefOid,
      baseBranch: baseRefName,
      state,
      url,
    }));
  options.reporter?.step(`Classifying branches stale for ${staleDays}+ days`);
  const classificationInput = {
    branches,
    defaultBranch: repository.defaultBranchRef.name,
    protectedBranches,
    mergedBranches,
    functionallyMergedBranches: new Set<string>(),
    pullRequests,
    staleDays,
  };
  const initialRows = classifyBranches(classificationInput);
  const functionallyMergedBranches = new Set<string>();
  for (const branch of initialRows.filter(({ tier }) => tier === "tier3")) {
    const range =
      `${remote}/${repository.defaultBranchRef.name}..${remote}/${branch.name}`;
    const uniqueMergeCommits = await checkedCommand(
      runner,
      "git",
      ["rev-list", "--min-parents=2", range],
      repositoryRoot,
    );
    const cherryOutput = await checkedCommand(
      runner,
      "git",
      [
        "cherry",
        `${remote}/${repository.defaultBranchRef.name}`,
        `${remote}/${branch.name}`,
      ],
      repositoryRoot,
    );
    if (isFunctionallyMerged(cherryOutput, uniqueMergeCommits)) {
      functionallyMergedBranches.add(branch.name);
    }
  }
  const rows = classifyBranches({
    ...classificationInput,
    functionallyMergedBranches,
  });

  for (const branch of rows.filter(({ tier }) => tier === "tier3")) {
    const range =
      `${remote}/${repository.defaultBranchRef.name}..${remote}/${branch.name}`;
    const uniqueCommitCount = Number(
      await checkedCommand(
        runner,
        "git",
        ["rev-list", "--count", range],
        repositoryRoot,
      ),
    );
    const authors = new Set(nonemptyLines(
      await checkedCommand(
        runner,
        "git",
        ["log", "--format=%ae", range],
        repositoryRoot,
      ),
    ));
    const numstat = nonemptyLines(
      await checkedCommand(
        runner,
        "git",
        [
          "diff",
          "--numstat",
          `${remote}/${repository.defaultBranchRef.name}...${remote}/${branch.name}`,
        ],
        repositoryRoot,
      ),
    );
    let additions = 0;
    let deletions = 0;
    for (const line of numstat) {
      const [added, deleted] = line.split("\t");
      additions += Number(added) || 0;
      deletions += Number(deleted) || 0;
    }
    const ownRef = `${remote}/${branch.name}`;
    const containedByBranches = nonemptyLines(
      await checkedCommand(
        runner,
        "git",
        [
          "branch",
          "-r",
          "--contains",
          branch.sha,
          "--format=%(refname:short)",
        ],
        repositoryRoot,
      ),
    ).filter((name) => name !== ownRef && !name.endsWith("/HEAD"));
    branch.reviewPriority = rankTierThreeBranch(branch, {
      uniqueCommitCount,
      uniqueAuthorCount: authors.size,
      changedFileCount: numstat.length,
      additions,
      deletions,
      containedByBranches,
      botAuthored: /(?:^|\b)(?:bot|dependabot|renovate)(?:\b|\[)/i.test(
        branch.author,
      ),
    });
  }

  return createManifest({
    repositoryRoot,
    remote,
    remoteUrl,
    slug: repository.nameWithOwner,
    defaultBranch: repository.defaultBranchRef.name,
    staleDays,
    rows,
  });
}

export interface SnapshotResult {
  repositoryName: string;
  branchCount: number;
  bundlePath: string;
}

function repositoryNameFromRemote(remoteUrl: string): string {
  const repositoryName = remoteUrl
    .replace(/\/+$/, "")
    .replace(/\.git$/, "")
    .split(/[/:]/)
    .at(-1);
  if (!repositoryName || !/^[A-Za-z0-9._-]+$/.test(repositoryName)) {
    throw new Error(
      `could not derive a safe repository name from the ${
        remoteUrl ? "configured remote" : "empty remote URL"
      }`,
    );
  }
  return repositoryName;
}

export async function snapshotRepository(options: {
  repoPath: string;
  remote?: string;
  outputDirectory?: string;
  runner?: CommandRunner;
  reporter?: ProgressReporter;
  createTemporaryDirectory?: () => Promise<string>;
}): Promise<SnapshotResult> {
  const runner = options.runner ?? runCommand;
  const remote = options.remote ?? "origin";
  const repositoryRoot = await checkedCommand(
    runner,
    "git",
    ["rev-parse", "--show-toplevel"],
    options.repoPath,
  );
  const remoteUrl = await checkedCommand(
    runner,
    "git",
    ["remote", "get-url", remote],
    repositoryRoot,
  );
  const repositoryName = repositoryNameFromRemote(remoteUrl);
  const outputDirectory = resolve(options.outputDirectory ?? "git-wash");
  const bundlePath = join(
    outputDirectory,
    `${repositoryName}_branch-backup.bundle`,
  );

  try {
    await Deno.lstat(bundlePath);
    throw new Error(`backup already exists: ${bundlePath}`);
  } catch (error) {
    if (!(error instanceof Deno.errors.NotFound)) throw error;
  }

  await Deno.mkdir(outputDirectory, { recursive: true });
  const temporaryDirectory = options.createTemporaryDirectory
    ? await options.createTemporaryDirectory()
    : await Deno.makeTempDir({ prefix: "git-wash-snapshot-" });
  const mirrorPath = join(temporaryDirectory, `${repositoryName}.git`);
  let bundleComplete = false;

  try {
    options.reporter?.step(`Mirror-cloning ${repositoryName} from ${remote}`);
    await checkedCommand(
      runner,
      "git",
      ["clone", "--mirror", remoteUrl, mirrorPath],
      repositoryRoot,
      "git clone --mirror <remote> <temporary-directory>",
    );

    const heads = nonemptyLines(
      await checkedCommand(
        runner,
        "git",
        ["for-each-ref", "--format=%(refname)", "refs/heads"],
        mirrorPath,
      ),
    );
    options.reporter?.info(`${branchCount(heads.length)} captured`);
    options.reporter?.step(`Creating ${bundlePath}`);
    await checkedCommand(
      runner,
      "git",
      ["bundle", "create", bundlePath, "--all"],
      mirrorPath,
    );
    options.reporter?.step("Verifying bundle integrity");
    await checkedCommand(
      runner,
      "git",
      ["bundle", "verify", bundlePath],
      mirrorPath,
    );
    bundleComplete = true;

    return { repositoryName, branchCount: heads.length, bundlePath };
  } finally {
    try {
      if (!bundleComplete) {
        await removeFileIfPresent(bundlePath);
      }
    } finally {
      await Deno.remove(temporaryDirectory, { recursive: true });
      options.reporter?.info("Temporary mirror removed");
    }
  }
}

export function createReviews(manifest: GitWashManifest): GitWashReviews {
  return {
    version: REVIEWS_VERSION,
    repository: {
      slug: manifest.repository.slug,
      remote: manifest.repository.remote,
      remoteUrl: manifest.repository.remoteUrl,
    },
    manifestGeneratedAt: manifest.generatedAt,
    branches: {},
  };
}

function isReviewRecommendation(value: unknown): value is ReviewRecommendation {
  return value === "keep" || value === "delete" || value === "human-review";
}

function isReviewConfidence(value: unknown): value is ReviewConfidence {
  return value === "high" || value === "medium" || value === "low";
}

export function parseReviews(value: string): GitWashReviews {
  const reviews = JSON.parse(value) as Partial<GitWashReviews>;
  if (
    reviews.version !== REVIEWS_VERSION ||
    !reviews.repository?.slug ||
    !reviews.repository.remote ||
    !reviews.repository.remoteUrl ||
    !reviews.manifestGeneratedAt ||
    !reviews.branches ||
    Array.isArray(reviews.branches)
  ) {
    throw new Error("invalid or unsupported git-wash reviews");
  }

  for (const [branch, review] of Object.entries(reviews.branches)) {
    if (
      !branch || !review || typeof review !== "object" ||
      typeof review.sha !== "string" ||
      !isReviewRecommendation(review.recommendation) ||
      !isReviewConfidence(review.confidence) ||
      typeof review.summary !== "string" || !review.summary.trim() ||
      !Array.isArray(review.evidence) ||
      review.evidence.some((item) =>
        typeof item !== "string" || !item.trim()
      ) ||
      typeof review.reviewer !== "string" || !review.reviewer.trim()
    ) {
      throw new Error(`invalid review for branch: ${branch}`);
    }
  }
  return reviews as GitWashReviews;
}

function sameReviewIdentity(
  left: GitWashReviews,
  right: GitWashReviews,
): boolean {
  return left.repository.slug === right.repository.slug &&
    left.repository.remote === right.repository.remote &&
    left.repository.remoteUrl === right.repository.remoteUrl &&
    left.manifestGeneratedAt === right.manifestGeneratedAt;
}

export function mergeReviews(reviewFiles: GitWashReviews[]): GitWashReviews {
  const [first, ...rest] = reviewFiles;
  if (!first) throw new Error("at least one reviews file is required");
  const merged: GitWashReviews = {
    ...first,
    repository: { ...first.repository },
    branches: { ...first.branches },
  };

  for (const reviews of rest) {
    if (!sameReviewIdentity(first, reviews)) {
      throw new Error("cannot merge reviews from different manifests");
    }
    for (const [branch, review] of Object.entries(reviews.branches)) {
      const current = merged.branches[branch];
      if (current && JSON.stringify(current) !== JSON.stringify(review)) {
        throw new Error(`conflicting reviews for ${branch}`);
      }
      merged.branches[branch] = review;
    }
  }
  return merged;
}

export interface ReviewValidation {
  delete: string[];
  keep: string[];
  humanReview: string[];
  pending: string[];
}

export function validateReviews(
  manifest: GitWashManifest,
  reviews: GitWashReviews,
): ReviewValidation {
  const expected = createReviews(manifest);
  if (!sameReviewIdentity(expected, reviews)) {
    throw new Error("reviews do not match this manifest and repository");
  }

  const tierThree = new Map(
    manifest.branches
      .filter(({ tier }) => tier === "tier3")
      .map((branch) => [branch.name, branch]),
  );
  const result: ReviewValidation = {
    delete: [],
    keep: [],
    humanReview: [],
    pending: [],
  };

  for (const [name, review] of Object.entries(reviews.branches)) {
    const branch = tierThree.get(name);
    if (!branch) {
      throw new Error(
        `review references unknown or non-Tier-3 branch: ${name}`,
      );
    }
    if (review.sha !== branch.sha) {
      throw new Error(
        `${name} review SHA does not match manifest: expected ${branch.sha}, got ${review.sha}`,
      );
    }
    if (review.recommendation === "delete") result.delete.push(name);
    else if (review.recommendation === "keep") result.keep.push(name);
    else result.humanReview.push(name);
  }
  for (const name of tierThree.keys()) {
    if (!reviews.branches[name]) result.pending.push(name);
  }
  for (const names of Object.values(result)) names.sort();
  return result;
}

export function parseManifest(value: string): GitWashManifest {
  const manifest = JSON.parse(value) as Partial<GitWashManifest>;
  if (
    manifest.version !== MANIFEST_VERSION ||
    !manifest.repository?.root ||
    !manifest.repository.remote ||
    !manifest.repository.remoteUrl ||
    !Array.isArray(manifest.branches) ||
    !Array.isArray(manifest.test)
  ) {
    throw new Error("invalid or unsupported git-wash manifest");
  }
  return manifest as GitWashManifest;
}

export async function writeManifestFiles(
  manifest: GitWashManifest,
  outputDirectory: string,
): Promise<string> {
  await Deno.mkdir(outputDirectory, { recursive: true });
  const manifestPath = `${outputDirectory}/manifest.json`;
  await Deno.writeTextFile(
    manifestPath,
    `${JSON.stringify(manifest, null, 2)}\n`,
  );

  const reports: Array<{ target: WashTarget; branches: ClassifiedBranch[] }> = [
    ...(["tier1", "tier2", "tier3"] as const).map((target) => ({
      target,
      branches: manifest.branches
        .filter(({ tier }) => tier === target)
        .sort((left, right) =>
          target === "tier3"
            ? (right.reviewPriority?.score ?? 0) -
                (left.reviewPriority?.score ?? 0) ||
              left.name.localeCompare(right.name)
            : 0
        ),
    })),
    {
      target: "test",
      branches: manifest.test.map((name) => {
        const branch = manifest.branches.find((row) => row.name === name);
        if (!branch) {
          throw new Error(`test target references unknown branch: ${name}`);
        }
        return branch;
      }),
    },
  ];

  for (const report of reports) {
    await Deno.writeTextFile(
      `${outputDirectory}/${report.target}.json`,
      `${
        JSON.stringify(
          {
            version: manifest.version,
            repository: manifest.repository,
            generatedAt: manifest.generatedAt,
            target: report.target,
            branches: report.branches,
          },
          null,
          2,
        )
      }\n`,
    );
  }
  const reviewsPath = `${outputDirectory}/reviews.json`;
  const reviews = createReviews(manifest);
  try {
    const previous = parseReviews(await Deno.readTextFile(reviewsPath));
    if (
      previous.repository.slug !== reviews.repository.slug ||
      previous.repository.remote !== reviews.repository.remote ||
      previous.repository.remoteUrl !== reviews.repository.remoteUrl
    ) {
      throw new Error("existing reviews belong to a different repository");
    }
    const currentBranches = new Map(
      manifest.branches
        .filter(({ tier }) => tier === "tier3")
        .map((branch) => [branch.name, branch]),
    );
    for (const [name, review] of Object.entries(previous.branches)) {
      if (currentBranches.get(name)?.sha === review.sha) {
        reviews.branches[name] = review;
      }
    }
  } catch (error) {
    if (!(error instanceof Deno.errors.NotFound)) throw error;
  }
  await Deno.writeTextFile(
    reviewsPath,
    `${JSON.stringify(reviews, null, 2)}\n`,
  );
  return manifestPath;
}

function isWashTarget(value: string): value is WashTarget {
  return value === "tier1" || value === "tier2" || value === "tier3" ||
    value === "test" || value === "reviewed";
}

export interface WashResult {
  branch: string;
  status: "preview" | "deleted" | "missing";
}

export async function washBranches(options: {
  repoPath: string;
  manifest: GitWashManifest;
  reviews?: GitWashReviews;
  target: string;
  execute?: boolean;
  runner?: CommandRunner;
  reporter?: ProgressReporter;
}): Promise<WashResult[]> {
  if (!isWashTarget(options.target)) {
    throw new Error("target must be tier1, tier2, tier3, test, or reviewed");
  }

  const runner = options.runner ?? runCommand;
  options.reporter?.step(
    `Checking ${options.target} against ${options.manifest.repository.slug}`,
  );
  const repositoryRoot = await checkedCommand(
    runner,
    "git",
    ["rev-parse", "--show-toplevel"],
    options.repoPath,
  );
  const manifestRoot = await Deno.realPath(options.manifest.repository.root);
  const actualRoot = await Deno.realPath(repositoryRoot);
  if (manifestRoot !== actualRoot) {
    throw new Error(
      `repository root does not match manifest: expected ${manifestRoot}, got ${actualRoot}`,
    );
  }

  const { remote, remoteUrl } = options.manifest.repository;
  const actualRemoteUrl = await checkedCommand(
    runner,
    "git",
    ["remote", "get-url", remote],
    repositoryRoot,
  );
  if (actualRemoteUrl !== remoteUrl) {
    throw new Error(
      `remote URL does not match manifest: expected ${remoteUrl}, got ${actualRemoteUrl}`,
    );
  }

  let selectedNames: string[];
  if (options.target === "reviewed") {
    if (!options.reviews) {
      throw new Error("reviewed target requires a reviews file");
    }
    const review = validateReviews(options.manifest, options.reviews);
    if (
      options.execute &&
      (review.pending.length > 0 || review.humanReview.length > 0)
    ) {
      throw new Error(
        `review is incomplete: ${review.pending.length} pending, ${review.humanReview.length} human-review`,
      );
    }
    options.reporter?.info(
      `${review.delete.length} delete · ${review.keep.length} keep · ${review.humanReview.length} human-review · ${review.pending.length} pending`,
    );
    selectedNames = review.delete;
  } else if (options.target === "test") {
    selectedNames = options.manifest.test;
  } else {
    selectedNames = options.manifest.branches
      .filter(({ tier }) => tier === options.target)
      .map(({ name }) => name);
  }
  const branchesByName = new Map(
    options.manifest.branches.map((branch) => [branch.name, branch]),
  );
  const selectedBranches = selectedNames.map((name) => {
    const branch = branchesByName.get(name);
    if (!branch) {
      throw new Error(`manifest target references unknown branch: ${name}`);
    }
    return branch;
  });
  options.reporter?.step(
    `Preflighting ${branchCount(selectedBranches.length)} against ${remote}`,
  );

  const preflight: Array<{
    branch: ClassifiedBranch;
    status: "ready" | "missing";
  }> = [];
  for (const branch of selectedBranches) {
    const remoteRef = await checkedCommand(
      runner,
      "git",
      ["ls-remote", "--heads", remote, `refs/heads/${branch.name}`],
      repositoryRoot,
    );
    if (!remoteRef) {
      preflight.push({ branch, status: "missing" });
      continue;
    }
    const currentSha = remoteRef.split(/\s+/)[0];
    if (currentSha !== branch.sha) {
      throw new Error(
        `${branch.name} changed since the manifest was generated; expected ${branch.sha}, found ${currentSha}`,
      );
    }
    preflight.push({ branch, status: "ready" });
  }

  if (!options.execute) {
    return preflight.map(({ branch, status }) => ({
      branch: branch.name,
      status: status === "missing" ? "missing" : "preview",
    }));
  }

  const readyCount =
    preflight.filter(({ status }) => status === "ready").length;
  if (readyCount > 0) {
    options.reporter?.step(
      `Deleting ${readyCount} SHA-matched remote ${
        readyCount === 1 ? "branch" : "branches"
      }`,
    );
  }
  const results: WashResult[] = [];
  for (const item of preflight) {
    if (item.status === "missing") {
      results.push({ branch: item.branch.name, status: "missing" });
      continue;
    }

    const branch = item.branch;
    await checkedCommand(
      runner,
      "git",
      [
        "push",
        `--force-with-lease=refs/heads/${branch.name}:${branch.sha}`,
        remote,
        "--delete",
        branch.name,
      ],
      repositoryRoot,
    );
    results.push({ branch: branch.name, status: "deleted" });
  }
  return results;
}

export function summarizeManifest(manifest: GitWashManifest): {
  tier1: number;
  tier2: number;
  tier3: number;
  kept: number;
  test: number;
} {
  const count = (classification: Classification) =>
    manifest.branches.filter(({ tier }) => tier === classification).length;
  return {
    tier1: count("tier1"),
    tier2: count("tier2"),
    tier3: count("tier3"),
    kept: count("keep"),
    test: manifest.test.length,
  };
}

function printManifestSummary(manifest: GitWashManifest, path: string): void {
  const summary = summarizeManifest(manifest);
  log.success(`Mess list ready for ${manifest.repository.slug}`);
  console.log(
    `  ${
      bold(green("● Tier 1"))
    }  ${summary.tier1}  merged into the default branch`,
  );
  console.log(
    `  ${
      bold(cyan("● Tier 2"))
    }  ${summary.tier2}  patch-equivalent to the default branch`,
  );
  console.log(
    `  ${
      bold(yellow("● Tier 3"))
    }  ${summary.tier3}  possible dead branches requiring review`,
  );
  console.log(
    `  ${bold("○ Kept")}    ${summary.kept}  protected, open, or active`,
  );
  console.log(
    `  ${bold(magenta("◆ Test"))}    ${summary.test}  oldest Tier 1 branches`,
  );
  log.info(`Review files: ${path.replace(/\/manifest\.json$/, "")}`);
}

function printWashResults(
  results: WashResult[],
  execute: boolean,
  target: string,
): void {
  if (results.length === 0) {
    log.info(`No branches in ${target}`);
    return;
  }

  const missing = results.filter(({ status }) => status === "missing").length;
  const ready = results.length - missing;
  if (missing > 0) {
    log.warn(`${branchCount(missing)} already absent from the remote`);
  }
  if (execute) {
    log.success(`Deleted ${branchCount(ready)} from the remote`);
  } else if (ready > 0) {
    log.success(`${branchCount(ready)} passed SHA preflight`);
    log.info("Preview only · pass --execute to delete this target");
  }
}

export async function main(args: string[] = Deno.args): Promise<number> {
  let exitCode = 0;

  const listCommand = new Command()
    .description("Generate a tiered branch manifest and ten-branch test target")
    .arguments("<repo:string>")
    .option("-o, --output <path:string>", "Output directory", {
      default: "git-wash",
    })
    .option("--remote <name:string>", "Git remote to inspect", {
      default: "origin",
    })
    .option(
      "--github-repo <repository:string>",
      "Explicit [host/]owner/repo for the selected remote",
    )
    .option("--stale-days <days:integer>", "Minimum tip commit age", {
      default: 90,
    })
    .option(
      "--skip-fetch",
      "Use existing remote-tracking refs without fetching",
    )
    .action(async (options, repo: string) => {
      try {
        const manifest = await generateManifest({
          repoPath: repo,
          remote: options.remote,
          githubRepository: options.githubRepo,
          staleDays: options.staleDays,
          fetch: !options.skipFetch,
          reporter: log,
        });
        log.step(`Writing tier reports to ${options.output}`);
        const manifestPath = await writeManifestFiles(manifest, options.output);
        printManifestSummary(manifest, manifestPath);
      } catch (error) {
        log.error(
          `list failed: ${error instanceof Error ? error.message : error}`,
        );
        exitCode = 1;
      }
    });

  const washCommand = new Command()
    .description("Preview or delete a manifest tier, test, or reviewed target")
    .arguments("<repo:string> <target:string>")
    .option("-m, --manifest <path:string>", "Manifest generated by list", {
      default: "git-wash/manifest.json",
    })
    .option("-r, --reviews <path:string>", "Agent review decisions", {
      default: "git-wash/reviews.json",
    })
    .option("--execute", "Delete SHA-matched remote branches")
    .action(async (options, repo: string, target: string) => {
      try {
        const manifest = parseManifest(
          await Deno.readTextFile(options.manifest),
        );
        const reviews = target === "reviewed"
          ? parseReviews(await Deno.readTextFile(options.reviews))
          : undefined;
        const results = await washBranches({
          repoPath: repo,
          manifest,
          reviews,
          target,
          execute: options.execute,
          reporter: log,
        });
        printWashResults(results, Boolean(options.execute), target);
      } catch (error) {
        log.error(
          `wash failed: ${error instanceof Error ? error.message : error}`,
        );
        exitCode = 1;
      }
    });

  const snapshotCommand = new Command()
    .description("Back up every remote branch into a verified Git bundle")
    .arguments("<repo:string>")
    .option("-o, --output <path:string>", "Git Wash artifact directory", {
      default: "git-wash",
    })
    .option("--remote <name:string>", "Git remote to mirror", {
      default: "origin",
    })
    .action(async (options, repo: string) => {
      try {
        const result = await snapshotRepository({
          repoPath: repo,
          remote: options.remote,
          outputDirectory: options.output,
          reporter: log,
        });
        log.success(
          `Backed up ${
            branchCount(result.branchCount)
          } to ${result.bundlePath}`,
        );
      } catch (error) {
        log.error(
          `snapshot failed: ${error instanceof Error ? error.message : error}`,
        );
        exitCode = 1;
      }
    });

  const cli = new Command()
    .name("git-wash")
    .version("0.2.1")
    .description("Find, back up, and safely remove stale remote branches")
    .command("list", listCommand)
    .command("wash", washCommand)
    .command("snapshot", snapshotCommand);

  await cli.parse(args[0] === "--" ? args.slice(1) : args);
  return exitCode;
}

if (import.meta.main) {
  Deno.exit(await main());
}
