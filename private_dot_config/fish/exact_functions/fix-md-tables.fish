function fix-md-tables -d "Fix markdown table spacing in one or more files"
    # Logic lives in .utils/fix-md-tables.ts — this is just the global entrypoint.
    # See .utils/AGENTS.md for the tool's docs and tests.
    deno run \
        --allow-read \
        --allow-write \
        (chezmoi source-path)/.utils/fix-md-tables.ts $argv
end
