import {
  assertEquals,
  assertRejects,
  assertStringIncludes,
  assertThrows,
} from "@std/assert";
import {
  classifyBranches,
  type CommandRunner,
  createManifest,
  createReviews,
  generateManifest,
  type GitWashManifest,
  type GitWashReviews,
  isFunctionallyMerged,
  mergeReviews,
  parseGitHubRemote,
  rankTierThreeBranch,
  type RemoteBranch,
  snapshotRepository,
  summarizeManifest,
  validateReviews,
  washBranches,
  writeManifestFiles,
} from "./git-wash.ts";

const DAY = 86_400;
const NOW = Date.parse("2026-08-20T00:00:00Z") / 1000;

function branch(
  name: string,
  ageDays: number,
  overrides: Partial<RemoteBranch> = {},
): RemoteBranch {
  return {
    name,
    sha: name.padEnd(40, "0").slice(0, 40),
    committedAt: NOW - ageDays * DAY,
    author: "winnie",
    ...overrides,
  };
}

Deno.test("classifyBranches assigns confidence tiers after safety exclusions", () => {
  const exactPrSha = branch("squash-merged", 150).sha;
  const rows = classifyBranches({
    branches: [
      branch("main", 500),
      branch("protected", 500),
      branch("open-pr", 500),
      branch("recent", 10),
      branch("git-merged", 120),
      branch("squash-merged", 150),
      branch("patch-equivalent", 160),
      branch("wrong-base", 170),
      branch("advanced-after-pr", 175),
      branch("closed-pr", 180),
      branch("unlanded", 200),
    ],
    defaultBranch: "main",
    protectedBranches: new Set(["protected"]),
    mergedBranches: new Set(["git-merged"]),
    functionallyMergedBranches: new Set(["patch-equivalent"]),
    pullRequests: [
      {
        number: 1,
        branch: "open-pr",
        state: "OPEN",
        baseBranch: "main",
        headSha: "older-open-pr-head",
        url: "https://github.com/fixture/repo/pull/1",
      },
      {
        number: 2,
        branch: "squash-merged",
        state: "MERGED",
        baseBranch: "main",
        headSha: exactPrSha,
        url: "https://github.com/fixture/repo/pull/2",
      },
      {
        number: 3,
        branch: "closed-pr",
        state: "CLOSED",
        baseBranch: "main",
        headSha: branch("closed-pr", 180).sha,
        url: "https://github.com/fixture/repo/pull/3",
      },
      {
        number: 4,
        branch: "wrong-base",
        state: "MERGED",
        baseBranch: "release",
        headSha: branch("wrong-base", 170).sha,
        url: "https://github.com/fixture/repo/pull/4",
      },
      {
        number: 5,
        branch: "advanced-after-pr",
        state: "MERGED",
        baseBranch: "main",
        headSha: "older-merged-head",
        url: "https://github.com/fixture/repo/pull/5",
      },
    ],
    staleDays: 90,
    now: NOW,
  });

  assertEquals(
    Object.fromEntries(rows.map((row) => [row.name, [row.tier, row.reason]])),
    {
      main: ["keep", "default branch"],
      protected: ["keep", "protected branch"],
      "open-pr": ["keep", "open PR #1"],
      recent: ["keep", "tip commit is 10 days old"],
      "git-merged": ["tier1", "merged into main"],
      "squash-merged": ["tier1", "PR #2 merged this branch tip into main"],
      "patch-equivalent": ["tier2", "commits patch-equivalent in main"],
      "wrong-base": [
        "tier3",
        "merged PR #4 targeted release; review unlanded commits",
      ],
      "advanced-after-pr": [
        "tier3",
        "branch advanced after merged PR #5; review unlanded commits",
      ],
      "closed-pr": ["tier3", "closed PR #3; review unlanded commits"],
      unlanded: ["tier3", "no PR; review unlanded commits"],
    },
  );
});

Deno.test("isFunctionallyMerged requires nonempty equivalent patches and no unique merges", () => {
  assertEquals(isFunctionallyMerged("- aaa\n- bbb", ""), true);
  assertEquals(isFunctionallyMerged("- aaa\n+ bbb", ""), false);
  assertEquals(isFunctionallyMerged("", ""), false);
  assertEquals(isFunctionallyMerged("- aaa", "merge-sha"), false);
});

