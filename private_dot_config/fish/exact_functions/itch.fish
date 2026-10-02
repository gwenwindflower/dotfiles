function itch -d "Build a throwaway git repo with a bare origin and sibling worktrees, then cd into it"
    # Logic lives in .utils/itch.ts — this is just the global entrypoint.
    # See .utils/AGENTS.md for the tool's docs and tests.
    set -l output (deno run \
        --allow-read \
        --allow-write \
        --allow-run=git \
        (chezmoi source-path)/.utils/itch.ts $argv)
    or return

    if status is-interactive; and test (count $output) -eq 1; and test -d "$output"
        cd $output
    else
        printf '%s\n' $output
    end
end
