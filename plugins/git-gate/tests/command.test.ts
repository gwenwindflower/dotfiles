import { describe, expect, test } from 'claude-code/testing'

import { parseBranchCreation, parseGit, tokenize } from '../hooks/command'

describe('tokenize', () => {
  test('splits a plain command on whitespace', () => {
    expect(tokenize('git  push origin feat')).toEqual(['git', 'push', 'origin', 'feat'])
  })

  test('keeps quoted words whole', () => {
    expect(tokenize(`git commit -m "fix(cli): handle 'x'" -m 'two words'`)).toEqual([
      'git',
      'commit',
      '-m',
      "fix(cli): handle 'x'",
      '-m',
      'two words',
    ])
  })

  test('refuses pipes, chains, substitution and redirects', () => {
    for (const command of [
      'git log | head',
      'git add . && git commit',
      'git status; rm -rf x',
      'git commit -m "$(cat msg)"',
      'git log > out.txt',
      'git show `git rev-parse HEAD`',
      'cd ../x\ngit status',
      'git status &',
    ]) {
      expect(tokenize(command)).toBeUndefined()
    }
  })

  test('refuses a leading environment assignment', () => {
    expect(tokenize('GIT_DIR=/x git status')).toBeUndefined()
  })

  test('refuses an unterminated quote', () => {
    expect(tokenize('git commit -m "oops')).toBeUndefined()
  })
})

describe('parseGit', () => {
  test('reads the subcommand and its arguments', () => {
    expect(parseGit(['git', 'push', '-u', 'origin', 'feat'])).toEqual({
      subcommand: 'push',
      args: ['-u', 'origin', 'feat'],
    })
  })

  test('resolves repeated -C directories against each other', () => {
    expect(parseGit(['git', '-C', '../repo.feat', '-C', 'sub', 'status'])).toEqual({
      dir: '../repo.feat/sub',
      subcommand: 'status',
      args: [],
    })
    expect(parseGit(['git', '-C', 'a', '-C', '/abs', 'status'])?.dir).toBe('/abs')
  })

  test('skips pager and lock flags before the subcommand', () => {
    expect(parseGit(['git', '--no-pager', 'log'])?.subcommand).toBe('log')
  })

  test('declines config overrides and other global options', () => {
    expect(parseGit(['git', '-c', 'core.sshCommand=x', 'push'])).toBeUndefined()
    expect(parseGit(['git', '--git-dir=/x', 'status'])).toBeUndefined()
  })

  test('declines anything that is not git', () => {
    expect(parseGit(['gh', 'pr', 'list'])).toBeUndefined()
    expect(parseGit(['git'])).toBeUndefined()
  })
})

describe('parseBranchCreation', () => {
  test('reads checkout -b and switch -c with an optional start point', () => {
    expect(parseBranchCreation(['git', 'checkout', '-b', 'feat/x'])).toEqual({ branch: 'feat/x' })
    expect(parseBranchCreation(['git', 'switch', '-c', 'feat/x', 'origin/main'])).toEqual({
      branch: 'feat/x',
      base: 'origin/main',
    })
    expect(parseBranchCreation(['git', 'switch', '--create', 'feat/x'])).toEqual({ branch: 'feat/x' })
  })

  test('reads a bare git branch creation', () => {
    expect(parseBranchCreation(['git', 'branch', 'feat/x', 'main'])).toEqual({
      branch: 'feat/x',
      base: 'main',
    })
  })

  test('carries the -C directory along', () => {
    expect(parseBranchCreation(['git', '-C', '../repo', 'switch', '-c', 'x'])).toEqual({
      branch: 'x',
      dir: '../repo',
    })
  })

  test('reads wt switch --create with a base', () => {
    expect(parseBranchCreation(['wt', 'switch', '--create', 'x', '--base', '^'])).toEqual({
      branch: 'x',
      base: '^',
    })
    expect(parseBranchCreation(['wt', 'switch', '-c', 'x', '-b', 'main', '--no-cd'])).toEqual({
      branch: 'x',
      base: 'main',
    })
  })

  test('leaves resets, listings, deletes and extra flags alone', () => {
    for (const argv of [
      ['git', 'checkout', '-B', 'x'],
      ['git', 'switch', '-C', 'x'],
      ['git', 'switch', 'existing'],
      ['git', 'branch'],
      ['git', 'branch', '-d', 'x'],
      ['git', 'branch', '--list', 'x*'],
      ['git', 'checkout', '-b', 'x', '--track', 'origin/x'],
      ['wt', 'switch', '--create', 'x', '-x', 'claude'],
      ['wt', 'switch', 'x'],
    ]) {
      expect(parseBranchCreation(argv)).toBeUndefined()
    }
  })
})
