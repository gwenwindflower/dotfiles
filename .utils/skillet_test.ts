import { assertEquals, assertThrows } from "@std/assert";
import {
  findEntry,
  parseManifest,
  parseSkillMetadata,
  refName,
  setBaseline,
  sharedFileSources,
  stripGhMetadata,
  upstreamStatus,
} from "./skillet.ts";

const MANIFEST = `# Upstream skills distilled into our spines.

[[context-search.upstream]]
repo = "tobi/qmd"
skill = "qmd"
files = ["qmd.md", "qmd-upkeep.md"]
baseline = "aaaa"
tree = "1111"

[[context-search.upstream]]
repo = "ast-grep/agent-skill"
skill = "outline"
# folded into the ast-grep doc
files = ["ast-grep.md"]

[[managing-tasks.upstream]]
repo = "BRO3886/rem"
skill = "rem-cli"
files = ["ref/rem.md"]
`;

Deno.test("parseManifest reads upstream entries grouped under their spine", () => {
  const entries = parseManifest(MANIFEST);
  assertEquals(entries, [
    {
      spine: "context-search",
      repo: "tobi/qmd",
      skill: "qmd",
      files: ["qmd.md", "qmd-upkeep.md"],
      baseline: "aaaa",
      tree: "1111",
      pin: undefined,
    },
    {
      spine: "context-search",
      repo: "ast-grep/agent-skill",
      skill: "outline",
      files: ["ast-grep.md"],
      baseline: "",
      tree: "",
      pin: undefined,
    },
    {
      spine: "managing-tasks",
      repo: "BRO3886/rem",
      skill: "rem-cli",
      files: ["ref/rem.md"],
      baseline: "",
      tree: "",
      pin: undefined,
    },
  ]);
});

Deno.test("parseManifest rejects an entry without files and names the spine and entry", () => {
  const text = `[[context-search.upstream]]\nrepo = "a/b"\nskill = "c"\n`;
  assertThrows(
    () => parseManifest(text),
    Error,
    "context-search upstream 1 (a/b c): files",
  );
});

Deno.test("parseManifest rejects a file path that escapes the spine", () => {
  const text =
    `[[context-search.upstream]]\nrepo = "a/b"\nskill = "c"\nfiles = ["ok.md", "../other/x.md"]\n`;
  assertThrows(
    () => parseManifest(text),
    Error,
    "relative path inside the spine",
  );
});

Deno.test("parseManifest rejects a spine table without an upstream list", () => {
  const text = `[context-search]\nrepo = "a/b"\n`;
  assertThrows(() => parseManifest(text), Error, "[[context-search.upstream]]");
});

Deno.test("parseManifest rejects a repo that is not owner/name", () => {
  const text =
    `[[context-search.upstream]]\nrepo = "qmd"\nskill = "qmd"\nfiles = ["x.md"]\n`;
  assertThrows(() => parseManifest(text), Error, "repo must be owner/name");
});

Deno.test("parseManifest rejects duplicate skill names across spines so commands can address entries by name", () => {
  const text =
    `[[a.upstream]]\nrepo = "a/b"\nskill = "x"\nfiles = ["x.md"]\n\n` +
    `[[b.upstream]]\nrepo = "c/d"\nskill = "x"\nfiles = ["y.md"]\n`;
  assertThrows(
    () => parseManifest(text),
    Error,
    "skill x appears more than once",
  );
});

Deno.test("findEntry reports the known skill names when a name is unknown", () => {
  const entries = parseManifest(MANIFEST);
  assertThrows(
    () => findEntry(entries, "nope"),
    Error,
    "known: qmd, outline, rem-cli",
  );
});

Deno.test("setBaseline replaces the baseline and tree of the matching entry only", () => {
  const out = setBaseline(MANIFEST, "qmd", { baseline: "bbbb", tree: "2222" });
  assertEquals(parseManifest(out)[0].baseline, "bbbb");
  assertEquals(parseManifest(out)[0].tree, "2222");
  assertEquals(parseManifest(out)[1].baseline, "");
  assertEquals(parseManifest(out)[2].baseline, "");
  assertEquals(
    out.startsWith("# Upstream skills distilled into our spines."),
    true,
  );
});

