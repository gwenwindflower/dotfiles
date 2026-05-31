#!/usr/bin/env -S deno run --allow-run=agent-browser,gh --allow-read --allow-write --allow-env
/**
 * scrape-github-stars — One-shot scrape of a GitHub user's curated stars lists.
 *
 * GitHub's REST/GraphQL APIs do not expose star list membership (community#8293).
 * This walks the web UI via agent-browser (Playwright) and dumps every list's
 * contents to a CSV for manual curation.
 *
 * Usage:
 *   deno task scrape-stars [--user <login>] [--out <csv>] [--only <slug>] [--fresh] [--dry-run]
 *
 * Output:
 *   ./github-stars.csv             (list,name,url,description,language)
 *   ./github-stars.progress.json   (resume state)
 */

import { parseArgs } from "@std/cli/parse-args";

// ── Constants ──────────────────────────────────────────────────────────

const SESSION = "gh-stars-scrape";
const DEFAULT_CSV = "./github-stars.csv";
const DEFAULT_PROGRESS = "./github-stars.progress.json";
const DELAY_MIN_MS = 4000;
const DELAY_MAX_MS = 9000;
const CSV_HEADER = "list,name,url,description,language";

// ── Types ──────────────────────────────────────────────────────────────

export interface RepoCard {
  name: string;
  url: string;
  description: string;
  language: string;
}

interface ListState {
  slug: string;
  nextPage: number;
  done: boolean;
}

interface Progress {
  user: string;
  lists: ListState[];
  seen: string[]; // `${list}\t${url}` keys for dedupe
}

// ── Pure helpers (exported for tests) ──────────────────────────────────

