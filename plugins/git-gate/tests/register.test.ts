import { describe, expect, test } from 'claude-code/testing'

const bash = (command: string, extra: Record<string, unknown> = {}) => ({ tool: 'Bash', input: { command, ...extra } })

describe('tool.check on EnterWorktree', () => {
  test('keeps the session verdict when git-gate did not raise the call', async ($, on) => {
    on('tool.check', () => ({ decision: 'ask', reason: 'from settings' }))

    expect(await $.tool.check({ tool: 'EnterWorktree', input: { path: '/code/repo.feat' } })).toEqual({
      decision: 'ask',
      reason: 'from settings',
    })
  })
})

describe('tool.check on Bash', () => {
  test('decides a matched git command over the session verdict', async ($, on) => {
    on('tool.check', () => ({ decision: 'ask' }))

    expect((await $.tool.check(bash('git status'))).decision).toBe('allow')
    const forced = await $.tool.check(bash('git push --force origin feat'))
    expect(forced.decision).toBe('deny')
    expect(forced.reason).toMatch(/^git-gate: /)
  })

  test('keeps a settings deny on a command it would allow', async ($, on) => {
    on('tool.check', () => ({ decision: 'deny', reason: 'Bash(git status) is denied', rule: 'Bash(git status)' }))

    expect(await $.tool.check(bash('git status'))).toEqual({
      decision: 'deny',
      reason: 'Bash(git status) is denied',
      rule: 'Bash(git status)',
    })
  })

  test('leaves unmatched commands to the session verdict', async ($, on) => {
    on('tool.check', () => ({ decision: 'ask', reason: 'from settings' }))

    for (const command of ['ls -la', 'git log | head', 'cd ../x && git push', 'git -c core.pager=x log', 'git rebase main']) {
      expect(await $.tool.check(bash(command))).toEqual({ decision: 'ask', reason: 'from settings' })
    }
  })

  test('keeps the session verdict for an unsandboxed read but still denies an unsandboxed force push', async ($, on) => {
    on('tool.check', () => ({ decision: 'ask', reason: 'from settings' }))

    const unsandboxed = { dangerouslyDisableSandbox: true }
    expect((await $.tool.check(bash('git status', unsandboxed))).reason).toBe('from settings')
    expect((await $.tool.check(bash('git push -f', unsandboxed))).decision).toBe('deny')
  })

  test('allows the worktree creation the redirect runs', async ($, on) => {
    on('tool.check', () => ({ decision: 'ask' }))

    expect((await $.tool.check(bash('wt switch --create feat/x --no-cd'))).decision).toBe('allow')
    expect((await $.tool.check(bash('wtherdr run create --branch feat/x'))).decision).toBe('allow')
  })
})