Deno.test("setBaseline inserts baseline and tree into an entry that has neither, keeping its comments", () => {
  const out = setBaseline(MANIFEST, "outline", {
    baseline: "cccc",
    tree: "3333",
  });
  const outline = parseManifest(out)[1];
  assertEquals([outline.baseline, outline.tree], ["cccc", "3333"]);
  assertEquals(out.includes("# folded into the ast-grep doc"), true);
  assertEquals(parseManifest(out)[0].baseline, "aaaa");
});

Deno.test("setBaseline throws when the skill is not in the manifest", () => {
  assertThrows(
    () => setBaseline(MANIFEST, "nope", { baseline: "x", tree: "y" }),
    Error,
    "nope",
  );
});

const INSTALLED = `---
description: Search local markdown.
metadata:
    author: tobi
    github-path: skills/qmd
    github-ref: refs/tags/v2.8.3
    github-repo: https://github.com/tobi/qmd
    github-tree-sha: 7ee23d31
name: qmd
---
# QMD
`;

Deno.test("parseSkillMetadata reads the source gh records in frontmatter", () => {
  assertEquals(parseSkillMetadata(INSTALLED), {
    repo: "tobi/qmd",
    path: "skills/qmd",
    ref: "refs/tags/v2.8.3",
    tree: "7ee23d31",
  });
});

Deno.test("parseSkillMetadata throws when gh metadata is missing", () => {
  assertThrows(
    () => parseSkillMetadata("---\nname: x\n---\n# x\n"),
    Error,
    "not installed by gh skill",
  );
});

Deno.test("refName strips refs/tags and refs/heads prefixes and leaves SHAs alone", () => {
  assertEquals(refName("refs/tags/v2.8.3"), "v2.8.3");
  assertEquals(refName("refs/heads/main"), "main");
  assertEquals(refName("facd35e0"), "facd35e0");
});

Deno.test("setBaseline edits an entry in a later spine without touching earlier spines", () => {
  const out = setBaseline(MANIFEST, "rem-cli", {
    baseline: "dddd",
    tree: "4444",
  });
  const rem = parseManifest(out)[2];
  assertEquals([rem.spine, rem.baseline, rem.tree], [
    "managing-tasks",
    "dddd",
    "4444",
  ]);
  assertEquals(parseManifest(out)[1].baseline, "");
});

Deno.test("upstreamStatus distinguishes never-distilled, moved, and current entries", () => {
  const [qmd, outline] = parseManifest(MANIFEST);
  assertEquals(upstreamStatus(outline, "9999"), "new");
  assertEquals(upstreamStatus(qmd, "2222"), "changed");
  assertEquals(upstreamStatus(qmd, "1111"), "current");
});

Deno.test("stripGhMetadata removes gh keys and keeps authored metadata", () => {
  const out = stripGhMetadata(INSTALLED);
  assertEquals(
    out,
    `---
description: Search local markdown.
metadata:
    author: tobi
name: qmd
---
# QMD
`,
  );
});

Deno.test("stripGhMetadata drops the metadata key when only gh keys were under it", () => {
  const text = `---
name: chezmoi
description: chezmoi dotfiles.
metadata:
  github-path: skills/chezmoi
  github-ref: refs/heads/main
---
# chezmoi
`;
  assertEquals(
    stripGhMetadata(text),
    `---
name: chezmoi
description: chezmoi dotfiles.
---
# chezmoi
`,
  );
});

Deno.test("stripGhMetadata leaves a file without frontmatter untouched", () => {
  assertEquals(stripGhMetadata("# plain\n"), "# plain\n");
});

Deno.test("sharedFileSources names other upstreams folding into the same spine files", () => {
  const text = MANIFEST +
    `\n[[context-search.upstream]]\nrepo = "ast-grep/agent-skill"\nskill = "ast-grep"\nfiles = ["ast-grep.md", "ast-grep-rules.md"]\n`;
  const entries = parseManifest(text);
  assertEquals(sharedFileSources(entries, findEntry(entries, "ast-grep")), [
    { skill: "outline", file: "ast-grep.md" },
  ]);
  assertEquals(sharedFileSources(entries, findEntry(entries, "qmd")), []);
});

Deno.test("sharedFileSources ignores same-named files in a different spine", () => {
  const text =
    `[[a.upstream]]\nrepo = "o/r"\nskill = "x"\nfiles = ["tool.md"]\n\n` +
    `[[b.upstream]]\nrepo = "o/s"\nskill = "y"\nfiles = ["tool.md"]\n`;
  const entries = parseManifest(text);
  assertEquals(sharedFileSources(entries, findEntry(entries, "x")), []);
});
