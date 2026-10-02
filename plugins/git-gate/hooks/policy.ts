import { parseBranchCreation } from './command'
import type { GitInvocation } from './command'

export type Verdict = {
  decision: 'allow' | 'ask' | 'deny'
  reason: string
  /** The command needs the host by design, so an unsandboxed retry keeps this verdict. */
  isHostOk?: boolean
}

export type RepoFacts = {
  /** The target worktree's root. */
  worktree: string
  /** The target is another worktree of the session's repository. */
  isSibling: boolean
  /** The target worktree's checked-out branch; absent on a detached HEAD. */
  branch?: string
  defaultBranch: string
  /** The remote branch the checked-out branch tracks, without the remote. */
  upstreamBranch?: string
  isHeadPushed: boolean
}

/** Answers undefined when the target is not a worktree of the session's repository. */
export type LoadFacts = () => Promise<RepoFacts | undefined>

const allow = (reason: string, isHostOk?: true): Verdict =>
  isHostOk ? { decision: 'allow', reason, isHostOk } : { decision: 'allow', reason }
const ask = (reason: string): Verdict => ({ decision: 'ask', reason })
const deny = (reason: string): Verdict => ({ decision: 'deny', reason })

const YOURS_TO_RUN = 'is left for you to run yourself'

const shortLetters = (words: readonly string[]) =>
  words.filter(word => /^-[A-Za-z]+$/.test(word)).flatMap(word => [...word.slice(1)])

const positionals = (words: readonly string[]) => words.filter(word => !word.startsWith('-'))

const describeBranch = (facts: RepoFacts) => facts.branch ?? 'a detached HEAD'

const siblingWrite = (facts: RepoFacts) =>
  ask(`writes to sibling worktree ${facts.worktree} on ${describeBranch(facts)}; one agent stages and commits in a worktree at a time`)

const discard = (facts: RepoFacts) =>
  ask(`discards uncommitted work in ${facts.worktree} (${describeBranch(facts)})`)

const READ_SUBCOMMANDS = new Set([
  'blame', 'cat-file', 'check-ignore', 'check-ref-format', 'describe', 'diff', 'fetch',
  'for-each-ref', 'grep', 'log', 'ls-files', 'ls-remote', 'ls-tree', 'merge-base', 'name-rev',
  'range-diff', 'rev-list', 'rev-parse', 'shortlog', 'show', 'show-ref', 'status',
])

const BRANCH_MUTATION_LETTERS = new Set(['d', 'D', 'm', 'M', 'c', 'C', 'f', 'u'])
const BRANCH_MUTATION_FLAGS = /^--(delete|move|copy|force|set-upstream-to|unset-upstream|edit-description|track|no-track|create-reflog)/

const isBranchListing = (args: readonly string[]) => {
  if (shortLetters(args).some(letter => BRANCH_MUTATION_LETTERS.has(letter))) return false
  if (args.some(arg => BRANCH_MUTATION_FLAGS.test(arg))) return false
  return positionals(args).length === 0 || args.includes('--list') || args.includes('-l')
}

const isRead = ({ subcommand, args }: GitInvocation) => {
  if (args.some(arg => arg.startsWith('--output'))) return false
  if (READ_SUBCOMMANDS.has(subcommand)) return true

  const [first] = args
  switch (subcommand) {
    case 'worktree':
      return first === 'list'
    case 'branch':
      return isBranchListing(args)
    case 'remote':
      return first === undefined || first === '-v' || first === 'show' || first === 'get-url'
    case 'stash':
      return first === 'list' || first === 'show'
    case 'reflog':
      return first === undefined || first === 'show'
    case 'tag':
      return first === undefined || args.includes('-l') || args.includes('--list')
    case 'config':
      return first === '--get' || first === '--get-all' || first === '--get-regexp' || first === '--list' || first === '-l'
    case 'clean':
      return args.includes('-n') || args.includes('--dry-run')
    default:
      return false
  }
}

const COMMIT_VALUE_FLAGS = new Set([
  '-m', '-F', '-C', '-c', '-t', '--author', '--date', '--message', '--file', '--reuse-message',
  '--reedit-message', '--template', '--fixup', '--squash', '--trailer', '--cleanup',
])
const COMMIT_VALUE_LETTERS = new Set(['m', 'F', 'C', 'c', 't'])

