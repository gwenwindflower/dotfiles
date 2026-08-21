import { assertEquals } from "@std/assert";
import {
  diffLists,
  findDupes,
  getAllSlots,
  getEffective,
  parseCargoInstallList,
  planAdd,
  planRemove,
} from "./packy.ts";

// ── getEffective ──────────────────────────────────────────────────────

Deno.test("getEffective: profile=core returns only core", () => {
  const map = { core: ["a", "b"], personal: ["c"], work: ["d"] };
  assertEquals(getEffective(map, "core"), ["a", "b"]);
});

Deno.test("getEffective: profile=personal returns core + personal", () => {
  const map = { core: ["a", "b"], personal: ["c"], work: ["d"] };
  assertEquals(getEffective(map, "personal"), ["a", "b", "c"]);
});

Deno.test("getEffective: profile=work returns core + work (skips personal)", () => {
  const map = { core: ["a"], personal: ["c"], work: ["d"] };
  assertEquals(getEffective(map, "work"), ["a", "d"]);
});

Deno.test("getEffective: undefined map → empty", () => {
  assertEquals(getEffective(undefined, "personal"), []);
});

Deno.test("getEffective: missing core slot → empty core baseline", () => {
  const map = { personal: ["c"] };
  assertEquals(getEffective(map, "personal"), ["c"]);
});

// ── getAllSlots ───────────────────────────────────────────────────────

Deno.test("getAllSlots: union across all profile slots", () => {
  const map = { core: ["a"], personal: ["b"], work: ["c"] };
  assertEquals(getAllSlots(map).sort(), ["a", "b", "c"]);
});

Deno.test("getAllSlots: undefined → empty", () => {
  assertEquals(getAllSlots(undefined), []);
});

Deno.test("getAllSlots: returns duplicates (caller decides what to do)", () => {
  // Useful for lint: we want findDupes to see duplicates, not deduplicated.
  const map = { core: ["a"], personal: ["a"] };
  assertEquals(getAllSlots(map).sort(), ["a", "a"]);
});

// ── findDupes ─────────────────────────────────────────────────────────

Deno.test("findDupes: nothing duplicated", () => {
  const map = { core: ["a"], personal: ["b"], work: ["c"] };
  assertEquals(findDupes(map), []);
});

Deno.test("findDupes: item in two slots", () => {
  const map = { core: ["a"], personal: ["a"], work: ["b"] };
  const dupes = findDupes(map);
  assertEquals(dupes.length, 1);
  assertEquals(dupes[0].item, "a");
  assertEquals(dupes[0].slots.sort(), ["core", "personal"]);
});

Deno.test("findDupes: item in all three slots", () => {
  const map = { core: ["x"], personal: ["x"], work: ["x"] };
  const dupes = findDupes(map);
  assertEquals(dupes.length, 1);
  assertEquals(dupes[0].slots.sort(), ["core", "personal", "work"]);
});

Deno.test("findDupes: multiple distinct dupes", () => {
  const map = {
    core: ["a", "b"],
    personal: ["a", "c"],
    work: ["b", "c"],
  };
  const dupes = findDupes(map).sort((x, y) => x.item.localeCompare(y.item));
  assertEquals(dupes.length, 3);
  assertEquals(dupes[0].item, "a");
  assertEquals(dupes[0].slots.sort(), ["core", "personal"]);
  assertEquals(dupes[1].item, "b");
  assertEquals(dupes[1].slots.sort(), ["core", "work"]);
  assertEquals(dupes[2].item, "c");
  assertEquals(dupes[2].slots.sort(), ["personal", "work"]);
});

Deno.test("findDupes: undefined map → empty", () => {
  assertEquals(findDupes(undefined), []);
});

// ── diffLists ─────────────────────────────────────────────────────────

Deno.test("diffLists: identical → empty added/removed", () => {
  assertEquals(diffLists(["a", "b"], ["a", "b"]), { added: [], removed: [] });
});

Deno.test("diffLists: additions only", () => {
  assertEquals(diffLists(["a", "b", "c"], ["a"]), {
    added: ["b", "c"],
    removed: [],
  });
});

Deno.test("diffLists: removals only", () => {
  assertEquals(diffLists(["a"], ["a", "b", "c"]), {
    added: [],
    removed: ["b", "c"],
  });
});

Deno.test("diffLists: mixed", () => {
  assertEquals(diffLists(["a", "b", "c"], ["a", "x", "y"]), {
    added: ["b", "c"],
    removed: ["x", "y"],
  });
});

