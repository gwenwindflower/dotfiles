import { assert, assertEquals, assertThrows } from "@std/assert";
import { join } from "@std/path";
import {
  createItch,
  type ItchOptions,
  parseItchArgs,
  siblingPath,
} from "./itch.ts";

const git = async (cwd: string, ...args: string[]) => {
  const output = await new Deno.Command("git", { args, cwd }).output();
  return new TextDecoder().decode(output.stdout).trim();
};

const withParent = async (body: (parent: string) => Promise<void>) => {
  const parent = await Deno.makeTempDir({ prefix: "itch-test-" });
  try {
    await body(parent);
  } finally {
    await Deno.remove(parent, { recursive: true });
  }
};

const options = (overrides: Partial<ItchOptions>): ItchOptions => ({
  name: "repo",
  worktrees: [],
  commits: 2,
  hasRemote: true,
  ...overrides,
});

Deno.test("parseItchArgs fills defaults", () => {
  assertEquals(parseItchArgs([]), options({}));
});

Deno.test("parseItchArgs reads repeated worktrees and the other options", () => {
  assertEquals(
    parseItchArgs([
      "--name",
      "lab",
      "--worktree",
      "feat",
      "-w",
      "fix/x",
      "--commits",
      "5",
      "--no-remote",
      "--parent",
      "/tmp/x",
    ]),
    options({
      name: "lab",
      worktrees: ["feat", "fix/x"],
      commits: 5,
      hasRemote: false,
      parent: "/tmp/x",
    }),
  );
});

Deno.test("parseItchArgs rejects bad values with the flag named", () => {
  assertThrows(() => parseItchArgs(["--commits", "0"]), Error, "--commits");
  assertThrows(() => parseItchArgs(["--commits", "two"]), Error, "--commits");
  assertThrows(() => parseItchArgs(["--name", "a/b"]), Error, "--name");
  assertThrows(
    () => parseItchArgs(["--worktree", "main"]),
    Error,
    "--worktree",
  );
  assertThrows(
    () => parseItchArgs(["--worktree", "feat", "--worktree", "feat"]),
    Error,
    "--worktree",
  );
  assertThrows(() => parseItchArgs(["--bogus"]), Error, "--bogus");
});

Deno.test("siblingPath follows Worktrunk's default worktree path", () => {
  assertEquals(
    siblingPath("/t/itch-1", "repo", "fix/login"),
    "/t/itch-1/repo.fix-login",
  );
});

Deno.test("createItch builds a pushed main worktree with origin/HEAD set", async () => {
  await withParent(async (parent) => {
    const itch = await createItch(options({ parent, commits: 3 }));

    assertEquals(itch.repo, join(itch.root, "repo"));
    assertEquals(
      await git(itch.repo, "symbolic-ref", "--short", "HEAD"),
      "main",
    );
    assertEquals(await git(itch.repo, "rev-list", "--count", "HEAD"), "3");
    assertEquals(
      await git(
        itch.repo,
        "symbolic-ref",
        "--short",
        "refs/remotes/origin/HEAD",
      ),
      "origin/main",
    );
    assertEquals(
      await git(itch.repo, "rev-parse", "--abbrev-ref", "@{upstream}"),
      "origin/main",
    );
    assertEquals(await git(itch.repo, "status", "--porcelain"), "");
  });
});

Deno.test("createItch adds sibling worktrees with pushed upstream branches", async () => {
  await withParent(async (parent) => {
    const itch = await createItch(
      options({ parent, worktrees: ["feat", "fix/x"] }),
    );
    const sibling = siblingPath(itch.root, "repo", "fix/x");

    assertEquals(itch.worktrees, [
      siblingPath(itch.root, "repo", "feat"),
      sibling,
    ]);
    assertEquals(
      await git(sibling, "symbolic-ref", "--short", "HEAD"),
      "fix/x",
    );
    assertEquals(
      await git(sibling, "rev-parse", "--abbrev-ref", "@{upstream}"),
      "origin/fix/x",
    );
    assertEquals(await git(sibling, "rev-list", "--count", "main..HEAD"), "1");

    const commonDir = (cwd: string) =>
      git(cwd, "rev-parse", "--path-format=absolute", "--git-common-dir");
    assertEquals(await commonDir(sibling), await commonDir(itch.repo));
  });
});

Deno.test("createItch with no remote leaves branches local", async () => {
  await withParent(async (parent) => {
    const itch = await createItch(
      options({ parent, hasRemote: false, worktrees: ["feat"] }),
    );

    assertEquals(await git(itch.repo, "remote"), "");
    assertEquals(
      await git(itch.worktrees[0]!, "symbolic-ref", "--short", "HEAD"),
      "feat",
    );
  });
});

Deno.test("createItch commits unsigned under a local identity", async () => {
  await withParent(async (parent) => {
    const itch = await createItch(options({ parent }));

    assertEquals(
      await git(itch.repo, "config", "--local", "commit.gpgsign"),
      "false",
    );
    assert((await git(itch.repo, "log", "-1", "--format=%G?")) === "N");
  });
});
