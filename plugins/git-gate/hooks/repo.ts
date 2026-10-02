import type { RepoFacts } from './policy'

export type Run = (argv: string[], cwd?: string) => Promise<{ exitCode: number; stdout: string }>

const afterRemote = (ref: string | undefined) => (ref?.includes('/') ? ref.slice(ref.indexOf('/') + 1) : undefined)

/**
 * Reads what the policy needs about the worktree a git command targets, `dir`
 * resolved against the session's working directory. Answers undefined when
 * either side is outside a repository or the two belong to different ones.
 */
export const loadRepoFacts = async (run: Run, sessionCwd: string, dir?: string): Promise<RepoFacts | undefined> => {
  const git = async (cwd: string, ...args: string[]) => {
    const ran = await run(['git', ...args], cwd)
    return ran.exitCode === 0 ? ran.stdout.trim() : undefined
  }
  const target = dir === undefined ? sessionCwd : dir.startsWith('/') ? dir : `${sessionCwd}/${dir}`
  const ids = ['rev-parse', '--path-format=absolute', '--show-toplevel', '--git-common-dir']

  const [targetIds, sessionIds] = await Promise.all([git(target, ...ids), git(sessionCwd, ...ids)])
  const [worktree, commonDir] = targetIds?.split('\n') ?? []
  const [sessionWorktree, sessionCommonDir] = sessionIds?.split('\n') ?? []
  if (!worktree || !commonDir || commonDir !== sessionCommonDir) return undefined

  const [branch, originHead, upstream, remoteContaining] = await Promise.all([
    git(target, 'symbolic-ref', '--quiet', '--short', 'HEAD'),
    git(target, 'symbolic-ref', '--quiet', '--short', 'refs/remotes/origin/HEAD'),
    git(target, 'rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{upstream}'),
    git(target, 'branch', '-r', '--contains', 'HEAD'),
  ])

  const facts: RepoFacts = {
    worktree,
    isSibling: worktree !== sessionWorktree,
    defaultBranch: afterRemote(originHead) ?? 'main',
    isHeadPushed: (remoteContaining ?? '') !== '',
  }
  if (branch) facts.branch = branch
  const upstreamBranch = afterRemote(upstream)
  if (upstreamBranch) facts.upstreamBranch = upstreamBranch

  return facts
}
