import { assertEquals } from "@std/assert";
import {
  computeSplit,
  diffLists,
  findDupes,
  getAllSlots,
  getEffective,
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

// ── computeSplit ──────────────────────────────────────────────────────

Deno.test("computeSplit: profile=core collapses live into core, profileItems null", () => {
  const result = computeSplit(["a", "b"], ["a", "b", "c"], "core");
  assertEquals(result.core, ["a", "b", "c"]);
  assertEquals(result.profileItems, null);
});

Deno.test("computeSplit: prunes core to (oldCore ∩ live), residual → profile", () => {
  // oldCore = [a, b, c]; live = [a, c, d]
  // → newCore = [a, c]; newProfile = [d]
  const result = computeSplit(["a", "b", "c"], ["a", "c", "d"], "personal");
  assertEquals(result.core, ["a", "c"]);
  assertEquals(result.profileItems, ["d"]);
});

Deno.test("computeSplit: empty live → both empty", () => {
  const result = computeSplit(["a", "b"], [], "personal");
  assertEquals(result.core, []);
  assertEquals(result.profileItems, []);
});

Deno.test("computeSplit: live exactly matches old core → empty profile", () => {
  const result = computeSplit(["a", "b"], ["a", "b"], "personal");
  assertEquals(result.core, ["a", "b"]);
  assertEquals(result.profileItems, []);
});

Deno.test("computeSplit: empty oldCore → everything goes to profile", () => {
  const result = computeSplit([], ["a", "b"], "personal");
  assertEquals(result.core, []);
  assertEquals(result.profileItems, ["a", "b"]);
});

Deno.test("computeSplit: preserves core ordering (filter, not rebuild)", () => {
  // oldCore order matters for diff readability — verify we filter rather than
  // re-sort into live's order.
  const result = computeSplit(["c", "a", "b"], ["a", "b", "c"], "work");
  assertEquals(result.core, ["c", "a", "b"]);
  assertEquals(result.profileItems, []);
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
