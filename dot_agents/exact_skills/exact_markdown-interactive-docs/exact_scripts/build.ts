#!/usr/bin/env -S deno run --allow-read --allow-write
// Compile a markdown-interactive-docs source into one self-contained HTML page.
//
//   deno run --allow-read --allow-write build.ts <source.md> [-t template.html] [-o out.html]
//
// Defaults: template is assets/template.html next to this script; output is
// dist/<source-stem>.html next to the source. The dialect is specified in the
// skill's dialect.md; structural violations fail the build with line numbers.

type Piece =
  | { kind: "p"; html: string }
  | { kind: "list"; items: { group: boolean; html: string }[] }
  | { kind: "table"; head: string[]; rows: string[][] }
  | { kind: "code"; text: string };
interface Task {
  id: string;
  label: string;
}
interface LegendEntry {
  name: string;
  desc: string;
}
interface Item {
  label: string;
  title: string;
  badge: number;
  flags: string[];
  flat: boolean;
  pieces: Piece[];
  line: number;
}
interface Block {
  title: string;
  chip: string;
  pieces: Piece[];
  items: Item[];
}
interface Section {
  kicker: string;
  title: string;
  pieces: Piece[];
  blocks: Block[];
}

function fail(msg: string, line?: number): never {
  const loc = line === undefined ? "" : `${srcPath}:${line} — `;
  console.error(`build failed: ${loc}${msg}`);
  Deno.exit(1);
}

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/[^\x00-\x7F]/gu, (c) => `&#${c.codePointAt(0)};`);
}