Deno.test("parseGitHubRemote binds GitHub commands to the selected remote", () => {
  assertEquals(parseGitHubRemote("git@github.com:lightdash/lightdash.git"), {
    host: "github.com",
    slug: "lightdash/lightdash",
    specifier: "lightdash/lightdash",
  });
  assertEquals(parseGitHubRemote("https://github.com/lightdash/lightdash"), {
    host: "github.com",
    slug: "lightdash/lightdash",
    specifier: "lightdash/lightdash",
  });
  assertEquals(parseGitHubRemote("ssh://git@ghe.example.com/acme/docs.git"), {
    host: "ghe.example.com",
    slug: "acme/docs",
    specifier: "ghe.example.com/acme/docs",
  });
});

Deno.test("rankTierThreeBranch exposes every retention score contribution", () => {
  const ranked = rankTierThreeBranch(
    {
      ...branch("dependabot/zod", 800),
      tipAgeDays: 800,
      tier: "tier3",
      reason: "closed PR #9; review unlanded commits",
      pullRequest: {
        number: 9,
        state: "CLOSED",
        baseBranch: "main",
        headSha: branch("dependabot/zod", 800).sha,
        url: "https://github.com/fixture/repo/pull/9",
      },
      reviewPriority: null,
    },
    {
      uniqueCommitCount: 1,
      uniqueAuthorCount: 1,
      changedFileCount: 1,
      additions: 3,
      deletions: 1,
      containedByBranches: ["origin/dependency-rollup"],
      botAuthored: true,
    },
  );

  assertEquals(ranked.score, 0);
  assertEquals(
    ranked.signals.reduce((score, signal) => score + signal.weight, 0),
    ranked.unclampedScore,
  );
  assertEquals(ranked.signals.map(({ kind }) => kind), [
    "baseline",
    "unique-commits",
    "diff-size",
    "old-tip",
    "closed-pr",
    "contained-tip",
    "bot-author",
  ]);
});

Deno.test("generateManifest binds GitHub evidence to the selected remote and exhaustively protects open PRs", async () => {
  const calls: Array<{ command: string; args: string[] }> = [];
  const shas = {
    main: "1".repeat(40),
    open: "2".repeat(40),
    exact: "3".repeat(40),
    patch: "4".repeat(40),
    wrong: "5".repeat(40),
  };
  const old = NOW - 200 * DAY;
  const runner: CommandRunner = (command, args) => {
    calls.push({ command, args });
    const joined = args.join(" ");
    let stdout = "";
    if (joined === "rev-parse --show-toplevel") stdout = "/repo";
    else if (joined === "remote get-url upstream") {
      stdout = "git@github.com:lightdash/docs.git";
    } else if (args[0] === "repo" && args[1] === "view") {
      stdout = JSON.stringify({
        nameWithOwner: "lightdash/docs",
        defaultBranchRef: { name: "main" },
      });
    } else if (args[0] === "for-each-ref") {
      stdout = [
        `upstream/main\t${shas.main}\t${old}\twinnie`,
        `upstream/open-old\t${shas.open}\t${old}\twinnie`,
        `upstream/exact-pr\t${shas.exact}\t${old}\twinnie`,
        `upstream/patch-copy\t${shas.patch}\t${old}\twinnie`,
        `upstream/wrong-base\t${shas.wrong}\t${old}\twinnie`,
      ].join("\n");
    } else if (joined.startsWith("branch -r --merged")) {
      stdout = "upstream/main";
    } else if (
      args[0] === "api" && joined.includes("branches?protected=true")
    ) {
      stdout = "";
    } else if (args[0] === "api" && joined.includes("/pulls")) {
      stdout = JSON.stringify([[{
        number: 1,
        head: {
          ref: "open-old",
          sha: shas.open,
          repo: { full_name: "lightdash/docs" },
        },
        base: { ref: "main", repo: { full_name: "lightdash/docs" } },
        html_url: "https://github.com/lightdash/docs/pull/1",
      }]]);
    } else if (args[0] === "pr") {
      stdout = JSON.stringify([
        {
          number: 2,
          headRefName: "exact-pr",
          headRefOid: shas.exact,
          baseRefName: "main",
          state: "MERGED",
          isCrossRepository: false,
          url: "https://github.com/lightdash/docs/pull/2",
        },
        {
          number: 3,
          headRefName: "wrong-base",
          headRefOid: shas.wrong,
          baseRefName: "release",
          state: "MERGED",
          isCrossRepository: false,
          url: "https://github.com/lightdash/docs/pull/3",
        },
      ]);
    } else if (joined.startsWith("rev-list --min-parents=2")) stdout = "";
    else if (joined.includes("cherry upstream/main upstream/patch-copy")) {
      stdout = `- ${shas.patch}`;
    } else if (joined.startsWith("cherry ")) stdout = `+ ${shas.wrong}`;
    else if (joined.startsWith("rev-list --count")) stdout = "1";
    else if (joined.startsWith("log --format=%ae")) {
      stdout = "winnie@example.com";
    } else if (joined.startsWith("diff --numstat")) {
      stdout = "3\t1\tdocs/file.md";
    } else if (joined.startsWith("branch -r --contains")) {
      stdout = "upstream/wrong-base";
    } else throw new Error(`unexpected command: ${command} ${joined}`);
    return Promise.resolve({ code: 0, stdout, stderr: "" });
  };

  const manifest = await generateManifest({
    repoPath: "/repo",
    remote: "upstream",
    fetch: false,
    runner,
  });

  assertEquals(
    Object.fromEntries(manifest.branches.map((row) => [row.name, row.tier])),
    {
      main: "keep",
      "open-old": "keep",
      "exact-pr": "tier1",
      "patch-copy": "tier2",
      "wrong-base": "tier3",
    },
  );
  assertEquals(
    calls.some(({ args }) =>
      args.slice(0, 3).join(" ") === "repo view lightdash/docs"
    ),
    true,
  );
  const openCall = calls.find(({ args }) =>
    args[0] === "api" && args.includes("repos/lightdash/docs/pulls")
  );
  assertEquals(openCall?.args.includes("--paginate"), true);
  assertEquals(openCall?.args.includes("--slurp"), true);
  assertEquals(openCall?.args.includes("--jq"), false);
});

