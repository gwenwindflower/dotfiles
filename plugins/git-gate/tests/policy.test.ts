import { describe, expect, test } from 'claude-code/testing'

import { parseGit, tokenize } from '../hooks/command'
import { decideGit, decideWt } from '../hooks/policy'
import type { RepoFacts } from '../hooks/policy'

const OWN: RepoFacts = {
  worktree: '/code/repo.feat',
  isSibling: false,
  branch: 'feat',
  defaultBranch: 'main',
  upstreamBranch: 'feat',
  isHeadPushed: false,
}
const SIBLING: RepoFacts = { ...OWN, worktree: '/code/repo.other', isSibling: true, branch: 'other', upstreamBranch: 'other' }

const decide = (command: string, facts: RepoFacts | undefined = OWN) => {
  const inv = parseGit(tokenize(command) ?? [])
  if (!inv) throw new Error(`not a git invocation: ${command}`)
  return decideGit(inv, async () => facts)
}

const decisionOf = async (command: string, facts?: RepoFacts) => (await decide(command, facts))?.decision

describe('reads', () => {
  test('allows reads in any worktree', async () => {
    for (const command of ['git status', 'git diff --stat', 'git log --oneline -5', 'git fetch origin', 'git worktree list', 'git branch -vv']) {
      expect(await decisionOf(command, SIBLING)).toBe('allow')
    }
  })

  test('allows reads without consulting the repository', async () => {
    const inv = parseGit(['git', '-C', '/elsewhere', 'log'])!
    const verdict = await decideGit(inv, async () => {
      throw new Error('facts were loaded')
    })
    expect(verdict?.decision).toBe('allow')
  })

  test('passes on a read that writes a file', async () => {
    expect(await decide('git diff --output=patch.diff')).toBeUndefined()
  })
})

describe('staging and committing', () => {
  test('allows them in the own worktree', async () => {
    for (const command of ['git add -A', 'git commit -m "feat: x"', 'git restore --staged a.ts', 'git stash push -m wip']) {
      expect(await decisionOf(command)).toBe('allow')
    }
  })

  test('asks in a sibling worktree, naming it', async () => {
    const verdict = await decide('git -C ../repo.other commit -m x', SIBLING)
    expect(verdict?.decision).toBe('ask')
    expect(verdict?.reason).toContain('/code/repo.other')
    expect(verdict?.reason).toContain('other')
  })

  test('denies signed commits', async () => {
    for (const command of ['git commit -S -m x', 'git commit --gpg-sign=KEY -m x', 'git commit -Sm x']) {
      expect(await decisionOf(command)).toBe('deny')
    }
  })

  test('does not mistake a message for a signing flag', async () => {
    expect(await decisionOf('git commit -m -Sneaky')).toBe('allow')
  })

  test('asks when commit hooks are skipped', async () => {
    expect(await decisionOf('git commit --no-verify -m x')).toBe('ask')
  })

  test('allows amending an unpushed commit and asks for a pushed one', async () => {
    expect(await decisionOf('git commit --amend --no-edit')).toBe('allow')
    expect(await decisionOf('git commit --amend --no-edit', { ...OWN, isHeadPushed: true })).toBe('ask')
  })
})

describe('push', () => {
  test("allows pushing the worktree's own branch", async () => {
    for (const command of ['git push', 'git push origin feat', 'git push -u origin HEAD', 'git push origin feat:feat']) {
      const verdict = await decide(command)
      expect(verdict?.decision).toBe('allow')
      expect(verdict?.isHostOk).toBe(true)
    }
  })

  test('asks before pushing the default branch', async () => {
    const onMain = { ...OWN, branch: 'main', upstreamBranch: 'main' }
    expect(await decisionOf('git push', onMain)).toBe('ask')
    expect(await decisionOf('git push origin HEAD:main')).toBe('ask')
    expect(await decisionOf('git push origin master', { ...OWN, defaultBranch: 'trunk' })).toBe('ask')
  })

  test('asks before pushing a branch another worktree holds', async () => {
    expect(await decisionOf('git push origin other')).toBe('ask')
  })

  test('asks before pushing from a sibling worktree', async () => {
    expect(await decisionOf('git -C ../repo.other push', SIBLING)).toBe('ask')
  })

  test('asks for a lease-guarded force push and names the remote branch', async () => {
    const verdict = await decide('git push --force-with-lease origin feat')
    expect(verdict?.decision).toBe('ask')
    expect(verdict?.reason).toContain('feat')
  })

  test('denies forced pushes, deletions and mirrors', async () => {
    for (const command of ['git push --force', 'git push -f origin feat', 'git push origin +feat', 'git push origin :feat', 'git push --delete origin feat', 'git push --mirror']) {
      expect(await decisionOf(command)).toBe('deny')
    }
  })

  test('asks when push hooks are skipped', async () => {
    expect(await decisionOf('git push --no-verify')).toBe('ask')
  })

  test('passes on a detached HEAD with no refspec', async () => {
    expect(await decide('git push', { ...OWN, branch: undefined, upstreamBranch: undefined })).toBeUndefined()
  })
})

describe('destructive operations', () => {
  test('denies force-deleting a branch', async () => {
    for (const command of ['git branch -D x', 'git branch -d -f x', 'git branch --delete --force x', 'git branch -df x']) {
      expect(await decisionOf(command)).toBe('deny')
    }
  })

  test('asks before discarding working tree changes', async () => {
    for (const command of ['git reset --hard', 'git clean -fd', 'git restore a.ts', 'git checkout -- a.ts', 'git checkout .']) {
      expect(await decisionOf(command)).toBe('ask')
    }
  })

  test('allows a dry-run clean', async () => {
    expect(await decisionOf('git clean -n')).toBe('allow')
  })
})

describe('outside the policy', () => {
  test('passes on subcommands it does not cover', async () => {
    for (const command of ['git rebase main', 'git merge --ff-only main', 'git cherry-pick abc', 'git checkout main', 'git branch -d x']) {
      expect(await decide(command)).toBeUndefined()
    }
  })

  test('passes when the target is not a worktree of the session repo', async () => {
    const inv = parseGit(['git', '-C', '/other', 'commit', '-m', 'x'])!
    expect(await decideGit(inv, async () => undefined)).toBeUndefined()
  })
})

describe('worktrunk', () => {
  test('allows listing and switching to an existing worktree', () => {
    expect(decideWt(['wt', 'list'])?.decision).toBe('allow')
    expect(decideWt(['wt', 'switch', 'feat'])?.decision).toBe('allow')
  })

  test('allows the worktree creation shapes the redirect runs, on the host', () => {
    for (const argv of [
      ['wt', 'switch', '--create', 'feat/x', '--no-cd'],
      ['wt', 'switch', '--create', 'feat/x', '--base', 'main', '--no-cd'],
      ['wtherdr', 'run', 'create', '--branch', 'feat/x'],
      ['wtherdr', 'run', 'create', '--branch', 'feat/x', '--base', '^'],
    ]) {
      const verdict = decideWt(argv)
      expect(verdict?.decision).toBe('allow')
      expect(verdict?.isHostOk).toBe(true)
    }
  })

  test('passes on everything else', () => {
    for (const argv of [
      ['wt', 'switch', '--create', 'x', '-x', 'claude'],
      ['wt', 'merge'],
      ['wt', 'remove'],
      ['wtherdr', 'run', 'remove'],
    ]) {
      expect(decideWt(argv)).toBeUndefined()
    }
  })
})
