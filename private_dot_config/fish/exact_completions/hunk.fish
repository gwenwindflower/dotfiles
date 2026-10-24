function __hunk_needs_command
    set -l cmd (commandline -xpc)
    set -e cmd[1]
    for word in $cmd
        string match -qr -- '^-' $word; or return 1
    end
end

function __hunk_using -d 'True when the subcommand path matches the given words'
    set -l cmd (commandline -xpc)
    set -e cmd[1]
    set -l words (string match -rv -- '^-' $cmd)
    test (count $words) -eq (count $argv); or return 1
    test "$words" = "$argv"
end

function __hunk_under -d 'True when the subcommand path starts with the given words'
    set -l cmd (commandline -xpc)
    set -e cmd[1]
    set -l words (string match -rv -- '^-' $cmd)
    string match -q -- "$argv" "$words"; or string match -q -- "$argv *" "$words"
end

function __hunk_refs
    git rev-parse --git-dir &>/dev/null; or return
    printf '%s\tHEAD\n' HEAD
    git for-each-ref --format='%(refname:short)%09%(subject)' refs/heads refs/tags refs/remotes 2>/dev/null
    git log --format='%h%x09%s' -n 20 2>/dev/null
end

function __hunk_stashes
    git stash list --format='%gd%x09%s' 2>/dev/null
end

set -l review_cmds diff show stash patch pager difftool

complete -c hunk -f

# Global
complete -c hunk -s h -l help -d 'Show help'
complete -c hunk -n __hunk_needs_command -s v -l version -d 'Show version'
complete -c hunk -l experimental -d 'Enable experimental features (STML)'
complete -c hunk -l extension -r -F -d 'Load an extension entry file or directory'
complete -c hunk -l no-extensions -d 'Disable user extensions for this run'
complete -c hunk -l disable-extension -x -d 'Disable one extension for this run'
complete -c hunk -l enable-extension -x -d 'Re-enable one extension for this run'

# Commands
complete -c hunk -n __hunk_needs_command -a open -d 'View a file or browse a directory'
complete -c hunk -n __hunk_needs_command -a diff -d 'Review working tree changes or compare revisions'
complete -c hunk -n __hunk_needs_command -a show -d 'Review the last commit or a given ref'
complete -c hunk -n __hunk_needs_command -a status -d 'Inspect this workspace and sibling worktrees'
complete -c hunk -n __hunk_needs_command -a log -d 'Browse repository history'
complete -c hunk -n __hunk_needs_command -a gh -d 'Review changes hosted on GitHub'
complete -c hunk -n __hunk_needs_command -a stash -d 'Review a stash entry'
complete -c hunk -n __hunk_needs_command -a patch -d 'Review a patch file or stdin'
complete -c hunk -n __hunk_needs_command -a pager -d 'Git pager wrapper with diff detection'
complete -c hunk -n __hunk_needs_command -a difftool -d 'Review Git difftool file pairs'
complete -c hunk -n __hunk_needs_command -a session -d 'Inspect or control a live Hunk session'
complete -c hunk -n __hunk_needs_command -a markup -d 'Experimental STML note markup'
complete -c hunk -n __hunk_needs_command -a skill -d 'Print a bundled Hunk skill'
complete -c hunk -n __hunk_needs_command -a extension -d 'Install and manage shared extensions'
complete -c hunk -n __hunk_needs_command -a update -d 'Update Hunk'
complete -c hunk -n __hunk_needs_command -a completion -d 'Print a shell completion script'
complete -c hunk -n __hunk_needs_command -a daemon -d 'Manage the local session daemon'

# Positionals
complete -c hunk -n '__hunk_using open' -F
complete -c hunk -n '__hunk_under diff; and not __fish_contains_opt files; or __hunk_under show; or __hunk_using log' -a '(__hunk_refs)'
complete -c hunk -n '__hunk_under diff; and __fish_contains_opt files' -F
complete -c hunk -n '__hunk_under patch; or __hunk_under difftool; or __hunk_under markup render' -F
complete -c hunk -n '__hunk_using stash' -a show -d 'Review a stash entry'
complete -c hunk -n '__hunk_under stash show' -a '(__hunk_stashes)'
complete -c hunk -n '__hunk_using gh' -a 'pr commit compare'
complete -c hunk -n '__hunk_using completion' -a 'bash zsh'
complete -c hunk -n '__hunk_using markup' -a 'render guide'
complete -c hunk -n '__hunk_using skill' -a 'show path'
complete -c hunk -n '__hunk_using daemon' -a 'serve status restart'
complete -c hunk -n '__hunk_using extension; or __hunk_using ext' -a 'install list update remove'
complete -c hunk -n '__hunk_using session' -a 'list get context review navigate reload comment highlight'
complete -c hunk -n '__hunk_using session comment' -a 'add apply list rm clear'
complete -c hunk -n '__hunk_using session highlight' -a 'add clear'

