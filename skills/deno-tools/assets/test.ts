#!/usr/bin/env -S deno run --allow-read --allow-run=deno

/**
 * Custom test runner for Deno projects.
 *
 * Discovers `test:*` tasks from deno.json and runs each as a suite, with three
 * output modes:
 *   - Compact (default, TTY): spinner + progress bar, one line per suite
 *   - Verbose (-v): full deno test output with section headers
 *   - Plain (non-TTY / CI): no animation, one line per suite
 *
 * Usage:
 *   deno task test              all suites, compact
 *   deno task test -v           all suites, verbose
 *   deno task test sync         filter by label substring
 *   deno task test sync -v      filter + verbose
 *
 * Wire-up in deno.json:
 *   "test":      "deno run --allow-read --allow-run=deno scripts/test.ts",
 *   "test:unit": "deno test --allow-read unit_test.ts",
 *   "test:io":   "deno test --allow-read --allow-write io_test.ts",
 *   ...
 *
 * The runner picks up any task starting with `test:` (excluding `test:run` /
 * `test`). Add or remove suites by editing deno.json — no runner changes
 * needed.
 */

import { bold, cyan, dim, green, red } from '@std/fmt/colors';

// ── Constants ──────────────────────────────────────────────────────

const RUNNER_NAME = readRunnerName();

const SPINNER = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
const CHECK = '✓';
const CROSS = '✗';
const FILLED = '▰';
const EMPTY = '▱';
const BAR_WIDTH = 22;
const SPIN_MS = 80;

const HIDE_CURSOR = '\x1b[?25l';
const SHOW_CURSOR = '\x1b[?25h';
const CLEAR_LINE = '\x1b[2K';
const up = (n: number) => `\x1b[${n}A`;

// ── Types ──────────────────────────────────────────────────────────

interface Suite {
  task: string;
  label: string;
}

interface Result {
  suite: Suite;
  passed: number;
  failed: number;
  duration: number;
  failedTests: string[];
  output: string;
  success: boolean;
}

// ── Helpers ────────────────────────────────────────────────────────

const enc = new TextEncoder();
const write = (s: string) => Deno.stdout.writeSync(enc.encode(s));
const isTTY = Deno.stdout.isTerminal();

