import { describe, expect, test } from 'claude-code/testing'

import { loadRepoFacts } from '../hooks/repo'
import type { Run } from '../hooks/repo'

const COMMON = '/code/repo/.git'

const fakeGit = (worktrees: Record<string, { top: string; common: string; branch?: string; upstream?: string; pushed?: boolean }>): Run =>
  async (argv, cwd) => {
    const repo = worktrees[cwd ?? '']
    const ok = (stdout: string) => ({ exitCode: 0, stdout })
    const missing = { exitCode: 1, stdout: '' }
    if (!repo) return { exitCode: 128, stdout: '' }

    const args = argv.slice(1).join(' ')
    if (args.startsWith('rev-parse --path-format=absolute')) return ok(`${repo.top}\n${repo.common}\n`)
    if (args === 'symbolic-ref --quiet --short HEAD') return repo.branch ? ok(`${repo.branch}\n`) : missing
    if (args === 'symbolic-ref --quiet --short refs/remotes/origin/HEAD') return ok('origin/trunk\n')
    if (args.includes('@{upstream}')) return repo.upstream ? ok(`origin/${repo.upstream}\n`) : missing
    if (args === 'branch -r --contains HEAD') return ok(repo.pushed ? '  origin/feat\n' : '')
    return missing
  }

const run = fakeGit({
  '/code/repo.feat': { top: '/code/repo.feat', common: COMMON, branch: 'feat', upstream: 'feat', pushed: true },
  '/code/repo.feat/../repo.other': { top: '/code/repo.other', common: COMMON },
  '/code/elsewhere': { top: '/code/elsewhere', common: '/code/elsewhere/.git', branch: 'main' },
})

describe('loadRepoFacts', () => {
  test('reads the session worktree as its own', async () => {
    expect(await loadRepoFacts(run, '/code/repo.feat')).toEqual({
      worktree: '/code/repo.feat',
      isSibling: false,
      branch: 'feat',
      defaultBranch: 'trunk',
      upstreamBranch: 'feat',
      isHeadPushed: true,
    })
  })

  test('marks another worktree of the same repository as a sibling', async () => {
    const facts = await loadRepoFacts(run, '/code/repo.feat', '../repo.other')
    expect(facts?.isSibling).toBe(true)
    expect(facts?.worktree).toBe('/code/repo.other')
    expect(facts?.branch).toBeUndefined()
  })

  test('answers nothing for a different repository or a non-repository', async () => {
    expect(await loadRepoFacts(run, '/code/repo.feat', '/code/elsewhere')).toBeUndefined()
    expect(await loadRepoFacts(run, '/code/repo.feat', '/tmp/nowhere')).toBeUndefined()
  })
})