Deno.test("createManifest makes the test target the ten oldest tier-one branches", () => {
  const rows = Array.from(
    { length: 12 },
    (_, index) => ({
      ...branch(`merged-${index}`, 100 + index),
      tipAgeDays: 100 + index,
      tier: "tier1" as const,
      reason: "merged into main",
      pullRequest: null,
      reviewPriority: null,
    }),
  );

  const manifest = createManifest({
    repositoryRoot: "/tmp/work",
    remote: "origin",
    remoteUrl: "/tmp/remote.git",
    slug: "fixture/repo",
    defaultBranch: "main",
    staleDays: 90,
    generatedAt: "2026-08-20T00:00:00.000Z",
    rows,
  });

  assertEquals(manifest.test, [
    "merged-11",
    "merged-10",
    "merged-9",
    "merged-8",
    "merged-7",
    "merged-6",
    "merged-5",
    "merged-4",
    "merged-3",
    "merged-2",
  ]);
  assertEquals(summarizeManifest(manifest), {
    tier1: 12,
    tier2: 0,
    tier3: 0,
    kept: 0,
    test: 10,
  });
});

Deno.test("writeManifestFiles creates tier and test review artifacts", async () => {
  const output = await Deno.makeTempDir({ prefix: "git-wash-output-" });
  try {
    const rows = [
      {
        ...branch("merged", 120),
        tipAgeDays: 120,
        tier: "tier1" as const,
        reason: "merged into main",
        pullRequest: null,
        reviewPriority: null,
      },
      {
        ...branch("review", 150),
        tipAgeDays: 150,
        tier: "tier3" as const,
        reason: "no PR; review unlanded commits",
        pullRequest: null,
        reviewPriority: rankTierThreeBranch(
          {
            ...branch("review", 150),
            tipAgeDays: 150,
            tier: "tier3",
            reason: "no PR; review unlanded commits",
            pullRequest: null,
            reviewPriority: null,
          },
          {
            uniqueCommitCount: 2,
            uniqueAuthorCount: 1,
            changedFileCount: 3,
            additions: 10,
            deletions: 2,
            containedByBranches: [],
            botAuthored: false,
          },
        ),
      },
    ];
    const manifest = createManifest({
      repositoryRoot: "/tmp/work",
      remote: "origin",
      remoteUrl: "/tmp/remote.git",
      slug: "fixture/repo",
      defaultBranch: "main",
      staleDays: 90,
      generatedAt: "2026-08-20T00:00:00.000Z",
      rows,
    });

    await writeManifestFiles(manifest, output);

    assertEquals(
      JSON.parse(await Deno.readTextFile(`${output}/tier1.json`)).branches,
      [rows[0]],
    );
    assertEquals(
      JSON.parse(await Deno.readTextFile(`${output}/tier2.json`)).branches,
      [],
    );
    assertEquals(
      JSON.parse(await Deno.readTextFile(`${output}/tier3.json`)).branches,
      [rows[1]],
    );
    assertEquals(
      JSON.parse(await Deno.readTextFile(`${output}/test.json`)).branches,
      [rows[0]],
    );
    assertEquals(
      JSON.parse(await Deno.readTextFile(`${output}/reviews.json`)),
      createReviews(manifest),
    );
  } finally {
    await Deno.remove(output, { recursive: true });
  }
});