Deno.test("diffLists: empty both", () => {
  assertEquals(diffLists([], []), { added: [], removed: [] });
});

// ── parseCargoInstallList ───────────────────────────────────────────────

Deno.test("parseCargoInstallList: returns sorted crate names", () => {
  const output = `nightlight v2.1.0:
    nightlight
linear-cli v0.1.7:
    linear
usage-cli v2.3.2:
    usage
`;

  assertEquals(parseCargoInstallList(output), [
    "linear-cli",
    "nightlight",
    "usage-cli",
  ]);
});

Deno.test("parseCargoInstallList: ignores warnings and binary lines", () => {
  const output = `warning: metadata recovered
cargo-update v18.0.0:
    cargo-install-update
`;

  assertEquals(parseCargoInstallList(output), ["cargo-update"]);
});

// ── planAdd ───────────────────────────────────────────────────────────

Deno.test("planAdd: already in target → no-op, map unchanged", () => {
  const map = { core: ["a"], personal: ["b"], work: [] };
  const plan = planAdd(map, "a", "core", false);
  assertEquals(plan.action, "no-op");
  assertEquals(plan.newMap.core, ["a"]);
  assertEquals(plan.newMap.personal, ["b"]);
});

Deno.test("planAdd: new package + implicit target → added, sorted", () => {
  const map = { core: ["b"], personal: [], work: [] };
  const plan = planAdd(map, "a", "core", false);
  assertEquals(plan.action, "added");
  assertEquals(plan.newMap.core, ["a", "b"]);
});

Deno.test("planAdd: undefined map → added into empty target", () => {
  const plan = planAdd(undefined, "a", "work", false);
  assertEquals(plan.action, "added");
  assertEquals(plan.newMap.work, ["a"]);
  assertEquals(plan.newMap.core, []);
  assertEquals(plan.newMap.personal, []);
});

Deno.test("planAdd: in different profile + implicit target → kept, map untouched", () => {
  const map = { core: ["a"], personal: [], work: [] };
  const plan = planAdd(map, "a", "work", false);
  assertEquals(plan.action, "kept");
  assertEquals(plan.from, "core");
  assertEquals(plan.newMap.core, ["a"]);
  assertEquals(plan.newMap.work, []);
});

Deno.test("planAdd: in different profile + explicit target → moved", () => {
  const map = { core: ["a"], personal: [], work: [] };
  const plan = planAdd(map, "a", "work", true);
  assertEquals(plan.action, "moved");
  assertEquals(plan.from, "core");
  assertEquals(plan.newMap.core, []);
  assertEquals(plan.newMap.work, ["a"]);
});

Deno.test("planAdd: explicit target same as where pkg lives → no-op", () => {
  const map = { core: ["a"], personal: [], work: [] };
  const plan = planAdd(map, "a", "core", true);
  assertEquals(plan.action, "no-op");
});

Deno.test("planAdd: input map not mutated", () => {
  const map = { core: ["a"], personal: ["b"], work: [] };
  const snapshot = JSON.stringify(map);
  planAdd(map, "c", "work", false);
  assertEquals(JSON.stringify(map), snapshot);
});

// ── planRemove ────────────────────────────────────────────────────────

Deno.test("planRemove: removes from the slot it lives in", () => {
  const map = { core: ["a", "b"], personal: ["c"], work: [] };
  const plan = planRemove(map, "b");
  assertEquals(plan.action, "removed");
  assertEquals(plan.from, "core");
  assertEquals(plan.newMap.core, ["a"]);
  assertEquals(plan.newMap.personal, ["c"]);
});

Deno.test("planRemove: not in any slot → not-tracked", () => {
  const map = { core: ["a"], personal: [], work: [] };
  const plan = planRemove(map, "z");
  assertEquals(plan.action, "not-tracked");
  assertEquals(plan.from, undefined);
  assertEquals(plan.newMap.core, ["a"]);
});

Deno.test("planRemove: undefined map → not-tracked, all slots empty", () => {
  const plan = planRemove(undefined, "a");
  assertEquals(plan.action, "not-tracked");
  assertEquals(plan.newMap.core, []);
  assertEquals(plan.newMap.personal, []);
  assertEquals(plan.newMap.work, []);
});

Deno.test("planRemove: input map not mutated", () => {
  const map = { core: ["a"], personal: ["b"], work: [] };
  const snapshot = JSON.stringify(map);
  planRemove(map, "a");
  assertEquals(JSON.stringify(map), snapshot);
});