const commitFlags = (args: readonly string[]) => {
  const flags: string[] = []
  for (let index = 0; index < args.length; index += 1) {
    const arg = args[index]!
    if (!arg.startsWith('-')) continue
    flags.push(arg)
    const takesValue = COMMIT_VALUE_FLAGS.has(arg) || (/^-[A-Za-z]+$/.test(arg) && COMMIT_VALUE_LETTERS.has(arg.at(-1)!))
    if (takesValue) index += 1
  }
  return flags
}

const decideCommit = async (args: readonly string[], loadFacts: LoadFacts) => {
  const flags = commitFlags(args)
  const letters = shortLetters(flags)
  if (letters.includes('S') || flags.some(flag => flag.startsWith('--gpg-sign'))) {
    return deny('signs the commit; agent commits are unsigned')
  }

  const facts = await loadFacts()
  if (!facts) return undefined
  if (facts.isSibling) return siblingWrite(facts)
  if (letters.includes('n') || flags.includes('--no-verify')) return ask('skips the commit hooks')
  if (flags.includes('--amend') && facts.isHeadPushed) {
    return ask(`amends ${describeBranch(facts)}'s HEAD, which is already on a remote`)
  }

  return allow(`commits in this worktree (${describeBranch(facts)})`)
}

const PUSH_PLAIN_FLAGS = new Set([
  '-u', '--set-upstream', '-q', '--quiet', '-v', '--verbose', '--porcelain', '--progress',
  '--no-progress', '--atomic', '--follow-tags', '--no-follow-tags', '--force-if-includes',
])
const PUSH_PLAIN_LETTERS = new Set(['u', 'q', 'v'])