Deno.test("reviews merge cleanly across agent shards and reject conflicts", () => {
  const manifest = createManifest({
    repositoryRoot: "/tmp/work",
    remote: "origin",
    remoteUrl: "git@github.com:fixture/repo.git",
    slug: "fixture/repo",
    defaultBranch: "main",
    staleDays: 90,
    generatedAt: "2026-08-20T00:00:00.000Z",
    rows: [
      {
        ...branch("one", 100),
        tipAgeDays: 100,
        tier: "tier3",
        reason: "no PR; review unlanded commits",
        pullRequest: null,
        reviewPriority: null,
      },
      {
        ...branch("two", 110),
        tipAgeDays: 110,
        tier: "tier3",
        reason: "no PR; review unlanded commits",
        pullRequest: null,
        reviewPriority: null,
      },
    ],
  });
  const base = createReviews(manifest);
  const keep: GitWashReviews = {
    ...base,
    branches: {
      one: {
        sha: branch("one", 100).sha,
        recommendation: "keep",
        confidence: "high",
        summary: "Active supported branch.",
        evidence: ["Release workflow targets this branch."],
        reviewer: "reviewer-one",
      },
    },
  };
  const drop: GitWashReviews = {
    ...base,
    branches: {
      two: {
        sha: branch("two", 110).sha,
        recommendation: "delete",
        confidence: "high",
        summary: "Superseded abandoned work.",
        evidence: ["A later branch contains the intended changes."],
        reviewer: "reviewer-two",
      },
    },
  };

  assertEquals(mergeReviews([keep, drop]).branches, {
    ...keep.branches,
    ...drop.branches,
  });
  assertThrows(
    () =>
      mergeReviews([
        keep,
        {
          ...keep,
          branches: {
            one: { ...keep.branches.one, recommendation: "delete" },
          },
        },
      ]),
    Error,
    "conflicting reviews for one",
  );
});

Deno.test("validateReviews selects only explicit deletes and reports unresolved branches", () => {
  const manifest = createManifest({
    repositoryRoot: "/tmp/work",
    remote: "origin",
    remoteUrl: "git@github.com:fixture/repo.git",
    slug: "fixture/repo",
    defaultBranch: "main",
    staleDays: 90,
    generatedAt: "2026-08-20T00:00:00.000Z",
    rows: ["drop", "keep", "escalate", "pending"].map((name, index) => ({
      ...branch(name, 100 + index),
      tipAgeDays: 100 + index,
      tier: "tier3" as const,
      reason: "no PR; review unlanded commits",
      pullRequest: null,
      reviewPriority: null,
    })),
  });
  const reviews: GitWashReviews = {
    ...createReviews(manifest),
    branches: Object.fromEntries(
      [
        ["drop", "delete"],
        ["keep", "keep"],
        ["escalate", "human-review"],
      ].map(([name, recommendation]) => [
        name,
        {
          sha: manifest.branches.find((row) => row.name === name)!.sha,
          recommendation,
          confidence: "high",
          summary: `Reviewed ${name}.`,
          evidence: ["Direct branch inspection completed."],
          reviewer: "agent",
        },
      ]),
    ) as GitWashReviews["branches"],
  };

  assertEquals(validateReviews(manifest, reviews), {
    delete: ["drop"],
    keep: ["keep"],
    humanReview: ["escalate"],
    pending: ["pending"],
  });
  reviews.branches.drop.sha = "f".repeat(40);
  assertThrows(
    () => validateReviews(manifest, reviews),
    Error,
    "drop review SHA does not match manifest",
  );
});

async function git(cwd: string, ...args: string[]): Promise<string> {
  const result = await new Deno.Command("git", {
    args: ["-C", cwd, ...args],
    stdout: "piped",
    stderr: "piped",
  }).output();
  if (!result.success) {
    throw new Error(new TextDecoder().decode(result.stderr));
  }
  return new TextDecoder().decode(result.stdout).trim();
}

