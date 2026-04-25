#!/usr/bin/env -S deno run --allow-read --allow-write
/**
 * fix-md-tables — Fix markdown table formatting to proper compact style.
 *
 * Ensures all table rows use spaced compact style:
 *   |foo|bar|     → | foo | bar |
 *   |---|---|      → | --- | --- |
 *   |:---:|---:|   → | :---: | ---: |
 *
 * Usage:
 *   deno run --allow-read --allow-write tools/fix-md-tables.ts [options] <glob...>
 *
 * Options:
 *   --check     Report issues without writing fixes (exit 1 if any found)
 *   --dry-run   Print full fixed output to stdout (no file writes)
 *   --help      Show this help
 */

import { expandGlob } from "jsr:@std/fs@1/expand-glob";
import { relative } from "jsr:@std/path@1";

// ── Types ──────────────────────────────────────────────────────────────

interface TableIssue {
  file: string;
  line: number;
  original: string;
  fixed: string;
}

// ── Table detection and fixing ─────────────────────────────────────────

/** True if the line looks like part of a markdown table (starts with |). */
function isTableLine(line: string): boolean {
  return /^\s*\|/.test(line);
}

/**
 * Fix a single table line to proper compact style:
 * - Space after every opening | and before every closing |
 * - Trim cell content internally but preserve single space padding
 */
function fixTableLine(line: string): string {
  const trimmed = line.trim();
  if (!trimmed.startsWith("|") || !trimmed.endsWith("|")) return line;

  // Split into cells (drop the empty strings from leading/trailing |)
  const inner = trimmed.slice(1, -1);
  const cells = inner.split("|");

  const formatted = cells.map((cell) => ` ${cell.trim()} `).join("|");
  return `|${formatted}|`;
}

// ── File processing ────────────────────────────────────────────────────

function processContent(content: string, filePath: string): { output: string; issues: TableIssue[] } {
  const lines = content.split("\n");
  const issues: TableIssue[] = [];
  let inCodeBlock = false;

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    // Track fenced code blocks — don't touch tables inside them
    if (/^\s*(`{3,}|~{3,})/.test(line)) {
      inCodeBlock = !inCodeBlock;
      continue;
    }
    if (inCodeBlock) continue;

    if (!isTableLine(line)) continue;

    const fixed = fixTableLine(line);
    if (fixed !== line) {
      issues.push({
        file: filePath,
        line: i + 1,
        original: line,
        fixed,
      });
      lines[i] = fixed;
    }
  }

  return { output: lines.join("\n"), issues };
}

// ── CLI ────────────────────────────────────────────────────────────────

function printHelp() {
  console.log(`fix-md-tables — Fix markdown table formatting to proper compact style.

Usage:
  deno run --allow-read --allow-write tools/fix-md-tables.ts [options] <glob...>

Arguments:
  <glob...>   One or more file paths or glob patterns (e.g. "**/*.md")

Options:
  --check     Report issues without writing fixes (exit 1 if any found)
  --dry-run   Print full fixed output to stdout (no file writes)
  --help      Show this help

Examples:
  fix-md-tables "AGENTS.md"
  fix-md-tables "dot_agents/**/*.md"
  fix-md-tables --check "**/*.md"`);
}

async function main() {
  const args = Deno.args;
  const checkOnly = args.includes("--check");
  const dryRun = args.includes("--dry-run");
  const help = args.includes("--help") || args.includes("-h");
  const globs = args.filter((a: string) => !a.startsWith("--"));

  if (help || globs.length === 0) {
    printHelp();
    Deno.exit(help ? 0 : 1);
  }

  let totalIssues = 0;
  let filesFixed = 0;
  let filesScanned = 0;

  for (const pattern of globs) {
    let matched = false;
    for await (const entry of expandGlob(pattern, { globstar: true })) {
      if (!entry.isFile) continue;
      if (!entry.name.endsWith(".md")) continue;
      matched = true;
      filesScanned++;

      const filePath = entry.path;
      const displayPath = relative(Deno.cwd(), filePath);

      let content: string;
      try {
        content = await Deno.readTextFile(filePath);
      } catch (err) {
        console.error(`error: could not read ${displayPath}: ${err instanceof Error ? err.message : err}`);
        continue;
      }

      const { output, issues } = processContent(content, displayPath);

      if (issues.length === 0) continue;

      totalIssues += issues.length;
      filesFixed++;

      if (dryRun) {
        // In dry-run, print a header then the full fixed content to stdout
        console.log(`── ${displayPath} (${issues.length} fix${issues.length === 1 ? "" : "es"}) ──`);
        console.log(output);
        console.log();
      } else {
        for (const issue of issues) {
          const prefix = checkOnly ? "would fix" : "fixed";
          console.log(`  ${displayPath}:${issue.line}  ${prefix}`);
          console.log(`    - ${issue.original}`);
          console.log(`    + ${issue.fixed}`);
        }

        if (!checkOnly) {
          try {
            await Deno.writeTextFile(filePath, output);
          } catch (err) {
            console.error(`error: could not write ${displayPath}: ${err instanceof Error ? err.message : err}`);
          }
        }
      }
    }

    if (!matched) {
      console.error(`warning: no .md files matched pattern "${pattern}"`);
    }
  }

  // Summary
  console.log();
  if (totalIssues === 0) {
    console.log(`Scanned ${filesScanned} file(s) — all tables are properly formatted.`);
  } else {
    const verb = checkOnly ? "found" : "fixed";
    console.log(`${verb} ${totalIssues} table line(s) across ${filesFixed} file(s) (${filesScanned} scanned).`);
  }

  if (checkOnly && totalIssues > 0) {
    Deno.exit(1);
  }
}

main();