const stripHeads = (ref: string) => ref.replace(/^refs\/heads\//, '')

const decidePush = async (args: readonly string[], loadFacts: LoadFacts) => {
  let isLease = false
  let isNoVerify = false
  let isDryRun = false
  const words: string[] = []

  for (let index = 0; index < args.length; index += 1) {
    const arg = args[index]!
    if (arg === '-o' || arg === '--push-option') {
      index += 1
    } else if (arg.startsWith('--push-option=')) {
      continue
    } else if (arg === '--force' || arg === '--mirror' || arg === '--delete') {
      return deny(`${arg} ${YOURS_TO_RUN}`)
    } else if (arg.startsWith('--force-with-lease')) {
      isLease = true
    } else if (arg === '--no-verify') {
      isNoVerify = true
    } else if (arg === '--dry-run') {
      isDryRun = true
    } else if (arg === '--all' || arg === '--branches' || arg === '--tags') {
      return ask(`${arg} pushes more than this worktree's branch`)
    } else if (/^-[A-Za-z]+$/.test(arg)) {
      for (const letter of arg.slice(1)) {
        if (letter === 'f' || letter === 'd') return deny(`-${letter} ${YOURS_TO_RUN}`)
        if (letter === 'n') isDryRun = true
        else if (!PUSH_PLAIN_LETTERS.has(letter)) return undefined
      }
    } else if (arg.startsWith('-')) {
      if (!PUSH_PLAIN_FLAGS.has(arg)) return undefined
    } else {
      words.push(arg)
    }
  }

  const refspecs = words.slice(1)
  for (const refspec of refspecs) {
    if (refspec.startsWith('+')) return deny(`force-pushes ${refspec.slice(1)}, which ${YOURS_TO_RUN}`)
    if (refspec.startsWith(':')) return deny(`deletes remote branch ${refspec.slice(1)}, which ${YOURS_TO_RUN}`)
  }
  if (isDryRun) return allow('dry-runs a push', true)

  const facts = await loadFacts()
  if (!facts) return undefined

  const destinations = refspecs.length > 0
    ? refspecs.map(refspec => {
        const destination = stripHeads(refspec.includes(':') ? refspec.slice(refspec.indexOf(':') + 1) : refspec)
        return destination === 'HEAD' ? facts.branch : destination
      })
    : [facts.upstreamBranch ?? facts.branch]
  if (destinations.some(destination => destination === undefined)) return undefined

  const defaults = new Set([facts.defaultBranch, 'main', 'master'])
  const toDefault = destinations.find(destination => defaults.has(destination!))
  if (toDefault) return ask(`pushes ${toDefault}, a default branch; that needs your go-ahead`)
  if (facts.isSibling) return ask(`pushes from sibling worktree ${facts.worktree} (${describeBranch(facts)})`)

  const foreign = destinations.find(destination => destination !== facts.branch)
  if (foreign) return ask(`pushes ${foreign}, which is not this worktree's branch (${describeBranch(facts)})`)
  if (isLease) return ask(`force-pushes ${facts.branch} with a lease, rewriting its remote history`)
  if (isNoVerify) return ask('skips the pre-push hooks')

  return allow(`pushes ${facts.branch}, this worktree's own branch`, true)
}

const decideBranch = (args: readonly string[]) => {
  const letters = shortLetters(args)
  const isDelete = letters.includes('d') || args.includes('--delete')
  const isForce = letters.includes('f') || args.includes('--force')
  if (letters.includes('D') || (isDelete && isForce)) return deny(`force-deleting a branch ${YOURS_TO_RUN}`)
  return undefined
}

const isDiscard = ({ subcommand, args }: GitInvocation) => {
  switch (subcommand) {
    case 'reset':
      return args.includes('--hard')
    case 'clean':
      return shortLetters(args).includes('f') || args.includes('--force')
    case 'checkout':
      return args.includes('--') || (args.length === 1 && args[0] === '.')
    case 'restore':
      return !(args.includes('--staged') || args.includes('-S')) || args.includes('--worktree') || args.includes('-W')
    default:
      return false
  }
}

const isStageWrite = ({ subcommand, args }: GitInvocation) =>
  subcommand === 'add' ||
  (subcommand === 'restore' && !isDiscard({ subcommand, args })) ||
  (subcommand === 'stash' && (args[0] === undefined || args[0] === 'push'))

/**
 * Decides a git invocation, or answers undefined to leave it to the session's
 * own permission flow. Facts are loaded only for decisions that need them.
 */
export const decideGit = async (inv: GitInvocation, loadFacts: LoadFacts): Promise<Verdict | undefined> => {
  if (isRead(inv)) return allow(`reads repository state (git ${inv.subcommand})`)

  switch (inv.subcommand) {
    case 'commit':
      return decideCommit(inv.args, loadFacts)
    case 'push':
      return decidePush(inv.args, loadFacts)
    case 'branch':
      return decideBranch(inv.args)
  }

  if (isDiscard(inv)) {
    const facts = await loadFacts()
    return facts && discard(facts)
  }
  if (isStageWrite(inv)) {
    const facts = await loadFacts()
    if (!facts) return undefined
    return facts.isSibling ? siblingWrite(facts) : allow(`stages in this worktree (${describeBranch(facts)})`)
  }

  return undefined
}

const isWtherdrCreation = (argv: readonly string[]) => {
  const [tool, run, workflow, branchFlag, branch, baseFlag, base, ...rest] = argv
  if (tool !== 'wtherdr' || run !== 'run' || workflow !== 'create') return false
  if (branchFlag !== '--branch' || branch === undefined || branch.startsWith('-')) return false
  if (baseFlag === undefined) return true
  return baseFlag === '--base' && base !== undefined && !base.startsWith('-') && rest.length === 0
}

/** Decides a Worktrunk command, or answers undefined to leave it alone. */
export const decideWt = (argv: readonly string[]): Verdict | undefined => {
  if (isWtherdrCreation(argv)) return allow('creates a worktree through wtherdr', true)
  if (argv[0] !== 'wt') return undefined

  const [, subcommand, ...args] = argv
  if (subcommand === 'list') return allow('lists worktrees')
  if (subcommand !== 'switch') return undefined
  if (args.length === 1 && !args[0]!.startsWith('-')) return allow(`switches to worktree ${args[0]}`)
  if (args.includes('--no-cd') && parseBranchCreation(argv)) return allow('creates a worktree through Worktrunk', true)

  return undefined
}