async function createGitFixture(): Promise<{
  root: string;
  work: string;
  remote: string;
  sha: string;
}> {
  const root = await Deno.makeTempDir({ prefix: "git-wash-" });
  const remote = `${root}/remote.git`;
  const work = `${root}/work`;
  await git(root, "init", "--bare", remote);
  await git(root, "clone", remote, work);
  await git(work, "config", "user.name", "Fixture");
  await git(work, "config", "user.email", "fixture@example.com");
  await Deno.writeTextFile(`${work}/README.md`, "fixture\n");
  await git(work, "add", "README.md");
  await git(work, "commit", "-m", "fixture");
  await git(work, "branch", "-M", "main");
  await git(work, "push", "-u", "origin", "main");
  await git(work, "switch", "-c", "delete-me");
  await Deno.writeTextFile(`${work}/branch.txt`, "delete me\n");
  await git(work, "add", "branch.txt");
  await git(work, "commit", "-m", "branch");
  await git(work, "push", "-u", "origin", "delete-me");
  return { root, work, remote, sha: await git(work, "rev-parse", "HEAD") };
}

function fixtureManifest(
  work: string,
  remote: string,
  sha: string,
): GitWashManifest {
  return {
    version: 2,
    repository: {
      root: work,
      remote: "origin",
      remoteUrl: remote,
      slug: "fixture/repo",
      defaultBranch: "main",
    },
    criteria: { staleDays: 90 },
    generatedAt: "2026-08-20T00:00:00.000Z",
    branches: [{
      name: "delete-me",
      sha,
      committedAt: NOW,
      author: "Fixture",
      tipAgeDays: 100,
      tier: "tier1",
      reason: "merged into main",
      pullRequest: null,
      reviewPriority: null,
    }],
    test: ["delete-me"],
  };
}

Deno.test("washBranches previews without changing the isolated remote", async () => {
  const fixture = await createGitFixture();
  try {
    const result = await washBranches({
      repoPath: fixture.work,
      manifest: fixtureManifest(fixture.work, fixture.remote, fixture.sha),
      target: "test",
      execute: false,
    });

    assertEquals(result, [{ branch: "delete-me", status: "preview" }]);
    assertStringIncludes(
      await git(fixture.work, "ls-remote", "--heads", "origin", "delete-me"),
      "refs/heads/delete-me",
    );
  } finally {
    await Deno.remove(fixture.root, { recursive: true });
  }
});

Deno.test("washBranches requires a complete review before executing reviewed deletes", async () => {
  const fixture = await createGitFixture();
  try {
    const manifest = fixtureManifest(
      fixture.work,
      fixture.remote,
      fixture.sha,
    );
    manifest.branches[0].tier = "tier3";
    manifest.branches[0].reason = "no PR; review unlanded commits";
    const reviews: GitWashReviews = {
      ...createReviews(manifest),
      branches: {
        "delete-me": {
          sha: fixture.sha,
          recommendation: "human-review",
          confidence: "low",
          summary: "Needs a person.",
          evidence: ["The branch contains product decisions."],
          reviewer: "agent",
        },
      },
    };

    await assertRejects(
      () =>
        washBranches({
          repoPath: fixture.work,
          manifest,
          reviews,
          target: "reviewed",
          execute: true,
        }),
      Error,
      "review is incomplete: 0 pending, 1 human-review",
    );

    reviews.branches["delete-me"].recommendation = "delete";
    assertEquals(
      await washBranches({
        repoPath: fixture.work,
        manifest,
        reviews,
        target: "reviewed",
        execute: false,
      }),
      [{ branch: "delete-me", status: "preview" }],
    );
  } finally {
    await Deno.remove(fixture.root, { recursive: true });
  }
});

Deno.test("washBranches deletes only a SHA-matched branch in an isolated remote", async () => {
  const fixture = await createGitFixture();
  try {
    const progress: string[] = [];
    const result = await washBranches({
      repoPath: fixture.work,
      manifest: fixtureManifest(fixture.work, fixture.remote, fixture.sha),
      target: "test",
      execute: true,
      reporter: {
        info: (message) => progress.push(`info:${message}`),
        step: (message) => progress.push(`step:${message}`),
      },
    });

    assertEquals(result, [{ branch: "delete-me", status: "deleted" }]);
    assertEquals(progress, [
      "step:Checking test against fixture/repo",
      "step:Preflighting 1 branch against origin",
      "step:Deleting 1 SHA-matched remote branch",
    ]);
    assertEquals(
      await git(fixture.work, "ls-remote", "--heads", "origin", "delete-me"),
      "",
    );
  } finally {
    await Deno.remove(fixture.root, { recursive: true });
  }
});