/** Escape one CSV cell per RFC-4180. */
export function csvEscape(value: string): string {
  const v = value.replace(/\r?\n/g, " ").trim();
  if (/[",\n]/.test(v)) return `"${v.replace(/"/g, '""')}"`;
  return v;
}

export function toCsvRow(card: RepoCard, list: string): string {
  return [list, card.name, card.url, card.description, card.language]
    .map(csvEscape)
    .join(",");
}

/** Extract list slugs from the stars/lists index page HTML. */
export function parseListIndexHtml(html: string, user: string): string[] {
  const pattern = new RegExp(
    `/stars/${
      user.replace(/[.*+?^${}()|[\\]\\\\]/g, "\\$&")
    }/lists/([A-Za-z0-9_-]+)`,
    "g",
  );
  const slugs = new Set<string>();
  for (const m of html.matchAll(pattern)) slugs.add(m[1]);
  return [...slugs].sort();
}

// ── agent-browser subprocess wrapper ───────────────────────────────────

async function ab(...args: string[]): Promise<string> {
  const cmd = new Deno.Command("agent-browser", {
    args: ["--session-name", SESSION, ...args],
    stdout: "piped",
    stderr: "piped",
  });
  const { code, stdout, stderr } = await cmd.output();
  const out = new TextDecoder().decode(stdout);
  if (code !== 0) {
    const err = new TextDecoder().decode(stderr);
    throw new Error(`agent-browser ${args.join(" ")} exited ${code}: ${err}`);
  }
  return out;
}

async function abEval(js: string): Promise<unknown> {
  const cmd = new Deno.Command("agent-browser", {
    args: ["--session-name", SESSION, "eval", "--stdin"],
    stdin: "piped",
    stdout: "piped",
    stderr: "piped",
  });
  const child = cmd.spawn();
  const writer = child.stdin.getWriter();
  await writer.write(new TextEncoder().encode(js));
  await writer.close();
  const { code, stdout, stderr } = await child.output();
  const out = new TextDecoder().decode(stdout).trim();
  if (code !== 0) {
    const err = new TextDecoder().decode(stderr);
    throw new Error(`agent-browser eval exited ${code}: ${err}`);
  }
  // agent-browser eval prints the JSON-stringified result; strip surrounding quotes if it's a string literal of JSON.
  try {
    const parsed = JSON.parse(out);
    if (typeof parsed === "string") return JSON.parse(parsed);
    return parsed;
  } catch {
    return out;
  }
}

async function openAndWait(url: string): Promise<void> {
  await ab("open", url);
  await ab("wait", "--load", "networkidle");
}

function sleep(ms: number): Promise<void> {
  return new Promise((r) => setTimeout(r, ms));
}

function jitter(): number {
  return DELAY_MIN_MS +
    Math.floor(Math.random() * (DELAY_MAX_MS - DELAY_MIN_MS));
}

// ── In-page extraction scripts ─────────────────────────────────────────

const LIST_INDEX_EXTRACT_JS = (user: string) => `
JSON.stringify(
  Array.from(document.querySelectorAll('a[href*="/stars/${user}/lists/"]'))
    .map(a => {
      const m = a.getAttribute('href').match(/\\/stars\\/${user}\\/lists\\/([A-Za-z0-9_-]+)/);
      return m ? m[1] : null;
    })
    .filter(Boolean)
    .filter((v, i, arr) => arr.indexOf(v) === i)
    .sort()
)
`;

const LIST_PAGE_EXTRACT_JS = `
JSON.stringify((() => {
  // Repo cards on a list page use <h2> with an anchor whose href is /owner/repo.
  // Other <h2>s on the page (Navigation Menu, Achievements, etc.) don't match
  // that href shape so we filter by the href pattern, not the heading level alone.
  const cards = [];
  const headings = Array.from(document.querySelectorAll('h2, h3'));
  for (const h of headings) {
    const a = h.querySelector('a[href]');
    if (!a) continue;
    const href = a.getAttribute('href') || '';
    const m = href.match(/^\\/([^\\/\\s]+)\\/([^\\/\\s?#]+)$/);
    if (!m) continue;
    // Skip non-repo profile-ish paths.
    if (['settings','marketplace','explore','about','pricing','features','contact','sponsors','orgs','users','login','signup','search','notifications','codespaces','issues','pulls','discussions','new'].includes(m[1])) continue;
    const name = m[1] + '/' + m[2];
    const url = 'https://github.com' + href;
    // Walk up to the card container (the closest ancestor that also holds the description/language meta).
    let container = h.parentElement;
    for (let i = 0; i < 6 && container; i++) {
      if (container.querySelector('[itemprop="programmingLanguage"]') || container.querySelector('[itemprop="description"]')) break;
      container = container.parentElement;
    }
    let description = '';
    let language = '';
    if (container) {
      const desc = container.querySelector('[itemprop="description"]');
      if (desc) description = desc.textContent.trim();
      else {
        const p = container.querySelector('p');
        if (p) description = p.textContent.trim();
      }
      const lang = container.querySelector('[itemprop="programmingLanguage"]');
      if (lang) language = lang.textContent.trim();
    }
    cards.push({ name, url, description, language });
  }
  // De-dupe by url within page.
  const seen = new Set();
  return cards.filter(c => {
    if (seen.has(c.url)) return false;
    seen.add(c.url);
    return true;
  });
})())
`;

const HAS_NEXT_PAGE_JS = `
JSON.stringify(Boolean(
  document.querySelector('a[rel="next"]') ||
  Array.from(document.querySelectorAll('a')).find(a => /^\\s*Next\\s*$/i.test(a.textContent || ''))
))
`;

// ── Progress file I/O ──────────────────────────────────────────────────

async function readProgress(path: string): Promise<Progress | null> {
  try {
    const text = await Deno.readTextFile(path);
    return JSON.parse(text) as Progress;
  } catch {
    return null;
  }
}

async function writeProgress(path: string, p: Progress): Promise<void> {
  await Deno.writeTextFile(path, JSON.stringify(p, null, 2) + "\n");
}

async function appendCsv(path: string, rows: string[]): Promise<void> {
  if (rows.length === 0) return;
  await Deno.writeTextFile(path, rows.join("\n") + "\n", { append: true });
}

async function ensureCsvHeader(path: string): Promise<void> {
  try {
    const stat = await Deno.stat(path);
    if (stat.size > 0) return;
  } catch {
    // not present; create with header
  }
  await Deno.writeTextFile(path, CSV_HEADER + "\n");
}

async function resolveUser(): Promise<string> {
  const cmd = new Deno.Command("gh", {
    args: ["api", "user", "--jq", ".login"],
    stdout: "piped",
    stderr: "piped",
  });
  const { code, stdout } = await cmd.output();
  if (code !== 0) {
    throw new Error(
      "Could not resolve user via `gh api user`. Pass --user <login>.",
    );
  }
  return new TextDecoder().decode(stdout).trim();
}

// ── Main ───────────────────────────────────────────────────────────────

async function main(): Promise<void> {
  const args = parseArgs(Deno.args, {
    string: ["user", "out", "only", "progress"],
    boolean: ["fresh", "dry-run", "help"],
    default: { out: DEFAULT_CSV, progress: DEFAULT_PROGRESS },
  });

  if (args.help) {
    console.log(
      "Usage: scrape-github-stars [--user <login>] [--out <csv>] [--only <slug>] [--fresh] [--dry-run]",
    );
    Deno.exit(0);
  }

  const user = args.user ?? await resolveUser();
  const csvPath = args.out!;
  const progressPath = args.progress!;

  if (args.fresh) {
    for (const p of [csvPath, progressPath]) {
      try {
        await Deno.remove(p);
        console.log(`removed ${p}`);
      } catch { /* nothing to remove */ }
    }
  }

  console.log(`user: ${user}`);
  console.log(`csv:  ${csvPath}`);
  console.log(`progress: ${progressPath}`);

  // Discover or resume.
  let progress = await readProgress(progressPath);
  if (!progress) {
    console.log("\n→ Discovering lists...");
    await openAndWait(`https://github.com/${user}?tab=stars`);
    const slugs = await abEval(LIST_INDEX_EXTRACT_JS(user)) as string[];
    if (!Array.isArray(slugs) || slugs.length === 0) {
      console.error(
        "No lists discovered. Page may have changed or user has none. Aborting.",
      );
      console.error(
        "Tip: run `agent-browser --session-name " + SESSION +
          " screenshot` to inspect.",
      );
      Deno.exit(1);
    }
    progress = {
      user,
      lists: slugs.map((slug) => ({ slug, nextPage: 1, done: false })),
      seen: [],
    };
    await writeProgress(progressPath, progress);
    console.log(`  found ${slugs.length} list(s): ${slugs.join(", ")}`);
  } else {
    console.log(
      `\n→ Resuming. ${
        progress.lists.filter((l) => l.done).length
      }/${progress.lists.length} lists done.`,
    );
  }

  if (args["dry-run"]) {
    console.log("\n--dry-run: exiting before scrape.");
    Deno.exit(0);
  }

  await ensureCsvHeader(csvPath);
  const seen = new Set(progress.seen);

  // Scrape each list.
  for (const list of progress.lists) {
    if (list.done) continue;
    if (args.only && list.slug !== args.only) continue;

    console.log(`\n→ List: ${list.slug} (from page ${list.nextPage})`);
    let page = list.nextPage;
    let totalForList = 0;
    let emptyStrikes = 0;

    while (true) {
      const url = page === 1
        ? `https://github.com/stars/${user}/lists/${list.slug}`
        : `https://github.com/stars/${user}/lists/${list.slug}?page=${page}`;
      console.log(`   page ${page}: ${url}`);
      await openAndWait(url);

      const cards = await abEval(LIST_PAGE_EXTRACT_JS) as RepoCard[];
      const hasNext = await abEval(HAS_NEXT_PAGE_JS) as boolean;

      if (!Array.isArray(cards)) {
        console.error(
          "   ! unexpected eval output, stopping list. Inspect session manually.",
        );
        break;
      }

      const fresh = cards.filter((c) => {
        const key = `${list.slug}\t${c.url}`;
        if (seen.has(key)) return false;
        seen.add(key);
        return true;
      });

      const rows = fresh.map((c) => toCsvRow(c, list.slug));
      await appendCsv(csvPath, rows);
      totalForList += fresh.length;
      console.log(
        `     +${fresh.length} new (page total ${cards.length}, hasNext=${hasNext})`,
      );

      list.nextPage = page + 1;
      progress.seen = [...seen];
      await writeProgress(progressPath, progress);

      if (cards.length === 0) {
        emptyStrikes += 1;
        if (emptyStrikes >= 2 || !hasNext) {
          console.log("     ! empty page; finishing list.");
          break;
        }
      } else {
        emptyStrikes = 0;
      }

      if (!hasNext) break;

      const wait = jitter();
      console.log(`     waiting ${wait}ms before next page...`);
      await sleep(wait);
      page += 1;
    }

    list.done = true;
    await writeProgress(progressPath, progress);
    console.log(`   ✓ ${list.slug}: ${totalForList} new rows`);

    if (args.only) break;

    const wait = jitter();
    console.log(`   waiting ${wait}ms before next list...`);
    await sleep(wait);
  }

  await ab("close").catch(() => {});

  const allDone = progress.lists.every((l) => l.done);
  console.log(
    `\n${allDone ? "✓ All lists complete." : "Partial run; rerun to resume."}`,
  );
  console.log(`csv: ${csvPath}`);
  console.log(`progress: ${progressPath}`);
}

if (import.meta.main) {
  try {
    await main();
  } catch (err) {
    console.error("fatal:", err instanceof Error ? err.message : err);
    Deno.exit(1);
  }
}