// Inline dialect: `code`, **bold**, [text](url) links, [Tag] chips.
// chipClass is "tag" in body text, "flag" on item headings.
function renderInline(raw: string, chipClass = "tag"): string {
  const token = /(`[^`]+`)|(\[[^\]]+\]\([^)]+\))|(\[[^\]]+\])|(\*\*[^*]+\*\*)/g;
  let out = "";
  let last = 0;
  for (const m of raw.matchAll(token)) {
    out += escapeHtml(raw.slice(last, m.index));
    last = m.index + m[0].length;
    if (m[1]) {
      out += `<code>${escapeHtml(m[1].slice(1, -1))}</code>`;
    } else if (m[2]) {
      const link = m[2].match(/^\[([^\]]+)\]\(([^)]+)\)$/)!;
      out = out.trimEnd();
      out += ` <a class="mlink" href="${escapeHtml(link[2])}" target="_blank" rel="noopener">${escapeHtml(link[1])}</a>`;
    } else if (m[3]) {
      out = out.trimEnd();
      out += `<span class="${chipClass}">${escapeHtml(m[3].slice(1, -1))}</span>`;
    } else {
      out += `<strong>${escapeHtml(m[4].slice(2, -2))}</strong>`;
    }
  }
  return out + escapeHtml(raw.slice(last));
}

// ---- CLI -------------------------------------------------------------------

let srcPath = "";
let tplPath = "";
let outPath = "";
const argv = [...Deno.args];
while (argv.length) {
  const a = argv.shift()!;
  if (a === "-t") tplPath = argv.shift() ?? fail("-t needs a path");
  else if (a === "-o") outPath = argv.shift() ?? fail("-o needs a path");
  else if (!srcPath) srcPath = a;
  else fail(`unexpected argument "${a}"`);
}
if (!srcPath) fail("usage: build.ts <source.md> [-t template.html] [-o out.html]");

// ---- parse -----------------------------------------------------------------

const md = await Deno.readTextFile(srcPath);
const lines = md.split("\n");

const meta: Record<string, string> = {};
let i = 0;
if (lines[0] === "---") {
  for (i = 1; i < lines.length && lines[i] !== "---"; i++) {
    const m = lines[i].match(/^(\w+):\s*(.+)$/);
    if (m) meta[m[1]] = m[2];
  }
  i++;
}
for (const key of ["title", "eyebrow", "footer"]) {
  if (!meta[key]) fail(`frontmatter is missing "${key}"`);
}

let h1 = "";
const lede: Piece[] = [];
let calloutTitle = "";
const calloutPieces: Piece[] = [];
const tasks: Task[] = [];
const legend: LegendEntry[] = [];
const sections: Section[] = [];

type Zone = "head" | "callout" | "legend" | "section";
let zone: Zone = "head";
let item: Item | null = null;

function target(): Piece[] {
  if (item) return item.pieces;
  if (zone === "head") return lede;
  if (zone === "callout") return calloutPieces;
  if (zone === "legend") return []; // discarded; legend allows entries only
  const sec = sections.at(-1)!;
  const block = sec.blocks.at(-1);
  return block ? block.pieces : sec.pieces;
}

for (; i < lines.length; i++) {
  const line = lines[i];
  const n = i + 1;
  if (!line.trim()) continue;

  let m: RegExpMatchArray | null;

  if (line.startsWith("```")) {
    const start = n;
    const buf: string[] = [];
    for (i++; i < lines.length && !lines[i].startsWith("```"); i++) buf.push(lines[i]);
    if (i >= lines.length) fail("unclosed code fence", start);
    target().push({ kind: "code", text: buf.join("\n") });
  } else if (line.startsWith("|")) {
    const rows: string[][] = [];
    const start = n;
    for (; i < lines.length && lines[i].startsWith("|"); i++) {
      rows.push(lines[i].replace(/^\||\|\s*$/g, "").split("|").map((c) => c.trim()));
    }
    i--;
    if (rows.length < 3 || !rows[1].every((c) => /^:?-+:?$/.test(c))) {
      fail("table needs a header row, a |---| separator row, and at least one body row", start);
    }
    target().push({
      kind: "table",
      head: rows[0].map((c) => renderInline(c)),
      rows: rows.slice(2).map((r) => r.map((c) => renderInline(c))),
    });
  } else if ((m = line.match(/^# (.+)$/))) {
    if (h1) fail("more than one `# page heading`", n);
    h1 = m[1];
  } else if ((m = line.match(/^## Callout: (.+)$/))) {
    if (calloutTitle) fail("more than one Callout section", n);
    zone = "callout";
    item = null;
    calloutTitle = m[1];
  } else if ((m = line.match(/^## Legend: .+$/))) {
    if (legend.length) fail("more than one Legend section", n);
    zone = "legend";
    item = null;
  } else if ((m = line.match(/^## (.+)$/))) {
    zone = "section";
    item = null;
    const parts = m[1].split(/\s+—\s+/);
    const [kicker, title] = parts.length > 1 ? [parts[0], parts.slice(1).join(" — ")] : ["", parts[0]];
    sections.push({ kicker, title, pieces: [], blocks: [] });
  } else if ((m = line.match(/^### (.+)$/))) {
    if (zone !== "section") fail(`block "### ${m[1]}" outside a section`, n);
    item = null;
    const [title, chip = ""] = m[1].split(/\s+—\s+/);
    sections.at(-1)!.blocks.push({ title, chip, pieces: [], items: [] });
  } else if ((m = line.match(/^#### (.+)$/))) {
    const block = sections.at(-1)?.blocks.at(-1);
    if (!block) fail(`item "#### ${m[1]}" outside a "###" block`, n);
    let rest = m[1];
    const sep = rest.indexOf(" — ");
    let label = "";
    if (sep !== -1) {
      label = rest.slice(0, sep);
      rest = rest.slice(sep + 3);
    }
    let title = rest;
    const flags: string[] = [];
    let badge = 0;
    let flat = false;
    let tag: RegExpMatchArray | null;
    while ((tag = title.match(/\s*\[([^\]]+)\]\s*$/))) {
      title = title.slice(0, tag.index).trimEnd();
      if (/^t\d$/.test(tag[1])) badge = Number(tag[1].slice(1));
      else if (tag[1] === "flat") flat = true;
      else flags.unshift(tag[1]);
    }
    item = { label, title, badge, flags, flat, pieces: [], line: n };
    block.items.push(item);
  } else if ((m = line.match(/^- \[[ x]\] (.+?)(?:\s*\{#([\w-]+)\})?$/)) && zone === "callout" && !item) {
    const id = m[2] ?? fail(`callout task is missing a stable {#id}: "${m[1]}"`, n);
    if (tasks.some((t) => t.id === id)) fail(`duplicate task id "${id}"`, n);
    tasks.push({ id, label: renderInline(m[1]) });
  } else if ((m = line.match(/^\d+\. (.+)$/)) && zone === "legend") {
    const entry = m[1].match(/^\*\*(.+?)\*\*\s+—\s+(.+)$/);
    if (!entry) fail(`legend entries must be numbered "**Name** — description": "${line}"`, n);
    legend.push({ name: entry[1], desc: renderInline(entry[2]) });
  } else if ((m = line.match(/^- (.+)$/))) {
    const t = target();
    const prev = t.at(-1);
    const list = prev?.kind === "list" ? prev : ({ kind: "list", items: [] } as Piece & { kind: "list" });
    if (list !== prev) t.push(list);
    const bold = m[1].match(/^\*\*(.+)\*\*$/);
    list.items.push(
      bold
        ? { group: true, html: escapeHtml(bold[1]) }
        : { group: false, html: renderInline(m[1]) },
    );
  } else if (zone === "legend") {
    fail(`only numbered legend entries are allowed in a Legend section: "${line}"`, n);
  } else {
    target().push({ kind: "p", html: renderInline(line.trim()) });
  }
}

if (!h1) fail("no `# page heading` found");
if (legend.length > 3) fail(`legend has ${legend.length} entries; the default template styles at most 3 badge kinds`);

const allItems = sections.flatMap((s) => s.blocks.flatMap((b) => b.items));
for (const it of allItems) {
  if (it.badge > legend.length) {
    fail(`item "${it.title}" uses [t${it.badge}] but the legend has ${legend.length || "no"} entries`, it.line);
  }
}

// ---- render ----------------------------------------------------------------

const CHEVRON =
  '<svg class="chev" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 6l6 6-6 6"></path></svg>';
const CHECKMARK =
  '<span class="box"><svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12l5 5L20 7"></path></svg></span>';

function renderPieces(pieces: Piece[], pClass: string, indent: string): string {
  return pieces
    .map((p) => {
      if (p.kind === "p") return `${indent}<p class="${pClass}">${p.html}</p>`;
      if (p.kind === "code") return `${indent}<pre class="code"><code>${escapeHtml(p.text)}</code></pre>`;
      if (p.kind === "table") {
        const head = p.head.map((c) => `<th>${c}</th>`).join("");
        const body = p.rows
          .map((r) => `${indent}    <tr>${r.map((c) => `<td>${c}</td>`).join("")}</tr>`)
          .join("\n");
        return `${indent}<div class="table-wrap"><table>\n${indent}  <thead><tr>${head}</tr></thead>\n${indent}  <tbody>\n${body}\n${indent}  </tbody>\n${indent}</table></div>`;
      }
      const lis = p.items
        .map((li) =>
          li.group
            ? `${indent}  <li class="group">${li.html}</li>`
            : `${indent}  <li>${li.html}</li>`
        )
        .join("\n");
      return `${indent}<ul class="item-list">\n${lis}\n${indent}</ul>`;
    })
    .join("\n");
}

function renderItem(it: Item): string {
  const label = it.label ? `<span class="label">${renderInline(it.label)}</span>` : "";
  if (it.flat) {
    return `        <div class="flat-row">${label}<span class="flat-label">${escapeHtml(it.title)}</span><span class="rule"></span></div>`;
  }
  const flags = it.flags.map((f) => `\n            <span class="flag">${escapeHtml(f)}</span>`).join("");
  const badge = it.badge
    ? `\n            <span class="badge t${it.badge}"><span class="n">${it.badge}</span>${escapeHtml(legend[it.badge - 1].name)}</span>`
    : "";
  const body = it.pieces.length ? `\n${renderPieces(it.pieces, "detail", "            ")}` : "";
  return `        <details class="item" data-badge="${it.badge}">
          <summary>
            ${label ? label + "\n            " : ""}<span class="item-title">${renderInline(it.title)}</span>${flags}${badge}
            ${CHEVRON}
          </summary>
          <div class="item-body">${body}
          </div>
        </details>`;
}

function renderBlock(b: Block): string {
  const chip = b.chip ? `<span class="head-chip">${escapeHtml(b.chip)}</span>` : "";
  const pieces = b.pieces.length ? `\n${renderPieces(b.pieces, "sub", "        ")}\n` : "";
  return `      <div class="block">
        <div class="block-head"><span class="t">${escapeHtml(b.title)}</span>${chip}<span class="rule"></span></div>
${pieces}
${b.items.map(renderItem).join("\n\n")}
      </div>`;
}

function renderSection(s: Section): string {
  const kicker = s.kicker ? `\n        <span class="kicker">${escapeHtml(s.kicker)}</span>` : "";
  const pieces = s.pieces.length ? `\n${renderPieces(s.pieces, "sub", "        ")}` : "";
  return `    <section class="sec">
      <div class="sec-head">${kicker}
        <h2>${escapeHtml(s.title)}</h2>${pieces}
        <div class="sec-rule"></div>
      </div>

${s.blocks.map(renderBlock).join("\n\n")}
    </section>`;
}

const calloutHtml = calloutTitle
  ? `
      <div class="callout">
        <span class="c-title">${escapeHtml(calloutTitle)}</span>
${renderPieces(calloutPieces, "c-note", "        ")}
${tasks.length
    ? `        <div class="tasks">
${tasks
      .map(
        (t) => `          <div class="task" data-task="${t.id}" role="checkbox" aria-checked="false" tabindex="0">
            ${CHECKMARK}
            <span class="t-label">${t.label}</span>
          </div>`,
      )
      .join("\n")}
        </div>`
    : ""}
      </div>`
  : "";

const legendHtml = legend.length
  ? `
      <div class="legend">
${legend
    .map(
      (t, k) => `        <div class="badge-card">
          <span class="badge t${k + 1}"><span class="n">${k + 1}</span>${escapeHtml(t.name)}</span>
          <p>${t.desc}</p>
        </div>`,
    )
    .join("\n")}
      </div>`
  : "";

const badgesUsed = allItems.some((it) => it.badge > 0);
const collapsibles = allItems.some((it) => !it.flat);
const filterHtml = legend.length && badgesUsed
  ? `        <span class="lbl">Focus on</span>
        <div class="chips" role="group" aria-label="Filter by badge">
          <button class="chip" data-badge="all" aria-pressed="true">All</button>
${legend
    .map((t, k) => `          <button class="chip" data-badge="${k + 1}" aria-pressed="false">${escapeHtml(t.name)}</button>`)
    .join("\n")}
        </div>
        <span class="spacer"></span>
`
  : "";
const expandHtml = collapsibles
  ? `        <div class="chips">
          <button class="mini-btn" id="expand-all">Expand all</button>
          <button class="mini-btn" id="collapse-all">Collapse all</button>
        </div>`
  : "";
const controlsHtml = filterHtml || expandHtml
  ? `
      <div class="controls">
${filterHtml}${expandHtml}
      </div>`
  : "";

const header = `    <header class="doc">
      <div class="eyebrow">${escapeHtml(meta.eyebrow)}</div>
      <h1>${escapeHtml(h1)}</h1>
${renderPieces(lede, "lede", "      ")}${calloutHtml}${legendHtml}${controlsHtml}
    </header>`;

const footer = `    <footer class="doc">
      <span>${escapeHtml(meta.footer)}</span>
      <span>${escapeHtml(meta.eyebrow)}</span>
    </footer>`;

const content = [header, ...sections.map(renderSection), footer].join("\n\n");

// ---- assemble --------------------------------------------------------------

const tplUrl = tplPath
  ? new URL(tplPath, `file://${Deno.cwd()}/`)
  : new URL("../assets/template.html", import.meta.url);
const template = await Deno.readTextFile(tplUrl);
for (const slot of ["__TITLE__", "__CONTENT__", "__TASKKEY__"]) {
  if (!template.includes(slot)) fail(`template ${tplUrl.pathname} is missing the ${slot} slot`);
}

const taskKey = "mid-tasks-" +
  meta.title.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "");
const html = template
  .replace("__TITLE__", escapeHtml(meta.title))
  .replace("__CONTENT__", content)
  .replace("__TASKKEY__", taskKey);

if (!outPath) {
  const dir = srcPath.replace(/[^/]+$/, "");
  const stem = srcPath.replace(/^.*\//, "").replace(/\.md$/, "");
  outPath = `${dir}dist/${stem}.html`;
}
await Deno.mkdir(outPath.replace(/\/[^/]+$/, "") || ".", { recursive: true });
await Deno.writeTextFile(outPath, html);

for (const s of sections) {
  const its = s.blocks.flatMap((b) => b.items);
  console.log(`${s.kicker ? s.kicker + " — " : ""}${s.title}: ${its.filter((x) => !x.flat).length} items, ${its.filter((x) => x.flat).length} flat rows`);
}
console.log(`wrote ${outPath} (${(html.length / 1024).toFixed(0)} KB)`);