const ANSI_RE = /\x1b\[[0-9;]*m/g;
const strip = (s: string) => s.replace(ANSI_RE, '');

function fmtDuration(ms: number): string {
  if (ms < 1000) return `${Math.round(ms)}ms`;
  return `${(ms / 1000).toFixed(1)}s`;
}

function bar(done: number, total: number): string {
  const filled = Math.round((done / total) * BAR_WIDTH);
  const empty = BAR_WIDTH - filled;
  return `  ${green(FILLED.repeat(filled))}${dim(EMPTY.repeat(empty))}  ${dim(`${done}/${total}`)}`;
}

function readRunnerName(): string {
  try {
    const config = JSON.parse(Deno.readTextFileSync('deno.json'));
    return typeof config.name === 'string' ? config.name.replace(/^@[^/]+\//, '') : 'deno';
  } catch {
    return 'deno';
  }
}

// ── Suite Discovery ────────────────────────────────────────────────

function discoverSuites(): Suite[] {
  const config = JSON.parse(Deno.readTextFileSync('deno.json'));
  const tasks: Record<string, string> = config.tasks ?? {};
  const suites: Suite[] = [];

  for (const name of Object.keys(tasks)) {
    if (name.startsWith('test:') && name !== 'test:run') {
      suites.push({ task: name, label: name.slice(5) });
    }
  }
  return suites;
}

// ── Output Parsing ─────────────────────────────────────────────────

function parseOutput(raw: string): { passed: number; failed: number; failedTests: string[] } {
  const lines = strip(raw).split('\n');
  let passed = 0;
  let failed = 0;
  const failedTests: string[] = [];

  for (const line of lines) {
    const t = line.trim();

    const fail = t.match(/^(.+?)\s+\.\.\.\s+FAILED\b/);
    if (fail) failedTests.push(fail[1]);

    const sum = t.match(/(?:ok|FAILED)\s*\|\s*(\d+)\s*passed\s*\|\s*(\d+)\s*failed/);
    if (sum) {
      passed += parseInt(sum[1]);
      failed += parseInt(sum[2]);
    }
  }

  return { passed, failed, failedTests };
}

// ── Suite Execution ────────────────────────────────────────────────

async function runSuite(
  suite: Suite,
): Promise<{ stdout: string; stderr: string; duration: number; success: boolean }> {
  const start = performance.now();
  const cmd = new Deno.Command('deno', {
    args: ['task', suite.task],
    stdout: 'piped',
    stderr: 'piped',
  });
  const out = await cmd.output();
  return {
    stdout: new TextDecoder().decode(out.stdout),
    stderr: new TextDecoder().decode(out.stderr),
    duration: performance.now() - start,
    success: out.success,
  };
}

// ── Report ─────────────────────────────────────────────────────────

function printReport(results: Result[]) {
  const totalPassed = results.reduce((s, r) => s + r.passed, 0);
  const totalFailed = results.reduce((s, r) => s + r.failed, 0);
  const totalTests = totalPassed + totalFailed;
  const totalTime = results.reduce((s, r) => s + r.duration, 0);
  const failures = results.filter((r) => r.failed > 0);

  write('\n');

  if (totalFailed === 0) {
    write(
      `  ${green(bold(CHECK))} ${green(bold(`${totalPassed} tests passed`))} across ${results.length} suites  ${dim(fmtDuration(totalTime))}\n`,
    );
  } else {
    write(
      `  ${red(bold(CROSS))} ${bold(`${totalPassed}/${totalTests} passed`)}, ${red(bold(`${totalFailed} failed`))} across ${results.length} suites  ${dim(fmtDuration(totalTime))}\n`,
    );
  }

  if (failures.length > 0) {
    write(`\n  ${red(bold('Failures:'))}\n\n`);
    for (const r of failures) {
      write(`  ${red(CROSS)} ${bold(r.suite.label)}\n`);
      for (let i = 0; i < r.failedTests.length; i++) {
        const last = i === r.failedTests.length - 1;
        write(`    ${dim(last ? '└' : '├')} ${r.failedTests[i]}\n`);
      }
    }
  }

  write('\n');
}

// ── Main ───────────────────────────────────────────────────────────

async function main() {
  const verbose = Deno.args.includes('-v') || Deno.args.includes('--verbose');
  const filters = Deno.args.filter((a) => !a.startsWith('-'));

  let suites = discoverSuites();
  if (filters.length > 0) {
    suites = suites.filter((s) => filters.some((f) => s.label.includes(f)));
    if (suites.length === 0) {
      write(`\n  ${red(CROSS)} No suites matched: ${filters.join(', ')}\n\n`);
      Deno.exit(1);
    }
  }

  const results: Result[] = [];

  // Header
  write(
    `\n  ${bold(cyan(RUNNER_NAME))} test runner ${dim('·')} ${bold(String(suites.length))} suites\n\n`,
  );

  if (isTTY && !verbose) write(HIDE_CURSOR);

  const restore = () => {
    if (isTTY) write(SHOW_CURSOR);
  };

  try {
    Deno.addSignalListener('SIGINT', () => {
      restore();
      Deno.exit(130);
    });
  } catch {
    // signal listeners unsupported on some platforms
  }

  try {
    if (verbose) {
      await runVerbose(suites, results);
    } else if (isTTY) {
      await runCompact(suites, results);
    } else {
      await runPlain(suites, results);
    }

    printReport(results);

    if (results.some((r) => r.failed > 0)) Deno.exit(1);
  } finally {
    restore();
  }
}

// ── Verbose Mode ───────────────────────────────────────────────────

async function runVerbose(suites: Suite[], results: Result[]) {
  for (const suite of suites) {
    const rule = dim('━'.repeat(Math.max(1, 50 - suite.label.length)));
    write(`  ${cyan('━━')} ${bold(suite.label)} ${rule}\n\n`);

    const { stdout, stderr, duration, success } = await runSuite(suite);
    const combined = stdout + '\n' + stderr;

    // Print stdout, skipping the "Task test:xxx" preamble line
    for (const line of stdout.split('\n')) {
      const plain = strip(line).trim();
      if (plain.startsWith('Task test:')) continue;
      if (line.trim()) write(`  ${line}\n`);
    }

    const parsed = parseOutput(combined);

    // Handle process errors with no parsed test results
    if (!success && parsed.passed === 0 && parsed.failed === 0) {
      parsed.failed = 1;
      parsed.failedTests.push('(process error)');
      for (const line of stderr.split('\n')) {
        const plain = strip(line).trim();
        if (plain.startsWith('Task test:') || !plain) continue;
        write(`  ${red(line)}\n`);
      }
    }

    const icon = parsed.failed === 0 ? green(CHECK) : red(CROSS);
    write(`\n  ${icon} ${bold(suite.label)}  ${dim(fmtDuration(duration))}\n\n`);

    results.push({ suite, ...parsed, duration, output: combined, success });
  }
}

// ── Compact Mode (TTY) ─────────────────────────────────────────────

async function runCompact(suites: Suite[], results: Result[]) {
  for (let i = 0; i < suites.length; i++) {
    const suite = suites[i];

    // Draw spinner line + progress bar (2 lines)
    if (i > 0) write(up(1));
    write(`${CLEAR_LINE}  ${dim(SPINNER[0])} ${suite.label}\n`);
    write(`${CLEAR_LINE}${bar(i, suites.length)}\n`);

    // Animate spinner while suite runs
    let frame = 0;
    const tick = setInterval(() => {
      frame = (frame + 1) % SPINNER.length;
      write(`${up(2)}${CLEAR_LINE}  ${dim(SPINNER[frame])} ${suite.label}\n\x1b[1B`);
    }, SPIN_MS);

    const { stdout, stderr, duration, success } = await runSuite(suite);
    clearInterval(tick);

    const combined = stdout + '\n' + stderr;
    const parsed = parseOutput(combined);

    if (!success && parsed.passed === 0 && parsed.failed === 0) {
      parsed.failed = 1;
      parsed.failedTests.push('(process error — run with -v for details)');
    }

    const ok = parsed.failed === 0;
    const icon = ok ? green(CHECK) : red(CROSS);
    const stats = ok
      ? dim(`${parsed.passed} passed`)
      : `${red(`${parsed.failed} failed`)}${dim(`, ${parsed.passed} passed`)}`;

    // Replace spinner with result, update progress bar
    write(up(2));
    write(`${CLEAR_LINE}  ${icon} ${suite.label}  ${stats}  ${dim(fmtDuration(duration))}\n`);
    write(`${CLEAR_LINE}${bar(i + 1, suites.length)}\n`);

    results.push({ suite, ...parsed, duration, output: combined, success });
  }

  // Clear progress bar
  write(`${up(1)}${CLEAR_LINE}`);
}

// ── Plain Mode (non-TTY / CI) ──────────────────────────────────────

async function runPlain(suites: Suite[], results: Result[]) {
  for (let i = 0; i < suites.length; i++) {
    const suite = suites[i];

    const { stdout, stderr, duration, success } = await runSuite(suite);
    const combined = stdout + '\n' + stderr;
    const parsed = parseOutput(combined);

    if (!success && parsed.passed === 0 && parsed.failed === 0) {
      parsed.failed = 1;
      parsed.failedTests.push('(process error)');
    }

    const ok = parsed.failed === 0;
    const icon = ok ? CHECK : CROSS;
    const failStr = parsed.failed > 0 ? `, ${parsed.failed} failed` : '';
    write(`  ${icon} ${suite.label}  ${parsed.passed} passed${failStr}  ${fmtDuration(duration)}\n`);

    results.push({ suite, ...parsed, duration, output: combined, success });
  }
}

main();
