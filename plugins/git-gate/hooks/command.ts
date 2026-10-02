export type GitInvocation = {
  dir?: string
  subcommand: string
  args: string[]
}

export type BranchCreation = {
  branch: string
  base?: string
  dir?: string
}

const SHELL_SYNTAX = /[|&;<>()$`\\\n\r]/
const ENV_ASSIGNMENT = /^[A-Za-z_][A-Za-z0-9_]*=/

/**
 * Splits a single plain command into words, or answers undefined for anything
 * a shell would do more with: pipes, chains, substitution, redirects,
 * escapes, comments, or a leading environment assignment.
 */
export const tokenize = (command: string): string[] | undefined => {
  const words: string[] = []
  let word = ''
  let isInWord = false
  let quote: '"' | "'" | undefined

  for (const char of command) {
    if (quote) {
      if (char === quote) {
        quote = undefined
      } else if (quote === '"' && /[$`\\]/.test(char)) {
        return undefined
      } else {
        word += char
      }
      continue
    }
    if (char === '"' || char === "'") {
      quote = char
      isInWord = true
      continue
    }
    if (SHELL_SYNTAX.test(char)) return undefined
    if (/\s/.test(char)) {
      if (isInWord) words.push(word)
      word = ''
      isInWord = false
      continue
    }
    if (char === '#' && !isInWord) return undefined
    word += char
    isInWord = true
  }

  if (quote) return undefined
  if (isInWord) words.push(word)
  if (words.length === 0 || ENV_ASSIGNMENT.test(words[0]!)) return undefined

  return words
}

const joinDir = (base: string | undefined, next: string) =>
  base === undefined || next.startsWith('/') ? next : `${base}/${next}`

const IGNORED_GLOBALS = new Set(['--no-pager', '-P', '--no-optional-locks'])

/**
 * Reads `git [-C <dir>]... <subcommand> <args>`. Any other global option
 * (`-c`, `--git-dir`, `--work-tree`) can change what the subcommand does, so
 * those invocations are not read at all.
 */
export const parseGit = (argv: readonly string[]): GitInvocation | undefined => {
  if (argv[0] !== 'git') return undefined

  let dir: string | undefined
  let index = 1
  while (index < argv.length) {
    const word = argv[index]!
    if (word === '-C') {
      const next = argv[index + 1]
      if (next === undefined) return undefined
      dir = joinDir(dir, next)
      index += 2
    } else if (IGNORED_GLOBALS.has(word)) {
      index += 1
    } else if (word.startsWith('-')) {
      return undefined
    } else {
      break
    }
  }

  const subcommand = argv[index]
  if (subcommand === undefined) return undefined
  const args = argv.slice(index + 1)

  return dir === undefined ? { subcommand, args } : { dir, subcommand, args }
}

const isName = (word: string | undefined): word is string =>
  word !== undefined && word !== '' && !word.startsWith('-')

const withBase = (creation: BranchCreation, base: string | undefined): BranchCreation =>
  base === undefined ? creation : { ...creation, base }

const GIT_CREATE_FLAGS: Record<string, readonly string[]> = {
  checkout: ['-b'],
  switch: ['-c', '--create'],
}

const parseGitCreation = (inv: GitInvocation): BranchCreation | undefined => {
  const at = inv.dir === undefined ? {} : { dir: inv.dir }
  const [first, second, third, ...rest] = inv.args

  if (inv.subcommand === 'branch') {
    if (!isName(first) || (second !== undefined && !isName(second)) || third !== undefined) return undefined
    return withBase({ branch: first, ...at }, second)
  }

  const flags = GIT_CREATE_FLAGS[inv.subcommand]
  if (!flags || first === undefined || !flags.includes(first)) return undefined
  if (!isName(second) || (third !== undefined && !isName(third)) || rest.length > 0) return undefined

  return withBase({ branch: second, ...at }, third)
}

const parseWtCreation = (args: readonly string[]): BranchCreation | undefined => {
  const [flag, branch, ...rest] = args
  if ((flag !== '-c' && flag !== '--create') || !isName(branch)) return undefined

  let base: string | undefined
  for (let index = 0; index < rest.length; index += 1) {
    const word = rest[index]!
    if ((word === '--base' || word === '-b') && base === undefined && isName(rest[index + 1])) {
      base = rest[index + 1]
      index += 1
    } else if (word !== '--no-cd') {
      return undefined
    }
  }

  return withBase({ branch }, base)
}

/**
 * Reads a command that creates a branch without a worktree, or a
 * `wt switch --create` that needs its host-side run: the shapes git-gate
 * routes through Worktrunk. Resets (`-B`, `-C`), tracking setups and
 * `--execute` runs are left to the command as written.
 */
export const parseBranchCreation = (argv: readonly string[]): BranchCreation | undefined => {
  if (argv[0] === 'wt') return argv[1] === 'switch' ? parseWtCreation(argv.slice(2)) : undefined

  const inv = parseGit(argv)
  return inv && parseGitCreation(inv)
}