# Review options
for cmd in open $review_cmds status
    set -l cond "__hunk_under $cmd"
    complete -c hunk -n $cond -l theme -x -d 'Named theme override'
    complete -c hunk -n $cond -l line-numbers -d 'Show line numbers'
    complete -c hunk -n $cond -l no-line-numbers -d 'Hide line numbers'
    complete -c hunk -n $cond -l sidebar -d 'Show the sidebar'
    complete -c hunk -n $cond -l no-sidebar -d 'Hide the sidebar'
    complete -c hunk -n $cond -l wrap -d 'Wrap long lines'
    complete -c hunk -n $cond -l no-wrap -d 'Truncate long lines'
    complete -c hunk -n $cond -s x -l tab-width -x -a '(seq 1 16)' -d 'Tab stop width'
end
for cmd in $review_cmds status
    set -l cond "__hunk_under $cmd"
    complete -c hunk -n $cond -l mode -x -a 'auto split unified' -d 'Layout mode'
    complete -c hunk -n $cond -l cursor-line -x -a 'row number off' -d 'Current-line marker'
    complete -c hunk -n $cond -l file-gap -x -a '(seq 0 8)' -d 'File separator rows'
    complete -c hunk -n $cond -l hunk-gap -x -a '(seq 0 8)' -d 'Blank rows before later hunks'
    complete -c hunk -n $cond -l wheel-scroll-lines -x -a 'auto (seq 1 10)' -d 'Rows per wheel event'
    complete -c hunk -n $cond -l scroll-off -x -d 'Rows kept clear of the viewport edge'
    complete -c hunk -n $cond -l hunk-headers -d 'Show hunk metadata rows'
    complete -c hunk -n $cond -l no-hunk-headers -d 'Hide hunk metadata rows'
    complete -c hunk -n $cond -l agent-notes -d 'Show agent notes'
    complete -c hunk -n $cond -l no-agent-notes -d 'Hide agent notes'
    complete -c hunk -n $cond -l transparent-bg -d 'Let terminal background show through'
    complete -c hunk -n $cond -l no-transparent-bg -d 'Paint surfaces with the theme'
end
for cmd in $review_cmds
    set -l cond "__hunk_under $cmd"
    complete -c hunk -n $cond -l agent-context -r -F -d 'JSON sidecar with agent rationale'
    complete -c hunk -n $cond -l pager -d 'Use pager-style chrome'
    complete -c hunk -n "$cond; and not __hunk_under pager" -l watch -d 'Auto-reload when the diff input changes'
end
complete -c hunk -n '__hunk_under diff' -l staged -l cached -d 'Review staged changes'
complete -c hunk -n '__hunk_under diff' -l exclude-untracked -d 'Hide untracked files'
complete -c hunk -n '__hunk_under diff' -l files -d 'Compare two concrete files'

# status and log
complete -c hunk -n '__hunk_under status; or __hunk_under log' -l static -d 'Print static output'
complete -c hunk -n '__hunk_under status; or __hunk_under log' -l vcs -x -d 'Select a VCS provider'
complete -c hunk -n '__hunk_under status; or __hunk_under log; or __hunk_under markup render' -l color -x -a 'auto always never' -d 'Color output'
complete -c hunk -n '__hunk_under status' -l json -d 'Emit a JSON snapshot'
complete -c hunk -n '__hunk_under log' -l all -d 'Include history from every head'
complete -c hunk -n '__hunk_under log' -l first-parent -d 'Follow only first parents'
complete -c hunk -n '__hunk_under log' -s n -l max-count -x -d 'Stop after this many commits'
complete -c hunk -n '__hunk_under log' -l author -x -d 'Limit commits by author'
complete -c hunk -n '__hunk_under log' -l grep -x -d 'Limit commits by message'
complete -c hunk -n '__hunk_under log' -l since -x -d 'Show commits newer than a date'
complete -c hunk -n '__hunk_under log' -l until -x -d 'Show commits older than a date'
complete -c hunk -n '__hunk_under log' -l format -x -a 'medium compact' -d 'Static record format'
complete -c hunk -n '__hunk_under log' -l oneline -d 'Alias for --format compact'
complete -c hunk -n '__hunk_under log' -l ascii -d 'Use an ASCII graph'
complete -c hunk -n '__hunk_under log' -l theme -x -d 'Theme override'

