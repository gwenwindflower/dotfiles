import type { EngineInterface, Register } from 'claude-code'

import { parseBranchCreation, parseGit, tokenize } from './command'
import type { BranchCreation } from './command'
import { decideGit, decideWt } from './policy'
import type { Verdict } from './policy'
import { loadRepoFacts } from './repo'
import type { Run } from './repo'

const WORKTREE_TIMEOUT_MS = 600_000

const runner = ($: EngineInterface): Run => (argv, cwd) =>
  $.process.run(argv, cwd === undefined ? { timeoutMs: 10_000 } : { cwd, timeoutMs: 10_000 })

const review = async ($: EngineInterface, command: string): Promise<Verdict | undefined> => {
  const argv = tokenize(command)
  if (!argv) return undefined

  const inv = parseGit(argv)
  if (!inv) return decideWt(argv)

  const loadFacts = async () => loadRepoFacts(runner($), await $.session.cwd(), inv.dir)
  return decideGit(inv, () => loadFacts().catch(() => undefined))
}

const worktreeArgv = (creation: BranchCreation, isHerdr: boolean) => {
  const base = creation.base === undefined ? [] : ['--base', creation.base]
  return isHerdr
    ? ['wtherdr', 'run', 'create', '--branch', creation.branch, ...base]
    : ['wt', 'switch', '--create', creation.branch, ...base, '--no-cd']
}

const findWorktree = async (run: Run, branch: string, cwd?: string) => {
  const listed = await run(['git', 'worktree', 'list', '--porcelain'], cwd)
  const block = listed.stdout.split('\n\n').find(entry => entry.includes(`\nbranch refs/heads/${branch}`))
  return block?.match(/^worktree (.+)$/m)?.[1]
}

const enterWorktree = async ($: EngineInterface, path: string, creation: BranchCreation) => {
  const retry = `call EnterWorktree with path ${path} to work there`
  if (creation.dir !== undefined) {
    return `The worktree for ${creation.branch} is at ${path}; it belongs to the repository at ${creation.dir}, so this session stayed put. To move anyway, ${retry}.`
  }

  const entered = await $.tool.call({ tool: 'EnterWorktree', path })
  if (entered.deny !== undefined) return `The worktree for ${creation.branch} is at ${path}, but entering it was refused (${entered.deny}); ${retry}.`
  if (entered.isError) return `The worktree for ${creation.branch} is at ${path}, but entering it failed (${entered.text ?? 'no reason given'}); ${retry}.`

  return `This session entered the worktree for ${creation.branch} at ${path}.`
}

export const register: Register = on => {
  on('tool.check', { tool: 'EnterWorktree' }, async ($, e, next) => {
    const base = await next(e)
    if (base.decision === 'deny' || next.origin.plugin !== $.plugin.name) return base

    return { decision: 'allow', reason: 'git-gate: enters the worktree it created for the requested branch' }
  })

  on('tool.check', { tool: 'Bash' }, async ($, e, next) => {
    const base = await next(e)
    if (base.decision === 'deny') return base

    const input = e.input as { command?: unknown; dangerouslyDisableSandbox?: unknown }
    if (typeof input.command !== 'string') return base

    const verdict = await review($, input.command)
    if (!verdict) return base
    if (input.dangerouslyDisableSandbox === true && verdict.decision === 'allow' && !verdict.isHostOk) return base

    return { decision: verdict.decision, reason: `git-gate: ${verdict.reason}` }
  })

  on('tool.call', { tool: 'Bash' }, async ($, e, next) => {
    if (e.run_in_background) return next(e)
    const argv = tokenize(e.command)
    const creation = argv && parseBranchCreation(argv)
    if (!creation) return next(e)

    const run = runner($)
    const refFormat = await run(['git', 'check-ref-format', '--branch', creation.branch], creation.dir)
    if (refFormat.exitCode !== 0) return next(e)

    const wtArgv = worktreeArgv(creation, (await $.env.get('HERDR_ENV')) === '1')
    const wtCommand = wtArgv.join(' ')
    const check = await $.tool.check({ tool: 'Bash', input: { command: wtCommand } })
    if (check.decision === 'deny') return { deny: check.reason ?? `${wtCommand} is denied` }
    if (check.decision === 'ask') return creation.dir === undefined ? next({ ...e, command: wtCommand }) : next(e)

    const at = creation.dir === undefined ? {} : { cwd: creation.dir }
    const ran = await $.process.run(wtArgv, { ...at, timeoutMs: WORKTREE_TIMEOUT_MS })
    const isCreated = ran.exitCode === 0
    const path = isCreated ? await findWorktree(run, creation.branch, creation.dir) : undefined
    const stderr = isCreated ? ran.stderr : `${ran.stderr}\nExit code ${ran.exitCode}`.trim()
    const where = path ? await enterWorktree($, path, creation) : ''

    return {
      result: { stdout: ran.stdout, stderr, interrupted: false },
      context: [`git-gate: branch creation runs through Worktrunk, so \`${wtCommand}\` ran in place of \`${e.command}\`. ${where}`.trim()],
    }
  })
}