Deno.test("washBranches refuses a manifest from another repository", async () => {
  const fixture = await createGitFixture();
  try {
    const manifest = fixtureManifest(
      fixture.work,
      "/tmp/not-this-remote.git",
      fixture.sha,
    );
    await assertRejects(
      () =>
        washBranches({
          repoPath: fixture.work,
          manifest,
          target: "test",
          execute: true,
        }),
      Error,
      "remote URL does not match",
    );
    assertStringIncludes(
      await git(fixture.work, "ls-remote", "--heads", "origin", "delete-me"),
      "refs/heads/delete-me",
    );
  } finally {
    await Deno.remove(fixture.root, { recursive: true });
  }
});

Deno.test("washBranches refuses deletion after the remote branch moves", async () => {
  const fixture = await createGitFixture();
  try {
    const manifest = fixtureManifest(fixture.work, fixture.remote, fixture.sha);
    await Deno.writeTextFile(`${fixture.work}/branch.txt`, "advanced\n");
    await git(fixture.work, "add", "branch.txt");
    await git(fixture.work, "commit", "-m", "advance branch");
    await git(fixture.work, "push", "origin", "delete-me");

    await assertRejects(
      () =>
        washBranches({
          repoPath: fixture.work,
          manifest,
          target: "test",
          execute: true,
        }),
      Error,
      "changed since the manifest was generated",
    );
    assertStringIncludes(
      await git(fixture.work, "ls-remote", "--heads", "origin", "delete-me"),
      "refs/heads/delete-me",
    );
  } finally {
    await Deno.remove(fixture.root, { recursive: true });
  }
});

Deno.test("washBranches preflights the full target before deleting any branch", async () => {
  const fixture = await createGitFixture();
  try {
    await git(fixture.work, "switch", "main");
    await git(fixture.work, "switch", "-c", "delete-first");
    await Deno.writeTextFile(`${fixture.work}/first.txt`, "first\n");
    await git(fixture.work, "add", "first.txt");
    await git(fixture.work, "commit", "-m", "first branch");
    await git(fixture.work, "push", "-u", "origin", "delete-first");
    const firstSha = await git(fixture.work, "rev-parse", "HEAD");

    const manifest = fixtureManifest(fixture.work, fixture.remote, fixture.sha);
    manifest.branches.unshift({
      ...manifest.branches[0],
      name: "delete-first",
      sha: firstSha,
    });

    await git(fixture.work, "switch", "delete-me");
    await Deno.writeTextFile(`${fixture.work}/branch.txt`, "advanced again\n");
    await git(fixture.work, "add", "branch.txt");
    await git(fixture.work, "commit", "-m", "advance later branch");
    await git(fixture.work, "push", "origin", "delete-me");

    await assertRejects(
      () =>
        washBranches({
          repoPath: fixture.work,
          manifest,
          target: "tier1",
          execute: true,
        }),
      Error,
      "changed since the manifest was generated",
    );
    assertStringIncludes(
      await git(
        fixture.work,
        "ls-remote",
        "--heads",
        "origin",
        "delete-first",
      ),
      "refs/heads/delete-first",
    );
  } finally {
    await Deno.remove(fixture.root, { recursive: true });
  }
});

Deno.test("snapshotRepository bundles every remote branch and removes its mirror clone", async () => {
  const fixture = await createGitFixture();
  const temporaryDirectory = `${fixture.root}/snapshot-clone`;
  const outputDirectory = `${fixture.root}/backups`;
  try {
    await Deno.mkdir(outputDirectory);
    const result = await snapshotRepository({
      repoPath: fixture.work,
      outputDirectory,
      createTemporaryDirectory: async () => {
        await Deno.mkdir(temporaryDirectory);
        return temporaryDirectory;
      },
    });

    assertEquals(result, {
      repositoryName: "remote",
      branchCount: 2,
      bundlePath: `${outputDirectory}/remote_branch-backup.bundle`,
    });
    const heads = await git(
      fixture.work,
      "bundle",
      "list-heads",
      result.bundlePath,
    );
    assertStringIncludes(heads, "refs/heads/main");
    assertStringIncludes(heads, "refs/heads/delete-me");
    await assertRejects(
      () => Deno.lstat(temporaryDirectory),
      Deno.errors.NotFound,
    );
    await assertRejects(
      () =>
        snapshotRepository({
          repoPath: fixture.work,
          outputDirectory,
        }),
      Error,
      "backup already exists",
    );
  } finally {
    await Deno.remove(fixture.root, { recursive: true });
  }
});