# markup render
complete -c hunk -n '__hunk_under markup render' -l width -x -d 'Layout width in columns'
complete -c hunk -n '__hunk_under markup render' -l theme -x -d 'Theme used to resolve colors'
complete -c hunk -n '__hunk_under markup render' -l json -d 'Emit structured JSON'

# session
set -l session_targeted '__hunk_under session; and not __hunk_using session; and not __hunk_using session list'
complete -c hunk -n '__hunk_under session; and not __hunk_using session' -l json -d 'Emit structured JSON'
complete -c hunk -n $session_targeted -l repo -x -a '(__fish_complete_directories)' -d 'Target the session for this repo root'
complete -c hunk -n '__hunk_using session review' -l include-patch -d 'Include raw diff text'
complete -c hunk -n '__hunk_using session review' -l include-notes -d 'Include live review notes'
complete -c hunk -n '__hunk_using session reload' -l session-path -x -a '(__fish_complete_directories)' -d 'Target a session rooted elsewhere'
complete -c hunk -n '__hunk_using session reload' -l source -x -a '(__fish_complete_directories)' -d 'Load the diff from this directory'
complete -c hunk -n '__hunk_using session navigate; or __hunk_using session comment add; or __hunk_using session highlight add' -l file -r -F -d 'Diff file path'
complete -c hunk -n '__hunk_using session comment list; or __hunk_using session comment clear; or __hunk_using session highlight clear' -l file -r -F -d 'Limit to one diff file'
complete -c hunk -n '__hunk_using session navigate; or __hunk_using session comment add; or __hunk_using session highlight add' -l old-line -x -d '1-based line on the old side'
complete -c hunk -n '__hunk_using session navigate; or __hunk_using session comment add; or __hunk_using session highlight add' -l new-line -x -d '1-based line on the new side'
complete -c hunk -n '__hunk_using session navigate' -l hunk -x -d '1-based hunk number'
complete -c hunk -n '__hunk_using session navigate' -l comment -x -d 'Jump to the comment with this id'
complete -c hunk -n '__hunk_using session navigate' -l next-comment -d 'Jump to the next annotated hunk'
complete -c hunk -n '__hunk_using session navigate' -l prev-comment -d 'Jump to the previous annotated hunk'
complete -c hunk -n '__hunk_using session comment add' -l summary -x -d 'Short review note'
complete -c hunk -n '__hunk_using session comment add' -l rationale -x -d 'Longer explanation'
complete -c hunk -n '__hunk_using session comment add' -l reply-to -x -d 'Reply to an existing note'
complete -c hunk -n '__hunk_using session comment add' -l markup -x -d 'Experimental STML body'
complete -c hunk -n '__hunk_using session comment add' -l author -x -d 'Author label'
complete -c hunk -n '__hunk_using session comment add; or __hunk_using session comment apply; or __hunk_using session highlight add' -l focus -d 'Focus the viewport on the result'
complete -c hunk -n '__hunk_using session comment apply' -l stdin -d 'Read the batch from stdin as JSON'
complete -c hunk -n '__hunk_using session comment list' -l type -x -a 'live all ai agent user' -d 'Filter by comment type'
complete -c hunk -n '__hunk_using session comment clear' -l include-user -d 'Also clear human notes'
complete -c hunk -n '__hunk_using session comment clear' -l all -d 'Clear agent and human notes'
complete -c hunk -n '__hunk_using session comment clear' -l yes -d 'Confirm destructive clearing'
complete -c hunk -n '__hunk_using session highlight add' -l start -x -d '0-based inclusive start offset'
complete -c hunk -n '__hunk_using session highlight add' -l end -x -d 'Exclusive end offset'
complete -c hunk -n '__hunk_using session highlight add' -l tone -x -a 'match current info warning error dim' -d 'Mark tone'
