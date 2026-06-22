function herdir -d "Ensure or snapshot herdr session base layouts"
    # Logic lives in .utils/herdir.ts — this is just the global entrypoint.
    # See .utils/AGENTS.md for the tool's docs and tests.
    deno run \
        --allow-read \
        --allow-write=(chezmoi source-path)/.utils/assets/herdir-snapshots \
        --allow-env=HOME \
        --allow-run=herdr \
        (chezmoi source-path)/.utils/herdir.ts $argv
end
